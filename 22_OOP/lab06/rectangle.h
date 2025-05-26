#ifndef RECTANGLE_H_
#define RECTANGLE_H_

class Rectangle {
 public:
    explicit Rectangle(int height, int width);
    int height() const;
    int width() const;
    Rectangle operator+(const Rectangle& rect) const;
 private:
    const int height_;
    const int width_;
};

#endif

