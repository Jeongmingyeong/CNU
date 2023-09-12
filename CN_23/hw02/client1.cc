#include <iostream>
#include <sys/socket.h>
#include <netinet/in.h>
#include <cstring>
#include <unistd.h>
#include <arpa/inet.h>

#define PORT 8081
#define ADDR " 127.0.0.1"
#define LADDR "10.4.0.64"  // my ip

// create socket
int clientSocket;
struct sockaddr_in serverAddress;

int init_sock() {
	if ( (clientSocket = socket(AF_INET, SOCK_STREAM, 0)) == -1) {
		std::cerr << "Error creating socket\n" << std::endl;
		return -1;
	} else {
		std::cout << "Success creating socket\n";
	}

	// address set
	serverAddress.sin_family = AF_INET;
	serverAddress.sin_port = htons(PORT);  // PORT
	serverAddress.sin_addr.s_addr = inet_addr(LADDR);  // IP ADDR


	// connect server
	if (connect(clientSocket, (struct sockaddr*)&serverAddress, sizeof(serverAddress)) == -1) {
		std::cerr << "Error connecting to server" << std::endl;
		close(clientSocket);
		return -1;
	} 
	
	return 0;
}

int main() {

	// initialize socket
	init_sock();

	// send msg
	char message[] = "Hello, Server! My name is Mingyeong Jeong!";
	if(send(clientSocket, message, strlen(message), 0) == -1) {
		std::cerr << "Error sending data to server\n" << std::endl;
	} else {
		std::cout << "Message sent to server: " << message << std::endl;
	}

	
	// close socket
	close(clientSocket);

	return 0;
}

