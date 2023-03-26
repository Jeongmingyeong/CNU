#include <stdio.h>

#include <malloc.h>



// ���� ��带 ���� ����ü ����

typedef struct node{

char data;

struct node *pre;

}NODE;



// �ϳ��� ���ο� ��带 �������ִ� �Լ�

NODE* createNode(char data)

{

NODE *temp = (NODE*)malloc(sizeof(NODE));

temp->data = data;

temp->pre = NULL;



return temp;

}



// ���ÿ� ����� �����͸� �ϳ� ������ �Լ�

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



// ���ÿ� �����͸� �����ϴ� �Լ�

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



// ���� ǥ�⸦ ���� ������ �м��ϴ� �Լ�

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



// ������ �����͸� ������ִ� �Լ�

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