#include <iostream>
#include <cstdlib>
#include <cstring>
#include <cstdio>
#include <arpa/inet.h>
#include <netinet/in.h>
#include <sys/socket.h>
#include <sys/types.h>
#include <unistd.h>

#define SERVERIP "127.0.0.1" // SERVER IP address
#define SERVERPORT 8801 // SERVER Port number
#define BUFSIZE 512

// print error of socket function and exit
void err_quit(const char *msg) {
	perror(msg);
	exit(1);
}

int main() {
	int retval;

	// socket()
	int client_sock = socket(AF_INET, SOCK_STREAM, 0);
	if(client_sock == -1) {
		err_quit("socket()");
	}

	// connect to server
	struct sockaddr_in serveraddr;
	memset(&serveraddr, 0, sizeof(serveraddr));
	serveraddr.sin_family = AF_INET;
	serveraddr.sin_addr.s_addr = inet_addr(SERVERIP);
	serveraddr.sin_port = htons(SERVERPORT);

	retval = connect(client_sock, (struct sockaddr *)&serveraddr, sizeof(serveraddr));
	if(retval == -1) {
		err_quit("connect()");
	}

	char message[BUFSIZE];

	while(true) {
		// input message from user
		std::cout << "input message for send: ";
		std::cin.getline(message, BUFSIZE);

		// send data
		retval = send(client_sock, message, strlen(message), 0);
		if(retval == -1) {
			err_quit("send()");
			break;
		}

		// receive from server
		retval = recv(client_sock, message, BUFSIZE, 0);
		if(retval == -1) {
			err_quit("recv()");
			break;
		} else if (retval == 0) {
			std::cout << "disconnected from server" << std::endl;
			break;
		}

		// print receive data
		message[retval] = '\0';
		std::cout << "[Server Response] " << message << std::endl;
	}

	// close()
	close(client_sock);

	return 0;
}

