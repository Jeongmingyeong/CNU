CC= clang++
STDFLAG= -std=c++11
THD = -lpthread

all: client server

client: client.cc
	$(CC) $(STDFLAG) $(THD)  $^ -o $@

server: server.cc
	$(CC) $(STDFLAG) $(THD) $^ -o $@

clean: 
	rm -rf client server

.PHONY: all clean 
