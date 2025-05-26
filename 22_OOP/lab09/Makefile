GTEST_DIR = /home/jeongmingyeong/OOP_22/lab09/googletest/googletest
CPPFLAGS += -isystem $(GTEST_DIR)/include
CXXFLAGS += -pthread

GTEST_HEADERS = $(GTEST_DIR)/include/gtest/*.h \
				$(GTEST_DIR)/include/gtest/internal/*.h

GTEST_SRCS_ = $(GTEST_DIR)/src/*.cc $(GTEST_DIR)/src/*.h $(GTEST_HEADERS)

all : main

clean : 
	rm -f gtest.a gtest_main.a *o main test

gtest-all.o : $(GTEST_SRCS_)
	g++ $(CPPFLAGS) -I$(GTEST_DIR) $(CXXFLAGS) -c\
		$(GTEST_DIR)/src/gtest-all.cc

gtest_main.o : $(GTEST_SRCS_)
	g++ $(CPPFLAGS) -I$(GTEST_DIR) $(CXXFLAGS) -c\
		$(GTEST_DIR)/src/gtest_main.cc

gtest.a : gtest-all.o
	$(AR) $(ARFLAGS) $@ $^

gtest_main.a : gtest-all.o gtest_main.o
	$(AR) $(ARFLAGS) $@ $^ 

main : main.cc car_builder.o car_parts_factory.o car.o door.o  hyundai_parts_factory.o kia_parts_factory.o part.o roof.o wheel.o $(GTEST_HEADERS)
	g++ --std=c++17 main.cc car_builder.o car_parts_factory.o car.o door.o  hyundai_parts_factory.o kia_parts_factory.o part.o roof.o wheel.o -o $@

car_builder.o : car_builder.cc	
	g++ --std=c++17 -c car_builder.cc -o $@

car_parts_factory.o : car_parts_factory.cc	
	g++ --std=c++17 -c car_parts_factory.cc -o $@

car.o : car.cc	
	g++ --std=c++17 -c car.cc -o $@

door.o : door.cc	
	g++ --std=c++17 -c door.cc -o $@

hyundai_parts_factory.o : hyundai_parts_factory.cc	
	g++ --std=c++17 -c hyundai_parts_factory.cc -o $@

kia_parts_factory.o : kia_parts_factory.cc	
	g++ --std=c++17 -c kia_parts_factory.cc -o $@

part.o : part.cc	
	g++ --std=c++17 -c part.cc -o $@

roof.o : roof.cc	
	g++ --std=c++17 -c roof.cc -o $@

wheel.o : wheel.cc	
	g++ --std=c++17 -c wheel.cc -o $@

car_factory_test.o : car_factory_test.cc $(GTEST_HEADERS)
	g++ $(CPPFLAGS) $(CXXFLAGS) --std=c++17 -c car_factory_test.cc -o $@

test : car_factory_test.o car_builder.o car_parts_factory.o car.o door.o  hyundai_parts_factory.o kia_parts_factory.o part.o roof.o wheel.o gtest_main.a
	g++ $(CPPFLAGS) $(CXXFLAGS) --std=c++17 $^ -o $@

.PHONY : all