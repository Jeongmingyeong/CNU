#include <string>
#include "class_info.h"

ClassInfo::ClassInfo(int class_id, const std::string& name) :
    class_id_(class_id), name_(name) {}

const std::string ClassInfo::GetInfo() const {
    std::string id = std::to_string(class_id_);
    return "CLASS[" + id + ", " + name_ + "]";
}

int ClassInfoComparator::operator()
    (const ClassInfo& info1, const ClassInfo& info2) const {
    if (info1.class_id_ < info2.class_id_)
        return 1;
    else
        return 0;
}
