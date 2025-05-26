#ifndef CIRCLE_H_
#define CIRCLE_H_

class Circle {
 public:
    explicit Circle(int radius);
    int radius() const;
    Circle operator+(const Circle& circle) const;
 private:
    const int radius_;
};

#endif
