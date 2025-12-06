#include <iostream>
#include "int_node.h"
#include "node.h"
#include "string_node.h"
#include "tree_util.h"

int main() {
    IntNode in1(nullptr, nullptr, 1);
    IntNode in2(nullptr, nullptr, 9);
    StringNode sn1(&in1, nullptr, "Air");
    StringNode sn2(nullptr, nullptr, "pot");
    IntNode in3(&in2, &sn1, 18);
    IntNode in4(nullptr, &sn2, 6);
    StringNode root(&in3, &in4, "hello");

    TreeUtil* tree_util = TreeUtil::GetInstance();

    std::cout << tree_util->ToString(&root) << std::endl;
    std::cout << tree_util->PreOrderTraversal(&root) << std::endl;
    std::cout << tree_util->InOrderTraversal(&root) << std::endl;
    std::cout << tree_util->PostOrderTraversal(&root) << std::endl;
}
