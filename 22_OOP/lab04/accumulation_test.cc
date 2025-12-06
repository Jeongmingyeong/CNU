#include "gtest/gtest.h"
#include "int_acc.h"
#include "float_acc.h"

/* Add testcase */
TEST(TestUtil, intAddTest1) {
    int_acc::Accumulator accumulator(10);
    accumulator.Add(15);
    EXPECT_EQ(accumulator.acc(), 25);
}

TEST(TestUtil, intAddTest2) {
    int_acc::Accumulator accumulator(15);
    accumulator.Add(15);
    EXPECT_EQ(accumulator.acc(), 30);
}

TEST(TestUtil, intAddTest3) {
    int_acc::Accumulator accumulator(58);
    accumulator.Add(27);
    EXPECT_EQ(accumulator.acc(), 85);
}

TEST(TestUtil, floatAddTest1) {
    float_acc::Accumulator accumulator(15.36);
    accumulator.Add(26.54);
    EXPECT_FLOAT_EQ(accumulator.acc(), 41.90);
}

TEST(TestUtil, floatAddTest2) {
    float_acc::Accumulator accumulator(189.62);
    accumulator.Add(125.34);
    EXPECT_FLOAT_EQ(accumulator.acc(), 314.96);
}

TEST(TestUtil, floatAddTest3) {
    float_acc::Accumulator accumulator(1.234);
    accumulator.Add(5.678);
    EXPECT_FLOAT_EQ(accumulator.acc(), 6.912);
}

/* Sub testcase */
TEST(TestUtil, intSubTest1) {
    int_acc::Accumulator accumulator(10);
    accumulator.Sub(3);
    EXPECT_EQ(accumulator.acc(), 7);
}

TEST(TestUtil, intSubTest2) {
    int_acc::Accumulator accumulator(485);
    accumulator.Sub(3);
    EXPECT_EQ(accumulator.acc(), 482);
}

TEST(TestUtil, intSubTest3) {
    int_acc::Accumulator accumulator(85554);
    accumulator.Sub(152);
    EXPECT_EQ(accumulator.acc(), 85402);
}

TEST(TestUtil, floatSubTest1) {
    float_acc::Accumulator accumulator(15.384);
    accumulator.Sub(4.33);
    EXPECT_FLOAT_EQ(accumulator.acc(), 11.054);
}

TEST(TestUtil, floatSubTest2) {
    float_acc::Accumulator accumulator(999.99);
    accumulator.Sub(0.0);
    EXPECT_FLOAT_EQ(accumulator.acc(), 999.99);
}

TEST(TestUtil, floatSubTest3) {
    float_acc::Accumulator accumulator(456.123);
    accumulator.Sub(753.624);
    EXPECT_FLOAT_EQ(accumulator.acc(), -297.501);
}

/* Mult testcase */
TEST(TestUtil, intMultTest1) {
    int_acc::Accumulator accumulator(10);
    accumulator.Mult(3);
    EXPECT_EQ(accumulator.acc(), 30);
}

TEST(TestUtil, intMultTest2) {
    int_acc::Accumulator accumulator(25);
    accumulator.Mult(10);
    EXPECT_EQ(accumulator.acc(), 250);
}

TEST(TestUtil, intMultTest3) {
    int_acc::Accumulator accumulator(25625);
    accumulator.Mult(0);
    EXPECT_EQ(accumulator.acc(), 0.0);
}

TEST(TestUtil, floatMultTest1) {
    float_acc::Accumulator accumulator(20.36);
    accumulator.Mult(9.1);
    EXPECT_FLOAT_EQ(accumulator.acc(), 185.276);
}

TEST(TestUtil, floatMultTest2) {
    float_acc::Accumulator accumulator(1.23654);
    accumulator.Mult(0.0);
    EXPECT_FLOAT_EQ(accumulator.acc(), 0.0);
}

TEST(TestUtil, floatMultTest3) {
    float_acc::Accumulator accumulator(958.321);
    accumulator.Mult(0.5);
    EXPECT_FLOAT_EQ(accumulator.acc(), 479.1605);
}


/* Div testcase */
TEST(TestUtil, intDivTest1) {
    int_acc::Accumulator accumulator(25);
    accumulator.Div(0);
    EXPECT_EQ(accumulator.acc(), 0);
}

TEST(TestUtil, intDivTest2) {
    int_acc::Accumulator accumulator(2485);
    accumulator.Div(5);
    EXPECT_EQ(accumulator.acc(), 497);
}

TEST(TestUtil, intDivTest3) {
    int_acc::Accumulator accumulator(22222);
    accumulator.Div(2);
    EXPECT_EQ(accumulator.acc(), 11111);
}

TEST(TestUtil, floatDivTest1) {
    float_acc::Accumulator accumulator(7.5);
    accumulator.Div(0.5);
    EXPECT_FLOAT_EQ(accumulator.acc(), 15.0);
}

TEST(TestUtil, floatDivTest2) {
    float_acc::Accumulator accumulator(969.96);
    accumulator.Div(3.0);
    EXPECT_FLOAT_EQ(accumulator.acc(), 323.32);
}

TEST(TestUtil, floatDivTest3) {
    float_acc::Accumulator accumulator(361861.982);
    accumulator.Div(988.1);
    EXPECT_FLOAT_EQ(accumulator.acc(), 366.22);
}
