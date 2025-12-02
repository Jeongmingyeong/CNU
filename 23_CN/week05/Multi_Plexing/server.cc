#include <iostream>
#include <unistd.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <cstring>
#include <vector>
#include <algorithm>

const int PORT = 8801;
const int MAX_CLIENTS = 3;

int main() {
	// create server socket
	int serverSocket = socket(AF_INET, SOCK_STREAM, 0);
	if(serverSocket == -1) {
		std::cerr << "Failed to create server socket" << std::endl;
		return 1;
	}

	// setup server address
	sockaddr_in serverAddr;
	serverAddr.sin_family = AF_INET;
	serverAddr.sin_port = htons(PORT);
	serverAddr.sin_addr.s_addr = INADDR_ANY;

	// binding server socket and address
	if(bind(serverSocket, (struct sockaddr*)&serverAddr, sizeof(serverAddr)) == -1) {
		std::cerr << "Failed to binding" << std::endl;
		return 1;
	}

	// wait client connection
	if(listen(serverSocket, MAX_CLIENTS) == -1) {
		std::cerr << "Failed to wait" << std::endl;
		return 1;
	}

	std::cout << "Server waiting in " << PORT << " Port..." << std::endl;

	// vector for management client socket
	std::vector<int> clientSockets;

	while(true) {
		// initialization file_descriptor set
		fd_set readSet;
		FD_ZERO(&readSet);
		FD_SET(serverSocket, &readSet);

		int maxFd = serverSocket; // Max file descriptor value

		// add client socket to file descriptor
		for(const int& clientSocket: clientSockets) {
			FD_SET(clientSocket, &readSet);
			if(clientSocket > maxFd) {
				maxFd = clientSocket;
			}
		}

		// wait through multi plexing
		if(select(maxFd + 1, &readSet, nullptr, nullptr, nullptr) == -1) {
			std::cerr << "Failed to call select()" << std::endl;
			break;
		}

		// accept new client connection
		if(FD_ISSET(serverSocket, &readSet)) {
			sockaddr_in clientAddr;
			socklen_t clientAddrLen = sizeof(clientAddr);
			int clientSocket = accept(serverSocket, (struct sockaddr*)&clientAddr, &clientAddrLen);
			if(clientSocket == -1) {
				std::cerr << "Failed to accept connection" << std::endl;
			} else {
				std::cout << "Accept new client: " << inet_ntoa(clientAddr.sin_addr) << ":" << ntohs(clientAddr.sin_port) << std::endl;
				clientSockets.push_back(clientSocket); // add new client to vector for management
			}

			// receive message from client and echo
			for(auto it = clientSockets.begin(); it != clientSockets.end();) {
				int clientSocket =*it;
				if(FD_ISSET(clientSocket, &readSet)) {
					char buffer[1024];
					int bytesRead = recv(clientSocket, buffer, sizeof(buffer), 0);
					if(bytesRead == -1) {
						std::cerr << "Failed to receive message from client" << std::endl;
						close(clientSocket);
						it = clientSockets.erase(it);
					} else if (bytesRead == 0) {
						std::cout << "Disconnected client" << std::endl;
						close(clientSocket);
						it = clientSockets.erase(it);
					} else {
						buffer[bytesRead] = '\0';
						std::cout << "Message from client: " << buffer << std::endl;
						send(clientSocket, buffer, bytesRead, 0); // echo
						++it;
					}
				} else {
					++it;
				}
			}
		}

		// close client socket and server socket
		for(const int& clientSocket : clientSockets) {
			close(clientSocket);
		}
		close(serverSocket);

		return 0;
	}
}

