#ifndef NODE_H_
#define NODE_H_

class Node {
 public:
    Node(const Node* left, const Node* right);
    const Node* left() const;
    const Node* right() const;
    virtual ~Node();
 private:
    const Node* left_;
    const Node* right_;
};

#endif
