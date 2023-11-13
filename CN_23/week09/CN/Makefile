CC= clang++
STDFLAG= -std=c++11
THD = -lpthread

all: rts_sender rts_receiver rts_client rts_server rts_server_th

rts_sender: rts_sender.cc
	$(CC) $(STDFLAG) $(THD)  $^ -o $@

rts_receiver: rts_receiver.cc
	$(CC) $(STDFLAG) $(THD) $^ -o $@

rts_client: rts_client.cc
	$(CC) $(STDFLAG) $(THD) $^ -o $@

rts_server: rts_server.cc
	$(CC) $(STDFLAG) $(THD) $^ -o $@

rts_server_th: rts_server_th.cc
	$(CC) $(STDFLAG) $(THD) $^ -o $@

clean: 
	rm -rf rts_sender rts_receiver rts_client rts_server rts_server_th

.PHONY: all clean 
