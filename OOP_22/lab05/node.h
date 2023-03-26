#ifndef _NODE_H_
#define _NODE_H_
#include <iostream>
#include <string>

class Node {
 public:
    explicit Node(int valud, Node* left, Node* right);
    const int value() const;
    const Node* left() const;
    const Node* right() const;
    std::string ToString() const;
 private:
    const int value_;
    const Node* left_;
    const Node* right_;
};

#endif
