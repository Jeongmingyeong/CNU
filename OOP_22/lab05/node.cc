#include <iostream>
#include <string>
#include "node.h"

Node::Node(int value, Node* left, Node* right): // initialization list
  value_(value), left_(left), right_(right) {}

const int Node::value() const {
  return value_;
}
const Node* Node::left() const {
  return left_;
}
const Node* Node::right() const {
  return right_;
}
std::string Node::ToString() const {
  return "NODE(" + std::to_string(value()) + ", " 
  + ((left() == NULL) ? "NULL" : left()->ToString()) + ", " 
  + ((right() == NULL) ? "NULL" : right()->ToString()) + ")";
}
