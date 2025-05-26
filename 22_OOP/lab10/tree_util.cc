#include <queue>
#include <stack>
#include <vector>
#include <string>
#include "tree_util.h"

TreeUtil::TreeUtil() {}
TreeUtil* TreeUtil::instance_ = NULL;

TreeUtil* TreeUtil::GetInstance() {
    if (instance_ == NULL) {
        instance_ = new TreeUtil;
    }
    return instance_;
}

const std::vector<const Node*>
TreeUtil::DepthFirstSearch(const Node* node) const {
    std::stack<const Node*> stack;
    std::vector<const Node*> result;

    stack.push(node);

    while (!(stack.empty())) {
        const Node* value = stack.top();
        stack.pop();
        result.push_back(value);

        if (value->right() != nullptr) {
            stack.push(value->right());
        }
        if (value->left() != nullptr) {
            stack.push(value->left());
        }
    }

    return result;
}

const std::vector<const Node*>
TreeUtil::BreadthFirstSearch(const Node* node) const {
    std::queue<const Node*> q;
    std::vector<const Node*> result;

    q.push(node);

    while (!(q.empty())) {
        const Node* value = q.front();
        q.pop();
        result.push_back(value);

        if (value->left() != nullptr) {
            q.push(value->left());
        }
        if (value->right() != nullptr) {
            q.push(value->right());
        }
    }

    return result;
}
