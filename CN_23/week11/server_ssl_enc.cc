#include <stdio.h>
#include <stdlib.h>
#include <string>
#include <vector>
#include <thread>
#include <unistd.h>
#include <sys/socket.h>
#include <arpa/inet.h>
#include <cstring>
#include <openssl/ssl.h>
#include <openssl/err.h>

#define DEFAULT_BUFLEN 512

struct client_type {
    int id;
    int sockfd;
    SSL* ssl;
};

const int INVALID_SOCKET = -1;
const int SOCKET_ERROR = -1;
const int MAX_CLIENTS = 5;

SSL_CTX* createSSLContext() {
    SSL_CTX* ctx = SSL_CTX_new(TLS_server_method());
    if (!ctx) {
        fprintf(stderr, "Error creating SSL context\n");
        ERR_print_errors_fp(stderr);
        exit(EXIT_FAILURE);
    }
    // Set options and modes
    SSL_CTX_set_options(ctx, SSL_OP_NO_SSLv2 | SSL_OP_NO_SSLv3);
    // Set cipher list
    SSL_CTX_set_cipher_list(ctx, "HIGH:!aNULL:!eNULL:!EXPORT:!DES:!RC4:!MD5:!PSK:!SRP:!CAMELLIA:!SEED");
    // Load server certificate and private key
    if (SSL_CTX_use_certificate_file(ctx, "../certification/server-certificate.pem", SSL_FILETYPE_PEM) != 1 ||
        SSL_CTX_use_PrivateKey_file(ctx, "../certification/server-private-key.pem", SSL_FILETYPE_PEM) != 1) {
        fprintf(stderr, "Error loading server certificate/private key\n");
        ERR_print_errors_fp(stderr);
        exit(EXIT_FAILURE);
    }
    return ctx;
}

SSL* createSSLConnection(SSL_CTX* ctx, int sockfd) {
    SSL* ssl = SSL_new(ctx);
    if (!ssl) {
        fprintf(stderr, "Error creating SSL structure\n");
        ERR_print_errors_fp(stderr);
        exit(EXIT_FAILURE);
    }

    SSL_set_fd(ssl, sockfd);

    if (SSL_accept(ssl) != 1) {
        fprintf(stderr, "Error accepting SSL connection\n");
        ERR_print_errors_fp(stderr);
        exit(EXIT_FAILURE);
    }

    return ssl;
}

void cleanupSSL(SSL_CTX* ctx, SSL* ssl) {
    SSL_shutdown(ssl);
    SSL_free(ssl);
    SSL_CTX_free(ctx);
}

void send_message(SSL* ssl, const std::string& message) {
    int len = message.length();
    if (SSL_write(ssl, &len, sizeof(len)) <= 0) {
        fprintf(stderr, "SSL_write() failed for message length\n");
        exit(EXIT_FAILURE);
    }

    int total_sent = 0;
    while (total_sent < len) {
        int sent = SSL_write(ssl, message.c_str() + total_sent, len - total_sent);
        if (sent <= 0) {
            fprintf(stderr, "SSL_write() failed for message\n");
            exit(EXIT_FAILURE);
        }
        total_sent += sent;
    }
}

int process_client(client_type& new_client, std::vector<client_type>& client_array, SSL_CTX* ssl_ctx, std::thread& thread) {
    std::string msg = "";
    char tempmsg[DEFAULT_BUFLEN] = "";

    /* Session */
    while (true) {
        memset(tempmsg, 0, DEFAULT_BUFLEN);

        if (new_client.ssl != nullptr) {
            int iResult = SSL_read(new_client.ssl, tempmsg, DEFAULT_BUFLEN);

            if (iResult > 0) {
                if (strcmp("", tempmsg)) {
                    msg = "Client #" + std::to_string(new_client.id) + ": " + tempmsg;
                }

                printf("%s\n", msg.c_str());

                /* Broadcast that message to the other clients */
                for (int i = 0; i < MAX_CLIENTS; i++) {
                    if (client_array[i].ssl != nullptr) {
                        if (new_client.id != i) {
                            iResult = SSL_write(client_array[i].ssl, tempmsg, iResult);
                        }
                    }
                }
            } else {
                msg = "Client #" + std::to_string(new_client.id) + " Disconnected";
                printf("%s\n", msg.c_str());
                SSL_shutdown(new_client.ssl);
                SSL_free(new_client.ssl);
                close(new_client.sockfd);
                close(client_array[new_client.id].sockfd);
                client_array[new_client.id].sockfd = INVALID_SOCKET;
                /* Broadcast the disconnection message to the other clients */
                for (int i = 0; i < MAX_CLIENTS; i++) {
                    if (client_array[i].ssl != nullptr) {
                        //iResult = SSL_write(client_array[i].ssl, msg.c_str(), strlen(msg.c_str()));
                    }
                }
                break;
            }
        }
    }
    thread.detach();
    return 0;
}

int main(int argc, char** argv) {
    int sockfd;
    int port_no;
    int num_clients = 0;
    int temp_id = -1;
    struct sockaddr_in server_addr;
    struct sockaddr_in client_addr;
    socklen_t client_len;
    std::vector<client_type> client(MAX_CLIENTS);
    std::string msg = "";
    std::thread client_threads[MAX_CLIENTS];
    SSL_CTX* ctx;

	  printf( "████████╗░█████╗░██████╗░\n");
    printf( "╚══██╔══╝██╔══██╗██╔══██╗\n");
    printf( "░░░██║░░░██║░░╚═╝██████╔╝\n");
    printf( "░░░██║░░░██║░░██╗██╔═══╝░\n");
    printf( "░░░██║░░░╚█████╔╝██║░░░░░\n");
    printf( "░░░╚═╝░░░░╚════╝░╚═╝░░░░░\n\n");

    printf( "░██████╗███████╗██████╗░██╗░░░██╗███████╗██████╗░\n");
    printf( "██╔════╝██╔════╝██╔══██╗██║░░░██║██╔════╝██╔══██╗\n");
    printf( "╚█████╗░█████╗░░██████╔╝╚██╗░██╔╝█████╗░░██████╔╝\n");
    printf( "░╚═══██╗██╔══╝░░██╔══██╗░╚████╔╝░██╔══╝░░██╔══██╗\n");
    printf( "██████╔╝███████╗██║░░██║░░╚██╔╝░░███████╗██║░░██║\n");
    printf( "╚═════╝░╚══════╝╚═╝░░╚═╝░░░╚═╝░░░╚══════╝╚═╝░░╚═╝\n");

    if (argc < 2) {
        fprintf(stderr, "ERROR, no port provided\n");
        return -1;
    }

    port_no = atoi(argv[1]);
    if (port_no <= 0) {
        fprintf(stderr, "Invalid port -.-\n");
        return -1;
    }

    ctx = createSSLContext();

    fprintf(stdout, "Creating server socket...\n");
    sockfd = socket(AF_INET, SOCK_STREAM, 0);
    if (sockfd < 0) {
        fprintf(stderr, "ERROR opening socket\n");
        return -2;
    }

    bzero((char*)&server_addr, sizeof(server_addr));
    server_addr.sin_family = AF_INET;
    server_addr.sin_addr.s_addr = INADDR_ANY;
    server_addr.sin_port = htons(port_no);

    if (bind(sockfd, (struct sockaddr*)&server_addr, sizeof(server_addr)) < 0) {
        fprintf(stderr, "ERROR on binding\n");
        return -3;
    }

    listen(sockfd, 5);
    char local_host[INET_ADDRSTRLEN];
    inet_ntop(AF_INET, &(server_addr.sin_addr), local_host, INET_ADDRSTRLEN);
    printf("Listening on %s:%d\n", local_host, port_no);

    for (int i = 0; i < MAX_CLIENTS; i++) {
        client[i] = { -1, INVALID_SOCKET, nullptr };
    }

    client_len = sizeof(client_addr);

    while (true) {
        int incoming = INVALID_SOCKET;
        incoming = accept(sockfd, (struct sockaddr*)&client_addr, &client_len);

        if (incoming == INVALID_SOCKET) {
            continue;
        }

        num_clients = -1;
        temp_id = -1;

        for (int i = 0; i < MAX_CLIENTS; i++) {
            if (client[i].sockfd == INVALID_SOCKET && temp_id == -1) {
                client[i].sockfd = incoming;
                client[i].id = i;
                client[i].ssl = createSSLConnection(ctx, incoming);
                temp_id = i;
            }
            if (client[i].sockfd != INVALID_SOCKET) {
                num_clients++;
            }
        }

        if (temp_id != -1) {
            char remote_host[INET_ADDRSTRLEN];
            inet_ntop(AF_INET, &(client_addr.sin_addr), remote_host, INET_ADDRSTRLEN);
            printf(
                "Connection accepted from %s:%d (Client #%d) accepted\n",
                remote_host,
                ntohs(client_addr.sin_port),
                client[temp_id].id
            );
            msg = std::to_string(client[temp_id].id);
            send_message(client[temp_id].ssl, msg);
            client_threads[temp_id] = std::thread(
                process_client,
                std::ref(client[temp_id]),
                std::ref(client),
                ctx,
                std::ref(client_threads[temp_id])
            );
        } else {
            msg = "Server is full";
            send(incoming, msg.c_str(), strlen(msg.c_str()), 0);
            char remote_host[INET_ADDRSTRLEN];
            inet_ntop(AF_INET, &(client_addr.sin_addr), remote_host, INET_ADDRSTRLEN);
            printf(
                "Connection rejected to %s:%d (Client #%d). The server is full!\n",
                remote_host,
                ntohs(client_addr.sin_port),
                client[temp_id].id
            );
            close(client[temp_id].sockfd);
            SSL_shutdown(client[temp_id].ssl);
            SSL_free(client[temp_id].ssl);
        }
    }

    close(sockfd);
    for (int i = 0; i < MAX_CLIENTS; i++) {
        client_threads[i].detach();
        close(client[i].sockfd);
        SSL_shutdown(client[i].ssl);
        SSL_free(client[i].ssl);
    }

    SSL_CTX_free(ctx);

    return 0;
}
