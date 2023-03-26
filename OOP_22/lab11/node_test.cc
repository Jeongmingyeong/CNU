#include <array>
#include <string>
#include "gtest/gtest.h"
#include "node.h"

template <class T, int N>
std::string PrintChildren_String(const Node<T, N>& n) {
    std::string result = n.value();
    for (Node<T, N>* child : n.children()) {
        result += " " + child->value();
    }
    return result;
}

template <class T, int N>
std::string PrintChildren_Int(const Node<T, N>& n) {
    std::string result = std::to_string(n.value());
    for (Node<T, N>* child : n.children()) {
        result += " " + std::to_string(child->value());
    }
    return result;
}

/* AddChild_Int test */
TEST(TestUtil, AddChildIntTest1) {
    Node<int, 2> n1(1);
    Node<int, 2> n2(2);
    Node<int, 2> n3(3);
    Node<int, 2> n4(4);

    n1.AddChild(&n2);
    n1.AddChild(&n3);
    n1.AddChild(&n4);

    std::string result = PrintChildren_Int<int, 2>(n1);
    std::string answer = "1 2 3";
    EXPECT_EQ(result, answer);
}

TEST(TestUtil, AddChildIntTest2) {
    Node<int, 3> n1(7);
    Node<int, 3> n2(9);
    Node<int, 3> n3(8);
    Node<int, 3> n4(1);
    Node<int, 3> n5(3);
    Node<int, 3> n6(5);

    n1.AddChild(&n2);
    n1.AddChild(&n3);
    n1.AddChild(&n4);
    n1.AddChild(&n5);
    n1.AddChild(&n6);

    std::string result = PrintChildren_Int(n1);
    std::string answer = "7 9 8 1";
    EXPECT_EQ(result, answer);
}

TEST(TestUtil, AddChildIntTest3) {
    Node<int, 6> n1(1);
    Node<int, 6> n2(2);
    Node<int, 6> n3(3);
    Node<int, 6> n4(4);
    Node<int, 6> n5(5);
    Node<int, 6> n6(6);
    Node<int, 6> n7(7);
    Node<int, 6> n8(8);
    Node<int, 6> n9(9);

    n5.AddChild(&n1);
    n5.AddChild(&n2);
    n5.AddChild(&n3);
    n5.AddChild(&n4);
    n5.AddChild(&n6);
    n5.AddChild(&n7);
    n5.AddChild(&n8);
    n5.AddChild(&n9);

    std::string result = PrintChildren_Int(n5);
    std::string answer = "5 1 2 3 4 6 7";
    EXPECT_EQ(result, answer);
}

/* AddChild_String test */
TEST(TestUtil, AddChildStringTest1) {
    Node<std::string, 2> n1("hello");
    Node<std::string, 2> n2("room");
    Node<std::string, 2> n3("paper");
    Node<std::string, 2> n4("HTML");

    n1.AddChild(&n2);
    n1.AddChild(&n3);
    n1.AddChild(&n4);

    std::string result = PrintChildren_String(n1);
    std::string answer = "hello room paper";
    EXPECT_EQ(result, answer);
}

TEST(TestUtil, AddChildStringTest2) {
    Node<std::string, 3> n1("hello");
    Node<std::string, 3> n2("Ultra");
    Node<std::string, 3> n3("LG");
    Node<std::string, 3> n4("balance");
    Node<std::string, 3> n5("new");
    Node<std::string, 3> n6("gram");

    n1.AddChild(&n2);
    n1.AddChild(&n3);
    n1.AddChild(&n4);
    n1.AddChild(&n5);
    n1.AddChild(&n6);

    std::string result = PrintChildren_String(n1);
    std::string answer = "hello Ultra LG balance";
    EXPECT_EQ(result, answer);
}

TEST(TestUtil, AddChildStringTest3) {
    Node<std::string, 6> n1("hello");
    Node<std::string, 6> n2("world");
    Node<std::string, 6> n3("CPP");
    Node<std::string, 6> n4("grediant");
    Node<std::string, 6> n5("strow");
    Node<std::string, 6> n6("pencil");
    Node<std::string, 6> n7("good");
    Node<std::string, 6> n8("note");
    Node<std::string, 6> n9("samsung");

    n5.AddChild(&n1);
    n5.AddChild(&n2);
    n5.AddChild(&n3);
    n5.AddChild(&n4);
    n5.AddChild(&n6);
    n5.AddChild(&n7);
    n5.AddChild(&n8);
    n5.AddChild(&n9);

    std::string result = PrintChildren_String(n5);
    std::string answer = "strow hello world CPP grediant pencil good";
    EXPECT_EQ(result, answer);
}
