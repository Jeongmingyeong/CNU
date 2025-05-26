#pragma warning(disable:4996)
#define _CRT_SECURE_NO_WARNINGS

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define TRUE    1
#define FALSE   0

#define ADD 1
#define DELETE 2
#define FIND 3
#define PRINTALL 4
#define QUIT 5

#define NAMEMAX 10
#define PHONEMAX 15

typedef struct Address
{
    char name[NAMEMAX];
    char phone[PHONEMAX];
} Address;


typedef struct AddressBlock
{
    unsigned size;
    Address* book;
    struct AddressBlock* next;
} AddressBlock;

typedef struct AddressBook
{
    unsigned size;
    AddressBlock* head;
} AddressBook;

void initializeAddressBook(AddressBook* addrbook){
    addrbook->size =  0;
    addrbook->head = NULL; //addrbook의 head를 가리키는 포인터가 NULL을 가리킨다.
}

//function : You should complete the function
void finalizeAddressBook(AddressBook* addrbook){
    AddressBlock* p = addrbook->head;
     while(addrbook->head != NULL){
         while(p->next != NULL){
             p = p->next;
         }
         free(p->book);
         free(p);
     }
}

Address* findAddressByName(char* name, AddressBook* addrbook){
    AddressBlock* p;
    int i = 0; //AddressBlock* p = addrbook->head;
    for (p = addrbook->head; p != NULL; p = p->next) { //p의 전체를 돌며 반복
       //char findname[NAMEMAX];
       for(int i = 0; i < p->size; i++){//블록의 사이즈(주소의 개수)만큼 반복
           //int result = strcmp(p->book[i].name, name);
           if (strcmp(p->book[i].name, name) == 0){//찾고자 하는 값과 i번째 인덱스 이름이 같으면
               return &(p->book[i]);//블록의 i번째 인덱스(Address 배열의 인덱스) 반환
           }
       }
   }   
   /*
   while(p != NULL){
        for(i = 0; i < p->size; i++){//블록의 사이즈(주소의 개수)만큼 반복
            //int result = strcmp(p->book[i].name, name);
            if (strcmp(p->book[i].name, name) == 0){//찾고자 하는 값과 i번째 인덱스 이름이 같으면
                return &(p->book[i]);//블록의 i번째 인덱스(Address 배열의 인덱스) 반환
            }
        }
        p = p->next;
   }
   */
    return NULL;
}

//function : You should complete the function
AddressBlock* findMergingTarget(AddressBook* addrbook, AddressBlock* source){
    AddressBlock* p;
    for(p = addrbook->head; p != NULL; p=p->next){
        if(p->size < 5){
            if(p != source){
                return p;
            }
        }
    }

    return NULL;
    }

int addAddress_first(Address* addr, AddressBook* addrbook){
    char name[NAMEMAX];
    strcpy(name, addr->name);
    if(findAddressByName(name, addrbook) != NULL){
        return FALSE;
    }
    
    if(addrbook->head==NULL){//초기상태
        AddressBlock *ab=(AddressBlock *)malloc(sizeof(AddressBlock));
        ab->size = 0;
        ab->next = addrbook->head;//ab와 head연결
        ab->book = (Address *) malloc(sizeof(Address)*5); // 처음에는 5칸 할당
        ab->book[0] = *addr;
        addrbook->head = ab;//헤드 주소 교체
        addrbook->size++;//노드 사이즈 증가
        addrbook->head->size++;//블록 사이즈 증가
        return TRUE;
    }

    if(addrbook->head->size < 10 && addrbook->head->size != 5){//블록의 book 크기가 5미만 혹은 10 미만
        int size = addrbook->head->size;//사이즈 값 계산
        addrbook->head->book[size] = *addr;//사이즈 인덱스에 address저장
        addrbook->head->size++;//사이즈 크기 증가
        addrbook->size++;

    }else if(addrbook->head->size == 5){//book 크기가 5 ->realoc으로 사이즈 재배정
        Address* p = addrbook->head->book;
        addrbook->head->book = (Address *) realloc(p, sizeof(Address)*10);
        addrbook->head->book[5] = *addr;
        addrbook->head->size++;
        addrbook->size++;
    }else{//블록 크기가 10일때
        AddressBlock *ab2 = (AddressBlock *)malloc(sizeof(AddressBlock));
        ab2->next = addrbook->head;
        addrbook->head = ab2;
        addrbook->size++;
        addrbook->head->book = (Address *) malloc(sizeof(Address)*5);
        addrbook->head->book[0] = *addr;//주소 저장
        addrbook->head->size++;//블록 사이즈 증가
    }

    return TRUE;
    }

void deleteBlock(AddressBlock * p, AddressBook* addrbook){//addrbook에서 파라미터로 받은 p블록을 삭제한다.
    if(p->next == NULL && p == addrbook->head){//노드가 하나일 때
        addrbook->head = NULL;
        free(p->book);
        free(p);
    }else if(p == addrbook->head){//첫 노드일때
        addrbook->head = addrbook->head->next;
        addrbook->head = NULL;
        free(p->book);
        free(p);
    }else if(p->next == NULL){//마지막 노드일 때


    }else{//중간일 때
        AddressBlock* tmp = addrbook->head;
        while(tmp->next != NULL){
            if(tmp->next = p){
                tmp->next = tmp->next->next;
                free(tmp->next->book);
                free(tmp->next);
                addrbook->size--;
                break;
            }
            tmp = tmp->next;
        }
    }
}

int deleteAddressByName(char* name, AddressBook* addrbook){
    Address *toFind = findAddressByName(name, addrbook);
    if(toFind == NULL){
        return FALSE;
    }
   for (AddressBlock* p = addrbook->head; p != NULL; p = p->next) {//블록 순회
       char n[NAMEMAX];
       for(int i = 0; i < p->size; i++){//블록 안 book 배열의 Address 순회
           int result = strcmp(p->book[i].name, name);
           if (result == 0){//p의book i인덱스가 제거 대상
               if(p->size ==1){//원소가 하나밖에 없을 때
                    deleteBlock(p, addrbook);
                    addrbook->size--;
                    return TRUE;
               }else{
                    strcpy(n, p->book[i].name);//n에 삭제할 문자열 저장
                    for(int j = i; j<p->size -1; j++){//원소가 여러 개 일 때 삭제
                    p->book[j] = p->book[j+1];
                    }
               }
               p->size--;
               addrbook->size--;

               //병합이 필요한지 검사
               if(p->size < 5){//원소가 다섯개 미만일 때
                   AddressBlock* find = findMergingTarget(addrbook, p);
                   if(find != NULL){
                        AddressBlock* newB = (AddressBlock*)malloc(sizeof(AddressBlock));
                        newB->book = (Address*)malloc(sizeof(Address)*10);
                        newB->size = find->size + p->size;
                        newB->next = NULL;
                        for(int i = 0; i<p->size; i++){
                            newB->book[i] = p->book[i];
                        }
                        for(int i = p->size; i<p->size + find->size; i++){
                            newB->book[i] = find->book[i-p->size];
                        }
                        deleteBlock(find, addrbook);
                        deleteBlock(p, addrbook);
                        newB->next = addrbook->head;
                        addrbook->head = newB;
                        newB->next = NULL;
                   }


               }
               return TRUE;
           }
       }
   }
                
    return FALSE;
    }

int main_menu()
{
    int menu = 0;
    do {
        printf("1. Add an address\n");
        printf("2. Delete an address\n");
        printf("3. Find an address\n");
        printf("4. Print all\n");
        printf("5. Quit\n");
        printf("Select: ");

        scanf("%d", &menu);
    } while (menu < 1 || menu > 5);

    return menu;
}

void name_menu(char* name)
{
    printf("Type a name: ");
    scanf("%s", name);
}

void add_menu(Address* addr)
{
    printf("Type a name: ");
    scanf("%s", addr->name);
    printf("Type a phone number: ");
    scanf("%s", addr->phone);
}

//function : You should complete the function
//The code below does not print the appropriate results
int main()
{
    int menu = 0;
    AddressBook addrbook;
    Address addr;
    char name[10];

    initializeAddressBook(&addrbook);
    do {
        menu = main_menu();
        printf("\n");

        switch (menu) {
        case ADD:
            add_menu(&addr);
            if (addAddress_first(&addr, &addrbook))
                printf("%s is added successfully!\n", addr.name);
            else
                printf("%s already exists in the book\n", addr.name);
            break;
        case DELETE:
            name_menu(name);
            if (deleteAddressByName(name, &addrbook))
                printf("%s is deleted\n", name);
            else
                printf("%s does not exist in the book\n", name);
            break;
        case FIND:
            printf("Type a name: ");
            scanf("%s", name);
            {Address* p = findAddressByName(name, &addrbook);
            if (p == NULL)
                printf("%s is not found\n", name);
            else
                printf("%s: %s\n", p->name, p->phone);
            break;
            }
        case PRINTALL:
            for(AddressBlock* p = addrbook.head; p !=NULL; p = p->next){
                for(int i = 0; i < p->size; i++){
                    printf("%s: %s\n", p->book[i].name, p->book[i].phone);
                }
            }
            break;
        }

        if (menu != QUIT) {
            printf("\n");
            printf("---------------------------Providing My AddressBook---------------------------------------\n");

            printf("(Address Book Size: %d )\n\n", addrbook.size);


            for (AddressBlock* p = addrbook.head; p != NULL; p = p->next) {
                printf("block size : %d\n", p->size);
            }
            printf("------------------------------------------------------------------------------------------\n");
            printf("\n");
           
        }
           
           
    } while (menu != QUIT);

    finalizeAddressBook(&addrbook);

    return 0;
}