#include <csignal>
#include <iostream>
#include <cstring>
#include <cstdlib>
#include <unistd.h>

void sigIntHandler(int signum);

int main() {
  char buf[255];
  int i = 0;

  if(signal(SIGINT, sigIntHandler) == SIG_ERR) {
    perror("signal setting error : ");
    exit(1);
  }

  while(true) {
    std::cout << i << std::endl;
    sleep(1);
    i++;
  }
}

void sigIntHandler(int signum) {
  std::cerr << "SIGINT !!!!" << std::endl;
  sleep(5);
}

