#include <cmath>
#include "circle.h"
#include "rectangle.h"
#include "triangle.h"
#include "shape_util.h"

ShapeUtil* ShapeUtil::instance_;

ShapeUtil* ShapeUtil::GetInstance() {
    if (instance_ == NULL) {
        instance_ = new ShapeUtil;
    }
    return instance_;
}

float ShapeUtil::CalcArea(const Circle &circle) {
    return circle.radius() * circle.radius() * 3.14;
}

float ShapeUtil::CalcArea(const Triangle &triangle) {
    return triangle.base() * triangle.height() * 0.5;
}

int ShapeUtil::CalcArea(const Rectangle &rectangle) {
    return rectangle.height() * rectangle.width();
}
