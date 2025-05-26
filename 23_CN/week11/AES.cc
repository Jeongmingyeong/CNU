#include <iostream>
#include <iomanip>
#include <cstring>
#include "cryptopp/cryptlib.h"
#include "cryptopp/modes.h"
#include "cryptopp/aes.h"
#include "cryptopp/filters.h"
#include "cryptopp/base64.h"

void hex2byte(const char* in, size_t len, unsigned char* out) {
    for (size_t i = 0; i < len; i += 2) {
        char c0 = in[i + 0];
        char c1 = in[i + 1];
        unsigned char c = (
            ((c0 & 0x40 ? (c0 & 0x20 ? c0 - 0x57 : c0 - 0x37) : c0 - 0x30) << 4) |
            ((c1 & 0x40 ? (c1 & 0x20 ? c1 - 0x57 : c1 - 0x37) : c1 - 0x30))
        );
        out[i / 2] = c;
    }
}

int main(int argc, char* argv[]) {
    // 키 할당
    unsigned char key[CryptoPP::AES::DEFAULT_KEYLENGTH];
    std::memset(key, 0x00, CryptoPP::AES::DEFAULT_KEYLENGTH);
    const char* rawKey = "f4150d4a1ac5708c29e437749045a39a";
    hex2byte(rawKey, std::strlen(rawKey), key);

    // IV 할당
    unsigned char iv[CryptoPP::AES::BLOCKSIZE];
    std::memset(iv, 0x00, CryptoPP::AES::BLOCKSIZE);
    const char* rawIv = "86afc43868fea6abd40fbf6d5ed50905";
    hex2byte(rawIv, std::strlen(rawIv), iv);

    // 평문 할당
    std::string plaintext = "hello world~!";
    std::string ciphertext;
    std::string base64encodedciphertext;
    std::string decryptedtext;
    std::string base64decryptedciphertext;

    // 평문 출력
    std::cout << "Plain Text (" << plaintext.size() << " bytes)" << std::endl;
    std::cout << plaintext;
    std::cout << std::endl << std::endl;

    size_t plainTextLength = plaintext.length();

    // AES 암호화 수행
    CryptoPP::AES::Encryption aesEncryption(key, CryptoPP::AES::DEFAULT_KEYLENGTH);
    CryptoPP::CBC_Mode_ExternalCipher::Encryption cbcEncryption(aesEncryption, iv);
    CryptoPP::StreamTransformationFilter stfEncryptor(cbcEncryption, new CryptoPP::StringSink(ciphertext));
    stfEncryptor.Put(reinterpret_cast<const unsigned char*>(plaintext.c_str()), plainTextLength + 1);
    stfEncryptor.MessageEnd();

    // Base64 인코딩
    CryptoPP::StringSource(ciphertext, true,
        new CryptoPP::Base64Encoder(
            new CryptoPP::StringSink(base64encodedciphertext)
        ) // Base64Encoder
    ); // StringSource

    // Base64 인코딩 문자열 출력
    std::cout << "Cipher Text (" << base64encodedciphertext.size() << " bytes)" << std::endl;
    std::cout << "cipher : " << base64encodedciphertext << std::endl;
    std::cout << std::endl << std::endl;

    // Base64 디코딩
    CryptoPP::StringSource(base64encodedciphertext, true,
        new CryptoPP::Base64Decoder(
            new CryptoPP::StringSink(base64decryptedciphertext)
        ) // Base64Encoder
    ); // StringSource

    // AES 복호화
    CryptoPP::AES::Decryption aesDecryption(key, CryptoPP::AES::DEFAULT_KEYLENGTH);
    CryptoPP::CBC_Mode_ExternalCipher::Decryption cbcDecryption(aesDecryption, iv);
    CryptoPP::StreamTransformationFilter stfDecryptor(cbcDecryption, new CryptoPP::StringSink(decryptedtext));
    stfDecryptor.Put(reinterpret_cast<const unsigned char*>(base64decryptedciphertext.c_str()), base64decryptedciphertext.size());
    stfDecryptor.MessageEnd();

    // 복호화 문자열 출력
    std::cout << "Decrypted Text: " << std::endl;
    std::cout << decryptedtext;
    std::cout << std::endl << std::endl;

    return 0;
}
