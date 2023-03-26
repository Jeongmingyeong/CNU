#include "triangle.h"

Triangle::Triangle(int height, int base):
    height_(height), base_(base) {}

int Triangle::height() const {
    return height_;
}

int Triangle::base() const {
    return base_;
}
Triangle Triangle::operator+(const Triangle& triangle) const {
    return Triangle((this->height() + triangle.height()),
    (this->base() + triangle.base()));
}
