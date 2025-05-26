#include "hyundai_parts_factory.h"
#include "door.h"
#include "wheel.h"
#include "roof.h"

HyundaiPartsFactory::HyundaiPartsFactory() {}
HyundaiPartsFactory* HyundaiPartsFactory::instance_ = NULL;

HyundaiPartsFactory* HyundaiPartsFactory::GetInstance() {
    if (instance_ == NULL) {
        instance_ = new HyundaiPartsFactory;
    }
    return instance_;
}

Part* HyundaiPartsFactory::CreateDoor() const {
    return new Door("hyundai");
}
Part* HyundaiPartsFactory::CreateWheel() const {
    return new Wheel("hyundai");
}
Part* HyundaiPartsFactory::CreateRoof() const {
    return new Roof("hyundai");
}
