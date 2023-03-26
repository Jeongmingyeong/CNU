#ifndef HYUNDAI_PARTS_FACTORY_
#define HYUNDAI_PARTS_FACTORY_
#include "car_parts_factory.h"

class HyundaiPartsFactory : public CarPartsFactory {
 public:
    static HyundaiPartsFactory* GetInstance();
    Part* CreateDoor() const override;
    Part* CreateWheel() const override;
    Part* CreateRoof() const override;
 private:
    HyundaiPartsFactory();
    static HyundaiPartsFactory* instance_;
};
#endif
