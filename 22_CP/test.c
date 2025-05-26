#define _CRT_SECURE_NO_WARNINGS
#pragma warning(disable:6031)
#pragma warning(disable:4996)
#include <stdio.h>
#include <string.h>
#include <stdlib.h>


typedef struct b {
   char name[100];
   int id;
   int kor, eng, math;
   double avg;
} student;

int main(void) {
   struct b a = {"Hong", 111, 90, 80, 70 };
   struct b *pa;

   pa = &a;

   scanf("%s %d", a.name, &a.id);
   scanf("%s %d", pa->name, &pa->id);

   return 0;
}