CC = gcc
CFLAGS = -O1 -Wall -g  -fPIC
CPPFLAGS = 
LDFLAGS = -O1
LIBS = -lnsl -lpthread -ldl
OBJS = simworld.o
LIBNAME = simworld



all:  lib${LIBNAME} testsw



install : lib${LIBNAME}
	cp -f lib${LIBNAME}.so.1.0.1 /usr/local/lib/.
	ldconfig
	ln -f -s /usr/local/lib/lib${LIBNAME}.so.1 /usr/local/lib/lib${LIBNAME}.so
	if ! [ -d '/usr/local/include/flux' ] ; then mkdir /usr/local/include/flux; fi
	cp -f *.h /usr/local/include/flux/.

lib${LIBNAME} : ${OBJS}
	${CC} -shared -Wl,-soname,$@.so.1 -o $@.so.1.0.1 ${OBJS} -lc

testsw : lib${LIBNAME}
	${CC} ${LDFLAGS}  -o $@ testsw.c simworld.o ${LIBS}
	
simworld.o : simworld.c simworld.h
	${CC} ${CFLAGS}  -c simworld.c 
	
#tinyrely.o : tinyrely.c tinyrely.h telossource.o teloscomm.o
#	${CC} ${CFLAGS} -c tinyrely.c


clean:
	rm *.o

