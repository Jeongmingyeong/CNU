#ifndef CAR_BUILDER_
#define CAR_BUILDER_
#include "car_parts_factory.h"
#include "car.h"
#include <string>

class CarBuilder {
 public:
    explicit CarBuilder(CarPartsFactory* factory);
    virtual ~CarBuilder();
    CarBuilder& CreateDoor();
    CarBuilder& CreateWheel();
    CarBuilder& CreateRoof();
    CarBuilder& SetColor(std::string color);
    Car* Build();
 private:
    Part* door_;
    Part* wheel_;
    Part* roof_;
    std::string color_;
    const CarPartsFactory* factory_;
};

#endif
