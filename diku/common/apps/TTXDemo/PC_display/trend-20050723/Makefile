## Makefile for trend
## Copyright(c) 2003-2005 by wave++ "Yuri D'Elia" <wavexx@users.sf.net>
## Distributed under GNU LGPL WITHOUT ANY WARRANTY.

#if $(CXX) == "CC"
# pmake (assume Mipspro)
CPPFLAGS = -I/usr/freeware/include -I/usr/local/include
LDFLAGS = -FE:template_in_elf_section -quiet_prelink
LDADD = -lpthread -L/usr/freeware/lib32 -L/usr/local/lib32 -lm -lglut -lGL -lGLU -lX11 -lXmu
#else
ifeq ($(shell uname), Darwin)
# OS X (_nice_ framework system, I admit)
CPPFLAGS = -F GLUT -F OpenGL
LDFLAGS =
LDADD = -framework GLUT -framework OpenGL
else
# classic posix
CPPFLAGS = -I/usr/local/include
LDFLAGS = -L/usr/local/lib
LDADD = -lglut -lGL -lGLU
endif
#endif


# Config
TREND_OBJECTS = trend.o color.o
TARGETS = trend


# Rules
.SUFFIXES: .cc .o
.PHONY: all clean

.cc.o:
	$(CXX) $(CPPFLAGS) $(CXXFLAGS) -c -o $@ $<


# Targets
all: $(TARGETS)

trend: $(TREND_OBJECTS)
	$(CXX) $(CXXFLAGS) $(LDFLAGS) -o $@ $(TREND_OBJECTS) $(LDADD)

clean:
	rm -rf *.o core ii_files $(TARGETS)


# Dependencies
trend.o: defaults.hh color.hh rr.hh timer.hh gl.hh
color.o: color.hh gl.hh
