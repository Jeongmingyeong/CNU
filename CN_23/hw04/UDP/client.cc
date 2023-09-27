#include <iostream>
#include <cstring>
#include <arpa/inet.h>
#include <unistd.h>

const char *SERVER_IP = "127.0.0.1";
const int SERVER_PORT = 8081;
const int BUFFER_SIZE = 1024;

int main() {
	int clientSocket;
	struct sockaddr_in serverAddr;
	char buffer[BUFFER_SIZE];

	// create socket
	if( (clientSocket = socket(AF_INET, SOCK_DGRAM, 0)) < 0) {
		perror("socket creation failed");
		return -1;
	}

	// config server address
	memset(&serverAddr, 0, sizeof(serverAddr));
	serverAddr.sin_family = AF_INET;
	serverAddr.sin_port = htons(SERVER_PORT);
	if(inet_pton(AF_INET, SERVER_IP, &serverAddr.sin_addr) <= 0) {
		perror("inet_pton failed");
		return -1;
	}

	while (true) {
		std::cout << "Enter a message to send (or type 'exit' to quit): ";
		std::cin.getline(buffer, BUFFER_SIZE);

		// if input == exit, break the loop
		if (strcmp(buffer, "exit") == 0) {
			break;
		}

		// send message to server
		ssize_t bytesSent = sendto(clientSocket, buffer, strlen(buffer), 0, (struct sockaddr*)&serverAddr, sizeof(serverAddr));
		if (bytesSent < 0) {
			perror("sendto failed");
			break;
		}

		memset(buffer, 0, BUFFER_SIZE);

		// receive response from server
		ssize_t bytesRead = recvfrom(clientSocket, buffer, BUFFER_SIZE, 0, nullptr, nullptr);
		if (bytesRead < 0) {
			perror("recvfrom failed");
			break;
		}

		std::cout << "Received response: " << buffer << std::endl;
	}

	// close client socket
	close(clientSocket);

	return 0;
}

