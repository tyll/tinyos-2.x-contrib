#include <inttypes.h>
#include <errno.h>
#include <stdio.h>
#include <string.h>
#include "../buffer.h"
#include <stdlib.h>

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

#define SHORT_BITS 4

int16_t read_value()
{
  int16_t res = 0;
  res |= read_bits(4) << 8;
  res |= read_bits(8);
  if (res & 0x0800)
    res |= 0xF000;
  return res;
}

int16_t get_value(int16_t old_value)
{
  uint8_t tmp = read_bits(1);
  int16_t res = 0;

  if (tmp) {
    //    fprintf(stderr, "Reading short\n");
    res = read_bits(SHORT_BITS);
    if (res & (1 << (SHORT_BITS - 1))) {
      res |= ~((1 << SHORT_BITS) - 1);
    }
    res += old_value;
  } else {
    res = read_value();
  }

  //  fprintf(stderr, "Returning %d\n", res);

  return res;
}

int decompress_sample(int16_t *digi_x, int16_t *digi_y, 
		      int16_t *digi_z, uint16_t *analog_x,
		      uint16_t *analog_y)
{
  static int first = 1;
  static int16_t last_vals[3];

  if (first) {
    first = 0;
    fill_buffer();

    *digi_x = last_vals[0] = read_value();
    *digi_y = last_vals[1] = read_value();
    *digi_z = last_vals[2] = read_value();
  } else {
    int i; 

    if (bits_left() < 3 * 13) {
      fill_buffer();
    }

    for (i = 0; i < 3; i++) {
      last_vals[i] = get_value(last_vals[i]);
    }

    *digi_x = last_vals[0];
    *digi_y = last_vals[1];
    *digi_z = last_vals[2];
  }

  return 0;
}


