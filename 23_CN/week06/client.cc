#include <iostream>
#include <cstring>
#include <sys/socket.h>
#include <netinet/in.h>
#include <unistd.h>
#include <arpa/inet.h>
#include <thread>

#define PORT 8082
#define ADDR "127.0.0.1"
#define LADDR "192.168.0.47"

void receiveMessages(int clientSocket) {
    char buffer[1024];
    while (true) {
        memset(buffer, 0, sizeof(buffer));
        int bytesRead = recv(clientSocket, buffer, sizeof(buffer), 0);
        if (bytesRead == -1) {
            std::cerr << "Error receiving data from server" << std::endl;
            break;
        } else if (bytesRead == 0) {
            std::cout << "Server disconnected" << std::endl;
            break;
        } else {
            std::cout << "Received from server: " << buffer << std::endl;
        }
    }
}
int clientSocket;
struct sockaddr_in serverAddress;
int init_sock(){
	if ((clientSocket = socket(AF_INET, SOCK_STREAM, 0)) == -1) {
        std::cerr << "Error creating socket\n" << std::endl;
        return -1;
    }

    serverAddress.sin_family = AF_INET;
    serverAddress.sin_port = htons(PORT);
    serverAddress.sin_addr.s_addr = inet_addr(LADDR);

    if (connect(clientSocket, (struct sockaddr *)&serverAddress, sizeof(serverAddress)) == -1) {
        std::cerr << "Error connecting to server" << std::endl;
        close(clientSocket);
        return -1;
    }	
    std::cout << "Connected to server" << std::endl;
	return 0;
}
int main() {   

    if( init_sock() == -1){
		std::cerr << "Error init_socket()\n" << std::endl;
		return -1;
	}
    // Start a thread that receives messages from the server
    //std::thread(receiveMessages, clientSocket).detach();

    // Send user input to server
    char message[1024];
    while (true) {
        std::cin.getline(message, sizeof(message));
        send(clientSocket, message, strlen(message), 0);
    }

    close(clientSocket);

    return 0;
}
