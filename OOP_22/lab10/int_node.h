#ifndef INTNODE_H_
#define INTNODE_H_
#include <string>
#include "node.h"

class IntNode : public Node {
 public:
    IntNode(const Node* left, const Node* right, const int value);
    std::string value() const;
 private:
    const int value_;
};

#endif
