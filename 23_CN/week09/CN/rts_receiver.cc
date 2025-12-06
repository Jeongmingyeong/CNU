#include <csignal>
#include <iostream>
#include <unistd.h>
#include <cstdlib>

void sighandler(int signo, siginfo_t *si, void *context) {

	if (si->si_code == SI_QUEUE) {     // ---> signal ? rts?
        std::cout << "User RTS signal " << si->si_pid << std::endl;
        std::cout << "Sig Number " << si->si_signo << std::endl;
        std::cout << "User Data is " << si->si_value.sival_int << std::endl;
        std::cout << "Press Enter to continue..." << std::endl;
        std::cin.get(); 
    } else {
        std::cout << "Get non-realtime signal " << signo << std::endl;
    }
}

int main() {
    struct sigaction sigact;

    std::cout << "My pid " << getpid() << std::endl;
	
    sigemptyset(&sigact.sa_mask);	// ---> rts regist 
    sigact.sa_flags = SA_SIGINFO;
    sigact.sa_restorer = nullptr;
    sigact.sa_sigaction = sighandler;

    if (sigaction(SIGRTMIN, &sigact, nullptr) == -1) {	// ---> SIGRTMIN signal regist
        std::cerr << "Signal error" << std::endl;
        exit(EXIT_FAILURE);
    }

    while (true) {
        sleep(1);
    }

    return 0;
}
