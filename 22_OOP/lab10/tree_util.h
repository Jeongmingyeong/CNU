#ifndef TREEUTIL_H_
#define TREEUTIL_H_
#include <iostream>
#include <string>
#include <vector>
#include "node.h"

class TreeUtil {
 public:
    static TreeUtil* GetInstance();
    const std::vector<const Node*> DepthFirstSearch(const Node* node) const;
    const std::vector<const Node*> BreadthFirstSearch(const Node* node) const;
 private:
    TreeUtil();
    static TreeUtil* instance_;
};

#endif
