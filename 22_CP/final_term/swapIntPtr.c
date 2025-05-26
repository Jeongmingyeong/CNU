#include <stdio.h>

void SwapIntPtr(int *p, int *q){
    int temp = *p;
    *p = *q;
    *q = temp;
}

int main(void){
    int num1=10;
    int num2=20;
    int *ptr1;
    int *ptr2;
    ptr1=&num1, ptr2=&num2;
    printf("*ptr1, *ptr2 : %d %d \n", *ptr1, *ptr2);

    SwapIntPtr(ptr1, ptr2);
    printf("*ptr1, *ptr2 : %d %d \n", *ptr1, *ptr2);
    return 0;
}