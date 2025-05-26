#include <stdio.h>
#include <string.h>
#include <math.h>
#include <stdlib.h>

int main() {
    int line = 0;
    int length = 0;
    int idx = 0;
    int i;
    
    scanf("%d", &line);
    char arr[line][80];
    for(i = 0; i < line; i++){
        idx = 0;
        scanf("%s", arr[i]);
         while(arr[i][idx] != '\0'){
            length++;
            idx++;
        }
    }
    
    printf("%d", length);
  
    return 0;
}

// gcc CP_03_01_09_2.c -o CP_03_01_09_2