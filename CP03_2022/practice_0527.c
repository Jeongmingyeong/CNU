#include <stdio.h>

typedef struct data
{
    char name[30];
    char local[30];
} address;

int main(){
    address a[3];
    for(int i = 0; i < 3; i++){
        scanf("%s", &a[i].name);
        scanf("%s", &a[i].local);
    }

    char input[30];
    scanf("%s", input);
    for(int i = 0; i < 3; i++){
        if(a[i].name == input){
            printf("%s", a[i].local);
        }
    }

    return 0;
}