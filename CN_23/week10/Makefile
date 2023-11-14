CC= clang++
STDFLAG= --std=c++11
THD = -lpthread

all: ping ping2 traceroute sniffer

ping: ping.cc
	$(CC) $(STDFLAG) $(THD)  $^ -o $@

ping2: ping2.cc
	$(CC) $(STDFLAG) $(THD)  $^ -o $@

traceroute: traceroute.cc
	$(CC) $(STDFLAG) $(THD)  $^ -o $@

sniffer: sniffer.cc
	$(CC) $(STDFLAG) $(THD)  $^ -o $@

clean: 
	rm -rf ping ping2 traceroute sniffer

.PHONY: all clean 
