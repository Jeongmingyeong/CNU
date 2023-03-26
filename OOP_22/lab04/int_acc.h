#ifndef INT_ACC_H_
#define INT_ACC_H_

namespace int_acc {
class Accumulator {
 public :
    explicit Accumulator(int acc);
    void Add(int x);
    void Sub(int x);
    void Mult(int x);
    void Div(int x);
    int acc();
 private:
    int acc_;
};
}  // namespace int_acc
#endif
