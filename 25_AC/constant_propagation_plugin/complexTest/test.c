#include <stdio.h>

int square(int x) {
    return x * x;
}

int main() {
    int a = 10;
    int b = 20;
    int c = a + b;  // c = 30
    int d = c * 2;  // d = 60
    int e = 0;

    if (a == 10) {
        e = d + 5;  // e = 65
    } else {
        e = d - 5;
    }

    int f = square(3);  // 9, cannot be propagated unless inlined

    int g;
    for (int i = 0; i < 3; i++) {
        g = e + i;  // g = 10, 11, 12 (not constant)
    }

    return 0;
}

