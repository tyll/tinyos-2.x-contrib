CC = arm-linux-gcc
CFLAGS =  -I/usr/local/arm/3.4.1/include -Isfaccess -fPIC
CPPFLAGS = 
LDFLAGS = 
LIBS = -lnsl -lpthread
OBJS = rt_intercomm.o rt_handler.o rt_marshall.o


all: rt_main.o ${OBJS}

rt_main.o : rt_main.c ${OBJS}
	cd sfaccess; make; cd ..
	cp sfaccess/*.o .
	${CC} ${CFLAGS} -c rt_main.c

rt_intercomm.o : rt_intercomm.h rt_intercomm.c rt_marshall.o
	${CC} ${CFLAGS} -c rt_intercomm.c

rt_handler.o : rt_handler.h rt_handler.c
	${CC} ${CFLAGS} -c rt_handler.c
	
rt_marshall.o : rt_marshall.h rt_marshall.c
	${CC} ${CFLAGS} -c rt_marshall.c

clean:
	
	cd sfaccess; make clean; cd ..
	rm *.o