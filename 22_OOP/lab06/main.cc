#include <iostream>
#include "circle.h"
#include "rectangle.h"
#include "triangle.h"
#include "shape_util.h"

int main() {
    ShapeUtil *util = ShapeUtil::GetInstance();

    Circle c1(7);

    Circle c2(8);
    Circle c3(4);
    Circle c4 = c3 + c2;

    Circle c5(2);
    Circle c6(0);
    Circle c7 = c5 + c6;


    std::cout << "#Circle1: " << util->CalcArea(c1) << std::endl;
    std::cout << "#Circle2: " << util->CalcArea(c4) << std::endl;
    std::cout << "#Circle3: " << util->CalcArea(c7) << std::endl;

    Triangle t1(2, 6);

    Triangle t2(6, 15);
    Triangle t3(9, 1);
    Triangle t4 = t3 + t2;

    Triangle t5(12, 12);
    Triangle t6(5, 5);
    Triangle t7 = t5 + t6;

    std::cout << "#Triangle1: " << util->CalcArea(t1) << std::endl;
    std::cout << "#Triangle2: " << util->CalcArea(t4) << std::endl;
    std::cout << "#Triangle3: " << util->CalcArea(t7) << std::endl;

    Rectangle r1(3, 6);

    Rectangle r2(9, 17);
    Rectangle r3(3, 7);
    Rectangle r4 = r3 + r2;

    Rectangle r5(16, 3);
    Rectangle r6(9, 9);
    Rectangle r7 = r5 + r6;

    std::cout << "#Rectangle1: " << util->CalcArea(r1) << std::endl;
    std::cout << "#Rectangle2: " << util->CalcArea(r4) << std::endl;
    std::cout << "#Rectangle3: " << util->CalcArea(r7) << std::endl;
    return (0);
}
