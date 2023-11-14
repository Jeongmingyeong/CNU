#include <iostream>
#include <cstring>
#include <unistd.h>
#include <cstdio>
#include <netinet/ip.h>
#include <netinet/ip_icmp.h>
#include <arpa/inet.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <netinet/ip.h>
#include <netinet/ip_icmp.h>
#include <netinet/udp.h>
#include <netinet/tcp.h>
#include <netinet/if_ether.h>
//#include <netinet/ether.h>
#include <sys/ioctl.h>
#include <net/if.h>
#include <sys/time.h>
#include <netinet/in_systm.h>
#include <netdb.h>
#include <stdexcept>

#define BUFSIZE 1024  // ICMP 수신 버퍼 크기

// IP 헤더 구조체
struct IPHeader {
    u_char ip_hl : 4;     // header length
    u_char ip_v : 4;      // version
    u_char ip_tos;        // type of service
    u_short ip_len;       // total length
    u_short ip_id;        // Identification
    u_short ip_off;       // flags & fragment offset field
    u_char ip_ttl;        // time to live
    u_char ip_p;          // protocol
    u_short ip_cksum;     // checksum
    in_addr ip_src;       // source addr
    in_addr ip_dst;       // dest addr
};

// ICMP 메시지 구조체
struct ICMPMessage {
    u_char icmp_type;
    u_char icmp_code;
    u_short icmp_cksum;
    union {
        struct {
            u_short icd_id;
            u_short icd_seq;
        } ih_idseq;
        u_long ih_void;
    } icmp_hun;
    struct ip icmp_dun;
};

// ICMP 메시지 타입
#define ICMP_ECHOREPLY 0
#define ICMP_DESTUNREACH 3
#define ICMP_ECHOREQUEST 8
#define ICMP_TIMEOUT 11

// ICMP 메시지 분석 함수
bool DecodeICMPMessage(char* buf, int buflen, sockaddr_in* peeraddr, sockaddr_in* destaddr) {
    IPHeader* iphdr = reinterpret_cast<IPHeader*>(buf);
    int iphdrlen = iphdr->ip_hl * 4;
    ICMPMessage* icmpmsg = reinterpret_cast<ICMPMessage*>(buf + iphdrlen);

    // 오류 체크
    if (buflen - iphdrlen < 0) {
        std::cerr << "[Err] ICMP packet is too short!" << std::endl;
        return false;
    }
    switch (icmpmsg->icmp_type) {
        case ICMP_TIMEOUT:
            std::cout << inet_ntoa(peeraddr->sin_addr) << std::endl;
            return true;
        case ICMP_ECHOREPLY:
            std::cout << inet_ntoa(peeraddr->sin_addr) << std::endl;
            return false;
        case ICMP_DESTUNREACH:
            std::cerr << "[Err] Host unreachable !" << std::endl;
            return false;
        default:
            std::cerr << "[Err] Unknown icmp packet !" << std::endl;
            return true;
    }
    return true;
}

// 도메인 이름을 IPv4 주소로 변환하는 함수
bool GetIPAddr(const char* name, in_addr* addr) {
    hostent* host = gethostbyname(name);
	std::cout << "host: " <<host<<"      name:"<<name<< std::endl;
    if (host == nullptr || host->h_addr_list[0] == nullptr) {
        std::cerr << "Failed to resolve host: " << name << std::endl;
        return false;
    }
    memcpy(addr, host->h_addr, host->h_length);
	std::cout << "addr: " <<addr<<"       host:"<<host<< std::endl;
	std::cout << "addr: " << inet_ntoa(*addr) << std::endl;
    return true;
}

// 체크섬 계산 함수
u_short checksum(u_short* buffer, int size) {
    u_long cksum = 0;
    u_short* ptr = buffer;
    int left = size;

    while (left > 1) {
        cksum += *ptr++;
        left -= sizeof(u_short);
    }
    if (left == 1) {
        cksum += *(reinterpret_cast<u_char*>(buffer));
    }
    cksum = (cksum >> 16) + (cksum & 0xffff);
    cksum += (cksum >> 16);

    return static_cast<u_short>(~cksum);
}

int main(int argc, char* argv[]) {
    int retval;

    if (argc < 2) {
        std::cerr << "Usage: " << argv[0] << " <host_name>" << std::endl;
        return 1;
    }

    int sock = socket(AF_INET, SOCK_RAW, IPPROTO_ICMP);
    if (sock == -1) {
        std::cerr << "socket(): line 129" << std::endl;
        return 1;
    }    
	// 소켓 옵션 설정
    struct timeval timeout;      
    timeout.tv_sec = 10;
    timeout.tv_usec = 0;	

	retval = setsockopt(sock, SOL_SOCKET, SO_SNDTIMEO, &timeout, sizeof(timeout));
    if (retval == -1) {
		std::cerr << "setsockopt(): line 136, retval: " << retval << std::endl;
		return 1;
	}

    retval = setsockopt(sock, SOL_SOCKET, SO_RCVTIMEO, &timeout, sizeof(timeout));
    if (retval == -1) {
        std::cerr << "setsockopt(): line 141" << std::endl;
        return 1;
    }
	// 소켓 구조체 init
	sockaddr_in destaddr;
    memset(&destaddr, 0, sizeof(destaddr));
    destaddr.sin_family = AF_INET;
    in_addr addr;
    if (GetIPAddr(argv[1], &addr)) {
        destaddr.sin_addr = addr;
		std::cout << "addr: " << inet_ntoa(addr) << std::endl;
    } else {
        return 1;
    }

	// 통신에 사용할 변수
    ICMPMessage icmpmsg;
    char buf[BUFSIZE];
    sockaddr_in peeraddr;
    socklen_t addrlen = sizeof(peeraddr);

    for (int ttl = 1; ttl <= 30; ttl++) {
        //int ttl_value = ttl; // TTL 값을 변경
		timeout.tv_sec = ttl;
	    retval = setsockopt(sock, IPPROTO_IP, IP_TTL, &timeout, sizeof(timeout));
        if (retval == -1) {
            std::cerr << "setsockopt(): line 159" << std::endl;
            return 1;
        }

        memset(&icmpmsg, 0, sizeof(icmpmsg));
        icmpmsg.icmp_type = ICMP_ECHOREQUEST;
        icmpmsg.icmp_hun.ih_idseq.icd_id = static_cast<u_short>(getpid());
        icmpmsg.icmp_hun.ih_idseq.icd_seq = static_cast<u_short>(ttl);
        icmpmsg.icmp_cksum = checksum(reinterpret_cast<u_short*>(&icmpmsg), sizeof(icmpmsg));

        retval = sendto(sock, &icmpmsg, sizeof(icmpmsg), 0, (struct sockaddr*)&destaddr, sizeof(destaddr));
		// retval = send(sock, &icmpmsg, sizeof(icmpmsg), 0);
        if (retval == -1) {
            if (errno == EAGAIN) {
                std::cout << "[Err] send timed out !!!" << std::endl;
                continue;
            } else {
                perror("send(): line 185");
                break;
            }
        }
		retval = recvfrom(sock, buf, BUFSIZE, 0, (struct sockaddr*)&peeraddr, &addrlen);
        //retval = recv(sock, buf, BUFSIZE, 0);
        if (retval == -1) {
            if (errno == EAGAIN) {
                std::cout << "[Err] request timed out !!!" << std::endl;
                continue;
            } else {
                perror("recv(): line 196");
                break;
            }
        }

        if (!DecodeICMPMessage(buf, retval, &peeraddr, &destaddr)) {
            break;
        }
    }

    close(sock);

    return 0;
}
