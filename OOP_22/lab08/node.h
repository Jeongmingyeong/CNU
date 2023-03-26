#ifndef NODE_H_
#define NODE_H_
#include <string>

class Node {
 public:
    Node(const Node* left, const Node* right);
    const Node* left() const;
    const Node* right() const;
    virtual std::string value() const = 0;
    virtual std::string ToString() const = 0;

 private:
    const Node* left_;
    const Node* right_;
};

#endif
