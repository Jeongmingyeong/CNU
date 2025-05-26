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
int sock = 0, valread;
struct sockaddr_in serv_addr;
char buffer[1024] = {0};
char *messages[WINDOW_SIZE-1];
char *ack = "ACK";
int seq_num = 0b000;
int re_time = 2; // renewal 타임 변수
clock_t past; // clock을 이용해 과거 시간을 저장할 변수
int is_connect = 0; // connect 확인 변수 (연결x : 0, 연결 : 1)

struct Frame {
    int Flag;
    char Address; // sender : b | receiver : a
    int Control; // I-frame : 0 = 0 | S-frame : 10 = 2 | U-frame : 11 = 3
    char Data[1024]; //Closing Falg 잘라내고 데이터 값 찾기;
    int Closing_Flag;
};

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
	printf("- 2. chat   \n");
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
    // create socket
    if ((sock = socket(AF_INET, SOCK_STREAM, 0)) < 0) { 
        printf("\n Socket creation error \n");
        return -1;
    }
    memset(&serv_addr, '0', sizeof(serv_addr));
    serv_addr.sin_family = AF_INET;
    serv_addr.sin_port = htons(PORT);
    if (inet_pton(AF_INET, "127.0.0.1", &serv_addr.sin_addr) <= 0) {
        printf("Invalid address/ Address not supported \n");
        return -1;
    }
    if (connect(sock, (struct sockaddr *)&serv_addr, sizeof(serv_addr)) < 0) {
        printf("Connection Failed \n");
        return -1;
    }

    // 구조체 만들기
    struct Frame f;

    // 사용자에게 1을 입력받을때까지 반복
    while(1) {
        if(!is_connect) {
            print_connect_menu();
            int select = 0;
            scanf("%d", &select);
            if(select != 1) { // 1번을 선택하지 않았다면 다시 선택하도록
                printf("retry\n");
                continue;
            }

            printf("\n=================================\n");
            printf("request connection. (SABM)\n");
            struct Frame sabm = {FLAG, SENDER_ADDRESS, SABM, "", FLAG};
            send(sock, &sabm, sizeof(sabm), 0);
            
            /* 통신 결과 수신까지 기다리기 */
            /* 수신받은 소켓(frame)의 정보를 우리가 따로 생성한 frame 에 저장 */
            /* valread : read 함수가 실제로 읽은 byte 수  */
            /* 우리가 수신받은 데이터는 f 에 저장되어있음. */
            valread = read(sock, &f, sizeof(struct Frame));

            printf("Received UA message.\n");
            check_flag(f);
            check_address(f);

            printf("connection success\n");
            is_connect = 1;
            printf("=================================\n");

        } else { // 연결되었다면
            print_menu();
            int select = 0;
            scanf("%d", &select);

            // 입력 버퍼 비우기
            int c;
            while ((c = getchar()) != '\n' && c != EOF) {}

            switch(select){
                case 2: // chat mode
                    while(1){
                        // 보낼 메세지 입력받기
                        printf("Send[SEQ: %d]: ", seq_num);

                        fgets(f.Data, sizeof(f.Data), stdin);
                        printf("\n");

                        // if(check_str(f.Data, "quit\n") || check_str(f.Data, "exit\n")){
                        //     printf("break chat\n");
                        //     seq_num = 0;
                        //     break;
                        // }

                        // frame 만들기
                        f.Flag = FLAG;
                        f.Address = SENDER_ADDRESS;
                        f.Control = I_FRAME + ((seq_num % 8) << 4);
                        f.Closing_Flag = FLAG;
                        // struct Frame f2 = {FLAG, SENDER_ADDRESS, I_FRAME, d, FLAG};
                        // struct Frame sabm = {FLAG, SENDER_ADDRESS, SABM, "", FLAG};
                        seq_num++;                        

                        // 보내기
                        send(sock, &f, sizeof(f), 0);
                        // printf("send I-frame\n"); // 확인용
                        if(check_str(f.Data, "quit\n") || check_str(f.Data, "exit\n")){
                            printf("break chat\n");
                            seq_num = 0;
                            break;
                        }

                        // 수신
                        valread = read(sock, &f, sizeof(f));
                        for (int i = 0; f.Data[i] != '\0'; i++) {
                            if (islower(f.Data[i])) {
                                f.Data[i] = toupper(f.Data[i]);  // 소문자를 대문자로 변경
                            } else if (isupper(f.Data[i])) {
                                f.Data[i] = tolower(f.Data[i]);  // 대문자를 소문자로 변경
                            }
                        }

                        if((seq_num % 8) != (f.Control % 8)){
                            printf("send NAK\n");
                            printf("seq_num : %d, f.Control: %d\n", (seq_num % 8), (f.Control % 8));
                        } else {
                            printf("correct!!\n");
                            printf("seq_num : %d, f.Control: %d\n", (seq_num % 8), (f.Control % 8));
                        }
                        // printf("receive from client : %s\n", f.Data);
                        // break;
                    }
                    break;
                case 3: // disconnect
                    // f = {FLAG, SENDER_ADDRESS, DISC, "", FLAG};
                    f.Flag = FLAG;
                    f.Address = SENDER_ADDRESS;
                    f.Control = DISC;
                    strcpy(f.Data, "");
                    f.Closing_Flag = FLAG;
                    send(sock, &f, sizeof(f), 0);

                    valread = read(sock, &f, sizeof(f));
                    printf("\n=================================\n");
                    printf("Received UA message from receiver.\n");
                    printf("Disconnect.\n");
                    printf("=================================\n");
                    is_connect = 0; // 연결 해제
                    seq_num = 0;
                    continue; // 다시 연결하려는 코드 실행
            }
        }
    }
 

    // Close socket
    close(sock);

    return 0;

}
