CSVFILES=$(wildcard *.csv)

NAMES=$(CSVFILES:.csv=)

ALGORITHMS=passthru simple huffman huffman_diff \
	   huffman_whole huffman_whole_diff lz77 lz77_diff 

LOG_FILES:=$(foreach csv,$(NAMES),$(foreach alg,$(ALGORITHMS),$(csv).$(alg).log))

all: $(LOG_FILES)

%.passthru.log: %.csv
	./change_alg.sh passthru
	../node-comm $< | tee $@

%.simple.log: %.csv
	./change_alg.sh simple
	../node-comm $< | tee $@

%.huffman.log: %.csv
	./change_alg.sh huffman
	../node-comm $< | tee $@

%.huffman_diff.log: %.csv
	./change_alg.sh huffman_diff
	../node-comm $< | tee $@

%.huffman_whole.log: %.csv
	./change_alg.sh huffman_whole
	../node-comm $< | tee $@

%.huffman_whole_diff.log: %.csv
	./change_alg.sh huffman_whole_diff
	../node-comm $< | tee $@

%.lz77.log: %.csv
	./change_alg.sh lz77
	../node-comm $< | tee $@

%.lz77_diff.log: %.csv
	./change_alg.sh lz77_diff
	../node-comm $< | tee $@

clean:
	rm -f *.log
