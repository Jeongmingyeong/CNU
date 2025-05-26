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

const std::string TreeUtil::ToString(const Node* node) const {
  const IntNode* intnode = dynamic_cast<const IntNode*>(node);
  const StringNode* strnode = dynamic_cast<const StringNode*>(node);
  if (intnode) {
    return "IntNode(" + std::to_string(intnode->value()) + ", "
    + ((intnode->left() == NULL) ? "NULL" : ToString(intnode->left())) + ", "
    + ((intnode->right() == NULL) ? "NULL" : ToString(intnode->right())) + ")";
  } else if (strnode) {
    return "StringNode(" + strnode->value() + ", "
    + ((strnode->left() == NULL) ? "NULL" : ToString(strnode->left())) + ", "
    + ((strnode->right() == NULL) ? "NULL" : ToString(strnode->right())) + ")";
  }
}

const std::string TreeUtil::PreOrderTraversal(const Node* node) const {
  std::string result = "";
  const IntNode* intnode = dynamic_cast<const IntNode*>(node);
  const StringNode* strnode = dynamic_cast<const StringNode*>(node);
  if (intnode) {
    result = result + std::to_string(intnode->value());
    if (intnode->left() != nullptr) {
      result = result + ", " + PreOrderTraversal(intnode->left());
    } else if (intnode->left() == nullptr || intnode->left() == nullptr) {
      std::to_string(intnode->value());
    }

    if (intnode->right() != nullptr) {
      result = result + ", " + PreOrderTraversal(intnode->right());
    } else if (intnode->right() == nullptr) {
      std::to_string(intnode->value());
    }
    return result;

  } else if (strnode) {
    result = result + strnode->value();
    if (strnode->left() != nullptr) {
      result = result + ", " + PreOrderTraversal(strnode->left());
    } else if (strnode->left() == nullptr) {
      strnode->value();
    }

    if (strnode->right() != nullptr) {
      result = result + ", " + PreOrderTraversal(strnode->right());
    } else if (strnode->right() == nullptr) {
      strnode->value();
    }
    return result;
  }
}

const std::string TreeUtil::InOrderTraversal(const Node* node) const {
  std::string result = "";
  Node* temp_node = const_cast<Node*>(node);
  StringNode* string_node = dynamic_cast<StringNode*>(temp_node);
  IntNode* int_node = dynamic_cast<IntNode*>(temp_node);

  if (node->left() != nullptr) {
    result += InOrderTraversal(node->left()) + ", ";
  }

  if (int_node != nullptr) {
    result += std::to_string(int_node->value());
  } else if (string_node != nullptr) {
    result += string_node->value();
  }

  if (node->right() != nullptr) {
    result += ", " + InOrderTraversal(node->right());
  }

  return result;
}
const std::string TreeUtil::PostOrderTraversal(const Node* node) const {
  std::string result = "";
  Node* temp_node = const_cast<Node*>(node);
  StringNode* string_node = dynamic_cast<StringNode*>(temp_node);
  IntNode* int_node = dynamic_cast<IntNode*>(temp_node);

  if (node->left() != nullptr) {
    result += PostOrderTraversal(node->left()) + ", ";
  }

  if (node->right() != nullptr) {
    result += PostOrderTraversal(node->right()) + ", ";
  }

  if (int_node != nullptr) {
    result += std::to_string(int_node->value());
  } else if (string_node != nullptr) {
    result += string_node->value();
  }

  return result;
}
