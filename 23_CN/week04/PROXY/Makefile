CC= clang++
STDFLAG= -std=c++11
THD = -lpthread

all: client server proxy

client: client.cc
	$(CC) $(STDFLAG) $(THD)  $^ -o $@

server: server.cc
	$(CC) $(STDFLAG) $(THD) $^ -o $@

proxy: proxy.cc
	$(CC) $(STDFLAG) $(THD) $^ -o $@

clean: 
	rm -rf client server proxy

.PHONY: all clean 
