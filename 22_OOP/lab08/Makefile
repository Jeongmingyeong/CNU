GTEST_DIR = /Users/jeongmingyeong/ood23/googletest/googletest
CPPFLAGS += -isystem $(GTEST_DIR)/include
CXXFLAGS += -pthread

GTEST_HEADERS = $(GTEST_DIR)/include/gtest/*.h \
				$(GTEST_DIR)/include/gtest/internal/*.h

GTEST_SRCS_ = $(GTEST_DIR)/src/*.cc $(GTEST_DIR)/src/*.h $(GTEST_HEADERS)

all : main

clean : 
	rm -f gtest.a gtest_main.a *o main test

gtest-all.o : $(GTEST_SRCS_)
	clang++ $(CPPFLAGS) -I$(GTEST_DIR) $(CXXFLAGS) -c\
		$(GTEST_DIR)/src/gtest-all.cc

gtest_main.o : $(GTEST_SRCS_)
	clang++ $(CPPFLAGS) -I$(GTEST_DIR) $(CXXFLAGS) -c\
		$(GTEST_DIR)/src/gtest_main.cc

gtest.a : gtest-all.o
	$(AR) $(ARFLAGS) $@ $^

gtest_main.a : gtest-all.o gtest_main.o
	$(AR) $(ARFLAGS) $@ $^ 

main : main.cc node.o tree_util.o int_node.o string_node.o $(GTEST_HEADERS)
	clang++ --std=c++17 main.cc node.o tree_util.o int_node.o string_node.o -o $@

node.o : node.cc	
	clang++ --std=c++17 -c node.cc -o $@

tree_util.o : tree_util.cc	
	clang++ --std=c++17 -c tree_util.cc -o $@

int_node.o : int_node.cc	
	clang++ --std=c++17 -c int_node.cc -o $@

string_node.o : string_node.cc	
	clang++ --std=c++17 -c string_node.cc -o $@

treeutil_test.o : treeutil_test.cc $(GTEST_HEADERS)
	clang++ $(CPPFLAGS) $(CXXFLAGS) --std=c++17 -c treeutil_test.cc -o $@

test : treeutil_test.o node.o tree_util.o int_node.o string_node.o gtest_main.a
	clang++ $(CPPFLAGS) $(CXXFLAGS) --std=c++17 $^ -o $@

.PHONY : all
