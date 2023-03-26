GTEST_DIR = /home/jeongmingyeong/OOP_22/lab13/googletest/googletest
CPPFLAGS += -isystem $(GTEST_DIR)/include
CXXFLAGS += -pthread

GTEST_HEADERS = $(GTEST_DIR)/include/gtest/*.h \
				$(GTEST_DIR)/include/gtest/internal/*.h

GTEST_SRCS_ = $(GTEST_DIR)/src/*.cc $(GTEST_DIR)/src/*.h $(GTEST_HEADERS)

all : main

clean : 
	rm -f gtest.a gtest_main.a *o main class_info_test class_test student_test

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

main : main.cc class_info.o class.o grade.h student.o $(GTEST_HEADERS)
	g++ --std=c++17 main.cc class_info.o class.o student.o -o $@

class_info.o : class_info.cc	
	g++ --std=c++17 -c class_info.cc -o $@

class.o : class.cc	
	g++ --std=c++17 -c class.cc -o $@

student.o : student.cc	
	g++ --std=c++17 -c student.cc -o $@

class_test.o : class_test.cc $(GTEST_HEADERS)
	g++ $(CPPFLAGS) $(CXXFLAGS) --std=c++17 -c class_test.cc -o $@

student_test.o : student_test.cc $(GTEST_HEADERS)
	g++ $(CPPFLAGS) $(CXXFLAGS) --std=c++17 -c student_test.cc -o $@

class_info_test.o : class_info_test.cc $(GTEST_HEADERS)
	g++ $(CPPFLAGS) $(CXXFLAGS) --std=c++17 -c class_info_test.cc -o $@

class_test : class_test.o class_info.o class.o grade.h student.o gtest_main.a
	g++ $(CPPFLAGS) $(CXXFLAGS) --std=c++17 $^ -o $@

student_test : student_test.o class_info.o class.o grade.h student.o gtest_main.a
	g++ $(CPPFLAGS) $(CXXFLAGS) --std=c++17 $^ -o $@

class_info_test : class_info_test.o class_info.o class.o grade.h student.o gtest_main.a
	g++ $(CPPFLAGS) $(CXXFLAGS) --std=c++17 $^ -o $@

.PHONY : all