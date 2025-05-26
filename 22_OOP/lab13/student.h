#ifndef _STUDENT_H_
#define _STUDENT_H_
#include <string>
#include <map>
#include "class_info.h"
#include "grade.h"

class StudentComparator;

class Student {
 public:
    explicit Student(const int id, const std::string name);
    void AddGrade(const ClassInfo& info, const Grade& grade);
    const std::string GetInfo() const;
 private:
    const int id_;
    const std::string name_;
    std::map<const ClassInfo, const Grade, ClassInfoComparator> grade_map_;
    friend StudentComparator;
};

class StudentComparator {
 public:
    int operator() (const Student& student1, const Student& student2) const;
};

#endif
