#include <iostream>

class House {
  private:
    House(std::string name, bool has_roof, bool has_garage, bool has_swimming_pool, bool has_garden, int num_of_doors) :
      name_(name), has_roof_(has_roof), has_garage_(has_garage), has_swimming_pool_(has_swimming_pool)
      , has_garden_(has_garden), num_of_doors_(num_of_doors) {}

    const std::string name_;
    const bool has_roof_;
    const bool has_garage_;
    const bool has_swimming_pool_;
    const bool has_garden_;
    const int num_of_doors_;

    friend HouseBuilder;
};

class HouseBuilder {
  public:
    void reset() {
      name_ = "";
      has_roof_ = false;
      has_garage_ = false;
      has_swimming_pool_ = false;
      has_garden_ = false;
      num_of_doors_ = 0;
    }

    HouseBuilder& SetName(std::string name) {
      name_ = name;
      return *this;
    }
    HouseBuilder& AddRoof() {
      has_roof_ = true;
      return *this;
    }
    HouseBuilder& AddGarage() {
      has_garage_ = true;
      return *this;
    }
    HouseBuilder& AddSwimmingPool() {
      has_swimming_pool_ = true;
      return *this;
    }
    HouseBuilder& AddGarden() {
      has_garden_ = true;
      return *this;
    }
    HouseBuilder& SetNumOfDoors(int n) {
      num_of_doors_ = n;
      return *this;
    }
    House* Build() {
      return new House(name_, has_roof_, has_garage_, has_swimming_pool_, has_garden_, num_of_doors_);
    }


  private:
    std::string name_;
    bool has_roof_;
    bool has_garage_;
    bool has_swimming_pool_;
    bool has_garden_;
    int num_of_doors_;
};

int main() {
    HouseBuilder builder;
    House* my_house = builder.SetName("my house")
      .AddRoof()
      .AddGarage()
      .AddGarden()
      .SetNumOfDoors(4)
      .Build();

    return 1;
}