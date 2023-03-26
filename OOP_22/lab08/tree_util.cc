#include <string>
#include "tree_util.h"
#include "int_node.h"
#include "string_node.h"
#include "node.h"

TreeUtil::TreeUtil() {}
TreeUtil* TreeUtil::instance_;

TreeUtil* TreeUtil::GetInstance() {
  if (instance_ == NULL) {
    instance_ = new TreeUtil;
  }
  return instance_;
}

const std::string TreeUtil::PreOrderTraversal(const Node* node) const {
    std::string result = "";

    result = result + node->value();

    if (node->left() != nullptr) {
      result = result + ", " + PreOrderTraversal(node->left());
    } else if (node->left() == nullptr || node->left() == nullptr) {
      node->value();
    }

    if (node->right() != nullptr) {
      result = result + ", " + PreOrderTraversal(node->right());
    } else if (node->right() == nullptr) {
      node->value();
    }
    return result;
}

const std::string TreeUtil::InOrderTraversal(const Node* node) const {
    std::string result = "";

    if (node->left() != nullptr) {
    result += InOrderTraversal(node->left()) + ", ";
    }

    if (node != nullptr) {
        result += node->value();
    }

    if (node->right() != nullptr) {
        result += ", " + InOrderTraversal(node->right());
    }

    return result;
}

const std::string TreeUtil::PostOrderTraversal(const Node* node) const {
    std::string result = "";

    if (node->left() != nullptr) {
    result += PostOrderTraversal(node->left()) + ", ";
    }

    if (node->right() != nullptr) {
        result += PostOrderTraversal(node->right()) + ", ";
    }

    if (node != nullptr) {
        result += node->value();
    }

    return result;
}
