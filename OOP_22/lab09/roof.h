#ifndef ROOF_
#define ROOF_
#include <string>
#include "part.h"

class Roof : public Part {
 public:
    explicit Roof(std::string factory_name);
    std::string GetInfo() const override;
};

#endif
