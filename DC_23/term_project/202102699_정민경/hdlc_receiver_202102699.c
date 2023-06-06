#include <stdio.h>
#include <stdlib.h>
#include <sys/socket.h>
#include <arpa/inet.h>
#include <string.h>
#include <unistd.h>
#include <time.h>
#include <pthread.h>
#include <ctype.h>

#define PORT 8080
#define WINDOW_SIZE 4
#define SENDER_ADDRESS 'b'
#define RECEIVER_ADDRESS 'a'
#define I_FRAME 0b00000000
#define S_FRAME 0b10000000
// U-Frame 값 define
#define SABM 0b11110100
#define UA 0b11000110
#define DISC 0b11000010
#define FLAG 0x7E

int G_Flag = FLAG; // flag 를 비교할 전역변수
int sock = 0;
char buffer[1024] = {0};
char *messages[WINDOW_SIZE-1];
char *ack = "ACK";
int seq_num = 0;
int re_time = 2; // renewal 타임 변수
clock_t past; // clock을 이용해 과거 시간을 저장할 변수
int is_connect = 0; // connect 확인 변수 (연결x : 0, 연결 : 1)
int server_fd, new_socket, valread;
int opt = 1;
struct sockaddr_in address;
int addrlen = sizeof(address);
int ack_num = 0b001;
int count = 0;

struct Frame {
    int Flag;
    char Address; // sender : b | receiver : a
    int Control; // I-frame : 0 = 0 | S-frame : 10 = 2 | U-frame : 11 = 3
    char Data[1024]; //Closing Falg 잘라내고 데이터 값 찾기;
    int Closing_Flag;
};

// void sendFrames() {
//     send(sock, 보낼것, sizeof(구조체 크기), 0);
//     printf("Sending frame with sequence number %d\n", seq_num + i);
// }

// 처음 연결을 시작하고자 할 때 출력되는 menu 
void print_connect_menu() {
    printf("\n----------------------------\n");
	printf("- 1. connect                  \n");
	printf("------------------------------\n");
	printf("- What do you want ? : ");
}

// 연결 성공하면 출력되는 menu
void print_menu() {
    printf("\n----------------------------\n");
	printf("- 2. chat  -\n");
	printf("- 3. disconnect               \n");
	printf("------------------------------\n");
	printf("- What do you want ? : ");
}

void check_flag(struct Frame f) {
    if(f.Flag == G_Flag){
        printf("Flag is same. %d = %d\n", f.Flag, G_Flag);
        printf("CFlag is same. %d = %d\n", f.Closing_Flag, G_Flag);
    } else {
        printf("Flag is different.\n");
    }
}

void check_address(struct Frame f) {
    printf("Address is %c\n", f.Address);
}

int check_str(char* s1, char* s2) { // string 끼리의 비교 시 같으면 1, 다르면 0 return
    if(strcmp(s1, s2) == 0) {
        return 1;
    } else {
        return 0;
    }
}

int main(int argc, char const *argv[]) {
    // Creating socket file descriptor
    if ((server_fd = socket(AF_INET, SOCK_STREAM, 0)) == 0) {
        perror("socket failed");
        exit(EXIT_FAILURE);
    }
    
    // Set socket options
    if (setsockopt(server_fd, SOL_SOCKET, SO_REUSEADDR | SO_REUSEPORT, &opt, sizeof(opt))) {
        perror("setsockopt failed");
        exit(EXIT_FAILURE);
    }
    
    address.sin_family = AF_INET;
    address.sin_addr.s_addr = INADDR_ANY;
    address.sin_port = htons(PORT);
    
    // Bind the socket to the specified port
    if (bind(server_fd, (struct sockaddr *)&address, sizeof(address)) < 0) {
        perror("bind failed");
        exit(EXIT_FAILURE);
    }    
    // Listen for incoming connections
    if (listen(server_fd, 3) < 0) {
        perror("listen failed");
        exit(EXIT_FAILURE);
    }    
    printf("Waiting for incoming connection...\n");    
    // Accept incoming connections
    if ((new_socket = accept(server_fd, (struct sockaddr *)&address, (socklen_t*)&addrlen)) < 0) {
        perror("accept failed");
        exit(EXIT_FAILURE);
    }    
    printf("Connection accepted\n");

    // 구조체 만들기
    struct Frame f;

    // 사용자에게 1을 입력받을때까지 반복
    while(1) {
        if(!is_connect) {
            /* 통신 결과 수신까지 기다리기 */
            /* 수신받은 소켓(frame)의 정보를 우리가 따로 생성한 frame 에 저장 */
            /* valread : read 함수가 실제로 읽은 byte 수  */
            /* 우리가 수신받은 데이터는 f 에 저장되어있음. */
            valread = read(new_socket, &f, sizeof(struct Frame));
            printf("\n=================================\n");

            check_flag(f);
            check_address(f);

            printf("received message is SABM.\n");
            printf("Send UA message.\n");

            struct Frame ua = {FLAG, RECEIVER_ADDRESS, UA, "", FLAG};
            send(new_socket, &ua, sizeof(ua), 0);
            is_connect = 1;
            printf("=================================\n\n");

        } else { // 연결되었다면
            valread = read(new_socket, &f, sizeof(struct Frame));

            if((f.Control >> 7) == 0b0) {
                for (int i = 0; f.Data[i] != '\0'; i++) {
                    if (islower(f.Data[i])) {
                        f.Data[i] = toupper(f.Data[i]);  // 소문자를 대문자로 변경
                    } else if (isupper(f.Data[i])) {
                        f.Data[i] = tolower(f.Data[i]);  // 대문자를 소문자로 변경
                    }
                }

                printf("Receiver[SEQ: %d, ACK: %d]: %s\n", seq_num, (count + 1), f.Data);
        
                if((count % 8) != (f.Control >> 4)) {
                    printf("conut : %d, f.Control ; %d", count, f.Control);
                    printf("NAK\n"); // 이론상 unreachable
                    continue;
                } 

                count++;

                // printf("receive from server : %s\n", f.Data);
                

                f.Flag = FLAG;
                f.Address = RECEIVER_ADDRESS;
                f.Control = I_FRAME + (ack_num % 8);
                f.Closing_Flag = FLAG;

                ack_num++;

                if(check_str(f.Data, "QUIT\n") || check_str(f.Data, "EXIT\n")){
                    printf("break chat\n");
                    count = 0;
                    ack_num = 1;
                    seq_num = 0;
                    continue;
                }
                send(new_socket, &f, sizeof(f), 0);

            } else if((f.Control >> 6) == 0b11) {
                struct Frame ua = {FLAG, RECEIVER_ADDRESS, UA, "", FLAG};
                send(new_socket, &ua, sizeof(ua), 0);
                printf("\n=================================\n");
                printf("send UA to sender\n");
                printf("Disconnect.\n");
                printf("=================================\n");
                is_connect = 0;
                seq_num = 0;
                ack_num = 1;
                count = 0;
            }
        }
    }

    // Close socket
    close(new_socket);

    return 0;

}
