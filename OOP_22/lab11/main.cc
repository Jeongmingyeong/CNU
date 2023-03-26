#include <iostream>
#include "node.h"

template <class T, int N>
void PrintChildren(const Node<T, N>& n) {
    std::cout << "#Print children of Node " << n.value() << " : " << std::endl;
    for (Node<T, N>* child : n.children()) {
        std::cout << child->value() << std::endl;
    }
}

int main() {
    Node<int, 2> n1(7);
    Node<int, 2> n2(9);
    Node<int, 2> n3(8);
    Node<int, 2> n4(1);
    Node<int, 2> n5(3);
    Node<int, 2> n6(5);

    std::cout << "#Add a child to n1: " << n1.AddChild(&n2) << std::endl;
    std::cout << "#Add a child to n1: " << n1.AddChild(&n3) << std::endl;
    std::cout << "#Add a child to n1: " << n1.AddChild(&n4) << std::endl;
    std::cout << "#Add a child to n1: " << n1.AddChild(&n5) << std::endl;
    std::cout << "#Add a child to n1: " << n1.AddChild(&n6) << std::endl;

    PrintChildren<int, 2>(n1);

    Node<std::string, 3> s1("what");
    Node<std::string, 3> s2("are");
    Node<std::string, 3> s3("you");
    Node<std::string, 3> s4("looking");
    Node<std::string, 3> s5("for");

    std::cout << "#Add a child to s1: " << s1.AddChild(&s2) << std::endl;
    std::cout << "#Add a child to s1: " << s1.AddChild(&s3) << std::endl;
    std::cout << "#Add a child to s1: " << s1.AddChild(&s4) << std::endl;
    std::cout << "#Add a child to s1: " << s1.AddChild(&s5) << std::endl;

    PrintChildren<std::string, 3>(s1);

    return 0;
}
