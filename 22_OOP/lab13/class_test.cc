#include <string>
#include "gtest/gtest.h"
#include "class_info.h"
#include "class.h"
#include "grade.h"
#include "student.h"

TEST(TestUtil, ClassTest1) {
    ClassInfo c1(12142004, "global english");
    ClassInfo c2(23145019, "software analysis");
    ClassInfo c3(46512397, "data structure");

    Student s1(202102695, "Jinyoung Jang");
    Student s2(202302719, "Sieun Choi");
    Student s3(201802617, "Seoung Kim");
    Student s4(200202699, "Mingyeong Jeong");

    Class ge2022(c1);
    Class sa2022(c2);
    Class ds2022(c3);

    ge2022.Register(s1);
    ge2022.Register(s2);
    sa2022.Register(s2);
    sa2022.Register(s3);
    sa2022.Register(s4);
    ds2022.Register(s1);
    ds2022.Register(s2);
    ds2022.Register(s3);

    std::string result =
        ge2022.GetInfo() + " " + sa2022.GetInfo() + " " + ds2022.GetInfo();

    std::string answer =
        "CLASS[12142004, global english]\n"
        "(1) STUDENT[202102695, Jinyoung Jang]\n"
        "(2) STUDENT[202302719, Sieun Choi] "
        "CLASS[23145019, software analysis]\n"
        "(1) STUDENT[200202699, Mingyeong Jeong]\n"
        "(2) STUDENT[201802617, Seoung Kim]\n"
        "(3) STUDENT[202302719, Sieun Choi] "
        "CLASS[46512397, data structure]\n"
        "(1) STUDENT[201802617, Seoung Kim]\n"
        "(2) STUDENT[202102695, Jinyoung Jang]\n"
        "(3) STUDENT[202302719, Sieun Choi]";

    EXPECT_EQ(result, answer);
}

TEST(TestUtil, ClassTest2) {
    ClassInfo c1(12142004, "system programming");
    ClassInfo c2(23145019, "data structure");
    ClassInfo c3(32631040, "computer structure");
    ClassInfo c4(12345678, "adventure design");
    ClassInfo c5(20210296, "algorithm");

    Student s1(202102695, "Jinyoung Jang");
    Student s2(202302719, "Sieun Choi");
    Student s3(201802617, "Seoung Kim");
    Student s4(200202699, "Mingyeong Jeong");

    Class sys2022(c1);
    Class ds2022(c2);
    Class cs2022(c3);
    Class add2022(c4);
    Class algo2022(c5);

    sys2022.Register(s1);
    sys2022.Register(s2);
    sys2022.Register(s2); /* ignored, since s2 already exist in class */
    ds2022.Register(s3);
    ds2022.Register(s4);
    add2022.Register(s1);
    add2022.Register(s2);
    algo2022.Register(s1);
    algo2022.Register(s2);
    algo2022.Register(s3);
    algo2022.Register(s4);
    algo2022.Register(s1);  /* ignored, since s1 already exist in class */

    std::string result =
        sys2022.GetInfo() + " " + ds2022.GetInfo() + " " +
        cs2022.GetInfo() + " " + add2022.GetInfo() + " " +
        algo2022.GetInfo();

    std::string answer =
        "CLASS[12142004, system programming]\n"
        "(1) STUDENT[202102695, Jinyoung Jang]\n"
        "(2) STUDENT[202302719, Sieun Choi] "
        "CLASS[23145019, data structure]\n"
        "(1) STUDENT[200202699, Mingyeong Jeong]\n"
        "(2) STUDENT[201802617, Seoung Kim] "
        "CLASS[32631040, computer structure] "
        "CLASS[12345678, adventure design]\n"
        "(1) STUDENT[202102695, Jinyoung Jang]\n"
        "(2) STUDENT[202302719, Sieun Choi] "
        "CLASS[20210296, algorithm]\n"
        "(1) STUDENT[200202699, Mingyeong Jeong]\n"
        "(2) STUDENT[201802617, Seoung Kim]\n"
        "(3) STUDENT[202102695, Jinyoung Jang]\n"
        "(4) STUDENT[202302719, Sieun Choi]";

    EXPECT_EQ(result, answer);
}

TEST(TestUtil, ClassTest3) {
    ClassInfo c1(12142004, "object oriented programming");
    ClassInfo c2(23145019, "web programming");
    ClassInfo c3(32631040, "programming language");

    Student s1(202102695, "Jinyoung Jang");
    Student s2(202302719, "Sieun Choi");
    Student s3(201802617, "Seoung Kim");
    Student s4(200202699, "Mingyeong Jeong");
    Student s5(201802617, "Seoung Kim");
    Student s6(200202699, "Mingyeong Jeong");

    Class oop2022(c1);
    Class wp2022(c2);
    Class pl2022(c3);

    oop2022.Register(s1);
    oop2022.Register(s2);
    oop2022.Register(s4);
    wp2022.Register(s1);
    wp2022.Register(s2);
    wp2022.Register(s3);
    wp2022.Register(s4);
    wp2022.Register(s5); /* ignored, since s5 is the same to s3 */
    wp2022.Register(s6); /* ignored, since s6 is the same to s4 */

    std::string result =
        oop2022.GetInfo() + " " + wp2022.GetInfo() + " " + pl2022.GetInfo();

    std::string answer =
        "CLASS[12142004, object oriented programming]\n"
        "(1) STUDENT[200202699, Mingyeong Jeong]\n"
        "(2) STUDENT[202102695, Jinyoung Jang]\n"
        "(3) STUDENT[202302719, Sieun Choi] "
        "CLASS[23145019, web programming]\n"
        "(1) STUDENT[200202699, Mingyeong Jeong]\n"
        "(2) STUDENT[201802617, Seoung Kim]\n"
        "(3) STUDENT[202102695, Jinyoung Jang]\n"
        "(4) STUDENT[202302719, Sieun Choi] "
        "CLASS[32631040, programming language]";

    EXPECT_EQ(result, answer);
}

TEST(TestUtil, classTest4) { /* only s3 and s4 name are different (same id) */
    ClassInfo c1(12142004, "object oriented programming");
    ClassInfo c2(23145019, "web programming");
    ClassInfo c3(32631040, "programming language");

    Student s1(202102695, "Jinyoung Jang");
    Student s2(202302719, "Sieun Choi");
    Student s3(202202617, "Seoung Kim");
    Student s4(202202617, "Mingyeong Jeong");

    Class oop2022(c1);
    Class wp2022(c2);
    Class pl2022(c3);

    oop2022.Register(s2);
    oop2022.Register(s4);
    wp2022.Register(s1);
    wp2022.Register(s2);
    wp2022.Register(s3);

    /* insert succeed, since s3 name is different from s4 name */
    wp2022.Register(s4);
    pl2022.Register(s3);

    /* insert succeed, since s3 name is different from s4 name */
    pl2022.Register(s4);

    std::string result =
        oop2022.GetInfo() + " " + wp2022.GetInfo() + " " + pl2022.GetInfo();

    std::string answer =
        "CLASS[12142004, object oriented programming]\n"
        "(1) STUDENT[202202617, Mingyeong Jeong]\n"
        "(2) STUDENT[202302719, Sieun Choi] "
        "CLASS[23145019, web programming]\n"
        "(1) STUDENT[202102695, Jinyoung Jang]\n"
        "(2) STUDENT[202202617, Mingyeong Jeong]\n"
        "(3) STUDENT[202202617, Seoung Kim]\n"
        "(4) STUDENT[202302719, Sieun Choi] "
        "CLASS[32631040, programming language]\n"
        "(1) STUDENT[202202617, Mingyeong Jeong]\n"
        "(2) STUDENT[202202617, Seoung Kim]";

    EXPECT_EQ(result, answer);
}
