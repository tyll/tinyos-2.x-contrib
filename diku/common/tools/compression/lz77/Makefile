ALGORITHMS=lz77 lz77_diff
BACKSTEPDIR=..

#DEBUG=-DDEBUG

all: $(ALGORITHMS:=_comp.so) $(ALGORITHMS:=_decomp.so)

lz77_diff_comp.lo: lz77_comp.c
	gcc -g -o $@ -c $^ -fPIC -Wall $(DEBUG) -DDIFFERENCE

lz77_diff_decomp.lo: lz77_decomp.c
	gcc -g -o $@ -c $^ -fPIC -Wall $(DEBUG) -DDIFFERENCE

include ../Makefile.rules

