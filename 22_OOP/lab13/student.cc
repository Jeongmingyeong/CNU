#include <string>
#include <map>
#include <utility>
#include "student.h"
#include "class_info.h"
#include "grade.h"

Student::Student(const int id, const std::string name) :
    id_(id), name_(name) {}

void Student::AddGrade(const ClassInfo& info, const Grade& grade) {
    grade_map_.insert({info, grade});
}

const std::string Student::GetInfo() const {
    std::string id = std::to_string(this->id_);
    std::string grade = "";
    std::string result = "STUDENT[" + id + ", " + this->name_ + "]";
    for (std::pair<const ClassInfo, const Grade> st : grade_map_) {
        result += "\n- " + st.first.GetInfo() + " : ";
        if (st.second == Grade::A) {
            result += "A";
        } else if (st.second == Grade::B) {
            result += "B";
        } else if (st.second == Grade::C) {
            result += "C";
        } else if (st.second == Grade::D) {
            result += "D";
        } else {
            result += "F";
        }
    }

    return result;
}

int StudentComparator::operator()
    (const Student& student1, const Student& student2) const {
    if (student1.id_ < student2.id_) {
        return 1;
    } else if (student1.id_ == student2.id_) {
        if (student1.name_.compare(student2.name_) < 0) {
            return 1;
        }
    } else {
        return 0;
    }
}
