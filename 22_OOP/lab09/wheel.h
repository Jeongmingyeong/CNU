#ifndef WHEEL_
#define WHEEL_
#include <string>
#include "part.h"

class Wheel : public Part {
 public:
    explicit Wheel(std::string factory_name);
    std::string GetInfo() const override;
};

#endif
