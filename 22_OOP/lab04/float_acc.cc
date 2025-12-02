#include <iostream>
#include "float_acc.h"

namespace float_acc {
Accumulator::Accumulator(float acc) {
    Accumulator::acc_ = acc;
}

void Accumulator::Add(float x) {
     Accumulator::acc_ += x;
}

void Accumulator::Sub(float x) {
    Accumulator::acc_ -= x;
}

void Accumulator::Mult(float x) {
    Accumulator::acc_ *= x;
}

void Accumulator::Div(float x) {
    if (x == 0) {
        Accumulator::acc_ = 0;
    } else {
        Accumulator::acc_ /= x;
    }
}

float Accumulator::acc() {
    return Accumulator::acc_;
}
}  // namespace float_acc
