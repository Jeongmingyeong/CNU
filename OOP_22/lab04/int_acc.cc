#include <iostream>
#include "int_acc.h"

namespace int_acc {
Accumulator::Accumulator(int acc) {
    Accumulator::acc_ = acc;
}
void Accumulator::Add(int x) {
     Accumulator::acc_ += x;
}

void Accumulator::Sub(int x) {
    Accumulator::acc_ -= x;
}

void Accumulator::Mult(int x) {
    Accumulator::acc_ *= x;
}

void Accumulator::Div(int x) {
    if (x == 0) {
        Accumulator::acc_ = 0;
    } else {
        Accumulator::acc_ /= x;
    }
}

int Accumulator::acc() {
    return Accumulator::acc_;
}
}  //  namespace int_acc
