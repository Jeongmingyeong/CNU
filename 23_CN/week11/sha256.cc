#include <iostream>
#include <iomanip>
#include <openssl/sha.h>
#include <cstring>

int main() {
    char input_string[100];
    std::cout << "문자열을 입력하세요: ";
    std::cin.getline(input_string, sizeof(input_string));

    unsigned char sha256_hash[SHA256_DIGEST_LENGTH];
    SHA256(reinterpret_cast<const unsigned char*>(input_string), strlen(input_string), sha256_hash);

    std::cout << "SHA256 해시 결과: ";
    for (int i = 0; i < SHA256_DIGEST_LENGTH; i++) {
        std::cout << std::hex << std::setw(2) << std::setfill('0') << static_cast<int>(sha256_hash[i]);
    }
    std::cout << std::dec << std::endl;

    return 0;
}
