OBJS = util.o main.o

util.o : util.h util.cc
	g++ -c util.cc

main.o : main.cc util.h
	g++ -c main.cc

main : util.o main.o
	g++ --std=c++17 util.o main.o -o main

clean:
	rm -rf $(OBJS) main