// compile : gcc -std=gnu99 -o test.out 202102699.c -pthread
#define _CRT_SECURE_NO_WARNINGS
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/socket.h>
#include <arpa/inet.h>
#include <unistd.h>
#include <pthread.h>
#include <libgen.h>
#include <net/if.h>
#include <sys/ioctl.h>
#include <errno.h>
#include <malloc.h>
#define MAX_SIZE 300
#define IP_ADDRESS "127.0.0.1"

// server : 받고 주는애
// client : 보내기만 하는 애

struct L1
{
    int saddr[4];
    int daddr[4];
    int length;
    char L1_data[MAX_SIZE];
};
struct L2
{
    int saddr[6];
    int daddr[6];
    int length;
    char L2_data[MAX_SIZE];
};
struct Control
{
    int type; // 1: chat 2: find adress    
};
struct Addr // 여기에 내 ip, mac 주소 저장되어있음
{
    int type;
    char ip[4];
    char mac[6];
};

void L1_send(char *input, int length);
void L2_send(char *input, int length);
void L3_send(char *data, int length);
char *L1_receive(int *);
char *L2_receive(int *);
char *L3_receive(int *);

int sndsock, rcvsock, clen;
struct sockaddr_in s_addr, r_addr;
void *do_thread(void *);

void init_socket();
void initAdress();

void check_is_server(char *const *argv);
int is_server = 0;

struct Control control;
struct Addr addr;


int main(int argc, char *argv[])
{

    check_is_server(argv);
    init_socket();
    initAdress();
    char input[MAX_SIZE];

    int length;
    pthread_t t_id;
    int status = pthread_create(&t_id, NULL, do_thread, NULL);
    if (status != 0)
    {
        printf("Thread Error!\n");
        exit(1);
    }
   while (1)   {
        fgets(input, sizeof(input), stdin);   
      L1_send(input, strlen(input));      
   }
   
    
}

void initAdress()
{

    control.type = 2;
    char output[MAX_SIZE];
    int length;

    if (is_server == 0)
    {
        // client
        printf("\033[0;31m[Find Adress Mode - Request ...]\n\033[0m");
        addr.type = 0;
        L1_send("", strlen(""));

        strcpy(output, L1_receive(&length));
        output[length] = '\0';        
        printf("\033[0;33m[Mode Change]\n\033[0m");
        control.type = 1;
    }
    else
    {
        // server
        strcpy(output, L1_receive(&length));
        output[length] = '\0';
        L1_send("", strlen(""));

        //printf("[Find Adress Mode - Success ...]\n");
      printf("\033[0;33m[Find Adress Mode - Success ...]\n\033[0m");
        control.type = 1;
    }
}

void *do_thread(void *arg)
{
    char output[MAX_SIZE];
    int length;
    while (1)
    {
        if (control.type == 1) // Not Find_Addr Mode
        {
            strcpy(output, L1_receive(&length));
            output[length] = '\0';
            if (strlen(output) > 1)
            {
                printf("Received: %s", output);
            }
        }
    }
    return NULL;
}

void L1_send(char *input, int length)
{
    struct L1 data;
    struct Addr addrData;
   char temp[350];
    int size = 0;
    if (control.type == 2) // Find_Addr Mode
    {
        if (is_server == 0) // client 
        {
            data.saddr[0] = 0x33;
            data.saddr[1] = 0x33;
            data.saddr[2] = 0x33;
            data.saddr[3] = 0x33;

            data.daddr[0] = 0x44;
            data.daddr[1] = 0x44;
            data.daddr[2] = 0x44;
            data.daddr[3] = 0x44;
         
            data.length = length;
            memset(data.L1_data, 0x00, MAX_SIZE);
            strcpy(data.L1_data, input);

            size = sizeof(struct L1) - sizeof(data.L1_data) + length;
            memset(temp, 0x00, 350);
            memcpy(temp, (void *)&data, size);
            L2_send(temp, size);
         // 형식상 맞춰줌
        }
        else
        {
            // server
            printf("[%s] my IP --> ", __func__);
            unsigned char ip[] = {192, 168, 0, 1};
            for (int i = 0; i < sizeof(ip); i++)
            {
                addrData.ip[i] = ip[i];
            addr.ip[i] = ip[i];
                printf("%hhu", addrData.ip[i]);
                if (i != 3)
                    printf(".");
            }
            printf("\n");
            data.saddr[0] = 0x33;
            data.saddr[1] = 0x33;
            data.saddr[2] = 0x33;
            data.saddr[3] = 0x33;

            data.daddr[0] = 0x44;
            data.daddr[1] = 0x44;
            data.daddr[2] = 0x44;
            data.daddr[3] = 0x44;
         // 형식상 맞춰줌
         /*
            구현. IP 주소 헤더에 붙임
         */

            // addrData 에 ip 저장되어있고, L1_header 를 붙여주기 위해 L1_data 에 addrData 저장
            memset(data.L1_data, 0x00, MAX_SIZE);
            memcpy(data.L1_data, (void *)&addrData, sizeof(addrData)); 
 
            // L1_data 에 addrData 를 저장했으므로 그 size로 update
            size = sizeof(struct L1) - sizeof(data.L1_data) + sizeof(addrData); 

            memset(temp, 0x00, 350);
            memcpy(temp, (void*)&data, size);

            L2_send(temp, size);      
        }
    }
    else if (control.type == 1) // Not Find_Addr Mode[L1]
    {      
      
      for (int i = 0; i < sizeof(addr.ip); i++) 
      {
         // printf("send ip : %hhu\n", addr.ip[i]);
            data.daddr[i] = addr.ip[i];
            // printf("save ip : %hhu\n", data.daddr[i]);
      }
      //printf("\n"); 

      printf("[%s] daddr(IP) setting FINISH --> ", __func__); 
      for (int i = 0; i < sizeof(addr.ip); i++) 
      {
         printf("%hhu", data.daddr[i]);
         if (i != 3)
            printf(".");         
      }
      printf("\n");    
      
        data.saddr[0] = 0x33;
        data.saddr[1] = 0x33;
        data.saddr[2] = 0x33;
        data.saddr[3] = 0x33;
      // [!]도착지 주소 생략 가능
      /*
        data.daddr[0] = 0x44;
        data.daddr[1] = 0x44;
        data.daddr[2] = 0x44;
        data.daddr[3] = 0x44;
      */

      // 나머지 코드는 동일함
        data.length = length;
        memset(data.L1_data, 0x00, MAX_SIZE);
        strcpy(data.L1_data, input);
        size = sizeof(struct L1) - sizeof(data.L1_data) + length;
        memset(temp, 0x00, 350);
        memcpy(temp, (void *)&data, size);
        L2_send(temp, size);   
      
    }

}

void L2_send(char *input, int length)
{
    struct L2 data;
    struct Addr addrData;

    char temp[350];
    int size = 0;
    if (control.type == 2)
    {
        if (is_server == 0) // client
        {
            data.saddr[0] = 0x11;
            data.saddr[1] = 0x12;
            data.saddr[2] = 0x13;
            data.saddr[3] = 0x14;
            data.saddr[4] = 0x15;
            data.saddr[5] = 0x16;

            data.daddr[0] = 0x21;
            data.daddr[1] = 0x22;
            data.daddr[2] = 0x23;
            data.daddr[3] = 0x24;
            data.daddr[4] = 0x25;
            data.daddr[5] = 0x26;

            data.length = length;
            memset(data.L2_data, 0x00, MAX_SIZE);
            memcpy(data.L2_data, (void *)input, length);

            size = sizeof(struct L2) - sizeof(data.L2_data) + length;

            memset(temp, 0x00, 350);
            memcpy(temp, (void *)&data, size);
            L3_send(temp, size);
        }
        else // server
        {
            struct L1 *tempL1 = (struct L1 *)input; 
            struct Addr *tempAddr = (struct Addr *)tempL1->L1_data; 
            memcpy(addrData.ip, tempAddr->ip, sizeof(addrData.ip)); 

            unsigned char mac[] = {0x00, 0x10, 0x00, 0x0A, 0x00, 0x00};
            printf("[%s] my MAC --> ", __func__);
            for (int i = 0; i < sizeof(mac); i++)
            {
            // 구현. addrData.mac 과 addr에 각각 mac[]의 값 할당
                addrData.mac[i] = mac[i]; // 지역변수 struct 에 mac 할당 -> mac을 확인할때 사용
                addr.mac[i] = mac[i]; // 전역변수 struct 에 mac 할당 -> mac을 가져올때 사용

            // hint. 아래는 출력문임 
                printf("%02X", addrData.mac[i]);
                if (i != 5)
                    printf(":");
            }
            printf("\n");
         
            data.saddr[0] = 0x11;
            data.saddr[1] = 0x12;
            data.saddr[2] = 0x13;
            data.saddr[3] = 0x14;
            data.saddr[4] = 0x15;
            data.saddr[5] = 0x16;

            data.daddr[0] = 0x21;
            data.daddr[1] = 0x22;
            data.daddr[2] = 0x23;
            data.daddr[3] = 0x24;
            data.daddr[4] = 0x25;
            data.daddr[5] = 0x26;

            data.length = length;
         
         // 구현. memset, cpy 2번
            // addrData 를 L1에 넣고 L2에 넣음

            // 현재 addrData에 mac과 ip 저장되어있음. 이것을 L1_data에 저장
            memset(tempL1->L1_data, 0x00, MAX_SIZE);
            memcpy(tempL1->L1_data, (void*)&addrData, sizeof(tempL1->L1_data));

            // L1_data에 L2_header를 붙여야하므로 L1 구조체를 L2_data에 저장 
            memset(data.L2_data, 0x00, MAX_SIZE);
            memcpy(data.L2_data, tempL1, sizeof(data.L2_data)); 
            
            size = sizeof(struct L2) - sizeof(data.L2_data) + length;

            memset(temp, 0x00, 350);
            memcpy(temp, (void *)&data, size);
            L3_send(temp, size);
        }
    }
    else if (control.type == 1)
    {
      for (int i = 0; i < sizeof(addr.mac); i++) 
      {         
         // 구현. 데이터 값 대입
            // printf("send mac : %02x\n", addr.mac[i]);
            data.daddr[i] = addr.mac[i];
            // printf("save mac : %02x\n", data.daddr[i]);
      }
      
        data.saddr[0] = 0x11;
        data.saddr[1] = 0x12;
        data.saddr[2] = 0x13;
        data.saddr[3] = 0x14;
        data.saddr[4] = 0x15;
        data.saddr[5] = 0x16;
      
        data.length = length;
        memset(data.L2_data, 0x00, MAX_SIZE);
        memcpy(data.L2_data, (void *)input, length);

        size = sizeof(struct L2) - sizeof(data.L2_data) + length;

        memset(temp, 0x00, 350);
        memcpy(temp, (void *)&data, size);
        L3_send(temp, size);
    }
}

void L3_send(char *data, int length)
{
    sendto(sndsock, data, length, 0, (struct sockaddr *)&s_addr, sizeof(s_addr));
}

char *L1_receive(int *length)
{
    struct L1 *data;
    struct Addr *addrData;
   
    if (control.type == 2)
    {
        data = (struct L1 *)L2_receive(length);         
        if (is_server == 1)
        {
            // server            
         printf("\033[0;31m[Find Adress Mode - Response ...]\n\033[0m");   
            // printf("L1 Receive");

            *length = *length - sizeof(data->daddr) - sizeof(data->length) - sizeof(data->saddr);
            return (char *)data->L1_data;
        }
        else if (is_server == 0)
        {
            // client
            addrData = (struct Addr *)data->L1_data; 
            // 구현   addrData 에 데이터 파싱된 값들 전역 변수에 할당 진행
            for (int i = 0; i < sizeof(addrData->ip); i++) {
                // 받은 ip를 전역변수 addr.ip에 저장
                addr.ip[i] = addrData->ip[i];
            }

            printf("[%s] your IP --> ", __func__);
            for (int i = 0; i < sizeof(addr.ip); i++)
            {
                printf("%hhu", addr.ip[i]);
                if (i != 3)
                    printf(".");
            }
            printf("\n");
      
            *length = *length - sizeof(data->daddr) - sizeof(data->length) - sizeof(data->saddr);
            return (char *)data->L1_data;
        }
    }
    else if (control.type == 1)
    {
        data = (struct L1 *)L2_receive(length);      
      
      // 편의상 char 형태로  두개의 값을 비교
      char str_ip[16]; // my ip
      char str_daddr[16]; // receive ip
      // 구현 . sprintf(??)

        // 전역변수 addr.ip에 담긴 값을 str_ip 변수에 저장
        sprintf(str_ip, "%hhu.%hhu.%hhu.%hhu", addr.ip[0],addr.ip[1],addr.ip[2],addr.ip[3]); 

         // data.daddr에 담긴 값을 str_daddr 변수에 저장
        sprintf(str_daddr, "%hhu.%hhu.%hhu.%hhu", data->daddr[0], data->daddr[1], data->daddr[2], data->daddr[3]);

        // for (int i = 0; i < 4; i++)
        // {
        //     // hint. 아래는 출력문임 
        //     printf("%hhu", str_ip[i]);
        //     if (i != 3)
        //         printf(".");
        // }
        // printf("\n");

        // for (int i = 0; i < 4; i++)
        // {
        //     // hint. 아래는 출력문임 
        //     printf("%hhu", str_daddr[i]);
        //     if (i != 3)
        //         printf(".");
        // }
        // printf("\n");

      int result = strcmp(str_daddr, str_ip); // 검증
      if (result == 0) {
         *length = *length - sizeof(data->daddr) - sizeof(data->length) - sizeof(data->saddr);
           return (char *)data->L1_data;
      } else {

         printf("L1 : daddr is not equal to %s\n",str_ip);         
      }       
    }
}

char *L2_receive(int *length)
{
    struct L2 *data; // 보내는 애가 붙인 ip, mac 주소 저장
    struct Addr *addrData;
    if (control.type == 2)
    {
        if (is_server == 1)
        {
            // server
            data = (struct L2 *)L3_receive(length);
            *length = *length - sizeof(data->daddr) - sizeof(data->length) - sizeof(data->saddr);
            return (char *)data->L2_data;
        }
        else
        {
            // client
            // 구현. 데이터 파싱과 addr.mac에 값 대입
         // data =   *length =     addrData = 

            // L3_receive 에서 return 해주는 값을 L2 구조로 변환
            data = (struct L2 *)L3_receive(length);  

            // mac 주소를 뗐으니 mac 주소가 저장되어있던 공간을 없애줌. (length에서 mac주소가 사용했던 size 제거)
            *length = *length - sizeof(data->daddr) - sizeof(data->length) - sizeof(data->saddr);

            // L2_data 에 있는 정보를 L1으로 바꾼 후 L1_data 값을 Addr로 변환해 addrData에 할당
            addrData = (struct Addr *)(((struct L1 *)data->L2_data)->L1_data); 

            for (int i = 0; i < sizeof(addrData->mac); i++) {
                // 전달받은 mac 주소를 전역변수 addr.mac 에 저장
                addr.mac[i] = addrData->mac[i];
            }
            // for (int i = 0; i < 6; i++)
            // {
         //    // hint. 아래는 출력문임 
            //     printf("%02X", addr.mac[i]);
            //     if (i != 5)
            //         printf(":");
            // }
            //printf("l2data : %x\n", data->L2_data);

            printf("[%s] your MAC --> ", __func__);
            for (int i = 0; i < sizeof(addr.mac); i++)
            {
            // hint. 아래는 출력문임 
                printf("%02X", addr.mac[i]);
                if (i != 5)
                    printf(":");
            }
            printf("\n");

            return (char *)data->L2_data;
        }
    }
    else if (control.type == 1)
    {

        data = (struct L2 *)L3_receive(length);
      
      char mac[18]; // my ip
      char str_daddr[18]; // receive ip      
      // 구현. L1_rev 참고하여 구현

        // 전역변수 addr.mac에 담긴 값을 mac 변수에 저장
      sprintf(mac, "%02X:%02X:%02X:%02X:%02X:%02X", addr.mac[0],addr.mac[1],addr.mac[2],addr.mac[3],addr.mac[4],addr.mac[5]); 

        // daddr을 str_daddr 변수에 저장
        sprintf(str_daddr, "%02X:%02X:%02X:%02X:%02X:%02X", data->daddr[0], data->daddr[1], data->daddr[2], data->daddr[3],data->daddr[4],data->daddr[5]);

        // for (int i = 0; i < 6; i++)
        //     {
      //       // hint. 아래는 출력문임 
        //         printf("%02X", mac[i]);
        //         if (i != 5)
        //             printf(":");
        //     }
        // printf("\n");

        // for (int i = 0; i < 6; i++)
        //     {
      //       // hint. 아래는 출력문임 
        //         printf("%02X", str_daddr[i]);
        //         if (i != 5)
        //             printf(":");
        //     }
        // printf("\n");

        int result = strcmp(str_daddr, mac);
      if(result==0){         
         *length = *length - sizeof(data->daddr) - sizeof(data->length) - sizeof(data->saddr);
            // printf("L2 : daddr is equal to %s\n",mac);

           return (char *)data->L2_data;
      }else{
         printf("L2 : daddr is not equal to %s\n",mac);   
      }        
    }
}

char *L3_receive(int *length)
{
    static char data[MAX_SIZE];
    *length = recvfrom(rcvsock, data, MAX_SIZE, 0, (struct sockaddr *)&r_addr, &clen);
    return data;
}

void check_is_server(char *const *argv)
{
    // Check is 1 or 2
    char *progname = basename(argv[0]);
    char cmd[256];
    snprintf(cmd, sizeof(cmd), "pgrep -x %s | wc -l", progname);
    FILE *fp = popen(cmd, "r");
    if (fp == NULL)
    {
        perror("popen");
        exit(EXIT_FAILURE);
    }
    int process_count = 0;
    char line[256];
    if (fgets(line, sizeof(line), fp) != NULL)
    {
        process_count = atoi(line);
    }
    pclose(fp);
    is_server = process_count == 1;
}
void init_socket()
{

    int send_port;
    int receive_port;    

    if (is_server == 0)
    {
        printf("Session 2 starting...\n");
        send_port = 8811;
        receive_port = 8810;
    }
    else
    {
        printf("Session 1 starting...\n");
        send_port = 8810;
        receive_port = 8811;
      
    }
    // Create Send Socket
    if ((sndsock = socket(PF_INET, SOCK_DGRAM, IPPROTO_UDP)) < 0)
    {
        perror("socket error : ");
        exit(1);
    }
    s_addr.sin_family = AF_INET;
    s_addr.sin_addr.s_addr = inet_addr(IP_ADDRESS);
    s_addr.sin_port = htons(send_port);
    if (connect(sndsock, (struct sockaddr *)&s_addr, sizeof(s_addr)) < 0)
    {
        perror("connect error : ");
        exit(1);
    }
    // Create Receive Socket
    if ((rcvsock = socket(PF_INET, SOCK_DGRAM, IPPROTO_UDP)) < 0)
    {
        perror("socket error : ");
        exit(1);
    }

    clen = sizeof(r_addr);
    memset(&r_addr, 0, sizeof(r_addr));

    r_addr.sin_family = AF_INET;
    r_addr.sin_addr.s_addr = inet_addr(IP_ADDRESS);
    r_addr.sin_port = htons(receive_port);
    if (bind(rcvsock, (struct sockaddr *)&r_addr, sizeof(r_addr)) < 0)
    {
        perror("bind error : ");
        exit(1);
    }
    int optvalue = 1;
    int optlen = sizeof(optvalue);
    setsockopt(sndsock, SOL_SOCKET, SO_REUSEADDR, &optvalue, optlen);
    setsockopt(rcvsock, SOL_SOCKET, SO_REUSEADDR, &optvalue, optlen);
    printf("####################################################\n");
    printf("[READY]sndsock port: %d, rcvsock port: %d \n", send_port, receive_port);
    printf("[READY]IP: %s \n", IP_ADDRESS);
    printf("####################################################\n");
         
}
