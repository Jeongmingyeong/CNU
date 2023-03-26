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

//function : You should complete the function
void initializeAddressBook(AddressBook* addrbook) {
    AddressBlock * newBlock = (AddressBlock *)malloc(sizeof(AddressBlock));
    newBlock->size = 100;
    addrbook->head = newBlock;
    addrbook->size = 0;
}

//function : You should complete the function
void finalizeAddressBook(AddressBook* addrbook) {
    AddressBlock * currentBlock = NULL;
    AddressBlock * i = addrbook->head;
    while(i != NULL) {
       currentBlock = i;
       free(currentBlock); 
       i = i->next;
    }
}

//function : You should complete the function
Address* findAddressByName(char* name, AddressBook* addrbook) {
    for (AddressBlock * i = addrbook->head; (i != NULL) && (i->size != 100); i = i->next) {
        for (int j = 0; j < i->size; j++) {
            if (strcmp(name, i->book[j].name) == 0) {
                return (i->book) + j;
            }
        }
    }
    
    return NULL;
}

//function : You should complete the function
AddressBlock* findMergingTarget(AddressBook* addrbook, AddressBlock* source) {
    for (AddressBlock * i = addrbook->head; i != NULL && i->size != 100; i = i->next) {
        if (i->size < 5 && source != i && source->size + i->size == 5) {
            i->book = (Address*)realloc(i->book, sizeof(Address) * 10);
            return i;
        }
    }
    return NULL;
}

//function : You should complete the function
int addAddress_first(Address* addr, AddressBook* addrbook) {
    if (findAddressByName(addr->name, addrbook) != NULL) {
        return FALSE;
    }
    if (addrbook->size == 0) {
        AddressBlock * newBlock = (AddressBlock *)malloc(sizeof(AddressBlock));
        newBlock->next = addrbook->head;
        addrbook->head = newBlock;
        newBlock->book = (Address *)malloc(sizeof(Address) * 5);
        newBlock->book[newBlock->size] = *addr;
        newBlock->size = newBlock->size + 1;
        addrbook->size = addrbook->size + 1;

        return TRUE;
    }
    else {
        int currentSize = addrbook->head->size;
        if (currentSize == 10) {
            AddressBlock * newBlock = (AddressBlock *)malloc(sizeof(AddressBlock));
            newBlock->next = addrbook->head;
            addrbook->head = newBlock;
            newBlock->book = (Address *)malloc(sizeof(Address) * 5);
            newBlock->book[newBlock->size] = *addr;
            newBlock->size = newBlock->size + 1;
            addrbook->size = addrbook->size + 1;

            return TRUE;
        }
        else if (currentSize == 5) {
            addrbook->head->book = (Address *)realloc(addrbook->head->book, sizeof(Address) * 10);
        }

        addrbook->head->book[currentSize] = *addr;
        addrbook->head->size = addrbook->head->size + 1;
        addrbook->size = addrbook->size + 1;

        return TRUE;
    }

    return FALSE;
}

//function : You should complete the function
int deleteAddressByName(char* name, AddressBook* addrbook) {
    if (findAddressByName(name, addrbook) == NULL) {
        return FALSE;
    }
    AddressBlock * currentBlock = NULL;
    AddressBlock * nextBlock = addrbook->head;
    
    while(nextBlock != NULL && nextBlock->size != 100) {
        for(int index = 0; index < nextBlock->size; index++) {
            if(strcmp(nextBlock->book[index].name, name) == 0) {
                for(int i = index; i < nextBlock->size - 1; i++) {
                    nextBlock->book[i] = nextBlock->book[i + 1];
                }

                nextBlock->size = nextBlock->size - 1;
                addrbook->size = addrbook->size - 1;

                if(nextBlock->size == 0) {
                    if(currentBlock == NULL) {
                        addrbook->head = addrbook->head->next;
                    }
                    else {
                        currentBlock->next = nextBlock->next;
                    }
                }
                else if(nextBlock->size < 5) {
                    AddressBlock * mergingTarget = findMergingTarget(addrbook, nextBlock);

                    if(mergingTarget == NULL) {
                     
                        break;
                    }
                    
                    for(int i = 0; i < nextBlock->size; i++) {
                        mergingTarget->book[mergingTarget->size] = nextBlock->book[i];
                        mergingTarget->size = mergingTarget->size + 1;
                    }
                    if (nextBlock != addrbook->head) {
                        //currentBlock->next = mergingTarget->next;
                        nextBlock->size = 0;
                    }
                    else {
                        addrbook->head = mergingTarget;
                        nextBlock->size = 0;
                    }
                }
            }
        }
        nextBlock = nextBlock->next;
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
            // fill code!
            name_menu(name);
            if (deleteAddressByName(name, &addrbook))
                printf("%s is deleted\n", name);
            else
                printf("%s does not exist in the book\n", name);
            break;
        case FIND:
            // fill code!
            {  
            name_menu(name);
            Address * findingName = findAddressByName(name, &addrbook);
            if (findingName == NULL)
                printf("%s is not found\n", name);
            else
                printf("phone: %s\n", findingName->phone);
            break;
            }
        case PRINTALL:
            // fill code!
            for (AddressBlock * i = addrbook.head; i != NULL && i->size != 100; i = i->next) {
                for (int j = 0; j < i->size; j++) {
                    printf("%s: %s\n", i->book[j].name, i->book[j].phone);
                }
            }
            break;
        default: //다른 숫자를 입력하였을 경우 오류처리
            break;        
        }

        if (menu != QUIT) {
            printf("\n");
            printf("---------------------------Providing My AddressBook---------------------------------------\n");

            printf("(Address Book Size: %d)\n\n", addrbook.size);

            for (AddressBlock* p = addrbook.head; p != NULL && p->size != 100 && p->size != 0; p = p->next) 
                printf("block size : %d\n", p->size);
         
            printf("------------------------------------------------------------------------------------------\n");
            printf("\n");
           
        }
           
           
    } while (menu != QUIT);

    finalizeAddressBook(&addrbook);

    return 0;
}