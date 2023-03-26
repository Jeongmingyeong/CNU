#include <iostream>
#include "gtest/gtest.h"
#include "car.h"
#include "car_builder.h"
#include "car_parts_factory.h"
#include "door.h"
#include "hyundai_parts_factory.h"
#include "kia_parts_factory.h"
#include "part.h"
#include "roof.h"
#include "wheel.h"

CarPartsFactory* factory1 = HyundaiPartsFactory::GetInstance();
CarPartsFactory* factory2 = KiaPartsFactory::GetInstance();

/* HyundaiCar test */
TEST(TestUtil, HyundaiCarTest1) {
    CarBuilder builder(factory1);
    Car* car = builder.CreateDoor()
        .CreateRoof()
        .CreateWheel()
        .SetColor("yellow")
        .Build();

    std::string result = car->GetSpec();
    std::string answer =
        "Car([hyundai] Door, "
        "[hyundai] Wheel, [hyundai] Roof, yellow)";
    EXPECT_EQ(result, answer);
    delete car;
}

TEST(TestUtil, HyundaiCarTest2) {
    CarBuilder builder(factory1);
    Car* car = builder.CreateDoor()
        .CreateDoor()
        .CreateDoor()
        .Build();

    std::string result = car->GetSpec();
    std::string answer = "Car([hyundai] Door, black)";
    EXPECT_EQ(result, answer);
    delete car;
}

TEST(TestUtil, HyundaiCarTest3) {
    CarBuilder builder(factory1);
    Car* car = builder.CreateRoof()
        .SetColor("purple")
        .CreateWheel()
        .Build();

    std::string result = car->GetSpec();
    std::string answer =
        "Car([hyundai] Wheel, [hyundai] Roof, purple)";
    EXPECT_EQ(result, answer);
    delete car;
}

/* KiaCar test */
TEST(TestUtil, KiaCarTest1) {
    CarBuilder builder(factory2);
    Car* car = builder.CreateWheel()
        .CreateWheel()
        .SetColor("red")
        .Build();

    std::string result = car->GetSpec();
    std::string answer = "Car([kia] Wheel, red)";
    EXPECT_EQ(result, answer);
    delete car;
}

TEST(TestUtil, KiaCarTest2) {
    CarBuilder builder(factory2);
    Car* car = builder.CreateDoor()
        .SetColor("yellow")
        .CreateDoor()
        .CreateDoor()
        .CreateRoof()
        .CreateRoof()
        .CreateWheel()
        .Build();

    std::string result = car->GetSpec();
    std::string answer =
        "Car([kia] Door, [kia] Wheel, [kia] Roof, yellow)";
    EXPECT_EQ(result, answer);
    delete car;
}

TEST(TestUtil, KiaCarTest3) {
    CarBuilder builder(factory2);
    Car* car = builder.Build();

    std::string result = car->GetSpec();
    std::string answer = "Car(black)";
    EXPECT_EQ(result, answer);
    delete car;
    delete factory1;
    delete factory2;
}
