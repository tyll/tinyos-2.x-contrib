QUANTOLOGGER_SRC=QuantoLogger.c ue9.c
QUANTOLOGGER_OBJ=$(QUANTOLOGGER_SRC:.c=.o)

CFLAGS=-Wall -g
CC=gcc $(CFLAGS)
LDFLAGS=
LIBS=-lm

all: QuantoLogger

QuantoLogger: $(QUANTOLOGGER_OBJ)
	$(CC) -o QuantoLogger $(QUANTOLOGGER_OBJ) $(LDFLAGS) $(LIBS)

clean: 
	rm -f *.o QuantoLogger

#gcc -Wall -g -Wall -g -c -o QuantoLogger.o QuantoLogger.c 

