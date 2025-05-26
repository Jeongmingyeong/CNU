#ifndef PART_
#define PART_
#include <string>

class Part {
 public:
    explicit Part(std::string factory_name);
    virtual std::string GetInfo() const = 0;
 protected:
    const std::string& factory_name() const;
 private:
    const std::string factory_name_;
};

#endif
