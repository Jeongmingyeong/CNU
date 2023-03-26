#include <iostream>

class Employee {
  public:
    Employee(std::string name, int age, std::string dept) :
        name_(name), age_(age), dept_(dept) {}
    std::string GetInfo() {
        return "Employee: " + name_ + ", "  + std::to_string(age_) + ", " + dept_;
    }
    virtual ~Employee() {}

  protected:
    std::string name_;
    int age_;
    std::string dept_;
};

class Citizen {
  public:
    Citizen(std::string name, std::string address, std::string phone_number) :
        name_(name), address_(address), phone_number_(phone_number) {}
    virtual std::string GetInfo() {
        return "Citizen: " + address_ + " (" + phone_number_ + ")";
    }
    virtual ~Citizen() {}

  protected:
    std::string name_;
    std::string address_;
    std::string phone_number_;
};

class Developer : public Citizen, public Employee {
  public:
    Developer(std::string name, std::string address, std::string phone_number, int age, std::string dept) :
        Employee(name, age, dept), Citizen(name, address, phone_number) {}
    std::string GetInfo() override {
        return "Developer & Citizen";
    }
};

int main() {
    Developer* developer = new Developer("Kim", "Daejeon", "010-xxxx-xxxx", 26, "cs");
    Employee* employee = developer;
    Citizen* citizen = developer;
    std::cout << employee->GetInfo() << std::endl; // developer type
    std::cout << citizen->GetInfo() << std::endl; // developer type
    std::cout << developer->GetInfo() << std::endl; // developer type
    delete developer;

    return 1;
}