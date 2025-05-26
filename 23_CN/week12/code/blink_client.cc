#include <iostream>
#include <cstring>
#include <unistd.h>
#include <sys/socket.h>
#include <arpa/inet.h>
#include <wiringPi.h>

#define BUTTON 1

void error_handling(const char* message);

int main(void) {
    int clnt_sock;
    struct sockaddr_in serv_addr;
    char message[1024] = {0x00, };

    clnt_sock = socket(PF_INET, SOCK_STREAM, 0);
    if (clnt_sock == -1)
        error_handling("socket error");

    memset(&serv_addr, 0, sizeof(serv_addr));
    serv_addr.sin_family = AF_INET;
    serv_addr.sin_addr.s_addr = inet_addr("127.0.0.1");
    serv_addr.sin_port = htons(atoi("8081"));

    if (connect(clnt_sock, (struct sockaddr*) &serv_addr, sizeof(serv_addr)) == -1)
        error_handling("connect error");

    std::cout << "Raspberry Pi Button Socket\n";

    if (wiringPiSetup() == -1)
        return 1;

    pinMode(BUTTON, INPUT);

    while(1) {
        if (digitalRead(BUTTON) == HIGH) {
            if (write(clnt_sock, message, sizeof(message)) == -1)
                error_handling("write error");
            std::cout << "Toggle!\n";
            delay(500);
        }
    }

    return 0;
}

void error_handling(const char* message) {
    std::cerr << message << '\n';
    exit(1);
}
