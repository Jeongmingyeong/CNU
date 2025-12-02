#include <iostream>
#include "int_node.h"
#include "node.h"
#include "string_node.h"
#include "tree_util.h"

int main() {
    IntNode in1(nullptr, nullptr, 3);
    IntNode in2(nullptr, nullptr, 7);
    StringNode sn1(nullptr, nullptr, "hello");
    StringNode sn2(nullptr, nullptr, "world");
    StringNode sn3(&in1, &in2, "here");
    IntNode in3(&sn1, &sn2, 7);
    IntNode root(&sn3, &in3, 10);

    TreeUtil* tree_util = TreeUtil::GetInstance();

    std::cout << root.ToString() << std::endl;

    std::cout << tree_util->PreOrderTraversal(&root) << std::endl;
    std::cout << tree_util->InOrderTraversal(&root) << std::endl;
    std::cout << tree_util->PostOrderTraversal(&root) << std::endl;

    return 0;
}
