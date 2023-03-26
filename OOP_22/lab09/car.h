#ifndef CAR_
#define CAR_
#include <string>
#include "part.h"

class CarBuilder;

class Car {
 public:
    std::string GetSpec();
 private:
    Car(Part* door, Part* wheel, Part* roof, std::string color);
    const Part* door_;
    const Part* wheel_;
    const Part* roof_;
    const std::string color_;
    friend CarBuilder;
};

#endif
