#ifndef _SORT_H_
#define _SORT_H_
#include <iterator>

template <class T>
void Sort(typename T::iterator begin, typename T::iterator end) {
    for (auto i = begin; i != end; i++) {
        for (auto j = begin; j != end; j++) {
            if (*i < *j) {
                auto temp = *i;
                *i = *j;
                *j = temp;
            } else {
                continue;
            }
        }
    }
}

#endif
