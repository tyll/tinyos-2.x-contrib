/**************************************************************************
 *
 * simple_comp.c
 *
 * This file is licensed under the GNU GPL.
 *
 * (C) 2005, Klaus S. Madsen <klaussm@diku.dk>
 *
 */
#include "../compressor.h"
#include "../buffer.h"
#include <string.h>

#define SHORT_BITS 4
#define SHORT_MASK ((1 << (SHORT_BITS - 1)) - 1)

void write_measurement(int16_t diff, int16_t val)
{
  //  fprintf(stderr, "Difference is: %d\n", diff);
  if (diff <= SHORT_MASK && diff >= -(SHORT_MASK + 1)) {
    //    fprintf(stderr, "Writing short\n");
    write_bits(1, 1);
    write_bits(diff & ((1 << SHORT_BITS) - 1), SHORT_BITS);
  } else {
    write_bits(0, 1);
    write_bits((val >> 8) & 0x0F, 4);
    write_bits(val & 0xFF, 8);
  }
}

int first = 1;

void compress_sample(int16_t digi_x, int16_t digi_y, int16_t digi_z,
		     uint16_t ana_x, uint16_t ana_y)
{
  static int last_val[3];

  if (first) {
    reset_buffer();
    first = 0;

    write_bits((digi_x >> 8) & 0x0F, 4);
    write_bits(digi_x & 0xFF, 8);
    write_bits((digi_y >> 8) & 0x0F, 4);
    write_bits(digi_y & 0xFF, 8);
    write_bits((digi_z >> 8) & 0x0F, 4);
    write_bits(digi_z & 0xFF, 8);

    last_val[0] = digi_x;
    last_val[1] = digi_y;
    last_val[2] = digi_z;

    return;
  }

  if (bits_left() < 3 * 13) {
    handle_full_buffer(get_buffer(), bits_left()/(uint8_t)8);
    reset_buffer();
  }

  write_measurement(digi_x - last_val[0], digi_x);
  write_measurement(digi_y - last_val[1], digi_y);
  write_measurement(digi_z - last_val[2], digi_z);

  last_val[0] = digi_x;
  last_val[1] = digi_y;
  last_val[2] = digi_z;
} 

void flush()
{
  uint8_t *tmp = get_unwritten();
  memset(tmp, 0, MEMBUFSIZE - (tmp - get_buffer()));
  handle_full_buffer(get_buffer(), bits_left()/(uint8_t)8);
  first = 1;
}
