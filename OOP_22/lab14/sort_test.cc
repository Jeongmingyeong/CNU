#include <array>
#include <vector>
#include <list>
#include <iostream>
#include <string>
#include "sort.h"
#include "gtest/gtest.h"


/* Vector Test */
TEST(TestUtil, VectorTest1) {
    std::vector<int> vec = {1, 15, 22, 1, 6, 3, 4, 9};
    std::string result = "#Sorted vector:";

    Sort<std::vector<int>>(vec.begin(), vec.end());
    for (int i : vec) {
        result += " " + std::to_string(i);
    }

    std::string answer = "#Sorted vector: 1 1 3 4 6 9 15 22";

    EXPECT_EQ(result, answer);
}

TEST(TestUtil, VectorTest2) {
    std::vector<std::string> vec = {"a", "h", "d", "l", "e"};
    std::string result = "#Sorted vector:";

    Sort<std::vector<std::string>>(vec.begin(), vec.end());
    for (std::string i : vec) {
        result += " " + i;
    }

    std::string answer = "#Sorted vector: a d e h l";

    EXPECT_EQ(result, answer);
}

TEST(TestUtil, VectorTest3) {
    std::vector<double> vec = {12.3, 25, 12.1, 25.0, 1.2, 1.23};
    std::string result = "#Sorted vector:";

    Sort<std::vector<double>>(vec.begin(), vec.end());
    for (double i : vec) {
        result += " " + std::to_string(i);
    }

    std::string answer =
        "#Sorted vector: 1.200000 1.230000 12.100000"
        " 12.300000 25.000000 25.000000";

    EXPECT_EQ(result, answer);
}

/* Array Test */
TEST(TestUtil, ArrayTest1) {
    std::array<int, 8> arr = {1, 15, 22, 1, 6, 3, 4, 9};
    std::string result = "#Sorted array:";

    Sort<std::array<int, 8>>(arr.begin(), arr.end());
    for (int i : arr) {
        result += " " + std::to_string(i);
    }

    std::string answer = "#Sorted array: 1 1 3 4 6 9 15 22";

    EXPECT_EQ(result, answer);
}

TEST(TestUtil, ArrayTest2) {
    std::array<std::string, 5> arr = {"a", "h", "d", "l", "e"};
    std::string result = "#Sorted array:";

    Sort<std::array<std::string, 5>>(arr.begin(), arr.end());
    for (std::string i : arr) {
        result += " " + i;
    }

    std::string answer = "#Sorted array: a d e h l";

    EXPECT_EQ(result, answer);
}

TEST(TestUtil, ArrayTest3) {
    std::array<double, 6> arr = {12.3, 25, 12.1, 25.0, 1.2, 1.23};
    std::string result = "#Sorted array:";

    Sort<std::array<double, 6>>(arr.begin(), arr.end());
    for (double i : arr) {
        result += " " + std::to_string(i);
    }

    std::string answer =
        "#Sorted array: 1.200000 1.230000 12.100000"
        " 12.300000 25.000000 25.000000";

    EXPECT_EQ(result, answer);
}

/* List Test */
TEST(TestUtil, ListTest1) {
    std::list<int> lst = {1, 15, 22, 1, 6, 3, 4, 9};
    std::string result = "#Sorted list:";

    Sort<std::list<int>>(lst.begin(), lst.end());
    for (int i : lst) {
        result += " " + std::to_string(i);
    }

    std::string answer = "#Sorted list: 1 1 3 4 6 9 15 22";

    EXPECT_EQ(result, answer);
}

TEST(TestUtil, ListTest2) {
    std::list<std::string> lst = {"a", "h", "d", "l", "e"};
    std::string result = "#Sorted list:";

    Sort<std::list<std::string>>(lst.begin(), lst.end());
    for (std::string i : lst) {
        result += " " + i;
    }

    std::string answer = "#Sorted list: a d e h l";

    EXPECT_EQ(result, answer);
}

TEST(TestUtil, ListTest3) {
    std::list<double> lst = {12.3, 25, 12.1, 25.0, 1.2, 1.23};
    std::string result = "#Sorted list:";

    Sort<std::list<double>>(lst.begin(), lst.end());
    for (double i : lst) {
        result += " " + std::to_string(i);
    }

    std::string answer =
        "#Sorted list: 1.200000 1.230000 12.100000"
        " 12.300000 25.000000 25.000000";

    EXPECT_EQ(result, answer);
}
