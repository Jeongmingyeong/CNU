#include <csignal>
#include <iostream>
#include <unistd.h>
#include <cstring>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <cstdio>
#include <cerrno>

struct Cal {
    int numa;
    int numb;
    char op;
    int result;
    int error;
};

void H2N(Cal *acal) {
    acal->numa = htonl(acal->numa);
    acal->numb = htonl(acal->numb);
    acal->result = htonl(acal->result);
    acal->error = htonl(acal->error);
}

void N2H(Cal *acal) {
    acal->numa = ntohl(acal->numa);
    acal->numb = ntohl(acal->numb);
    acal->result = ntohl(acal->result);
    acal->error = ntohl(acal->error);
}

int main(int argc, char **argv) {
  int sockfd;
  int n;
  struct sockaddr_in serveraddr;
  Cal mycal;

  // Create a socket
  sockfd = socket(AF_INET, SOCK_STREAM, 0);
  if (sockfd < 0) {
      std::cerr << "Socket create error!" << std::endl;
      return -1;
  }

  // Set up the server address
  serveraddr.sin_family = AF_INET;
  serveraddr.sin_addr.s_addr = inet_addr("127.0.0.1"); // Server IP address
  serveraddr.sin_port = htons(8801); // Server port

  // Connect to the server
  if (connect(sockfd, (struct sockaddr *)&serveraddr, sizeof(serveraddr)) < 0) {
      std::cerr << "Connect error!" << std::endl;
      return -1;
  }

  while (true) {     
    std::cout << "Enter the first number: ";
    std::cin >> mycal.numa;

    std::cout << "Enter the operator (+, -, *, /): ";
    std::cin >> mycal.op;

    std::cout << "Enter the second number: ";
    std::cin >> mycal.numb;

    // send input to server
    H2N(&mycal);
    send(sockfd, &mycal, sizeof(mycal), 0);
    
    if ((n = recv(sockfd, &mycal, sizeof(mycal), 0) <= 0)) {
        std::cerr << "Read error" << std::endl;
    } else {
        N2H(&mycal);
        std::cout << mycal.numa << " " << mycal.op << " " << mycal.numb << " = " << mycal.result << std::endl;
    }
    
    char response; 
    std::cout << "Do you want to continue (y/n)? ";
    std::cin >> response;

    if (response != 'y') {
        break;
    }
  }

  // Close the socket
  close(sockfd);

  return 0;
}
