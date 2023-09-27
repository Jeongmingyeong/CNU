#include <iostream>
#include <cstring>
#include <arpa/inet.h>
#include <unistd.h>

const int SERVER_PORT = 8081;
const int BUFFER_SIZE = 1024;

int main() {
  int serverSocket;
  struct sockaddr_in serverAddr, clientAddr;
  socklen_t clientAddrLen = sizeof(clientAddr);
  char buffer[BUFFER_SIZE];

  // create socket
  if ((serverSocket = socket(AF_INET, SOCK_DGRAM, 0)) < 0) {
    perror("socket creation failed");
    return -1;
  }

  // server address setting
  memset(&serverAddr, 0, sizeof(serverAddr));
  serverAddr.sin_family = AF_INET;
  serverAddr.sin_port = htons(SERVER_PORT);
  serverAddr.sin_addr.s_addr = INADDR_ANY;
  // socket and address binding
  if (bind(serverSocket, (struct sockaddr *)&serverAddr, sizeof(serverAddr)) < 0) {
    perror("bind failed");
    return -1;
  }

  std::cout << "UDP server is listening on port " << SERVER_PORT << std::endl;

  while (true) {
    memset(buffer, 0, BUFFER_SIZE);

    // data receive from client
    ssize_t byteRead = recvfrom(serverSocket, buffer, BUFFER_SIZE, 0, (struct sockaddr*)&clientAddr, &clientAddrLen);
    if (byteRead < 0) {
      perror("recvfrom failed");
      break;
    }

    std::cout << "Received message from " << inet_ntoa(clientAddr.sin_addr) << ":" << ntohs(clientAddr.sin_port) << ": " << buffer << std::endl;

    // receive data send to client
    ssize_t byteSent = sendto(serverSocket, buffer, byteRead, 0, (struct sockaddr*)&clientAddr, clientAddrLen);
    if (byteSent < 0) {
      perror("sendto failed");
      break;
    }
  }

  // close socket
  close(serverSocket);

  return 0;
}

