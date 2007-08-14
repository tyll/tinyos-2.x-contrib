CSVFILES=$(wildcard *.csv)

NAMES=$(CSVFILES:.csv=)

ALGORITHMS=passthru passthru_test simple lz77 lz77_diff huffman huffman_diff \
	   huffman_whole huffman_whole_diff

COMPRESSED_FILES:=$(foreach csv,$(NAMES),$(foreach alg,$(ALGORITHMS),$(csv).$(alg).out))

.PHONY: all

all: $(COMPRESSED_FILES)

csv-link:
	ln -s ../../linux-bluez/*.accel.csv .

%.passthru.out: %.csv
	../compress ../passthru $< > $@

%.passthru_test.out: %.csv
	../compress ../passthru_test $< > $@

%.simple.out: %.csv
	../compress ../simple $< > $@

%.lz77.out: %.csv
	../compress ../lz77 $< > $@

%.lz77_diff.out: %.csv
	../compress ../lz77_diff $< > $@

%.huffman.out: %.csv
	../compress ../huffman $< > $@

%.huffman_diff.out: %.csv
	../compress ../huffman_diff $< > $@

%.huffman_whole.out: %.csv
	../compress ../huffman_whole $< > $@

%.huffman_whole_diff.out: %.csv
	../compress ../huffman_whole_diff $< > $@
