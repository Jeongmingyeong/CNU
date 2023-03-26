#include "string_node.h"

StringNode::StringNode
    (const Node* left, const Node* right, const std::string value) :
    Node(left, right), value_(value) {}

std::string StringNode::value() const {
    return value_;
}

std::string StringNode::ToString() const {
    return "StringNode(" + value() + ", "
    + ((left() == NULL) ? "NULL" : left()->ToString()) + ", "
    + ((right() == NULL) ? "NULL" : right()->ToString()) + ")";
}
