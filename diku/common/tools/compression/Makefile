NO_NODE_POWER=1

all: compress decompress node-comm frequency average
	$(MAKE) -C passthru
##	$(MAKE) -C huffman
	$(MAKE) -C lz77
	$(MAKE) -C simple

CLEAN+=compress decompress

ifndef NO_NODE_POWER
INCLUDE+=-I../daq
endif

compress.o: compress.cc

average.o: average.cc

decompress.o: decompress.cc

node-comm.o: node-comm.cc

node-comm-power.o: node-comm-power.cc

frequency.o: frequency.cc

ifndef NO_NODE_POWER
node-comm: node-comm.o node-comm-power.o
else
node-comm: node-comm.o
endif
	g++ -g -rdynamic -o $@ $^  -lpthread 

%: %.o
	g++ -g -O3 -rdynamic -o $@ $^ -ldl -lm

%.o: %.cc
	g++ -g -O3 -o $@ -c $^ -Wall $(DEBUG) $(INCLUDE)

clean:
	rm -rf *.o compress decompress node-comm *~
	$(MAKE) -C passthru clean
	$(MAKE) -C huffman clean
	$(MAKE) -C lz77 clean
	$(MAKE) -C simple clean

