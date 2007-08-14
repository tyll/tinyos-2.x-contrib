CSVFILES=$(wildcard *.csv)

NAMES=$(CSVFILES:.csv=)

TEST=4DBF

ALGORITHMS=huffman huffman_diff \
	   huffman_whole huffman_whole_diff

COMPRESSED_FILES:=$(foreach csv,$(NAMES),$(foreach alg,$(ALGORITHMS),$(csv).$(alg).$(TEST).out))

.PHONY: all

all: $(COMPRESSED_FILES)

%.huffman.$(TEST).out: %.csv
	../compress ../huffman $< > $@

%.huffman_diff.$(TEST).out: %.csv
	../compress ../huffman_diff $< > $@

%.huffman_whole.$(TEST).out: %.csv
	../compress ../huffman_whole $< > $@

%.huffman_whole_diff.$(TEST).out: %.csv
	../compress ../huffman_whole_diff $< > $@
