#include <iostream>
#include <sys/socket.h>
#include <netinet/in.h>
#include <cstring>
#include <unistd.h>

// int sock = socket(int domain, int type, int protocol);
int sock, csock;
struct sockaddr_in serverAddress;
int opt = 1;
int addrlen = sizeof(serverAddress);
char buffer[1024];

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


	// accept incoming connection
	if( (csock = accept(sock, (struct sockaddr*)&serverAddress, (socklen_t *) &addrlen)) < 0) {
		std::cerr << "Error accept socket\n" << std::endl;
		return -1;
	} else {
		std::cout << "Success new client connection\n" << std::endl;
	}

	return 0;	
}

int main() {

	// initialize socket
	init_sock();


	// communicate with client
	memset(buffer, 0, sizeof(buffer));
	int bytesRead = recv(csock, buffer, sizeof(buffer), 0);
	if(bytesRead == -1) {
		std::cerr << "Error receiving data from client.\n" << std::endl;
		return -1;
	} else {
		std::cout << "Receive from client: " << buffer << std::endl;
	}

	close(csock);
	close(sock);

	return 0;
}

