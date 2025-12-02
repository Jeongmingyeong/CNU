#include "gtest/gtest.h"
#include "util.h"

TEST(TestUtil, MyAddPosPosTest1) {
    EXPECT_EQ(MyAdd(1, 2), 3);
}

TEST(TestUtil, MyAddPosPosTest2) {
    EXPECT_EQ(MyAdd(3, 8), 11);
}

TEST(TestUtil, MyAddPosPosTest3) {
    EXPECT_EQ(MyAdd(65, 99), 164);
}

TEST(TestUtil, MyAddPosPosTest4) {
    EXPECT_EQ(MyAdd(16, 25), 41);
}

TEST(TestUtil, MyAddPosPosTest5) {
    EXPECT_EQ(MyAdd(13, 9), 22);
}


TEST(TestUtil, MySubPosPosTest1) {
    EXPECT_EQ(MySub(19, 2), 17);
}

TEST(TestUtil, MySubPosPosTest2) {
    EXPECT_EQ(MySub(7, 6), 1);
}

TEST(TestUtil, MySubPosPosTest3) {
    EXPECT_EQ(MySub(1115, 695), 420);
}

TEST(TestUtil, MySubPosPosTest4) {
    EXPECT_EQ(MySub(52, 3), 49);
}

TEST(TestUtil, MySubPosPosTest5) {
    EXPECT_EQ(MySub(1, 1), 0);
}


TEST(TestUtil, MyMultPosPosTest1) {
    EXPECT_EQ(MyMult(9, 6), 54);
}

TEST(TestUtil, MyMultPosPosTest2) {
    EXPECT_EQ(MyMult(5, 30), 150);
}

TEST(TestUtil, MyMultPosPosTest3) {
    EXPECT_EQ(MyMult(655, 24), 15720);
}

TEST(TestUtil, MyMultPosPosTest4) {
    EXPECT_EQ(MyMult(65, 8), 520);
}

TEST(TestUtil, MyMultPosPosTest5) {
    EXPECT_EQ(MyMult(26, 1), 26);
}


TEST(TestUtil, MyDivPosPosTest1) {
    EXPECT_EQ(MyDiv(8, 2), 4);
}

TEST(TestUtil, MyDivPosPosTest2) {
    EXPECT_EQ(MyDiv(6958, 0), 0);
}

TEST(TestUtil, MyDivPosPosTest3) {
    EXPECT_EQ(MyDiv(888, 8), 111);
}

TEST(TestUtil, MyDivPosPosTest4) {
    EXPECT_EQ(MyDiv(54, 2), 27);
}

TEST(TestUtil, MyDivPosPosTest5) {
    EXPECT_EQ(MyDiv(123, 3), 41);
}
