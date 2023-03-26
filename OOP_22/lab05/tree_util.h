#ifndef TREEUTIL_H_
#define TREEUTIL_H_
#include "node.h"

class TreeUtil {
 public:
    static TreeUtil* GetInstance();
    bool IsFullBinaryTree(const Node& n) const;
    bool IsCompleteBinaryTree(const Node& n) const;
    bool IsBinarySearchTree(const Node& n) const;
 private:
    TreeUtil();
    static TreeUtil* instance_;
};

#endif
