#include <stdio.h>

#include <malloc.h>



// 스택 노드를 위한 구조체 선언

typedef struct node{

char data;

struct node *pre;

}NODE;



// 하나의 새로운 노드를 생성해주는 함수

NODE* createNode(char data)

{

NODE *temp = (NODE*)malloc(sizeof(NODE));

temp->data = data;

temp->pre = NULL;



return temp;

}



// 스택에 저장된 데이터를 하나 꺼내는 함수

char pop(NODE **top)

{

NODE *temp = *top;

char t;



if(*top == NULL)

return 0;



*top = (*top)->pre;



t = temp->data;



free(temp);



return t;

}



// 스택에 데이터를 저장하는 함수

void push(NODE **top, char data)

{

NODE *temp = createNode(data);



if(*top == NULL)

{

*top = temp;

return;

}


temp->pre = *top;

*top = temp;

}



// 전위 표기를 위해 수식을 분석하는 함수

void formulaCalc(NODE **first, NODE **second, char *input)

{

int i = 0;



for(i = strlen(input) - 1 ; i >=  0 ; i --)

{

switch(input[i])

{

case '*':

case '-':

case '/':

case '+':
case '^':

push(first, input[i]);

break;



case '(':

push(second, '(');

push(second, pop(first));

break;



default :

push(second, input[i]);

}

}

}



// 스택의 데이터를 출력해주는 함수

void printStack(NODE *top)

{

while(top != NULL)

{

printf("%c", top->data);



top = top->pre;

}

}



int main(void)

{

NODE *FIRST = NULL;

NODE *SECOND = NULL;

char input[20];



scanf("%s", input);



formulaCalc(&FIRST, &SECOND, input);



printStack(SECOND);


return 0;

}