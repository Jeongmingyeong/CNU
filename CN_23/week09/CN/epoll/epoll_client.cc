#include <iostream>
#include <cstring>
#include <sys/socket.h>
#include <netinet/in.h>
#include <unistd.h>
#include <arpa/inet.h>

#define PORT 8801
#define SERVER_ADDR "127.0.0.1"

int clientSocket;
struct sockaddr_in serverAddress;

int init_socket() {
    if ((clientSocket = socket(AF_INET, SOCK_STREAM, 0)) == -1) {
        std::cerr << "Error creating socket" << std::endl;
        return -1;
    }

    serverAddress.sin_family = AF_INET;
    serverAddress.sin_port = htons(PORT);
    serverAddress.sin_addr.s_addr = inet_addr(SERVER_ADDR);

    if (connect(clientSocket, (struct sockaddr *)&serverAddress, sizeof(serverAddress)) == -1) {
        std::cerr << "Error connecting to server" << std::endl;
        close(clientSocket);
        return -1;
    }
    std::cout << "Connected to server" << std::endl;
    return 0;
}

int main() {
    if (init_socket() == -1) {
        std::cerr << "Error init_socket()" << std::endl;
        return -1;
    }

    char message[256];
    while (true) {
        std::cin.getline(message, sizeof(message));
        send(clientSocket, message, strlen(message), 0);
        memset(message, 0, sizeof(message));

        int bytesRead = recv(clientSocket, message, sizeof(message), 0);
        if (bytesRead == -1) {
            std::cerr << "Error receiving data from server" << std::endl;
            break;
        } else if (bytesRead == 0) {
            std::cout << "Server disconnected" << std::endl;
            break;
        } else {
            std::cout << "Received from server: " << message << std::endl;
        }
    }

    close(clientSocket);

    return 0;
}
