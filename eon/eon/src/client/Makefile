CC = gcc
CFLAGS =  -I./sfaccess -fPIC
CPPFLAGS = 
LDFLAGS = 
LIBS = -lnsl -lpthread
OBJS = 


all: client

client : client.c  sfaccess
	cd sfaccess; make; cd ..
	cp sfaccess/*.o .
	${CC} ${CFLAGS} -o client client.c *.o ${LIBS}


clean:
	cd sfaccess; make clean; cd ..
	rm *.o
	rm client
