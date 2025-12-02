#include <string>
#include "gtest/gtest.h"
#include "class_info.h"
#include "class.h"
#include "grade.h"
#include "student.h"

TEST(TestUtil, StudentTest1) {
    ClassInfo c1(12142004, "global english");
    ClassInfo c2(23145019, "software analysis");
    ClassInfo c3(46512397, "data structure");

    Student s1(202102695, "Jinyoung Jang");
    Student s2(202302719, "Sieun Choi");
    Student s3(201802617, "Seoung Kim");
    Student s4(200202699, "Mingyeong Jeong");

    s1.AddGrade(c1, Grade::A);
    s1.AddGrade(c2, Grade::B);
    s2.AddGrade(c1, Grade::A);
    s2.AddGrade(c3, Grade::C);
    s3.AddGrade(c1, Grade::A);
    s3.AddGrade(c2, Grade::F);
    s3.AddGrade(c3, Grade::C);

    std::string result =
        s1.GetInfo() + " " + s2.GetInfo() + " " +
        s3.GetInfo() + " " + s4.GetInfo();
    std::string answer =
        "STUDENT[202102695, Jinyoung Jang]\n"
        "- CLASS[12142004, global english] : A\n"
        "- CLASS[23145019, software analysis] : B "
        "STUDENT[202302719, Sieun Choi]\n"
        "- CLASS[12142004, global english] : A\n"
        "- CLASS[46512397, data structure] : C "
        "STUDENT[201802617, Seoung Kim]\n"
        "- CLASS[12142004, global english] : A\n"
        "- CLASS[23145019, software analysis] : F\n"
        "- CLASS[46512397, data structure] : C "
        "STUDENT[200202699, Mingyeong Jeong]";

    EXPECT_EQ(result, answer);
}

TEST(TestUtil, StudentTest2) {
    ClassInfo c1(12142004, "system programming");
    ClassInfo c2(23145019, "data structure");
    ClassInfo c3(32631040, "computer structure");
    ClassInfo c4(12345678, "adventure design");
    ClassInfo c5(20210296, "algorithm");
    ClassInfo c6(12142004, "system programming");
    ClassInfo c7(20210296, "algorithm");

    Student s1(202102695, "Jinyoung Jang");
    Student s2(202302719, "Sieun Choi");
    Student s3(201802617, "Seoung Kim");
    Student s4(200202699, "Mingyeong Jeong");

    s1.AddGrade(c1, Grade::A);
    s1.AddGrade(c2, Grade::B);
    s1.AddGrade(c4, Grade::D);
    s1.AddGrade(c6, Grade::F);
    s2.AddGrade(c1, Grade::A);
    s2.AddGrade(c3, Grade::A);
    s2.AddGrade(c7, Grade::B);
    s3.AddGrade(c2, Grade::C);
    s3.AddGrade(c3, Grade::F);
    s3.AddGrade(c4, Grade::C);
    s3.AddGrade(c5, Grade::C);
    s3.AddGrade(c6, Grade::A);
    s4.AddGrade(c1, Grade::A);
    s4.AddGrade(c2, Grade::C);
    s4.AddGrade(c3, Grade::B);
    s4.AddGrade(c4, Grade::B);
    s4.AddGrade(c5, Grade::D);
    s4.AddGrade(c6, Grade::F);
    s4.AddGrade(c7, Grade::A);

    std::string result =
        s1.GetInfo() + " " + s2.GetInfo() + " " +
        s3.GetInfo() + " " + s4.GetInfo();
    std::string answer =
        "STUDENT[202102695, Jinyoung Jang]\n"
        "- CLASS[12142004, system programming] : A\n"
        "- CLASS[12345678, adventure design] : D\n"
        "- CLASS[23145019, data structure] : B "
        "STUDENT[202302719, Sieun Choi]\n"
        "- CLASS[12142004, system programming] : A\n"
        "- CLASS[20210296, algorithm] : B\n"
        "- CLASS[32631040, computer structure] : A S"
        "TUDENT[201802617, Seoung Kim]\n"
        "- CLASS[12142004, system programming] : A\n"
        "- CLASS[12345678, adventure design] : C\n"
        "- CLASS[20210296, algorithm] : C\n"
        "- CLASS[23145019, data structure] : C\n"
        "- CLASS[32631040, computer structure] : F "
        "STUDENT[200202699, Mingyeong Jeong]\n"
        "- CLASS[12142004, system programming] : A\n"
        "- CLASS[12345678, adventure design] : B\n"
        "- CLASS[20210296, algorithm] : D\n"
        "- CLASS[23145019, data structure] : C\n"
        "- CLASS[32631040, computer structure] : B";

    EXPECT_EQ(result, answer);
}

/* StudentTest3 and Student4 are similar (they differ only class_id) */
TEST(TestUtil, StudentTest3) { /* only c3 and c4 class_id are different */
    ClassInfo c1(12142004, "object oriented programming");
    ClassInfo c2(23145019, "web programming");
    ClassInfo c3(32631040, "programming language");
    ClassInfo c4(12345678, "programming language");

    Student s1(202102695, "Jinyoung Jang");
    Student s2(202302719, "Sieun Choi");
    Student s3(201802617, "Seoung Kim");
    Student s4(200202699, "Mingyeong Jeong");
    Student s5(201802617, "Seoung Kim");
    Student s6(200202699, "Mingyeong Jeong");

    s1.AddGrade(c1, Grade::A);
    s3.AddGrade(c2, Grade::C);
    s3.AddGrade(c3, Grade::F);
    s4.AddGrade(c1, Grade::A);
    s4.AddGrade(c2, Grade::C);
    s4.AddGrade(c3, Grade::B);

    /* insert succeed, since c4 class_id is different from c3 class_id */
    s4.AddGrade(c4, Grade::F);
    s5.AddGrade(c3, Grade::B);
    s6.AddGrade(c1, Grade::F);
    s6.AddGrade(c2, Grade::C);

    std::string result =
        s1.GetInfo() + " " + s2.GetInfo() + " " + s3.GetInfo() + " " +
        s4.GetInfo() + " " + s5.GetInfo() + " " + s6.GetInfo();
    std::string answer =
        "STUDENT[202102695, Jinyoung Jang]\n"
        "- CLASS[12142004, object oriented programming] : A "
        "STUDENT[202302719, Sieun Choi] "
        "STUDENT[201802617, Seoung Kim]\n"
        "- CLASS[23145019, web programming] : C\n"
        "- CLASS[32631040, programming language] : F "
        "STUDENT[200202699, Mingyeong Jeong]\n"
        "- CLASS[12142004, object oriented programming] : A\n"
        "- CLASS[12345678, programming language] : F\n"
        "- CLASS[23145019, web programming] : C\n"
        "- CLASS[32631040, programming language] : B "
        "STUDENT[201802617, Seoung Kim]\n"
        "- CLASS[32631040, programming language] : B "
        "STUDENT[200202699, Mingyeong Jeong]\n"
        "- CLASS[12142004, object oriented programming] : F\n"
        "- CLASS[23145019, web programming] : C";

    EXPECT_EQ(result, answer);
}

TEST(TestUtil, StudentTest4) { /* c3 and c4 are exactly same */
    ClassInfo c1(12142004, "object oriented programming");
    ClassInfo c2(23145019, "web programming");
    ClassInfo c3(32631040, "programming language");
    ClassInfo c4(32631040, "programming language");

    Student s1(202102695, "Jinyoung Jang");
    Student s2(202302719, "Sieun Choi");
    Student s3(201802617, "Seoung Kim");
    Student s4(200202699, "Mingyeong Jeong");
    Student s5(201802617, "Seoung Kim");
    Student s6(200202699, "Mingyeong Jeong");

    s1.AddGrade(c1, Grade::A);
    s3.AddGrade(c2, Grade::C);
    s3.AddGrade(c3, Grade::F);
    s4.AddGrade(c1, Grade::A);
    s4.AddGrade(c2, Grade::C);
    s4.AddGrade(c3, Grade::B);
    s4.AddGrade(c4, Grade::F); /* ignored, since c4 same to c3 */
    s5.AddGrade(c3, Grade::B);
    s6.AddGrade(c1, Grade::F);
    s6.AddGrade(c2, Grade::C);

    std::string result =
        s1.GetInfo() + " " + s2.GetInfo() + " " + s3.GetInfo() + " " +
        s4.GetInfo() + " " + s5.GetInfo() + " " + s6.GetInfo();
    std::string answer =
        "STUDENT[202102695, Jinyoung Jang]\n"
        "- CLASS[12142004, object oriented programming] : A "
        "STUDENT[202302719, Sieun Choi] "
        "STUDENT[201802617, Seoung Kim]\n"
        "- CLASS[23145019, web programming] : C\n"
        "- CLASS[32631040, programming language] : F "
        "STUDENT[200202699, Mingyeong Jeong]\n"
        "- CLASS[12142004, object oriented programming] : A\n"
        "- CLASS[23145019, web programming] : C\n"
        "- CLASS[32631040, programming language] : B "
        "STUDENT[201802617, Seoung Kim]\n"
        "- CLASS[32631040, programming language] : B "
        "STUDENT[200202699, Mingyeong Jeong]\n"
        "- CLASS[12142004, object oriented programming] : F\n"
        "- CLASS[23145019, web programming] : C";

    EXPECT_EQ(result, answer);
}
