#include "int_node.h"
#include <iostream>

IntNode::IntNode(const Node* left, const Node* right, const int value):
    Node(left, right), value_(value) {}

const int IntNode::value() const {
    return value_;
}
