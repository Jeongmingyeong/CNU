#include <iostream>
#include <cstring>
#include <netinet/in.h>
#include <sys/socket.h>
#include <unistd.h>
#include <pthread.h>
#include <csignal>

struct Cal {
    int numa;
    int numb;
    char op;
    int result;
    int error;
};

void H2N(Cal *acal) {
    acal->numa = htonl(acal->numa);
    acal->numb = htonl(acal->numb);
    acal->result = htonl(acal->result);
    acal->error = htonl(acal->error);
}

void N2H(Cal *acal) {
    acal->numa = ntohl(acal->numa);
    acal->numb = ntohl(acal->numb);
    acal->result = ntohl(acal->result);
    acal->error = ntohl(acal->error);
}
// TODO: Thread function
void* serverThread(void* arg) {
    int client_sockfd = *((int*)arg);
    Cal cal;
    
    ssize_t read_size;
    
    // Receive data from client
    read_size = recv(client_sockfd, &cal, sizeof(Cal), 0);
    if (read_size <= 0) {
        perror("recv error");
        close(client_sockfd);
        return nullptr;
    }

    // Process the received data (you can implement your calculation logic here)
    // ...

    // Send the result back to the client
    H2N(&cal);
    if (send(client_sockfd, &cal, sizeof(Cal), 0) < 0) {
        perror("send error");
    }

    close(client_sockfd);
}

// TODO: Signal handler function ±¸Çö x
void signalHandler(int signum) {

}

int main() {
    int server_sockfd;
    struct sockaddr_in serveraddr;


    server_sockfd = socket(AF_INET, SOCK_STREAM, 0);
    if (server_sockfd < 0) {
        std::cerr << "Socket create error" << std::endl;
        return 1;
    }

    std::memset(&serveraddr, 0, sizeof(serveraddr));
    serveraddr.sin_family = AF_INET;
    serveraddr.sin_addr.s_addr = htonl(INADDR_ANY);
    serveraddr.sin_port = htons(8801);


    if (bind(server_sockfd, (struct sockaddr*)&serveraddr, sizeof(serveraddr)) == -1) {
        perror("bind error");
        return 1;
    }


    if (listen(server_sockfd, 5) == -1) {
        perror("listen error");
        return 1;
    }

    while (1) {
        // Accept a connection
        client_sockfd = accept(server_sockfd, (struct sockaddr*)&clientaddr, &clientlen);
        if (client_sockfd < 0) {
            perror("accept error");
            continue;
        }

        // Create a new thread for each connection
        pthread_t thread;
        pthread_create(&thread, nullptr, serverThread, &client_sockfd);
    }

	  // close the server socket
    close(server_sockfd);

    return 0;
}
