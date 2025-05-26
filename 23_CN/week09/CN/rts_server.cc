#include <csignal>
#include <ctime>
#include <iostream>
#include <unistd.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <cstring>
#include <cerrno>
#include <cstdio>
#include <fcntl.h>
#include <sys/stat.h>

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

int setupSigio(int fd) {
    if (fcntl(fd, F_SETFL, O_RDWR | O_NONBLOCK | O_ASYNC) < 0) {
        std::cerr << "Couldn't setup nonblocking I/O " << fd << std::endl;
        return -1;
    }
    
    if (fcntl(fd, F_SETSIG, SIGRTMIN) < 0) {
        std::cerr << "Couldn't set signal " << SIGRTMIN << " on " << fd << std::endl;
        return -1;
    }
    
    if (fcntl(fd, F_SETOWN, getpid()) < 0) {
        std::cerr << "Couldn't set owner " << getpid() << " on " << fd << std::endl;
        return -1;
    }
    
    return 0;
}

int makeListenerFd(int port) {
    int clilen;
    int state;
    int sockfd;
    struct sockaddr_in serveraddr;

    clilen = sizeof(serveraddr);
    sockfd = socket(AF_INET, SOCK_STREAM, 0);
    
    if (sockfd < 0) {
        std::cerr << "Socket create error ! ! !" << std::endl;
        exit(0);
    }
    
    std::memset(&serveraddr, 0, sizeof(serveraddr));
    serveraddr.sin_family = AF_INET;
    serveraddr.sin_addr.s_addr = htonl(INADDR_ANY);
    serveraddr.sin_port = htons(port);

    state = bind(sockfd, (struct sockaddr *)&serveraddr, sizeof(serveraddr));
    
    if (state == -1) {
        perror("bind error ! ! !");
        exit(0);
    }
    
    if (listen(sockfd, 5) == -1) {
        perror("listen error ! ! !");
        exit(0);
    }
    
    return sockfd;
}

int main(int argc, char **argv) {
    int client_sockfd, server_sockfd;
    socklen_t clilen;
    int ret;
    int n;
    struct sockaddr_in clientaddr, serveraddr;
    Cal mycal;
    sigset_t set;
    siginfo_t si;

    sigemptyset(&set);
    sigaddset(&set, SIGRTMIN);
    sigprocmask(SIG_BLOCK, &set, nullptr);

    // create listen socket and Real-time signal response using setupSigio
    server_sockfd = makeListenerFd(8801);
    setupSigio(server_sockfd);

    while (true) {
        clilen = sizeof(clientaddr);
        
        // waiting signal using sigwaitinfo
        std::cout << "signal wait" << std::endl;
        ret = sigwaitinfo(&set, &si);
        
        // check the signal
        if (ret == SIGRTMIN) {
            
            // if listen socket signal,  connect using accept
            if (si.si_fd == server_sockfd) {
                if ((client_sockfd = accept(server_sockfd, (struct sockaddr *)&clientaddr, &clilen)) < 0) {
                    perror("accept error : ");
                    close(client_sockfd);
                    exit(0);
                }
              
              // apply accepted socket RTS
                setupSigio(client_sockfd);
                continue;
            }
            
            client_sockfd = si.si_fd;
            
            if ((n = recv(client_sockfd, &mycal, sizeof(mycal), 0) <= 0)) {
                close(client_sockfd);
                perror("recv error\n");
                continue;
            }
            
            N2H(&mycal);
            std::cout << " op : " << mycal.op << std::endl;

            switch (mycal.op) {
                case '+':
                    mycal.result = mycal.numa + mycal.numb;
                    mycal.error = 0;
                    break;
                case '-':
                    mycal.result = mycal.numa - mycal.numb;
                    mycal.error = 0;
                    break;
                case '/':
                    mycal.result = mycal.numa / mycal.numb;
                    mycal.error = 0;
                    break;
                case '*':
                    mycal.result = mycal.numa * mycal.numb;
                    mycal.error = 0;
                    break;
                case 'e':
                    close(client_sockfd);
                    break;
            }
            std::cout << mycal.numa << " " << mycal.op << " " << mycal.numb << " = " << mycal.result << std::endl;
            
            // send calc result to client
            H2N(&mycal);
            send(client_sockfd, &mycal, sizeof(mycal), 0);
        }
    }
    std::cout << "end" << std::endl;
}

