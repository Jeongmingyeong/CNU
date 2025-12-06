#ifndef PACKET_H
#define PACKET_H
// IP 헤더의 프로토콜 필드 값
constexpr uint16_t PROTO_IP = 0x0800;
constexpr uint16_t PROTO_ARP = 0x0806;
constexpr uint8_t PROTO_ICMP = 0x01;
constexpr uint8_t PROTO_TCP = 0x06;
constexpr uint8_t PROTO_UDP = 0x11;
// TCP 헤더의 falg 필드 값
constexpr uint8_t TCP_FIN = 0x01;
constexpr uint8_t TCP_SYN = 0x02;
constexpr uint8_t TCP_RST = 0x04;
constexpr uint8_t TCP_PSH = 0x08;
constexpr uint8_t TCP_ACK = 0x10;
constexpr uint8_t TCP_URG = 0x20;
constexpr uint8_t TCP_CTL = 0x3f;
// IP 헤더 구조체
#pragma pack(push, 1)
struct ip_header_t {
    uint8_t hlen:4;
    uint8_t version:4;
    uint8_t server;
    uint16_t length;
    uint16_t id;

    uint16_t fl_offset0:4;
    uint8_t flags:3;
    uint16_t fl_offset1:1;
    uint8_t fl_offest2:8;

    uint8_t ttl;
    uint8_t protocol;
    uint16_t checksum;
    uint32_t src_ip;
    uint32_t dst_ip;
};
#pragma pack(pop)
// TCP 헤더 구조체
#pragma pack(push, 1)
struct tcp_header_t {
    uint16_t src_port;
    uint16_t dst_port;
    uint32_t seqnum;
    uint32_t acknum;

    uint8_t reserved2:4;
    uint8_t hlen:4;
    uint8_t flags:6;
    uint8_t reserved1:2;

    uint16_t window_size;
    uint16_t checksum;
    uint16_t urgent_point;
};
#pragma pack(pop)
#endif  // PACKET_H
