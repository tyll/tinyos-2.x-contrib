#ifndef __AVR_ATmega128__
#define prog_uint8_t uint8_t
#endif

#define DECOMPRESSOR
#include <inttypes.h>
#include <errno.h>
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include "../buffer.h"

#include CODESET

uint8_t membuffer[MEMBUFSIZE];
uint8_t *data;
uint8_t read_count;
uint16_t buffer;

static uint8_t read_bits(uint8_t len)
{
  uint8_t res;
  // Fill the buffer
  while (read_count < len) {
    buffer <<= 8;
    buffer |= *data++;
    read_count += 8;
  }
  
  res = (buffer >> (read_count - len)) & ((1 << len) - 1);
  read_count -= len;
  buffer &= (1 << read_count) - 1;
  return res;
}

uint16_t bits_left()
{
  uint16_t res = MEMBUFSIZE - (data - membuffer); // Amount of unread data;
  
  /*
    printf("Length: %d, data: %p, data_start: %p, diff: %d\n",
    length, data, data_start, data - data_start);
  */
  
  res *= 8;
  res += read_count; // Bits read, but not outputted yet.
  
  //    printf("Bits left: %d\n", res);
  
  return res;
}

void fill_buffer()
{
  if (fread(membuffer, MEMBUFSIZE, 1, stdin) != 1) {
    fprintf(stderr, "Error reading from stdin: %s\n", 
	    strerror(errno));
    exit(1);
  }
  
  read_count = 0;
  buffer = 0;
  data = membuffer;
}

int16_t get_sample()
{
  struct huffman_node_t *cur_node = huffman_root;

  while (cur_node->type == NT_Node) {
    uint8_t tmp;

    if (bits_left() == 0)
      fill_buffer();
    
    tmp = read_bits(1);

    //    fprintf(stderr, "%d", tmp);

    cur_node = tmp ? cur_node->left : cur_node->right;
  }

  //  fprintf(stderr, " = sample with value: %d\n", cur_node->value);

  return cur_node->value;
}

int decompress_sample(int16_t *digi_x, int16_t *digi_y, 
		      int16_t *digi_z, uint16_t *analog_x,
		      uint16_t *analog_y)
{
  static int first = 1;
  static int16_t last_vals[3];
  int i;

  if (first) {
    fill_buffer();
    first = 0;

#ifdef HUFFMAN_DIFFERENCE
    for (i = 0; i < 3; i++) {
      last_vals[i] = 0;
      last_vals[i] |= (uint16_t)read_bits(4) << 8;
      last_vals[i] |= read_bits(8);
      if (last_vals[i] & 0x0800)
	last_vals[i] |= 0xF000;

      //      fprintf(stderr, "Sample is %d\n", last_vals[i]);
    }

    *digi_x = last_vals[0];
    *digi_y = last_vals[1];
    *digi_z = last_vals[2];

    return 0;
#endif
  } 

  for (i = 0; i < 3; i++) {
#ifdef HUFFMAN_WHOLE_SYMBOLS
    int16_t tmp = get_sample();
#else
    int16_t tmp = get_sample() & 0xFF;
    tmp |= (get_sample() << 8) & 0xFF00;
#endif

#ifdef HUFFMAN_DIFFERENCE
# ifdef HUFFMAN_WHOLE_SYMBOLS
    last_vals[i] = ((last_vals[i] & 0xFFF) + tmp - 4096) & 0xFFF;
		if (last_vals[i] & 0x800)
			last_vals[i] |= 0xF000;
# else
    last_vals[i] += tmp - 4096;
# endif
    //      fprintf(stderr, "Read sample is %d, last_val is now %d\n", 
    //	      tmp, last_vals[i]);
#else
# ifdef HUFFMAN_WHOLE_SYMBOLS
    last_vals[i] = tmp - 2048;
# else
    last_vals[i] = tmp;
# endif
#endif
  }

  *digi_x = last_vals[0];
  *digi_y = last_vals[1];
  *digi_z = last_vals[2];

  return 0;
}


