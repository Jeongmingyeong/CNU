#include <iostream>
#include <vector>
#include "gtest/gtest.h"
#include "node.h"
#include "string_node.h"
#include "int_node.h"
#include "tree_util.h"

TreeUtil* tree_util = TreeUtil::GetInstance();

/* DepthFirstSearch test */
TEST(TestUtil, DepthFirstSearchTest1) {
    IntNode in1(nullptr, nullptr, 8);
    IntNode in2(nullptr, nullptr, 4);
    StringNode sn1(nullptr, nullptr, "hello");
    StringNode sn2(nullptr, nullptr, "oop");
    StringNode sn3(&in1, &in2, "good");
    IntNode in3(&sn1, &sn2, 6);
    IntNode root(&sn3, &in3, 15);

    std::vector<const Node*> dfs_result =
        tree_util->DepthFirstSearch(&root);

    std::string result = "#DFS result :";

    for (const Node* n : dfs_result) {
        result += " " + n->value();
    }

    std::string answer = "#DFS result : 15 good 8 4 6 hello oop";
    EXPECT_EQ(result, answer);
}

TEST(TestUtil, DepthFirstSearchTest2) {
    IntNode in1(nullptr, nullptr, 1);
    IntNode in2(nullptr, nullptr, 9);
    StringNode sn1(&in1, nullptr, "Air");
    StringNode sn2(nullptr, nullptr, "pot");
    IntNode in3(&in2, &sn1, 18);
    IntNode in4(nullptr, &sn2, 6);
    StringNode root(&in3, &in4, "hello");

    std::vector<const Node*> dfs_result =
        tree_util->DepthFirstSearch(&root);

    std::string result = "#DFS result :";

    for (const Node* n : dfs_result) {
        result += " " + n->value();
    }

    std::string answer = "#DFS result : hello 18 9 Air 1 6 pot";
    EXPECT_EQ(result, answer);
}

TEST(TestUtil, DepthFirstSearchTest3) {
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

    std::vector<const Node*> dfs_result =
        tree_util->DepthFirstSearch(&root);

    std::string result = "#DFS result :";

    for (const Node* n : dfs_result) {
        result += " " + n->value();
    }

    std::string answer =
        "#DFS result : two string 3 2 1 0 2"
        " 9 mouse coffee ssd note finish pencil";
    EXPECT_EQ(result, answer);
}


/* BreadthFirstSearch Test */
TEST(TestUtil, BreadthFirstSearchTest1) {
    IntNode in1(nullptr, nullptr, 8);
    IntNode in2(nullptr, nullptr, 4);
    StringNode sn1(nullptr, nullptr, "hello");
    StringNode sn2(nullptr, nullptr, "oop");
    StringNode sn3(&in1, &in2, "good");
    IntNode in3(&sn1, &sn2, 6);
    IntNode root(&sn3, &in3, 15);

    std::vector<const Node*> bfs_result =
        tree_util->BreadthFirstSearch(&root);

    std::string result = "#BFS result :";

    for (const Node* n : bfs_result) {
        result += " " + n->value();
    }

    std::string answer = "#BFS result : 15 good 6 8 4 hello oop";
    EXPECT_EQ(result, answer);
}

TEST(TestUtil, BreadthFirstSearchTest2) {
    IntNode in1(nullptr, nullptr, 1);
    IntNode in2(nullptr, nullptr, 9);
    StringNode sn1(&in1, nullptr, "Air");
    StringNode sn2(nullptr, nullptr, "pot");
    IntNode in3(&in2, &sn1, 18);
    IntNode in4(nullptr, &sn2, 6);
    StringNode root(&in3, &in4, "hello");

    std::vector<const Node*> bfs_result =
        tree_util->BreadthFirstSearch(&root);

    std::string result = "#BFS result :";

    for (const Node* n : bfs_result) {
        result += " " + n->value();
    }

    std::string answer = "#BFS result : hello 18 6 9 Air pot 1";
    EXPECT_EQ(result, answer);
}

TEST(TestUtil, BreadthFirstSearchTest3) {
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

    std::vector<const Node*> bfs_result =
        tree_util->BreadthFirstSearch(&root);

    std::string result = "#BFS result :";

    for (const Node* n : bfs_result) {
        result += " " + n->value();
    }

    std::string answer =
        "#BFS result : two string 2 3 9 2 mouse"
        " 1 coffee pencil 0 ssd note finish";
    EXPECT_EQ(result, answer);
}
