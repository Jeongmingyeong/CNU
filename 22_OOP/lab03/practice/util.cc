#include <iostream>
#include "util.h"

int MyAdd(int x, int y) {
    return x + y;
}

int MySub(int x, int y) {
    return x - y;
}

int MyMult(int x, int y) {
    return x * y;
}

int MyDiv(int x, int y) {
    if (y == 0) {
        return 0;
    } else {
        return x / y;
    }
}
