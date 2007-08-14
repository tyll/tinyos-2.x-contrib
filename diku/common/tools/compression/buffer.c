/**************************************************************************
 *
 * buffer.c
 *
 * An implementation of the most basic buffer manipulation functions,
 * needed for the compression algorithms.
 *
 * This file is licensed under the GNU GPL.
 *
 * (C) 2005, Klaus S. Madsen <klaussm@diku.dk>
 *
 */
#include "buffer.h"
#ifdef HAVE_ASSERT
# include <assert.h>
#else
# define assert(x) 
#endif

uint8_t membuffer[MEMBUFSIZE] __attribute((xdata));
uint8_t *buf_pos;
uint8_t write_bits_used;

void reset_buffer()
{
  buf_pos = membuffer;
  write_bits_used = 0;
  *buf_pos = 0;
}

uint8_t *get_unwritten()
{
  if (write_bits_used) {
    return buf_pos + 1;
  } else {
    return buf_pos;
  }
}

uint8_t *get_buffer()
{
  return membuffer;
}

uint16_t bits_left()
{
  uint16_t res = MEMBUFSIZE * 8; // Entire memory
  res -= (buf_pos - membuffer) * 8; // Bytes used.
  res -= write_bits_used; // The unused bits left in the buffer.

  assert(res <= MEMBUFSIZE * 8);
  
  return res;
}

void write_bits(uint8_t data, uint8_t len)
{
  uint16_t buffer;

  assert(len <= 8);
  assert(write_bits_used < 8);
  assert(buf_pos >= membuffer && buf_pos < membuffer + MEMBUFSIZE);

  if (write_bits_used == 0) {
    buffer = 0;
  } else {
    buffer = ((uint16_t)*buf_pos) << 8;
  }
  buffer |= (uint16_t)data << (16 - len - write_bits_used);
  write_bits_used += len;
  
  while (write_bits_used >= 8) {
    *buf_pos++ = buffer >> 8;
    buffer <<= 8;
    write_bits_used -= 8;      
  }

  assert(write_bits_used < 8);

  if (write_bits_used) {
    assert(buf_pos >= membuffer && buf_pos < membuffer + MEMBUFSIZE);
    *buf_pos = (uint8_t)(buffer >> 8);
  }
}

