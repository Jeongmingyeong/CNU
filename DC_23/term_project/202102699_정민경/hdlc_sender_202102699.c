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
// U-Frame �� define
#define SABM 0b11110100
#define UA 0b11000110
#define DISC 0b11000010
#define FLAG 0x7E

int G_Flag = FLAG; // flag �� ���� ��������
int sock = 0, valread;
struct sockaddr_in serv_addr;
char buffer[1024] = {0};
char *messages[WINDOW_SIZE-1];
char *ack = "ACK";
int seq_num = 0b000;
int re_time = 2; // renewal Ÿ�� ����
clock_t past; // clock�� �̿��� ���� �ð��� ������ ����
int is_connect = 0; // connect Ȯ�� ���� (����x : 0, ���� : 1)

struct Frame {
    int Flag;
    char Address; // sender : b | receiver : a
    int Control; // I-frame : 0 = 0 | S-frame : 10 = 2 | U-frame : 11 = 3
    char Data[1024]; //Closing Falg �߶󳻰� ������ �� ã��;
    int Closing_Flag;
};

// ó�� ������ �����ϰ��� �� �� ��µǴ� menu 
void print_connect_menu() {
    printf("\n----------------------------\n");
	printf("- 1. connect                  \n");
	printf("------------------------------\n");
	printf("- What do you want ? : ");
}

// ���� �����ϸ� ��µǴ� menu
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

int check_str(char* s1, char* s2) { // string ������ �� �� ������ 1, �ٸ��� 0 return
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

    // ����ü �����
    struct Frame f;

    // ����ڿ��� 1�� �Է¹��������� �ݺ�
    while(1) {
        if(!is_connect) {
            print_connect_menu();
            int select = 0;
            scanf("%d", &select);
            if(select != 1) { // 1���� �������� �ʾҴٸ� �ٽ� �����ϵ���
                printf("retry\n");
                continue;
            }

            printf("\n=================================\n");
            printf("request connection. (SABM)\n");
            struct Frame sabm = {FLAG, SENDER_ADDRESS, SABM, "", FLAG};
            send(sock, &sabm, sizeof(sabm), 0);
            
            /* ��� ��� ���ű��� ��ٸ��� */
            /* ���Ź��� ����(frame)�� ������ �츮�� ���� ������ frame �� ���� */
            /* valread : read �Լ��� ������ ���� byte ��  */
            /* �츮�� ���Ź��� �����ʹ� f �� ����Ǿ�����. */
            valread = read(sock, &f, sizeof(struct Frame));

            printf("Received UA message.\n");
            check_flag(f);
            check_address(f);

            printf("connection success\n");
            is_connect = 1;
            printf("=================================\n");

        } else { // ����Ǿ��ٸ�
            print_menu();
            int select = 0;
            scanf("%d", &select);

            // �Է� ���� ����
            int c;
            while ((c = getchar()) != '\n' && c != EOF) {}

            switch(select){
                case 2: // chat mode
                    while(1){
                        // ���� �޼��� �Է¹ޱ�
                        printf("Send[SEQ: %d]: ", seq_num);

                        fgets(f.Data, sizeof(f.Data), stdin);
                        printf("\n");

                        // if(check_str(f.Data, "quit\n") || check_str(f.Data, "exit\n")){
                        //     printf("break chat\n");
                        //     seq_num = 0;
                        //     break;
                        // }

                        // frame �����
                        f.Flag = FLAG;
                        f.Address = SENDER_ADDRESS;
                        f.Control = I_FRAME + ((seq_num % 8) << 4);
                        f.Closing_Flag = FLAG;
                        // struct Frame f2 = {FLAG, SENDER_ADDRESS, I_FRAME, d, FLAG};
                        // struct Frame sabm = {FLAG, SENDER_ADDRESS, SABM, "", FLAG};
                        seq_num++;                        

                        // ������
                        send(sock, &f, sizeof(f), 0);
                        // printf("send I-frame\n"); // Ȯ�ο�
                        if(check_str(f.Data, "quit\n") || check_str(f.Data, "exit\n")){
                            printf("break chat\n");
                            seq_num = 0;
                            break;
                        }

                        // ����
                        valread = read(sock, &f, sizeof(f));
                        for (int i = 0; f.Data[i] != '\0'; i++) {
                            if (islower(f.Data[i])) {
                                f.Data[i] = toupper(f.Data[i]);  // �ҹ��ڸ� �빮�ڷ� ����
                            } else if (isupper(f.Data[i])) {
                                f.Data[i] = tolower(f.Data[i]);  // �빮�ڸ� �ҹ��ڷ� ����
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
                    is_connect = 0; // ���� ����
                    seq_num = 0;
                    continue; // �ٽ� �����Ϸ��� �ڵ� ����
            }
        }
    }
 

    // Close socket
    close(sock);

    return 0;

}
