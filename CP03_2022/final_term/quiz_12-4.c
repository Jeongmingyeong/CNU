#include <stdio.h>

typedef struct{
    int xpos;
    int ypos;
} Point;

int dist(Point *p1, Point *p2){
    return ((p2->xpos - p1->xpos)*(p2->xpos - p1->xpos) + (p2->ypos - p1->ypos)*(p2->ypos - p1->ypos));
}

int main(void){
    Point *p, *q;
    scanf("P1 : %d %d\n", &p->xpos, &p->ypos);
    scanf("P2 : %d %d\n", &q->xpos, &q->ypos);
    int d2 = dist(p, q);
    printf("%d\n", d2);
    return 0;
}