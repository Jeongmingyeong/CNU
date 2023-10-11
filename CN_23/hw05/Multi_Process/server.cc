#include <iostream>
#include <cstring>
#include <netinet/in.h>
#include <sys/socket.h>
#include <unistd.h>

const int PORT = 8801;
const int MAX_CONNECTIONS = 3;

void handleClient(int clientSocket) {
	char buffer[1024];
	int bytesRead;

	// receive Data from client
	bytesRead = recv(clientSocket, buffer, sizeof(buffer), 0);
	if (bytesRead == -1) {
		std::cerr << "Failed receive message" << std::endl;
		close(clientSocket);
		return;
	}

	// print receive message
	buffer[bytesRead] = '\0';
	std::cout << "message from client: " << buffer << std::endl;

	// send response message to client
	const char* response = "Server response: receive message.\n";
	send(clientSocket, response, strlen(response), 0);

	// close client socket
	close(clientSocket);
}

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

	// bind server socket and address
	if(bind(serverSocket, (struct sockaddr*)&serverAddr, sizeof(serverAddr)) == -1) {
		std::cerr << "Failed to binding" << std::endl;
		return 1;
	}

	// wait connect to client
	if(listen(serverSocket, MAX_CONNECTIONS) == -1) {
		std::cerr << "Failed to wait" << std::endl;
		return 1;
	}

	std::cout << "Server waiting in " << PORT << "port..." << std::endl;

	while(true) {

		// accept client connection
		sockaddr_in clientAddr;
		socklen_t clientAddrLen = sizeof(clientAddr);
		int clientSocket = accept(serverSocket, (struct sockaddr*)&clientAddr, &clientAddrLen);
		if(clientSocket == -1) {
			std::cerr << "Failed to accept connection" << std::endl;
			continue;
		}

		// create child process
		pid_t childPid = fork();

		if(childPid == -1) {
			std::cerr << "Failed to create child process" << std::endl;
			close(clientSocket);
			continue;
		} else if (childPid == 0) {
			// child process communicate with client and perform tasks
			close(serverSocket);
			handleClient(clientSocket);
			return 0; // terminate child process
		} else {
			// parent process close client socket and waiting other connection
			close(clientSocket);
		}

		// close server socket (unreachable)
		close(serverSocket);

		return 0;
	}
}

