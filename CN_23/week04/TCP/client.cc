#include <iostream>
#include <cstring>
#include <cstdio>
#include <cstdlib>
#include <unistd.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>

#define SERVER_IP "127.0.0.1"
#define SERVER_PORT 8081
#define BUFSIZE 512

int main() {
	int client_sock;
	struct sockaddr_in server_addr;

	// Create a socket
	client_sock = socket(AF_INET, SOCK_STREAM, 0);
	if(client_sock == -1) {
		perror("socket()");
		return 1;
	}

	// Initialize server address
	memset(&server_addr, 0, sizeof(server_addr));
	server_addr.sin_family = AF_INET;
	server_addr.sin_port = htons(SERVER_PORT);
	server_addr.sin_addr.s_addr = inet_addr(SERVER_IP);

	// Connect to the server
	if(connect(client_sock, (struct sockaddr*)&server_addr, sizeof(server_addr)) == -1) {
		perror("connect()");
		close(client_sock);
		return 1;
	}

	std::cout << "Connected to the server." << std::endl;

	char message[BUFSIZE];
		std::cout << "Enter a message (or'q' to quit)\n";
	while (true) {
		// std::cout << "Enter a message (or'q' to quit)\n";
		std::cin.getline(message, BUFSIZE);

		if(strcmp(message, "q") == 0) {
			break; // Exit the loop and close the connection
		}

		// Send the message to the server
		int bytes_sent = send(client_sock, message, strlen(message), 0);
		if(bytes_sent == -1) {
			perror("send()");
			break;
		}

		// Receive and display the server's response
		char server_response[BUFSIZE];
		int bytes_received = recv(client_sock, server_response, BUFSIZE -1, 0);
		if(bytes_received == -1) {
			perror("recv()");
			break;
		}
		server_response[bytes_received] = '\0';

		std::cout << "Server response: " << server_response << std::endl;
	}

	// Close the socket and exit
	close(client_sock);
	std::cout << "Connection closed. Goodbye!" << std::endl;

	return 0;
}


