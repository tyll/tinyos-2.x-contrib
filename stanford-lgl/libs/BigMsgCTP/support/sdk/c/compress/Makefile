CFLAGS += -g -fbounds-checking -I../ -I./compress -Wall
all:
	gcc $(CFLAGS) dctApp.c jpegTOS.c jpegUncompress.c huffmanUncompress.c -o dctApp.exe
	gcc $(CFLAGS) idctApp.c jpegUncompress.c huffmanUncompress.c -o idctApp.exe
	#gcc quantize.c runlengthEncode.c runlengthDecode.c jpeg.c dct.c dctApp.c -o dctApp.exe $(CFLAGS)
	#gcc $(CFLAGS) idct.c runlengthDecode.c idctApp.c -o idctApp.exe