#include <iostream>
#include <cstring>
#include <unistd.h>
#include <sys/socket.h>
#include <arpa/inet.h>
#include <wiringPi.h>

#define TRIG 0
#define ECHO 2

void error_handling(const char* message);

int main(void) {
    int distance = 0;
    int pulse = 0;
    int threshold = 0;
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

    std::cout << "Raspberry Pi Distance Socket\n";

    if (read(clnt_sock, message, sizeof(message)) == -1)
        error_handling("read error");
    threshold = atoi(message);
    std::cout << "Threshold : " << threshold << "cm\n";
    if (wiringPiSetup() == -1)
        return 1;
    pinMode(TRIG, OUTPUT);
    pinMode(ECHO, INPUT);
    while(1) {
        long travelTime = 0;
        long startTime = 0;
        digitalWrite(TRIG, LOW);
        usleep(2);
        digitalWrite(TRIG, HIGH);
        usleep(10);
        digitalWrite(TRIG, LOW);
        while (digitalRead(ECHO) == LOW)
            startTime = micros();
        while (digitalRead(ECHO) == HIGH)
            travelTime = micros() - startTime;
        distance = travelTime / 58;
        if (distance < threshold) {
            std::cout << "Distance : " << distance << "cm\n";
            sprintf(message, "%d", distance);
            if (write(clnt_sock, message, sizeof(message)) == -1)
                error_handling("write error");
        } else{
			std::cout << "Distance : " << distance << "cm (Threshold Exceeded)\n";
		}
        delay(100);
    }
    close(clnt_sock);
    close(serv_sock);
    return 0;
}
void error_handling(const char* message) {
    std::cerr << message << '\n';
    exit(1);
}
