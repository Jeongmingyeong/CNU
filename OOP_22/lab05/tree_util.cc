#include <iostream>
#include "node.h"
#include "tree_util.h"

TreeUtil::TreeUtil() {}
TreeUtil* TreeUtil::instance_;

TreeUtil* TreeUtil::GetInstance() {
  if (instance_ == NULL) {
    instance_ = new TreeUtil;
  }
  return instance_;
}

bool TreeUtil::IsFullBinaryTree(const Node& n) const {
  if (n.left() == NULL && n.right() == NULL) {
    return true;
  } else if ((n.left() != NULL && n.right() == NULL) || n.left() == NULL && n.right() != NULL) {
    return false;
  } else {
    return IsFullBinaryTree(*n.left()) & IsFullBinaryTree(*n.right());
  }
}

bool TreeUtil::IsCompleteBinaryTree(const Node& n) const {
    if (n.left() == NULL && n.right() != NULL) {
        return false;
    } else if (n.left() == NULL && n.right() == NULL) {
        return true;
    } else if (n.left() != NULL && n.right() == NULL) {
        return IsCompleteBinaryTree(*n.left());
    } else {
        return IsCompleteBinaryTree(*n.left()) & IsCompleteBinaryTree(*n.right());
    }
}

bool TreeUtil::IsBinarySearchTree(const Node& n) const {
    if (n.left() == NULL && n.right() == NULL) {
        return true;
    } else if (n.left() == NULL && n.right() != NULL) {
        if (n.value() < n.right()->value()) {
            return IsBinarySearchTree(*n.right());
        } else {
            return false;
        }
    } else if (n.left() != NULL && n.right() == NULL) {
        if (n.value() > n.left()->value()) {
            return IsBinarySearchTree(*n.left());
        } else {
            return false;
        }
    } else {
        return (IsBinarySearchTree(*n.left()) & IsBinarySearchTree(*n.right()));
    }
}
