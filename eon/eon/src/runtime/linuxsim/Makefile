CC = gcc
CFLAGS =  -fPIC
CPPFLAGS = 
LDFLAGS = 
LIBS = -lnsl -lpthread
OBJS = rt_handler.o energymgr.o simworld.o


all: rt_main.o ${OBJS}

rt_main.o : rt_main.c ${OBJS}
	${CC} ${CFLAGS} -c rt_main.c

rt_handler.o : rt_handler.h rt_handler.c
	${CC} ${CFLAGS} -c rt_handler.c
	
energymgr.o : energymgr.c energymgr.h evaluator.c
	${CC} ${CFLAGS} -c energymgr.c evaluator.c 
	
clean:
	
	rm *.o