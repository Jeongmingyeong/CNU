#include <iostream>
#include <cstdlib>
#include <cstring>
#include <cstdio>
#include <arpa/inet.h>
#include <netinet/in.h>
#include <sys/socket.h>
#include <sys/types.h>
#include <unistd.h>
#include <pthread.h>

#define SERVERPORT 8801
#define BUFSIZE 512

// print error about socket function and exit
void err_quit(const char *msg) {
	perror(msg);
	exit(1);
}

// only print error about socket function
void err_display(const char *msg) {
	perror(msg);
}

// Data Communication with client
// (thread function) Display data from TCP client and resend to TCP client
void *process_client(void *arg) {
	int client_sock = *(int *) arg;
	int retval;
	struct sockaddr_in clientaddr;
	socklen_t addrlen = sizeof(clientaddr);
	char buf[BUFSIZE + 1];

	// get client information
	getpeername(client_sock, (struct sockaddr *)&clientaddr, &addrlen);

	while(true) {
		
		// Receive Data
		retval = recv(client_sock, buf, BUFSIZE, 0);
		
		if (retval == -1) {
			err_display("recv()");
			break;
		} else if (retval == 0) {
			break;
		}

		// print receive message
		buf[retval] = '\0';
		printf("[TCP /%s:%d] %s\n", inet_ntoa(clientaddr.sin_addr), ntohs(clientaddr.sin_port), buf);

		// send data
		retval = send(client_sock, buf, retval, 0);

		if(retval == -1) {
			err_display("send()");
			break;
		}
	}

	// close()
	close(client_sock);
	printf("[TCP Server] Terminate Client: IP address = %s, Port Number = %d\n", inet_ntoa(clientaddr.sin_addr), ntohs(clientaddr.sin_port));

	return NULL;
}

int main() {
	int retval;

	// socket()
	int listen_sock = socket(AF_INET, SOCK_STREAM, 0);
	if (listen_sock == -1) {
		err_quit("socket()");
	}

	// bind()
	struct sockaddr_in serveraddr;
	memset(&serveraddr, 0, sizeof(serveraddr));
	serveraddr.sin_family = AF_INET;
	serveraddr.sin_addr.s_addr = htonl(INADDR_ANY);
	serveraddr.sin_port = htons(SERVERPORT);
	retval = bind(listen_sock, (struct sockaddr *)&serveraddr, sizeof(serveraddr));
	if(retval == -1) {
		err_quit("bind()");
	}

	// listen()
	retval = listen(listen_sock, SOMAXCONN);
	if (retval == -1) {
		err_quit("listen()");
	}

	// Variables for Data Communication
	int client_sock;
	struct sockaddr_in clientaddr;
	socklen_t addrlen;
	pthread_t tid; // store thread ID

	while(true) {
		// accept()
		addrlen = sizeof(clientaddr);
		client_sock = accept(listen_sock, (struct sockaddr *)&clientaddr, &addrlen);
		if(client_sock == -1) {
			err_display("accept()");
			break;
		}

		// print connected client information
		printf("\n[TCP SERVER] connect client : IP Address = %s, Port Number %d\n", inet_ntoa(clientaddr.sin_addr), ntohs(clientaddr.sin_port));

		// create thread
		if(pthread_create(&tid, NULL, process_client, &client_sock) != 0) {
			close(client_sock);
		}
	}

	// close()
	close(listen_sock);

	return 0;
}

