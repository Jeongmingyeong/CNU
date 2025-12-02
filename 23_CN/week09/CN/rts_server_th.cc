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
    Cal mycal;
    
    ssize_t read_size;
    
    while(true) {
      // Receive data from client
      read_size = recv(client_sockfd, &mycal, sizeof(Cal), 0);
      if (read_size <= 0) {
          perror("recv error");
          close(client_sockfd);
          return nullptr;
      }
      
      N2H(&mycal);
      std::cout << " op : " << mycal.op << std::endl;
  
      // Process the received data (you can implement your calculation logic here) 
      switch (mycal.op) {
        case '+':
          mycal.result = mycal.numa + mycal.numb;
          mycal.error = 0;
          break;
        case '-':
          mycal.result = mycal.numa - mycal.numb;
          mycal.error = 0;
          break;
        case '/':
          mycal.result = mycal.numa / mycal.numb;
          mycal.error = 0;
          break;
        case '*':
          mycal.result = mycal.numa * mycal.numb;
          mycal.error = 0;
          break;
        case 'e':
          close(client_sockfd);
          break;
      }
  
      std::cout << mycal.numa << " " << mycal.op << " " << mycal.numb << " = " << mycal.result << std::endl;
      
      // Send the result back to the client
      H2N(&mycal);
      if (send(client_sockfd, &mycal, sizeof(Cal), 0) < 0) {
          perror("send error");
      }
    }

    close(client_sockfd);

    return nullptr;
}

// TODO: Signal handler function ±¸Çö x
void signalHandler(int signum) {
  std::cout << "Receive signal : " << signum << std::endl;
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
        int addrlen = sizeof(serveraddr);
        int client_sockfd = accept(server_sockfd, (struct sockaddr*)&serveraddr,(socklen_t*)&addrlen);
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

