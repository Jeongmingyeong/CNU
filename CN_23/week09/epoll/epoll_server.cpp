#include <iostream>
#include <unistd.h>
#include <cstring>
#include <sys/epoll.h>
#include <arpa/inet.h>
#include <sys/socket.h>
#include <netinet/in.h>

#define SA struct sockaddr
#define EPOLL_SIZE 20

int main(int argc, char **argv) {
    struct sockaddr_in addr, clientaddr;
    struct epoll_event events[EPOLL_SIZE];
    int sfd, cfd, clilen;
    int flag = 1;
    int n, i;
    int readn;
    int efd;
    char buf_in[512];

    // create
    epoll_create(10);    	

    // create

    clilen = sizeof(clientaddr);
    sfd = socket(AF_INET, SOCK_STREAM, 0);

    if (sfd == -1) {
        perror("socket error:");
        close(sfd);
        return 1;
    }
    addr.sin_family = AF_INET;
    addr.sin_port = htons(8801);
    addr.sin_addr.s_addr = htonl(INADDR_ANY);
    if (bind(sfd, (SA *)&addr, sizeof(addr)) == -1) {
        close(sfd);
        return 1;
    }
    listen(sfd, 5);

    // listen socket에 대해 이벤트 설정하고 epoll_ctl을 이용해서 이벤트 풀에 추가 시킴
    events[0].events = EPOLLIN;
    events[0].data.fd = sfd;
    epoll_ctl(efd, EPOLL_CTL_ADD, sfd, &events[0]);

    while (1) {
        // wait
        n = epoll_wait(efd, events, EPOLL_SIZE, -1);
        if (n == -1) {
            perror("epoll wait error");
        }
        // 이벤트가 발생했다면 이벤트 발생 개수만큼 루프
        for (i = 0; i < n; i++) {
            // 이벤트가 listen socket 이면 accpet
            if (events[i].data.fd == sfd) {
                std::cout << "Accept" << std::endl;
                cfd = accept(sfd, (SA *)&clientaddr, (socklen_t *)&clilen);
                events[i].events = EPOLLIN;
                events[i].data.fd = cfd;
                epoll_ctl(efd, EPOLL_CTL_ADD, cfd, &events[i]);                
            } else {
                memset(buf_in, 0x00, sizeof(buf_in));
                readn = recv(events[i].data.fd, buf_in, sizeof(buf_in)-1, 0);
                if (readn <= 0) {
                    epoll_ctl(efd, EPOLL_CTL_DEL, events[i].data.fd, &events[i]);
                    close(events[i].data.fd);
                    std::cout << "Close fd: " << cfd << std::endl;
                } else {
                    std::cout << "Read data from client: " << buf_in << std::endl;
                    send(events[i].data.fd, buf_in, sizeof(buf_in)-1, 0);
                }
            }
        }
    }
    return 0;
}
