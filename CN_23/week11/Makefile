CC= clang++
STDFLAG= --std=c++11
THD = -lssl -lcrypto -lpthread

TARGET=AES client server client_ssl_enc server_ssl_enc client_ssl server_ssl sha256 

all: $(TARGET)
#all : client server

AES: AES.cc
	$(CC) $(STDFLAG) $^ -o $@ $(THD)

client: client.cc
	$(CC) $(STDFLAG) $(THD)  $^ -o $@

server: server.cc
	$(CC) $(STDFLAG) $(THD)  $^ -o $@

client_ssl: client_ssl.cc
	$(CC) $(STDFLAG) $(THD)  $^ -o $@

server_ssl: server_ssl.cc
	$(CC) $(STDFLAG) $(THD)  $^ -o $@

client_ssl_enc: client_ssl_enc.cc
	$(cc) $(stdflag) $(thd)  $^ -o $@

server_ssl_enc: server_ssl_enc.cc
	$(cc) $(stdflag) $(thd)  $^ -o $@

sha256: sha256.cc
	$(cc) $(stdflag) $(thd)  $^ -o $@

clean: 
	rm -rf $(TARGET)

.PHONY: all clean 
