#include "gtest/gtest.h"
#include "circle.h"
#include "rectangle.h"
#include "triangle.h"
#include "shape_util.h"

ShapeUtil* shape_util = ShapeUtil::GetInstance();

/* Circle Area */
TEST(TestUtil, Circle_CalcArea1) {
    Circle c1(7);

    EXPECT_FLOAT_EQ(shape_util->CalcArea(c1), 153.86);
}

TEST(TestUtil, Circle_CalcArea2) {
    Circle c1(8);
    Circle c2(4);
    Circle c3 = c1 + c2;

    EXPECT_FLOAT_EQ(shape_util->CalcArea(c3), 452.16);
}

TEST(TestUtil, Circle_CalcArea3) {
    Circle c1(2);
    Circle c2(0);
    Circle c3 = c1 + c2;

    EXPECT_FLOAT_EQ(shape_util->CalcArea(c3), 12.56);
}

/* Triangle Area */
TEST(TestUtil, Triangle_CalcArea1) {
    Triangle t1(2, 6);

    EXPECT_FLOAT_EQ(shape_util->CalcArea(t1), 6);
}

TEST(TestUtil, Triangle_CalcArea2) {
    Triangle t1(6, 15);
    Triangle t2(9, 1);
    Triangle t3 = t1 + t2;

    EXPECT_FLOAT_EQ(shape_util->CalcArea(t3), 120);
}

TEST(TestUtil, Triangle_CalcArea3) {
    Triangle t1(12, 12);
    Triangle t2(5, 5);
    Triangle t3 = t1 + t2;

    EXPECT_FLOAT_EQ(shape_util->CalcArea(t3), 144.5);
}

/* Rectangle Area */
TEST(TestUtil, Rectangle_CalcArea1) {
    Rectangle r1(3, 6);

    EXPECT_EQ(shape_util->CalcArea(r1), 18);
}

TEST(TestUtil, Rectangle_CalcArea2) {
    Rectangle r1(9, 17);
    Rectangle r2(3, 7);
    Rectangle r3 = r1 + r2;

    EXPECT_EQ(shape_util->CalcArea(r3), 288);
}

TEST(TestUtil, Rectangle_CalcArea3) {
    Rectangle r1(16, 3);
    Rectangle r2(9, 9);
    Rectangle r3 = r1 + r2;

    EXPECT_EQ(shape_util->CalcArea(r3), 300);
}
