#include <iostream>
#include <cstring>
#include <unistd.h>
#include <sys/socket.h>
#include <arpa/inet.h>
#include <wiringPi.h>

#define LED 4

void error_handling(const char* message);

int main(int argc, char* argv[]) {
    int serv_sock, clnt_sock;
    int reuse = 1;
    struct sockaddr_in serv_addr, clnt_addr;
    socklen_t clnt_addr_size;
    char message[1024] = {0x00, };

    serv_sock = socket(PF_INET, SOCK_STREAM, 0);
    setsockopt(serv_sock, SOL_SOCKET, SO_REUSEADDR, &reuse, sizeof(reuse));
    if (serv_sock == -1)
        error_handling("socket error");

    memset(&serv_addr, 0, sizeof(serv_addr));
    serv_addr.sin_family = AF_INET;
    serv_addr.sin_addr.s_addr = htonl(INADDR_ANY);
    serv_addr.sin_port = htons(atoi("8081"));

    if (bind(serv_sock, (struct sockaddr*) &serv_addr, sizeof(serv_addr)) == -1)
        error_handling("bind error");
    if (listen(serv_sock, 5) == -1)
        error_handling("listen error");

    clnt_addr_size = sizeof(clnt_addr);
    clnt_sock = accept(serv_sock, (struct sockaddr*) &clnt_addr, &clnt_addr_size);
    if (clnt_sock == -1)
        error_handling("accept error");

    std::cout << "Raspberry Pi Button Socket\n";

    if (wiringPiSetup() == -1)
        return 1;

    pinMode(LED, OUTPUT);

    while(1){
        if (read(clnt_sock, message, sizeof(message)) == -1)
            error_handling("read error");
        std::cout << "Toggle!\n";
        digitalWrite(LED, !digitalRead(LED));
    }

    close(clnt_sock);
    close(serv_sock);
    return 0;
}

void error_handling(const char* message) {
    std::cerr << message << '\n';
    exit(1);
}
