CC = arm-linux-gcc
CFLAGS = -O1 -Wall -g -fPIC
CPPFLAGS = 
LDFLAGS = -O1
LIBS = -lnsl -lpthread
OBJS = telossource.o sfsource.o tinyrely.o teloscomm.o tinystream.o
SFAOBJS = telossource.o sfsource.o teloscomm.o
LIBNAME = sfaccess

ARMCC = arm-linux-gcc
ARMCFLAGS =  -O1 -Wall -g -fPIC 
ARMCPPFLAGS = 
ARMLDFLAGS = -O1
ARMLIBS = -lnsl -lpthread
ARMOBJS = telossource-arm.o sfsource-arm.o tinyrely-arm.o teloscomm-arm.o tinystream-arm.o
ARMSFAOBJS = telossource-arm.o sfsource-arm.o teloscomm-arm.o
ARMLIBNAME = sfaccess

all: sfaccess ttr lib${LIBNAME}



install : lib${LIBNAME}
	cp -f lib${LIBNAME}.so.1.0.1 /usr/local/lib/.
	ldconfig
	ln -f -s /usr/local/lib/lib${LIBNAME}.so.1 /usr/local/lib/lib${LIBNAME}.so
	if ! [ -d '/usr/local/include/flux' ] ; then mkdir /usr/local/include/flux; fi
	cp -f *.h /usr/local/include/flux/.

lib${LIBNAME} : ${OBJS}
	${CC} -shared -Wl,-soname,$@.so.1 -o $@.so.1.0.1 ${OBJS} -lc

ttr : testtinyrely.c ${OBJS}
	${CC} ${LDFLAGS} -o $@ testtinyrely.c ${OBJS} ${LIBS}

sfaccess : sfaccess.c ${SFAOBJS}
	${CC} ${LDFLAGS} -o $@ sfaccess.c ${SFAOBJS} ${LIBS}

Semaphore.o : Semaphore.h Semaphore.c
	${CC} ${CPPFLAGS} ${CFLAGS} -c Semaphore.c

tinystream.o : tinystream.c tinystream.h tinyrely.o
	${CC} ${CFLAGS} -c tinystream.c

tinyrely.o : tinyrely.c tinyrely.h telossource.o teloscomm.o
	${CC} ${CFLAGS} -c tinyrely.c

teloscomm.o : teloscomm.h teloscomm.c
	${CC} ${CFLAGS} -c teloscomm.c

telossource.o : telossource.h telossource.c teloscomm.o
	${CC} ${CFLAGS} -c telossource.c

sfsource.o : sfsource.h sfsource.c
	${CC} ${CFLAGS} -c sfsource.c






clean:
	rm *.o
	rm sfaccess
	rm ttr

