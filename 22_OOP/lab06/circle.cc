#include "circle.h"

Circle::Circle(int radius) :
    radius_(radius) {}

int Circle::radius() const {
    return radius_;
}

Circle Circle::operator+(const Circle& circle) const {
    return Circle(this->radius() + circle.radius());
}
