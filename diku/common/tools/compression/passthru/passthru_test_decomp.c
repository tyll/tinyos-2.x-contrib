#include <inttypes.h>
#include <errno.h>
#include <stdio.h>
#include <string.h>
#include "../buffer.h"

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

uint16_t get_sample()
{
  uint16_t tmp = 0;
  tmp |= read_bits(8);
  tmp |= (uint16_t)read_bits(8) << 8;
  return tmp;
}

int decompress_sample(int16_t *digi_x, int16_t *digi_y, 
		      int16_t *digi_z, uint16_t *analog_x,
		      uint16_t *analog_y)
{
  static int first = 1;

  if (first || bits_left() < 3 * 12) {
    first = 0;
    if (fread(membuffer, MEMBUFSIZE, 1, stdin) != 1) {
      fprintf(stderr, "Error reading from stdin: %s\n", 
	      strerror(errno));
      return 1;
    }

    read_count = 0;
    buffer = 0;
    data = membuffer;
  }

  *digi_x = get_sample();
  *digi_y = get_sample();
  *digi_z = get_sample();

  return 0;
}


