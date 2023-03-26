#include <string>
#include "gtest/gtest.h"
#include "class_info.h"
#include "class.h"
#include "grade.h"
#include "student.h"

TEST(TestUtil, ClassInfotest1) {
    ClassInfo c1(12142004, "global english");
    ClassInfo c2(23145019, "software analysis");
    ClassInfo c3(46512397, "data structure");

    std::string result = c1.GetInfo() + " " + c2.GetInfo() + " " + c3.GetInfo();
    std::string answer =
        "CLASS[12142004, global english] "
        "CLASS[23145019, software analysis] "
        "CLASS[46512397, data structure]";

    EXPECT_EQ(result, answer);
}

TEST(TestUtil, ClassInfotest2) {
    ClassInfo c1(12142004, "system programming");
    ClassInfo c2(23145019, "data structure");
    ClassInfo c3(32631040, "computer structure");
    ClassInfo c4(12345678, "adventure design");
    ClassInfo c5(20210296, "algorithm");
    ClassInfo c6(12142004, "system programming");
    ClassInfo c7(20210296, "algorithm");

    std::string result =
        c1.GetInfo() + " " + c2.GetInfo() + " " + c3.GetInfo() + " " +
        c4.GetInfo() + " " + c5.GetInfo() + " " + c6.GetInfo() + " " +
        c7.GetInfo();
    std::string answer =
        "CLASS[12142004, system programming] "
        "CLASS[23145019, data structure] "
        "CLASS[32631040, computer structure] "
        "CLASS[12345678, adventure design] "
        "CLASS[20210296, algorithm] "
        "CLASS[12142004, system programming] "
        "CLASS[20210296, algorithm]";

    EXPECT_EQ(result, answer);
}

TEST(TestUtil, ClassInfotest3) {
    ClassInfo c1(12142004, "object oriented programming");
    ClassInfo c2(23145019, "web programming");
    ClassInfo c3(32631040, "programming language");
    ClassInfo c4(12345678, "programming basic for AI");

    std::string result =
        c1.GetInfo() + " " + c2.GetInfo() + " " +
        c3.GetInfo() + " " + c4.GetInfo();

    std::string answer =
        "CLASS[12142004, object oriented programming] "
        "CLASS[23145019, web programming] "
        "CLASS[32631040, programming language] "
        "CLASS[12345678, programming basic for AI]";

    EXPECT_EQ(result, answer);
}
