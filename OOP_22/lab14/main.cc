#include <array>
#include <vector>
#include <list>
#include <iostream>
#include "sort.h"

int main() {
    std::vector<int> vec = {7, 10, 5, 2, 4, 3, 9};
    std::array<int, 7> arr = {7, 10, 5, 2, 4, 3, 9};
    std::list<int> lst = {7, 10, 5, 2, 4, 3, 9};

    std::cout << "#Sorted vector: ";
    Sort<std::vector<int>>(vec.begin(), vec.end());
    for (int i : vec) {
        std::cout << i << " ";
    }
    std::cout << std::endl;

    std::cout << "#Sorted array: ";
    Sort<std::array<int, 7>>(arr.begin(), arr.end());
    for (int i : arr) {
        std::cout << i << " ";
    }
    std::cout << std::endl;

    std::cout << "#Sorted list: ";
    Sort<std::list<int>>(lst.begin(), lst.end());
    for (int i : lst) {
        std::cout << i << " ";
    }
    std::cout << std::endl;

    return 0;
}
