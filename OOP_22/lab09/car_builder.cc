#include "car_builder.h"

CarBuilder::CarBuilder(CarPartsFactory* factory) :
    factory_(factory) {
        door_ = nullptr;
        wheel_ = nullptr;
        roof_ = nullptr;
        color_ = "black";
    }

CarBuilder::~CarBuilder() {
    delete door_;
    delete wheel_;
    delete roof_;
}

CarBuilder& CarBuilder::CreateDoor() {
    delete(this->door_);
    door_ = factory_->CreateDoor();
    return *this;
}
CarBuilder& CarBuilder::CreateWheel() {
    delete(this->wheel_);
    wheel_ = factory_->CreateWheel();
    return *this;
}
CarBuilder& CarBuilder::CreateRoof() {
    delete(this->roof_);
    roof_ = factory_->CreateRoof();
    return *this;
}
CarBuilder& CarBuilder::SetColor(std::string color) {
    color_ = color;
    return *this;
}

Car* CarBuilder::Build() {
    return new Car(door_, wheel_, roof_, color_);
}
