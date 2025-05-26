#ifndef KIA_PARTS_FACTORY_
#define KIA_PARTS_FACTORY_
#include "car_parts_factory.h"

class KiaPartsFactory : public CarPartsFactory {
 public:
    static KiaPartsFactory* GetInstance();
    Part* CreateDoor() const override;
    Part* CreateWheel() const override;
    Part* CreateRoof() const override;
 private:
    KiaPartsFactory();
    static KiaPartsFactory* instance_;
};

#endif
