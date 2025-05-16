#
# Makefile
# 

CC = gcc

# CAUTION: Always use '-pthread' when compiling POSIX threads-based
# applications, instead of linking with "-lpthread" directly.
CFLAGS = -Wall -O2 -pthread 

## Mandel Semaphores
mandel: mandel-lib.o mandel.o
	$(CC) $(CFLAGS) -o mandelSem mandel-lib.o mandel.o $(LIBS)

mandel-lib.o: mandel-lib.h mandel-lib.c
	$(CC) $(CFLAGS) -c -o mandel-lib.o mandel-lib.c $(LIBS)

mandel.o: mandelSem.c
	$(CC) $(CFLAGS) -c -o mandel.o mandelSem.c $(LIBS)

## Mandel Conditional Variables
mandel: mandel-lib.o mandel.o
	$(CC) $(CFLAGS) -o mandelCond mandel-lib.o mandel.o $(LIBS)

mandel-lib.o: mandel-lib.h mandel-lib.c
	$(CC) $(CFLAGS) -c -o mandel-lib.o mandel-lib.c $(LIBS)

mandel.o: mandelCond.c
	$(CC) $(CFLAGS) -c -o mandel.o mandelCond.c $(LIBS)

clean:
	rm -f *.s *.o pthread-test simplesync-{atomic,mutex} kgarten mandel mandelSem mandelCond 
