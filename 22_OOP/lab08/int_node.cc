#include <string>
#include "int_node.h"

IntNode::IntNode(const Node* left, const Node* right, const int value):
    Node(left, right), value_(value) {}

std::string IntNode::value() const {
    return std::to_string(value_);
}

std::string IntNode::ToString() const {
    return "IntNode(" + value() + ", "
    + ((left() == NULL) ? "NULL" : left()->ToString()) + ", "
    + ((right() == NULL) ? "NULL" : right()->ToString()) + ")";
}
