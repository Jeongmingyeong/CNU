#include "car.h"
#include "door.h"
#include "wheel.h"
#include "roof.h"

std::string Car::GetSpec() {
    std::string result = "Car(";
    if (!(Car::door_ == nullptr)) {
        result += Car::door_->GetInfo();
    }
    if (!(Car::wheel_ == nullptr)) {
        result += Car::wheel_->GetInfo();
    }
    if (!(Car::roof_ == nullptr)) {
        result += Car::roof_->GetInfo();
    }
    result += Car::color_ + ")";
    return result;
}

Car::Car(Part* door, Part* wheel, Part* roof, std::string color) :
    door_(door), wheel_(wheel), roof_(roof), color_(color) {}
