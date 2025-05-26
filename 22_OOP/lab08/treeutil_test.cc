#include <iostream>
#include "gtest/gtest.h"
#include "node.h"
#include "string_node.h"
#include "int_node.h"
#include "tree_util.h"

TreeUtil* tree_util = TreeUtil::GetInstance();

/* PreOrderTraversal test */
TEST(TestUtil, PreOrderTraversalTest1) {
    IntNode in1(nullptr, nullptr, 8);
    IntNode in2(nullptr, nullptr, 4);
    StringNode sn1(nullptr, nullptr, "hello");
    StringNode sn2(nullptr, nullptr, "oop");
    StringNode sn3(&in1, &in2, "good");
    IntNode in3(&sn1, &sn2, 6);
    IntNode root(&sn3, &in3, 15);

    std::string result = tree_util->PreOrderTraversal(&root);
    std::string answer = "15, good, 8, 4, 6, hello, oop";
    EXPECT_EQ(result, answer);
}

TEST(TestUtil, PreOrderTraversalTest2) {
    IntNode in1(nullptr, nullptr, 1);
    IntNode in2(nullptr, nullptr, 9);
    StringNode sn1(&in1, nullptr, "Air");
    StringNode sn2(nullptr, nullptr, "pot");
    IntNode in3(&in2, &sn1, 18);
    IntNode in4(nullptr, &sn2, 6);
    StringNode root(&in3, &in4, "hello");

    std::string result = tree_util->PreOrderTraversal(&root);
    std::string answer = "hello, 18, 9, Air, 1, 6, pot";
    EXPECT_EQ(result, answer);
}

TEST(TestUtil, PreOrderTraversalTest3) {
    IntNode in1(nullptr, nullptr, 0);
    IntNode in2(&in1, nullptr, 1);
    IntNode in3(&in2, nullptr, 2);
    IntNode in4(&in3, nullptr, 3);
    StringNode sn1(&in4, nullptr, "string");
    StringNode sn2(nullptr, nullptr, "finish");
    StringNode sn3(&sn2, nullptr, "note");
    StringNode sn4(nullptr, &sn3, "ssd");
    StringNode sn5(nullptr, &sn4, "coffee");
    StringNode sn6(nullptr, nullptr, "pencil");
    StringNode sn7(&sn5, &sn6, "mouse");
    IntNode in5(nullptr, &sn7, 9);
    IntNode in6(&in5, nullptr, 2);
    StringNode root(&sn1, &in6, "two");

    std::string result = tree_util->PreOrderTraversal(&root);
    std::string answer = "two, string, 3, 2, 1, 0, 2, 9, "
    "mouse, coffee, ssd, note, finish, pencil";
    EXPECT_EQ(result, answer);
}


/* InOrderTraversal Test */
TEST(TestUtil, InOrderTraversalTest1) {
    IntNode in1(nullptr, nullptr, 8);
    IntNode in2(nullptr, nullptr, 4);
    StringNode sn1(nullptr, nullptr, "hello");
    StringNode sn2(nullptr, nullptr, "oop");
    StringNode sn3(&in1, &in2, "good");
    IntNode in3(&sn1, &sn2, 6);
    IntNode root(&sn3, &in3, 15);

    std::string result = tree_util->InOrderTraversal(&root);
    std::string answer = "8, good, 4, 15, hello, 6, oop";
    EXPECT_EQ(result, answer);
}

TEST(TestUtil, InOrderTraversalTest2) {
    IntNode in1(nullptr, nullptr, 1);
    IntNode in2(nullptr, nullptr, 9);
    StringNode sn1(&in1, nullptr, "Air");
    StringNode sn2(nullptr, nullptr, "pot");
    IntNode in3(&in2, &sn1, 18);
    IntNode in4(nullptr, &sn2, 6);
    StringNode root(&in3, &in4, "hello");

    std::string result = tree_util->InOrderTraversal(&root);
    std::string answer = "9, 18, 1, Air, hello, 6, pot";
    EXPECT_EQ(result, answer);
}

TEST(TestUtil, InOrderTraversalTest3) {
    IntNode in1(nullptr, nullptr, 0);
    IntNode in2(&in1, nullptr, 1);
    IntNode in3(&in2, nullptr, 2);
    IntNode in4(&in3, nullptr, 3);
    StringNode sn1(&in4, nullptr, "string");
    StringNode sn2(nullptr, nullptr, "finish");
    StringNode sn3(&sn2, nullptr, "note");
    StringNode sn4(nullptr, &sn3, "ssd");
    StringNode sn5(nullptr, &sn4, "coffee");
    StringNode sn6(nullptr, nullptr, "pencil");
    StringNode sn7(&sn5, &sn6, "mouse");
    IntNode in5(nullptr, &sn7, 9);
    IntNode in6(&in5, nullptr, 2);
    StringNode root(&sn1, &in6, "two");

    std::string result = tree_util->InOrderTraversal(&root);
    std::string answer = "0, 1, 2, 3, string, two, 9, "
    "coffee, ssd, finish, note, mouse, pencil, 2";
    EXPECT_EQ(result, answer);
}


/* PostOrderTraversal Test */
TEST(TestUtil, PostOrderTraversalTest1) {
    IntNode in1(nullptr, nullptr, 8);
    IntNode in2(nullptr, nullptr, 4);
    StringNode sn1(nullptr, nullptr, "hello");
    StringNode sn2(nullptr, nullptr, "oop");
    StringNode sn3(&in1, &in2, "good");
    IntNode in3(&sn1, &sn2, 6);
    IntNode root(&sn3, &in3, 15);

    std::string result = tree_util->PostOrderTraversal(&root);
    std::string answer = "8, 4, good, hello, oop, 6, 15";
    EXPECT_EQ(result, answer);
}

TEST(TestUtil, PostOrderTraversalTest2) {
    IntNode in1(nullptr, nullptr, 1);
    IntNode in2(nullptr, nullptr, 9);
    StringNode sn1(&in1, nullptr, "Air");
    StringNode sn2(nullptr, nullptr, "pot");
    IntNode in3(&in2, &sn1, 18);
    IntNode in4(nullptr, &sn2, 6);
    StringNode root(&in3, &in4, "hello");

    std::string result = tree_util->PostOrderTraversal(&root);
    std::string answer = "9, 1, Air, 18, pot, 6, hello";
    EXPECT_EQ(result, answer);
}

TEST(TestUtil, PostOrderTraversalTest3) {
    IntNode in1(nullptr, nullptr, 0);
    IntNode in2(&in1, nullptr, 1);
    IntNode in3(&in2, nullptr, 2);
    IntNode in4(&in3, nullptr, 3);
    StringNode sn1(&in4, nullptr, "string");
    StringNode sn2(nullptr, nullptr, "finish");
    StringNode sn3(&sn2, nullptr, "note");
    StringNode sn4(nullptr, &sn3, "ssd");
    StringNode sn5(nullptr, &sn4, "coffee");
    StringNode sn6(nullptr, nullptr, "pencil");
    StringNode sn7(&sn5, &sn6, "mouse");
    IntNode in5(nullptr, &sn7, 9);
    IntNode in6(&in5, nullptr, 2);
    StringNode root(&sn1, &in6, "two");

    std::string result = tree_util->PostOrderTraversal(&root);
    std::string answer = "0, 1, 2, 3, string, finish, note, "
    "ssd, coffee, pencil, mouse, 9, 2, two";
    EXPECT_EQ(result, answer);
}
