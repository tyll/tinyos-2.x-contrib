PROGRAMS=sf sflisten sfcomm sfcollect

all: $(PROGRAMS)

sf: sf.c serialsource.c sfsource.c platform.c platform.h serialsource.h sfsource.h sfcomm.c
	gcc -O1 -Wall -g -o $@ sf.c serialsource.c sfsource.c platform.c

# For ARM
asf: sf.c serialsource.c sfsource.c platform.c platform.h serialsource.h sfsource.h
	arm-linux-gcc -O1 -Wall -g -o $@ sf.c serialsource.c sfsource.c platform.c

sflisten: sflisten.c sfsource.c platform.c platform.h sfsource.h
	gcc -O1 -Wall -g -o $@ sflisten.c sfsource.c platform.c

sfcomm: sfcomm.c sfsource.c platform.c platform.h sfsource.h
	gcc -O1 -Wall -g -lpthread  -o $@ sfcomm.c sfsource.c platform.c

sfcollect: sfcollect.c sfsource.c platform.c platform.h sfsource.h
	gcc -O1 -Wall -g -lpthread  -o $@ sfcollect.c sfsource.c platform.c

sfforce: sfforce.c sfsource.c platform.c platform.h sfsource.h
	gcc -O1 -Wall -g -lpthread  -o $@ sfforce.c sfsource.c platform.c

sf_lo_radio: sf_lo_radio.c sfsource.c platform.c platform.h sfsource.h
	gcc -O1 -Wall -g -lpthread  -o $@ sf_lo_radio.c sfsource.c platform.c

sf_hi_radio: sf_hi_radio.c sfsource.c platform.c platform.h sfsource.h
	gcc -O1 -Wall -g -lpthread  -o $@ sf_hi_radio.c sfsource.c platform.c

clean:
	rm -f $(PROGRAMS) asf

