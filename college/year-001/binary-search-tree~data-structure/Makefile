# -*- Makefile -*-
# Make file to add all the dependacies to 
# the student Binary Search Tree algorthm Class Assignement

#   Author : Tatiana Zihindula
#   Date : 28 April 2017

EXE_NAME= k
CC= gcc
OPTION= -c

#all: main clean

# main depends on all the objects files
main: main.o insert.o search.o util_functs.o 
	$(CC) main.o insert.o search.o util_functs.o -o $(EXE_NAME)

# main object depends on main.c and student.h
main-o: main.c student.h
	$(CC) -c main.c 

# insert object depends on insert.c and student.h
insert.o: insert.c student.h
	$(CC) -c insert.c 

# search object depends on search.c and student.h
search.o: search.c student.h
	$(CC) -c search.c 

# util_functs object depends on util_functs.c and student.h
util_functs.o: util_functs.c student.h
	$(CC) -c util_functs.c 

# heap sumarry checking for memory management, depends on main 
valgrind: main
	valgrind --leak-check=full $(EXE_NAME) find Smith 

clean:
	rm -f *.o $(EXE_NAME)
