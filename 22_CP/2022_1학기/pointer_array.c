#include <stdio.h>

int main(void){
    int a=10, b=20, c=30, d=40, e=50;
    int *pa[] = {&a, &b, &c, &d, &e};
    int **ppa = pa;
    int i;
    for(i=0; i < 5; i++){
        printf("%d %d \n", /**(*(ppa+i))*/ *ppa[i], *pa[i]);
    }
    return 0;
}