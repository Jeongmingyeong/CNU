#include <iostream>
#include "car_parts_factory.h"
#include "hyundai_parts_factory.h"
#include "kia_parts_factory.h"
#include "car.h"
#include "car_builder.h"

int main() {
    CarPartsFactory* factory1 = HyundaiPartsFactory::GetInstance();
    CarPartsFactory* factory2 = KiaPartsFactory::GetInstance();

    CarBuilder builder1(factory1);
    Car* car1 = builder1.CreateDoor()
        .CreateDoor()
        .CreateDoor()
        .CreateDoor()
        .CreateRoof()
        .SetColor("red")
        .Build();

    CarBuilder builder2(factory1);
    Car* car2 = builder2.CreateDoor()
        .CreateDoor()
        .CreateDoor()
        .CreateDoor()
        .CreateDoor()
        .Build();

    CarBuilder builder3(factory2);
    Car* car3 = builder3.CreateRoof()
        .CreateDoor()
        .CreateDoor()
        .CreateDoor()
        .CreateDoor()
        .CreateWheel()
        .SetColor("white")
        .Build();

    CarBuilder builder4(factory2);
    Car* car4 = builder4.SetColor("gray")
        .Build();

    std::cout << car1->GetSpec() << std::endl;
    std::cout << car2->GetSpec() << std::endl;
    std::cout << car3->GetSpec() << std::endl;
    std::cout << car4->GetSpec() << std::endl;

    delete factory1;
    delete factory2;
    delete car1 ;
    delete car2;
    delete car3;
    delete car4;

    // exit(0);  /* Contain this code, it occurs only still reachable */

    return 0;
}
