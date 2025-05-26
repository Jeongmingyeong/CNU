#include <iostream>
#include <cstring>
#include <cstdio>
#include <cstdlib>
#include <unistd.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <fcntl.h>
#include <sys/select.h>
#include <vector>

#define SERVERPORT 8081
#define BUFSIZE 512
//#define FD_SETSIZE 64

// Socket information structure
typedef struct socket_info {
    int sock;
    char buf[BUFSIZE + 1];
    int recvbytes;
    int sendbytes;
} SOCKETINFO;

int nTotalSockets = 0;
SOCKETINFO *SocketInfoArray[FD_SETSIZE];

void err_quit(const char *msg);
void err_display(const char *msg);
bool AddSocketInfo(int sock);
void RemoveSocketInfo(int nIndex);

int main(int argc, char **argv) {
    int retval;

    // Create a socket
    int listen_sock = socket(AF_INET, SOCK_STREAM, 0);
    if (listen_sock == -1) {
        perror("socket()");
        return 1;
    }

    // Set socket to non-blocking
    int flags = fcntl(listen_sock, F_GETFL, 0);
    fcntl(listen_sock, F_SETFL, flags | O_NONBLOCK);

    // Initialize server address
    struct sockaddr_in serveraddr;
    memset(&serveraddr, 0, sizeof(serveraddr));
    serveraddr.sin_family = AF_INET;
    serveraddr.sin_addr.s_addr = htonl(INADDR_ANY);
    serveraddr.sin_port = htons(SERVERPORT);

    // Bind socket
    retval = bind(listen_sock, (struct sockaddr *)&serveraddr, sizeof(serveraddr));
    if (retval == -1) {
        perror("bind()");
        close(listen_sock);
        return 1;
    }

    // Listen for incoming connections
    retval = listen(listen_sock, SOMAXCONN);
    if (retval == -1) {
        perror("listen()");
        close(listen_sock);
        return 1;
    }

    std::cout << "Server is listening on port 8081..." << std::endl;

    std::vector<int> activeSockets;
        std::cout << "nTotalSockets(before):" << nTotalSockets <<"\n" <<std::endl;
    while (true) {
        fd_set rset, wset;
        FD_ZERO(&rset);
        FD_ZERO(&wset);
        FD_SET(listen_sock, &rset);
                
        for (int i = 0; i < nTotalSockets; i++) {
            if (SocketInfoArray[i]->recvbytes > SocketInfoArray[i]->sendbytes)
                FD_SET(SocketInfoArray[i]->sock, &wset);
            else
                FD_SET(SocketInfoArray[i]->sock, &rset);
        }

        int maxfd = listen_sock;
        for (int i = 0; i < nTotalSockets; i++) {
            if (SocketInfoArray[i]->sock > maxfd)
                maxfd = SocketInfoArray[i]->sock;
        }

        retval = select(maxfd + 1, &rset, &wset, NULL, NULL);
        if (retval == -1) {
            perror("select()");
            break;
        }

        // Check for new incoming connections
        if (FD_ISSET(listen_sock, &rset)) {
            int client_sock = accept(listen_sock, NULL, NULL);
            if (client_sock == -1) {
                perror("accept()");
            } else {
                std::cout << "Accepted a new connection" << std::endl;
                if (AddSocketInfo(client_sock)) {
                    activeSockets.push_back(client_sock);
                }
            }
        }

        // Handle data communication
        for (int i = 0; i < nTotalSockets; i++) {
        	SOCKETINFO *ptr = SocketInfoArray[i];

        	if (FD_ISSET(ptr->sock, &rset)) {
            	// Receive data
            	retval = recv(ptr->sock, ptr->buf, BUFSIZE, 0);
            	
				if (retval == -1) {
                	perror("recv()");
                    RemoveSocketInfo(i);
                	continue;
                } else if (retval == 0) {
                	RemoveSocketInfo(i);
                	continue;
                }
           		
				ptr->recvbytes = retval;

                // Print received data
                ptr->buf[retval] = '\0';
                std::cout << "Received from client " << i << ": " << ptr->buf << std::endl;

                // Broadcast the received message to all clients
                for (int j = 0; j < nTotalSockets; j++) {
                	if (i != j) {
                   		send(SocketInfoArray[j]->sock, ptr->buf, retval, 0);
                    }
                }
        	}
                        
            // Check for data to send to the current client
            if (FD_ISSET(ptr->sock, &wset)) {
 	           // Send data
               retval = send(ptr->sock, ptr->buf + ptr->sendbytes, ptr->recvbytes - ptr->sendbytes, 0);
        
				if (retval == -1) {
					perror("send()");
                    RemoveSocketInfo(i);
                    continue;
				}

				ptr->sendbytes += retval;
				
				if (ptr->recvbytes == ptr->sendbytes)
					ptr->recvbytes = ptr->sendbytes = 0;
			    }
			}
		}

    // Close all active sockets
    for (int sock : activeSockets) {
        close(sock);
    }

    // Close the server socket
    close(listen_sock);

    return 0;
}

bool AddSocketInfo(int sock) {
    if (nTotalSockets >= FD_SETSIZE) {
        std::cerr << "Cannot add socket info. Max limit reached." << std::endl;
        return false;
    }

    SOCKETINFO *ptr = new SOCKETINFO;
    if (ptr == NULL) {
        std::cerr << "Memory allocation failed." << std::endl;
        return false;
    }

    ptr->sock = sock;
    ptr->recvbytes = 0;
    ptr->sendbytes = 0;
    SocketInfoArray[nTotalSockets++] = ptr;
        std::cout << "nTotalSockets(after+):" << nTotalSockets <<"\n" <<std::endl;
    return true;
}

void RemoveSocketInfo(int nIndex) {
    SOCKETINFO *ptr = SocketInfoArray[nIndex];
    close(ptr->sock);
    delete ptr;

    if (nIndex != (nTotalSockets - 1)){
        SocketInfoArray[nIndex] = SocketInfoArray[nTotalSockets - 1];
        }
    --nTotalSockets;
        std::cout << "nTotalSockets(after-):" << nTotalSockets <<"\n" <<std::endl;
}

void err_quit(const char *msg) {
    perror(msg);
    exit(1);
}

void err_display(const char *msg) {
    perror(msg);
}

