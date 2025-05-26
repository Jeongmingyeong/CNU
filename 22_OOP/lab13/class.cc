#include <string>
#include <set>
#include "class.h"
#include "class_info.h"
#include "student.h"

Class::Class(const ClassInfo& info) :
    info_(info) {}

void Class::Register(const Student& student) {
    registered_student_.insert(student);
}

const std::string Class::GetInfo() const {
    std::string result = info_.GetInfo();
    int index = 1;
    for (Student st : registered_student_) {
        result += "\n(" + std::to_string(index) + ") " + st.GetInfo();
        index++;
    }
    return result;
}
