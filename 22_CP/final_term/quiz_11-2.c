#include <stdio.h>
#include <stdlib.h>

char * read_username(){
    char *name = (char*)malloc(sizeof(char)*30);
    //char name[80];
    printf("what is your name? ");
    scanf("%s", name);
    return name;
}

int main(void){
    char *name1, *name2;
    name1 = read_username();
    name2 = read_username();
    printf("name1 : %s\n", name1);
    printf("name2 : %s\n", name2);
    free(name1);
    free(name2);
    return 0;
}