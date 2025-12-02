#include <stdio.h>
#include <stdlib.h>

int main(void){
    int *ptr = (int*)malloc(sizeof(int)*7);
    int i;
    for(i = 0; i < 7; i++){
        *(ptr+i) = i+1;
    }
    
    for(i = 0; i < 7; i++){
        printf("%d \n", ptr[i]);
    }
    free(ptr);
    return 0;
}