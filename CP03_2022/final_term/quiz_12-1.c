#include <stdio.h>

struct student {
    char name[20];
    char id[20];
    int year;
};

int main() {
    struct student arr[5];
    int i;
    for (i=0; i<5; i++) {
        printf("name? "); scanf("%s", &arr[i].name);
        printf("id? "); scanf("%s", &arr[i].id);
        printf("year? "); scanf("%d", &arr[i].year);
    }
    for (i=0; i<5; i++) {
        printf("name: %s \n", arr[i].name); 
        printf("id: %s \n", arr[i].id);
        printf("year: %d \n", arr[i].year );
    }
    return 0;
}