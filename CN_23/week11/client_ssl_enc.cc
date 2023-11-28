#include <stdio.h>
#include <iostream>
#include <stdlib.h>
#include <string>
#include <thread>
#include <unistd.h>
#include <sys/socket.h>
#include <arpa/inet.h>
#include <netdb.h>
#include <cstring>
#include <openssl/ssl.h>
#include <openssl/err.h>
#include "cryptopp/cryptlib.h"
#include "cryptopp/modes.h"
#include "cryptopp/aes.h"
#include "cryptopp/filters.h"
#include "cryptopp/base64.h"
#define DEFAULT_BUFLEN 512

struct client_type{
    int id;
    int sockfd;
    SSL* ssl;
    char received_message[DEFAULT_BUFLEN];
};

const int INVALID_SOCKET = -1;
const int SOCKET_ERROR = -1;

SSL_CTX* createSSLContext(){
    SSL_CTX* ctx = SSL_CTX_new(TLS_client_method());
    if (!ctx){
        std::cerr << "Error creating SSL context\n";
        ERR_print_errors_fp(stderr);
        exit(EXIT_FAILURE);
    }
	// Like grammer
    // Set options and modes
    SSL_CTX_set_options(ctx, SSL_OP_NO_SSLv2 | SSL_OP_NO_SSLv3);
    // Set cipher list
    SSL_CTX_set_cipher_list(ctx, "HIGH:!aNULL:!eNULL:!EXPORT:!DES:!RC4:!MD5:!PSK:!SRP:!CAMELLIA:!SEED");
    // Load trusted CA certificates
    if (SSL_CTX_load_verify_locations(ctx, "../certification/ca-certificate.pem", nullptr) != 1){
        std::cerr << "Error loading CA certificate\n";
        ERR_print_errors_fp(stderr);
        exit(EXIT_FAILURE);
    }
    return ctx;
}

SSL* createSSLConnection(SSL_CTX* ctx, int sockfd){
    SSL* ssl = SSL_new(ctx);
    if (!ssl){
        std::cerr << "Error creating SSL structure\n";
        ERR_print_errors_fp(stderr);
        exit(EXIT_FAILURE);
    }

    SSL_set_fd(ssl, sockfd);

    if (SSL_connect(ssl) != 1){
        std::cerr << "Error establishing SSL connection\n";
        ERR_print_errors_fp(stderr);
        exit(EXIT_FAILURE);
    }

    return ssl;
}
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
int process_client(client_type &new_client){
	bool flag = false;
    while (true) {
        memset(new_client.received_message, 0, DEFAULT_BUFLEN);
        if (new_client.ssl != nullptr) {
            int iResult = SSL_read(
                new_client.ssl,
                new_client.received_message,
                DEFAULT_BUFLEN
            );
            if (iResult > 0) {				
				if(flag){
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

					std::string base64encodedciphertext= new_client.received_message;
					std::string decryptedtext;
					std::string base64decryptedciphertext;
					// Base64 디코딩
					CryptoPP::StringSource(base64encodedciphertext, true,
						new CryptoPP::Base64Decoder(
							new CryptoPP::StringSink(base64decryptedciphertext)
						)
					);
					// AES 복호화
					CryptoPP::AES::Decryption aesDecryption(key, CryptoPP::AES::DEFAULT_KEYLENGTH);
					CryptoPP::CBC_Mode_ExternalCipher::Decryption cbcDecryption(aesDecryption, iv);
					CryptoPP::StreamTransformationFilter stfDecryptor(cbcDecryption, new CryptoPP::StringSink(decryptedtext));
					stfDecryptor.Put(reinterpret_cast<const unsigned char*>(base64decryptedciphertext.c_str()), base64decryptedciphertext.size());
					stfDecryptor.MessageEnd();
					// 복호화 문자열 출력
					std::cout << "recv: "<< decryptedtext<< std::endl;								 
				}else{
					printf("%s\n", new_client.received_message);
				    flag = true;
				}

            } else {
                fprintf(stderr, "SSL_read() failed\n");
                break;
            }
        }
    }
    fprintf(stderr, "The server has disconnected\n");
    return 0;
}


int main(int argc, char** argv){
    int port_no;
    struct sockaddr_in server_addr;
    struct hostent *server;
    client_type client = { INVALID_SOCKET, -1, nullptr, "" };
    std::string message;
    std::string sent_message;
    int ret = 0;

    if (argc < 3) {
        fprintf(stderr, "Usage: %s hostname port\n", argv[0]);
        return -1;
    }

    port_no = atoi(argv[2]);
    if (port_no <= 0) {
        fprintf(stderr, "Invalid port -.-\n");
        return -1;
    }

    SSL_CTX* ctx = createSSLContext();

    server = gethostbyname(argv[1]);
    if (server == NULL) {
        fprintf(stderr, "ERROR, no such host\n");
        return -2;
    }

    fprintf(stdout, "Starting client...\n");

    client.sockfd = socket(AF_INET, SOCK_STREAM, 0);
    if (client.sockfd < 0) {
        fprintf(stderr, "ERROR opening socket\n");
        return -2;
    }

    bzero((char *) &server_addr, sizeof(server_addr));
    server_addr.sin_family = AF_INET;

    bcopy(
        (char *)server->h_addr,
        (char *)&server_addr.sin_addr.s_addr,
        server->h_length
    );

    server_addr.sin_port = htons(port_no);

    printf("Trying connect to %s:%d...\n", (char *)server->h_addr, port_no);

    if (connect(client.sockfd, (struct sockaddr *) &server_addr, sizeof(server_addr)) < 0) {
        close(client.sockfd);
        fprintf(stderr, "Unable to connect to server!\n");
        return -3;
    }

    fprintf(stdout, "Connected!\n");

    // SSL connection setup
    client.ssl = createSSLConnection(ctx, client.sockfd);

    // Receive initial message from the server
    SSL_read(client.ssl, client.received_message, DEFAULT_BUFLEN);
    message = client.received_message;

    if (message != "Server is full") {
        client.id = atoi(client.received_message);
        std::thread my_thread(process_client, std::ref(client));
        while (true) {
            fprintf(stdout, "You> ");
            getline(std::cin, sent_message);
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
			std::string plaintext = sent_message;
			std::string ciphertext;
			std::string base64encodedciphertext;
		    std::string decryptedtext;
		    std::string base64decryptedciphertext;
			size_t plainTextLength = plaintext.length();
			// AES 암호화 수행
			CryptoPP::AES::Encryption aesEncryption(key, CryptoPP::AES::DEFAULT_KEYLENGTH);
			CryptoPP::CBC_Mode_ExternalCipher::Encryption cbcEncryption(aesEncryption, iv);
			CryptoPP::StreamTransformationFilter stfEncryptor(cbcEncryption, new CryptoPP::StringSink(ciphertext));
			stfEncryptor.Put(reinterpret_cast<const unsigned char*>(plaintext.c_str()), plainTextLength);
			stfEncryptor.MessageEnd();

			// Base64 인코딩
			CryptoPP::StringSource(ciphertext, true,
				new CryptoPP::Base64Encoder(
					new CryptoPP::StringSink(base64encodedciphertext)
				)
			);
			ret = SSL_write(client.ssl, base64encodedciphertext.data(), base64encodedciphertext.size());
			//ret = SSL_write(client.ssl, base64encodedciphertext.c_str(), strlen(base64encodedciphertext.c_str()));
            //ret = SSL_write(client.ssl, sent_message.c_str(), strlen(sent_message.c_str()));
            if (ret <= 0) {
                fprintf(stderr, "SSL_write() failed\n");
                break;
            }
        }
        my_thread.detach();
    } else {
        printf("%s\n", client.received_message);
    }

    fprintf(stdout, "Closing socket...\n");
    SSL_shutdown(client.ssl);
    SSL_free(client.ssl);
    SSL_CTX_free(ctx);

    close(client.sockfd);

    return 0;
}
