ALL_CODES=huffman_codes.h huffman_whole_diff_codes.h \
	  huffman_diff_codes.h huffman_whole_codes.h

PROGRAMS=generate_whole_diff_codes generate_diff_codes generate_whole_codes \
	 generate_codes 

ALGORITHMS=huffman huffman_whole_diff huffman_diff huffman_whole

BACKSTEPDIR=..

ifdef CODEBASE
HUFFMAN=$(CODEBASE)
HUFFMAN_DIFF=$(CODEBASE)
HUFFMAN_WHOLE_DIFF=$(CODEBASE)
HUFFMAN_WHOLE=$(CODEBASE)
else
HUFFMAN=4D0B.csv
HUFFMAN_DIFF=4D0B.csv
HUFFMAN_WHOLE_DIFF=4D0B.csv
HUFFMAN_WHOLE=4EBF.csv
endif

all: $(ALL_CODES) $(ALGORITHMS:=_comp.so) $(ALGORITHMS:=_decomp.so) test huffman_hex_dump

test: test.c huffman_codes.h
	gcc -g -o $@ $< -Wall

huffman_comp.lo: huffman_comp.c huffman_codes.h
	gcc -g -o $@ -c $< -fPIC -Wall -DCODESET=\"huffman_codes.h\"

huffman_decomp.lo: huffman_decomp.c huffman_codes.h
	gcc -g -o $@ -c $< -fPIC -Wall -DCODESET=\"huffman_codes.h\"

huffman_whole_diff_comp.lo: huffman_comp.c huffman_whole_diff_codes.h
	gcc -g -o $@ -c $< -fPIC -Wall -DCODESET=\"huffman_whole_diff_codes.h\"

huffman_whole_diff_decomp.lo: huffman_decomp.c huffman_whole_diff_codes.h
	gcc -g -o $@ -c $< -fPIC -Wall -DCODESET=\"huffman_whole_diff_codes.h\"

huffman_whole_comp.lo: huffman_comp.c huffman_whole_codes.h
	gcc -g -o $@ -c $< -fPIC -Wall -DCODESET=\"huffman_whole_codes.h\"

huffman_whole_decomp.lo: huffman_decomp.c huffman_whole_codes.h
	gcc -g -o $@ -c $< -fPIC -Wall -DCODESET=\"huffman_whole_codes.h\"

huffman_diff_comp.lo: huffman_comp.c huffman_diff_codes.h
	gcc -g -o $@ -c $< -fPIC -Wall -DCODESET=\"huffman_diff_codes.h\"

huffman_diff_decomp.lo: huffman_decomp.c huffman_diff_codes.h
	gcc -g -o $@ -c $< -fPIC -Wall -DCODESET=\"huffman_diff_codes.h\"

huffman_codes.h: generate_codes
	./$< $(HUFFMAN) > $@

huffman_whole_diff_codes.h: generate_whole_diff_codes
	./$< $(HUFFMAN_WHOLE_DIFF) > $@

huffman_diff_codes.h: generate_diff_codes
	./$< $(HUFFMAN_DIFF) > $@

huffman_whole_codes.h: generate_whole_codes
	./$< $(HUFFMAN_WHOLE) > $@

huffman_hex_dump: huffman_hex_dump.cc
	g++ -Wall -O3 $^ -o $@ -D_GNU_SOURCE -g $(DEBUG) \

generate_whole_diff_codes: generate_codes.cc
	g++ -Wall -O3 $^ -o $@ -D_GNU_SOURCE -g $(DEBUG) \
		-DHUFFMAN_WHOLE_SYMBOLS -DHUFFMAN_DIFFERENCE

generate_diff_codes: generate_codes.cc
	g++ -Wall -O3 $^ -o $@ -D_GNU_SOURCE -g $(DEBUG) \
		-DHUFFMAN_DIFFERENCE

generate_whole_codes: generate_codes.cc
	g++ -Wall -O3 $^ -o $@ -D_GNU_SOURCE -g $(DEBUG) \
		-DHUFFMAN_WHOLE_SYMBOLS

generate_codes: generate_codes.cc
	g++ -Wall -O3 $^ -o $@ -D_GNU_SOURCE -g $(DEBUG)

%: %.cc
	g++ -Wall -O3 $^ -o $@ -D_GNU_SOURCE -g $(DEBUG)

-include ../Makefile.rules
CLEAN+=$(PROGRAMS) $(ALL_CODES)
