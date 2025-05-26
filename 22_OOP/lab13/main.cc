#include <iostream>
#include "class.h"
#include "class_info.h"
#include "grade.h"
#include "student.h"

int main() {
    ClassInfo c1(12142004, "object oriented programming");
    ClassInfo c2(23145019, "software analysis");
    ClassInfo c3(32631040, "programming basic for AI");
    ClassInfo c4(32631040, "programming basic for AI");

    Student s1(201620142, "Sora Park");
    Student s2(201941923, "Jihyuk Go");
    Student s3(202218423, "Sunghoon Kim");
    Student s4(201941923, "Jihyuk Go");

    Class ood2022(c1);
    Class sa2022(c2);
    Class pbai2022(c3);

    ood2022.Register(s1);
    ood2022.Register(s2);
    sa2022.Register(s2);
    sa2022.Register(s3);
    sa2022.Register(s4); /* Ignored, since s4 is the same to s2. */
    pbai2022.Register(s1);
    pbai2022.Register(s2);
    pbai2022.Register(s3);

    s1.AddGrade(c1, Grade::A);
    s1.AddGrade(c2, Grade::B);
    s2.AddGrade(c1, Grade::C);
    s2.AddGrade(c3, Grade::D);
    s2.AddGrade(c4, Grade::F);

    std::cout << c1.GetInfo() << std::endl;
    std::cout << c2.GetInfo() << std::endl;
    std::cout << c3.GetInfo() << std::endl << std::endl;

    std::cout << s1.GetInfo() << std::endl;
    std::cout << s2.GetInfo() << std::endl;
    std::cout << s3.GetInfo() << std::endl << std::endl;

    std::cout << ood2022.GetInfo() << std::endl;
    std::cout << sa2022.GetInfo() << std::endl;
    std::cout << pbai2022.GetInfo() << std::endl;
    return 0;
}
