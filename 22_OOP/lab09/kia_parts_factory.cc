#include "kia_parts_factory.h"
#include "door.h"
#include "wheel.h"
#include "roof.h"

KiaPartsFactory::KiaPartsFactory() {}
KiaPartsFactory* KiaPartsFactory::instance_ = NULL;

KiaPartsFactory* KiaPartsFactory::GetInstance() {
    if (instance_ == NULL) {
        instance_ = new KiaPartsFactory;
    }
    return instance_;
}

Part* KiaPartsFactory::CreateDoor() const {
    return new Door("kia");
}
Part* KiaPartsFactory::CreateWheel() const {
    return new Wheel("kia");
}
Part* KiaPartsFactory::CreateRoof() const {
    return new Roof("kia");
}
