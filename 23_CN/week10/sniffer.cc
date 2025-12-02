#include <iostream>
#include <cstring>
#include <string>
#include <sys/socket.h>
#include <sys/ioctl.h>
#include <net/if.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <unistd.h>
#include "packet.h"

int main() {
    int sock, ret, len;
    char buffer[1024];
    struct sockaddr_in from;
    struct in_addr src, dst;
    struct ifreq ifr;
    std::string interface = "en0";
    struct ip_header_t *ip = reinterpret_cast<struct ip_header_t *>(buffer);
    struct tcp_header_t *tcp;
    
    std::cout << "1" << std::endl;
    // RAW 소켓 생성
    sock = socket(AF_INET, SOCK_RAW, IPPROTO_TCP);

    std::cout << "2" << std::endl;
    strncpy(ifr.ifr_name, interface.c_str(), interface.size() + 1);

    std::cout << "3" << std::endl;
    if (ioctl(sock, SIOCGIFFLAGS, &ifr) < 0) {
        perror("SIOCGIFFLAGS error: ");
        exit(1);
    }

    std::cout << "4" << std::endl;
    ifr.ifr_flags |= IFF_PROMISC;

    std::cout << "5" << std::endl;
    if (ioctl(sock, SIOCGIFFLAGS, &ifr) < 0) {
        perror("Could not set the PROMISC flag: ");
        exit(1);
    }

    std::cout << "6" << std::endl;
    len = sizeof(from);

    std::cout << "7" << std::endl;
    while (1) {
        std::cout << "8" << std::endl;
        ret = recvfrom(sock, buffer, sizeof(buffer), 0, reinterpret_cast<struct sockaddr *>(&from), reinterpret_cast<socklen_t *>(&len));
        std::cout << "9" << std::endl;
        std::cout << "receive data = " << ret << std::endl;

        if (ip->protocol != PROTO_TCP) {
            continue;
        }

        std::cout << "==================IP header==================" << std::endl;
        src.s_addr = ip->src_ip;
        dst.s_addr = ip->dst_ip;

        std::cout << "Src ip = " << inet_ntoa(src) << std::endl;
        std::cout << "Dst ip = " << inet_ntoa(dst) << std::endl;
        std::cout << "Total length = " << ntohs(ip->length) << std::endl;
        std::cout << "ID = " << ntohs(ip->id) << std::endl;
        std::cout << "TTL = " << static_cast<int>(ip->ttl) << std::endl;
        std::cout << "Checksum = 0x" << std::hex << ntohs(ip->checksum) << std::dec << std::endl;

        std::cout << "==================TCP header==================" << std::endl;
        tcp = reinterpret_cast<struct tcp_header_t *>(buffer + (4 * ip->hlen));
        std::cout << "Src port = " << ntohs(tcp->src_port) << std::endl;
        std::cout << "Dst port = " << ntohs(tcp->dst_port) << std::endl;
        std::cout << "SEQ = 0x" << std::hex << ntohl(tcp->seqnum) << std::dec << std::endl;
        std::cout << "ACK = 0x" << std::hex << ntohs(tcp->acknum) << std::dec << std::endl;
        std::cout << "Checksum = 0x" << std::hex << ntohs(tcp->checksum) << std::dec << std::endl;

        std::cout << "==================DATA field==================" << std::endl;
        char *data = buffer + (4 * ip->hlen) + (4 * tcp->hlen);

        while (isprint(*data) || isspace(*data)) {
            std::cout << *data;
            data++;
        }

        std::cout << "\n\n\n\n";
		sleep(2);
    }

    return 0;
}
