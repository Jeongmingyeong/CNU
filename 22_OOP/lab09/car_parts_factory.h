#ifndef CAR_PARTS_FACTORY_
#define CAR_PARTS_FACTORY_
#include "part.h"

class CarPartsFactory {
 public:
    virtual Part* CreateDoor() const = 0;
    virtual Part* CreateWheel() const = 0;
    virtual Part* CreateRoof() const = 0;
};
#endif
