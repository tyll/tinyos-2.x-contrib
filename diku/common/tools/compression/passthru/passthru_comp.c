/**************************************************************************
 *
 * passthru_comp.c
 *
 * The passthru compression algorith. This will simply store the
 * results from the digital acceleromter as 3 times 12 bits.
 *
 * This file is licensed under the GNU GPL.
 *
 * (C) 2005, Klaus S. Madsen <klaussm@diku.dk>
 *
 */
#include "../compressor.h"
#include "../buffer.h"
#include <string.h>

int first = 1;

void compress_sample(int16_t digi_x, int16_t digi_y, int16_t digi_z,
		     uint16_t ana_x, uint16_t ana_y)
{
  if (first) {
    reset_buffer();
    first = 0;
  }

  if (bits_left() < 3 * 12) {
    handle_full_buffer(get_buffer(), bits_left()/(uint8_t)8);
    reset_buffer();
  }

  write_bits((digi_x >> 8) & 0x0F, 4);
  write_bits(digi_x & 0xFF, 8);
  write_bits((digi_y >> 8) & 0x0F, 4);
  write_bits(digi_y & 0xFF, 8);
  write_bits((digi_z >> 8) & 0x0F, 4);
  write_bits(digi_z & 0xFF, 8);
} 

void flush()
{
  uint8_t *tmp = get_unwritten();
  memset(tmp, 0, MEMBUFSIZE - (tmp - get_buffer()));
  handle_full_buffer(get_buffer(), bits_left()/(uint8_t)8);
  first = 1;
}
