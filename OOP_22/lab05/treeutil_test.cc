#include "gtest/gtest.h"
#include "node.h"
#include "tree_util.h"

TreeUtil* tree_util = TreeUtil::GetInstance();

/* IsFullBinaryTree test */
TEST(TestUtil, IsFullBinaryTreeTest1) {
    Node n1(1, NULL, NULL);
    Node n2(3, NULL, NULL);
    Node n3(6, NULL, NULL);
    Node n4(9, NULL, NULL);
    Node n5(2, &n1, &n2);
    Node n6(8, &n3, &n4);
    Node root(5, &n5, &n6);

    EXPECT_EQ(tree_util->IsFullBinaryTree(root), true);
}

TEST(TestUtil, IsFullBinaryTreeTest2) {
    Node n1(3, NULL, NULL);
    Node n2(2, NULL, NULL);
    Node n3(6, &n1, NULL);
    Node n4(9, NULL, NULL);
    Node n5(1, NULL, NULL);
    Node n6(8, NULL, &n2);
    Node n7(8, &n3, &n4);
    Node n8(8, &n5, &n6);
    Node root(5, &n7, &n8);

    EXPECT_EQ(tree_util->IsFullBinaryTree(root), false);
}

TEST(TestUtil, IsFullBinaryTreeTest3) {
    Node n1(1, NULL, NULL);
    Node n2(2, NULL, NULL);
    Node n3(3, NULL, NULL);
    Node n4(4, NULL, NULL);
    Node n5(5, &n1, NULL);
    Node n6(6, &n2, NULL);
    Node n7(7, &n3, NULL);
    Node n8(8, &n4, NULL);
    Node n9(9, &n5, &n6);
    Node n10(10, &n7, &n8);
    Node root(50, &n9, &n10);

    EXPECT_EQ(tree_util->IsFullBinaryTree(root), false);
}

/* IsCompleteBinaryTree test */
TEST(TestUtil, IsCompleteBinaryTreeTest1) {
    Node n1(1, NULL, NULL);
    Node n2(3, NULL, NULL);
    Node n3(6, NULL, NULL);
    Node n4(9, NULL, NULL);
    Node n5(2, &n1, &n2);
    Node n6(8, &n3, &n4);
    Node root(5, &n5, &n6);

    EXPECT_EQ(tree_util->IsCompleteBinaryTree(root), true);
}

TEST(TestUtil, IsCompleteBinaryTreeTest2) {
    Node n1(3, NULL, NULL);
    Node n2(2, NULL, NULL);
    Node n3(6, &n1, NULL);
    Node n4(9, NULL, NULL);
    Node n5(1, NULL, NULL);
    Node n6(8, NULL, &n2);
    Node n7(8, &n3, &n4);
    Node n8(8, &n5, &n6);
    Node root(5, &n7, &n8);

    EXPECT_EQ(tree_util->IsCompleteBinaryTree(root), false);
}

TEST(TestUtil, IsCompleteBinaryTreeTest3) {
    Node n1(1, NULL, NULL);
    Node n2(4, NULL, NULL);
    Node n3(7, NULL, NULL);
    Node n4(10, NULL, NULL);
    Node n5(2, &n1, NULL);
    Node n6(5, &n2, NULL);
    Node n7(8, &n3, NULL);
    Node n8(11, &n4, NULL);
    Node n9(3, &n5, &n6);
    Node n10(9, &n7, &n8);
    Node root(6, &n9, &n10);

    EXPECT_EQ(tree_util->IsCompleteBinaryTree(root), true);
}

/* IsBinarySearchTree test */
TEST(TestUtil, IsBinarySearchTreeTest1) {
    Node n1(1, NULL, NULL);
    Node n2(3, NULL, NULL);
    Node n3(6, NULL, NULL);
    Node n4(9, NULL, NULL);
    Node n5(2, &n1, &n2);
    Node n6(8, &n3, &n4);
    Node root(5, &n5, &n6);

    EXPECT_EQ(tree_util->IsBinarySearchTree(root), true);
}

TEST(TestUtil, IsBinarySearchTreeTest2) {
    Node n1(3, NULL, NULL);
    Node n2(2, NULL, NULL);
    Node n3(6, &n1, NULL);
    Node n4(9, NULL, NULL);
    Node n5(1, NULL, NULL);
    Node n6(8, NULL, &n2);
    Node n7(8, &n3, &n4);
    Node n8(8, &n5, &n6);
    Node root(5, &n7, &n8);

    EXPECT_EQ(tree_util->IsBinarySearchTree(root), false);
}

TEST(TestUtil, IsBinarySearchTreeTest3) {
    Node n1(1, NULL, NULL);
    Node n2(4, NULL, NULL);
    Node n3(7, NULL, NULL);
    Node n4(10, NULL, NULL);
    Node n5(2, &n1, NULL);
    Node n6(5, &n2, NULL);
    Node n7(8, &n3, NULL);
    Node n8(11, &n4, NULL);
    Node n9(3, &n5, &n6);
    Node n10(9, &n7, &n8);
    Node root(6, &n9, &n10);
    
    EXPECT_EQ(tree_util->IsBinarySearchTree(root), true);
}
