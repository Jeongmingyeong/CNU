#include <iostream>
#include "node.h"
#include "tree_util.h"

int main() {
    /*
    Node n1(1, NULL, NULL);
    Node n2(3, NULL, NULL);
    Node n3(6, NULL, NULL);
    Node n4(9, NULL, NULL);
    Node n5(2, &n1, &n2);
    Node n6(8, &n3, &n4);
    Node root(5, &n5, &n6);
    */

    Node n1(3, NULL, NULL);
    Node n2(2, NULL, NULL);
    Node n3(6, &n1, NULL);
    Node n4(9, NULL, NULL);
    Node n5(1, NULL, NULL);
    Node n6(8, NULL, &n2);
    Node n7(8, &n3, &n4);
    Node n8(8, &n5, &n6);
    Node root(5, &n7, &n8);

    TreeUtil* tree_util = TreeUtil::GetInstance();

    std::cout << root.ToString() << std::endl;

    std::cout << "IsFullBinaryTree? " << ((tree_util->IsFullBinaryTree(root) == 1)? "true" : "false") << std::endl;
    std::cout << "IsCompleteBinaryTree? " << ((tree_util->IsCompleteBinaryTree(root) == 1)? "true" : "false") << std::endl;
    std::cout << "IsBinarySearchTree? " << ((tree_util->IsBinarySearchTree(root) == 1)? "true" : "false") << std::endl;
    return 0;
}
