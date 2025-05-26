#include <stdio.h>
#include <string.h>

int main(){
    char s1[30];
    char s2[30];

    scanf("%s %s", s1, s2);

    int result = strcmp(s1, s2);

    if(result == 0){
        printf("%d\n", 0);
    }
    else{
        printf("%d\n", 1);
    }

    return 0;
}