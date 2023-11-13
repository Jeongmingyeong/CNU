#include <csignal>
#include <cstdlib>
#include <iostream>

int main(int argc, char **argv) {
    if (argc < 3) {
        std::cerr << "Usage: " << argv[0] << " <PID> <value>" << std::endl;
        return EXIT_FAILURE;
    }

    union sigval sv;
    sv.sival_int = atoi(argv[2]);

    if (sigqueue(atoi(argv[1]), SIGRTMIN, sv) == -1) {
        std::cerr << "sigqueue error" << std::endl;
        return EXIT_FAILURE;
    }

    return 0;
}
