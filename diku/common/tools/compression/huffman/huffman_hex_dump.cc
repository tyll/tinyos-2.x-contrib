#include <stdio.h>
#include <inttypes.h>

#define prog_uint8_t uint8_t
#include "huffman_codes.h"

int main(int argc, char* argv)
{
	for (size_t i = 0; i < sizeof(huffman_code); i++) {
		if (i % 16 == 15) {
			printf("\n");
		}

		printf(" %02X", huffman_code[i]);
	}
}
