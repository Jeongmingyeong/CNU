CC= clang++
STDFLAG= -std=c++11
THD = -lpthread

all: epoll_client epoll_server

epoll_client: epoll_client.cc
	$(CC) $(STDFLAG) $(THD) $^ -o $@

epoll_server: epoll_server.cc
	$(CC) $(STDFLAG) $(THD) $^ -o $@

clean: 
	rm -rf epoll_client epoll_server

.PHONY: all clean 
