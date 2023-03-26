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
    addrbook->head = NULL; //addrbook�� head�� ����Ű�� �����Ͱ� NULL�� ����Ų��.
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
    for (p = addrbook->head; p != NULL; p = p->next) { //p�� ��ü�� ���� �ݺ�
       //char findname[NAMEMAX];
       for(int i = 0; i < p->size; i++){//����� ������(�ּ��� ����)��ŭ �ݺ�
           //int result = strcmp(p->book[i].name, name);
           if (strcmp(p->book[i].name, name) == 0){//ã���� �ϴ� ���� i��° �ε��� �̸��� ������
               return &(p->book[i]);//����� i��° �ε���(Address �迭�� �ε���) ��ȯ
           }
       }
   }   
   /*
   while(p != NULL){
        for(i = 0; i < p->size; i++){//����� ������(�ּ��� ����)��ŭ �ݺ�
            //int result = strcmp(p->book[i].name, name);
            if (strcmp(p->book[i].name, name) == 0){//ã���� �ϴ� ���� i��° �ε��� �̸��� ������
                return &(p->book[i]);//����� i��° �ε���(Address �迭�� �ε���) ��ȯ
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
    
    if(addrbook->head==NULL){//�ʱ����
        AddressBlock *ab=(AddressBlock *)malloc(sizeof(AddressBlock));
        ab->size = 0;
        ab->next = addrbook->head;//ab�� head����
        ab->book = (Address *) malloc(sizeof(Address)*5); // ó������ 5ĭ �Ҵ�
        ab->book[0] = *addr;
        addrbook->head = ab;//��� �ּ� ��ü
        addrbook->size++;//��� ������ ����
        addrbook->head->size++;//��� ������ ����
        return TRUE;
    }

    if(addrbook->head->size < 10 && addrbook->head->size != 5){//����� book ũ�Ⱑ 5�̸� Ȥ�� 10 �̸�
        int size = addrbook->head->size;//������ �� ���
        addrbook->head->book[size] = *addr;//������ �ε����� address����
        addrbook->head->size++;//������ ũ�� ����
        addrbook->size++;

    }else if(addrbook->head->size == 5){//book ũ�Ⱑ 5 ->realoc���� ������ �����
        Address* p = addrbook->head->book;
        addrbook->head->book = (Address *) realloc(p, sizeof(Address)*10);
        addrbook->head->book[5] = *addr;
        addrbook->head->size++;
        addrbook->size++;
    }else{//��� ũ�Ⱑ 10�϶�
        AddressBlock *ab2 = (AddressBlock *)malloc(sizeof(AddressBlock));
        ab2->next = addrbook->head;
        addrbook->head = ab2;
        addrbook->size++;
        addrbook->head->book = (Address *) malloc(sizeof(Address)*5);
        addrbook->head->book[0] = *addr;//�ּ� ����
        addrbook->head->size++;//��� ������ ����
    }

    return TRUE;
    }

void deleteBlock(AddressBlock * p, AddressBook* addrbook){//addrbook���� �Ķ���ͷ� ���� p����� �����Ѵ�.
    if(p->next == NULL && p == addrbook->head){//��尡 �ϳ��� ��
        addrbook->head = NULL;
        free(p->book);
        free(p);
    }else if(p == addrbook->head){//ù ����϶�
        addrbook->head = addrbook->head->next;
        addrbook->head = NULL;
        free(p->book);
        free(p);
    }else if(p->next == NULL){//������ ����� ��


    }else{//�߰��� ��
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
   for (AddressBlock* p = addrbook->head; p != NULL; p = p->next) {//��� ��ȸ
       char n[NAMEMAX];
       for(int i = 0; i < p->size; i++){//��� �� book �迭�� Address ��ȸ
           int result = strcmp(p->book[i].name, name);
           if (result == 0){//p��book i�ε����� ���� ���
               if(p->size ==1){//���Ұ� �ϳ��ۿ� ���� ��
                    deleteBlock(p, addrbook);
                    addrbook->size--;
                    return TRUE;
               }else{
                    strcpy(n, p->book[i].name);//n�� ������ ���ڿ� ����
                    for(int j = i; j<p->size -1; j++){//���Ұ� ���� �� �� �� ����
                    p->book[j] = p->book[j+1];
                    }
               }
               p->size--;
               addrbook->size--;

               //������ �ʿ����� �˻�
               if(p->size < 5){//���Ұ� �ټ��� �̸��� ��
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