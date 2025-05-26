TARGET = simple_calculator
OBJECTS = main.o add.o sub.o mul.o div.o
CC = gcc
CFLAGS = -Wall
LDFLAGS = -Wall

all : $(TARGET) # create final file

%.o : %.c
	$(CC) $(CFLAGS) -c $<

$(TARGET) : $(OBJECTS)
	$(CC) $(LDFLAGS) -o $(TARGET) $(OBJECTS)

clean :
	rm -f $(OBJECTS) $(TARGET)
