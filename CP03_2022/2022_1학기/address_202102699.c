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

//function : You should complete the function, 초기내용 설정
void initializeAddressBook(AddressBook* addrbook){ // 생성자
    addrbook->size = 0;
    addrbook->head = NULL;
}

//function : You should complete the function
void finalizeAddressBook(AddressBook* addrbook){
    AddressBlock* p = addrbook->head;
     while(p != NULL){
         free(p);
         p = p->next;
     }
}

//function : You should complete the function
Address* findAddressByName(char* name, AddressBook* addrbook){ // 주소 반환
    AddressBlock * i;
    for (i = addrbook->head; (i != NULL); i = i->next) {
        for (int j = 0; j < i->size; j++) {
            if (strcmp(name, i->book[j].name) == 0) {
                return (i->book) + j;
            }
        }
    }
    return NULL;
}

//function : You should complete the function

AddressBlock* findMergingTarget(AddressBook* addrbook, AddressBlock* source){ 
    // 삭제시 병합할 AddressBook 탐색 및 공간 확보(병합 X)
    AddressBlock* p;
    for(p = addrbook->head; p != NULL; p = p->next){
        if(p->size < 5){
            if(p != source){
                return p;
            }
        }
    }
    return NULL;
}

/*
AddressBlock* findMergingTarget(AddressBook* addrbook, AddressBlock* source) {
    for (AddressBlock * i = addrbook->head; i != NULL && i->size != 100; i = i->next) {
        if (i->size < 5 && source != i && source->size + i->size == 5) {
            i->book = (Address*)realloc(i->book, sizeof(Address) * 10);
            return i;
        }
    }
    return NULL;
}
*/

//function : You should complete the function
int addAddress_first(Address* addr, AddressBook* addrbook){
    // AddressBook 삽입 및 공간 확보
    char name[NAMEMAX];
    //strcpy(name, addr->name);
    if(findAddressByName(addr->name, addrbook) != NULL){
        return FALSE;
    }
    
    if(addrbook->head==NULL){ //아무것도 없을때
        AddressBlock * addBlock =(AddressBlock*) malloc(sizeof(AddressBlock));
        addBlock->size = 0;
        addBlock->next = addrbook->head;
        addBlock->book = (Address*) malloc(sizeof(Address)*5); // 처음은 5칸만 할당 (나중에 크기 조절)
        addBlock->book[0] = *addr;
        addrbook->head = addBlock;
        addrbook->size++;
        addrbook->head->size++;
        return TRUE;
    }
    else{
        int size = addrbook->head->size;
        if(size == 5){
            Address* p = addrbook->head->book;
            addrbook->head->book = (Address *) realloc(p, sizeof(Address)*10);
        }
        else if(size == 10){
            AddressBlock *addBlock2 = (AddressBlock*) malloc(sizeof(AddressBlock));
            addBlock2->next = addrbook->head;
            addrbook->head = addBlock2;
            addrbook->head->book = (Address*) malloc(sizeof(Address)*5);
            addrbook->head->book[0] = *addr;
            addrbook->size++;
            addrbook->head->size++;
            return TRUE;
        }
        addrbook->head->book[size] = *addr;
        addrbook->head->size++;
        addrbook->size++;
    }
    return TRUE;
}

//function : You should complete the function
int deleteAddressByName(char* name, AddressBook* addrbook){
    // AddressBook 삭제 및 병합
     if (findAddressByName(name, addrbook) == NULL) { // 입력받은 이름이 없음. -> 지우기 불가
        return FALSE;
    }
    AddressBlock * cBlock = NULL;
    AddressBlock * nBlock = addrbook->head;
    int i, j;
    //char currentname[NAMEMAX];
    
    while(nBlock != NULL) {
        for(i = 0; i < nBlock->size; i++) {
            //strcpy(currentname, nBlock->book[i].name);
            if(strcmp(nBlock->book[i].name, name) == 0) {
                for(j = i; j < nBlock->size - 1; j++) {
                    nBlock->book[j] = nBlock->book[j+1];
                }

                nBlock->size--;;
                addrbook->size--;;

                if(nBlock->size == 0) {
                    if(cBlock == NULL) {
                        addrbook->head = addrbook->head->next;
                    }
                    else {
                        cBlock->next = nBlock->next;
                    }
                }
                else if(nBlock->size < 5) {
                    AddressBlock* p = findMergingTarget(addrbook, nBlock);

                    if(p == NULL) {
                        break;
                    }
                    
                    for(int i = 0; i < nBlock->size; i++) { // 병합하는 과정
                        p->book[p->size] = nBlock->book[i];
                        p->size++;
                    }
                    if (nBlock != addrbook->head) {
                        nBlock->size = 0; 
                    }
                    else {
                        addrbook->head = p;
                        nBlock->size = 0;
                    }
                }
            }
        }
        cBlock = nBlock;
        nBlock = nBlock->next;
    }
    return TRUE;
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

//function : You should complete the function
void name_menu(char* name)
{
    printf("Type a name: ");
    scanf("%s", name);
}

//function : You should complete the function
void add_menu(Address* addr)
{
    printf("Type a name: ");
    scanf("%s", addr->name);
    printf("Type a phone number: ");
    scanf("%s", addr->phone);
}

//function : You should complete the function
//The code below does not print the appropriate results
int main() {
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
            name_menu(name);
            {Address* p = findAddressByName(name, &addrbook);
            if (p == NULL)
                printf("%s is not found\n", name);
            else
                printf("%s: %s\n", p->name, p->phone);
            break;
            }
        case PRINTALL: {
            AddressBlock* p;
            for(p = addrbook.head; p != NULL; p = p->next){
                for(int i = 0; i < p->size; i++){
                    printf("%s: %s\n", p->book[i].name, p->book[i].phone);
                }
            }
            break;
        }
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

//gcc addressBook -o addressBook
//./addressBook