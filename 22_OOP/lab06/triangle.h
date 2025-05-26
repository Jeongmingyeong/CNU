#ifndef TRIANGLE_H_
#define TRIANGLE_H_

class Triangle {
 public:
    explicit Triangle(int height, int base);
    int height() const;
    int base() const;
    Triangle operator+(const Triangle& triangle) const;
 private:
    const int height_;
    const int base_;
};

#endif
