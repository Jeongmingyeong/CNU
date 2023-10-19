#include <iostream>
#include <sys/socket.h>
#include <netinet/in.h>
#include <cstring>
#include <unistd.h>
#include <thread>

// int sock = socket(int domain, int type, int protocol);
int sock, csock;
struct sockaddr_in serverAddress;
int opt = 1;
int addrlen = sizeof(serverAddress);

int init_sock() {
	if( (sock = socket(AF_INET, SOCK_STREAM, 0)) == -1 ) {
		std::cerr << "Error creating socket\n" << std::endl;
		return -1;
	} else {
		std::cout << "Success creating socket\n";
	}


	// server address set
	serverAddress.sin_family = AF_INET;
	serverAddress.sin_port = htons(8081);  // port
	serverAddress.sin_addr.s_addr = INADDR_ANY;  // Allow all interfaces to connect


	// sock binding
	if (bind(sock, (struct sockaddr*)&serverAddress, addrlen) == -1) {
		std::cerr << "Error binding socket\n" << std::endl;
		close(sock);

		return -1;
	} else {
		std::cout << "Success binding socket\n";
	}


	// waiting for client connection
	if(listen(sock, 5) == -1) {
		std::cerr << "Error listening on socket\n" << std::endl;
		close(sock);

		return -1;
	} else {
		std::cout << "Success listening socket\n";
	}

	return 0;	
}

// add functions to check and change socket options.
void checkSocketOptions() {
	int sndbuf, rcvbuf;
	socklen_t optlen = sizeof(int);

	// check SO_SNDBUF
	if(getsockopt(sock, SOL_SOCKET, SO_SNDBUF, &sndbuf, &optlen) == -1) {
		std::cerr << "Error getting SO_SNDBUF" << std::endl;
	} else {
		std::cout << "SO_SNDBUF: " << sndbuf << " bytes" << std::endl;
	}

	// check SO_RCVBUF
	if(getsockopt(sock, SOL_SOCKET, SO_RCVBUF, &rcvbuf, &optlen) == -1) {
		std::cerr << "Error getting SO_RCVBUF" << std::endl;
	} else {
		std::cout << "SO_RCVBUF: " << rcvbuf << " bytes" << std::endl;
	}

	// SO_RCVBUF * 2
	rcvbuf *= 2;
	if(setsockopt(sock, SOL_SOCKET, SO_RCVBUF, &rcvbuf, sizeof(rcvbuf)) == -1) {
		std::cerr << "Error setting SO_RCVBUF" << std::endl;
	} else {
		std::cout << "SO_RCVBUF increased to: " << rcvbuf << " bytes" << std::endl;
	}

	// reconfirm SO_RCVBUF
	// if(getsockopt(sock, SOL_SOCKET, SO_RCVBUF, &rcvbuf, &optlen) == -1) {
	//	std::cerr << "Error getting SO_RCVBUF" << std::endl;
	// } else {
	//	std::cout << "Updated SO_RCVBUF: " << rcvbuf << " bytes" << std::endl;
	// }
}

// Function to handle client connections in a separate thread
void handleClient(int csock) {
	char buffer[1024];

    while (true) {
    	memset(buffer, 0, sizeof(buffer));
		int bytesRead = recv(csock, buffer, sizeof(buffer), 0);
		if(bytesRead == -1) {
			std::cerr << "Error receiving data from client.\n" << std::endl;
			break;
		} else if (bytesRead == 0) {
			// Client disconnected
			std::cout << "Client disconnected" << std::endl;
			break;
		} else {
			std::cout << "Receive from client: " << buffer << std::endl;
		}
	}

    close(csock);
}

int main() {

	// initialize socket
	if(init_sock() == -1) {
		std::cerr << "Error init_socket() \n" << std::endl;
		return -1;
	}

	checkSocketOptions();

	while(true) {
		if( (csock = accept(sock, (struct sockaddr*)&serverAddress, (socklen_t*)&addrlen)) < 0) {
			std::cerr << "Error accepting client connection\n" << std::endl;
		} else {
			std::cout << "Success New client connected" << std::endl;
			// recv msg
			std::thread(handleClient, csock).detach();
		}
	}


//	// communicate with client
//	memset(buffer, 0, sizeof(buffer));
//	int bytesRead = recv(csock, buffer, sizeof(buffer), 0);
//	if(bytesRead == -1) {
//		std::cerr << "Error receiving data from client.\n" << std::endl;
//		return -1;
//	} else {
//		std::cout << "Receive from client: " << buffer << std::endl;
//	}

	close(csock);
	close(sock);

	return 0;
}

