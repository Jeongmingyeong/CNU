#ifndef STRINGNODE_H_
#define STRINGNODE_H_
#include <string>
#include "node.h"

class StringNode : public Node {
 public:
    StringNode(const Node* left, const Node* right, const std::string value);
    std::string value() const;
 private:
    const std::string value_;
};

#endif
