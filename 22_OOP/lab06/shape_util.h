#ifndef SHAPE_UTIL_H_
#define SHAPE_UTIL_H_
#include <cmath>
#include "circle.h"
#include "rectangle.h"
#include "triangle.h"

class ShapeUtil {
 public:
    static ShapeUtil *GetInstance();
    float CalcArea(const Circle &circle);
    float CalcArea(const Triangle &triangle);
    int CalcArea(const Rectangle &rectangle);
 private:
    static ShapeUtil *instance_;
};

#endif
