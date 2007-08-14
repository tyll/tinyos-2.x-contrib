/**************************************************************************
 *
 * huffman_comp.c
 *
 * A simple static huffman compressor.
 *
 * This file is licensed under the GNU GPL.
 *
 * (C) 2005, Klaus S. Madsen <klaussm@diku.dk>
 *
 */
#ifndef __AVR_ATmega128__
#define prog_uint8_t uint8_t
#define read_byte(x, y) (x[y])
#else
#include <avr/pgmspace.h>
#define read_byte(x, y) pgm_read_byte_near((x) + (y))
#endif

#ifndef __MSP430__
#include <inttypes.h>
#endif
#include <string.h>
#include CODESET
#include "../compressor.h"
#include "../buffer.h"

//#define PAGES_IN_A_ROW 32

void new_buffer(int16_t *vals)
{
  int i;
  reset_buffer();

  for (i = 0; i < 3; i++) {
    write_bits((vals[i] >> 8) & 0x0F, 4);
    write_bits(vals[i] & 0xFF, 8);
  }
}

inline uint16_t min(uint16_t a, uint16_t b)
{
  return a < b ? a : b;
}

uint16_t data_offset;
uint8_t read_count; /* What we have left to read of the current data */
uint16_t buffer;
#ifdef USE_TWO_ARRAYS
uint8_t data_in_first_array;
#endif

inline void increment_data(uint16_t inc)
{
  data_offset += inc;
#ifdef USE_TWO_ARRAYS
  if (data_in_first_array && data_offset > NEW_ARRAY_POINT - 1) {
    data_offset -= NEW_ARRAY_POINT;
    data_in_first_array = 0;
  }
#endif
}

static void new_bit_position(uint32_t bit_to_read)
{
  uint16_t byte = bit_to_read / (uint32_t)8;
  read_count = (8 - (bit_to_read % 8));

	data_offset = 0;
#ifdef USE_TWO_ARRAYS
  data_in_first_array = 1;
#endif
  increment_data(byte);

#ifdef USE_TWO_ARRAYS
	buffer = read_byte((data_in_first_array 
											? huffman_code : huffman_code2),
										 data_offset);
#else
	buffer = read_byte(huffman_code, data_offset);
#endif
  increment_data(1);
  buffer &= (1 << read_count) - 1;
}

static void new_position(uint16_t where)
{
  uint32_t bit_to_read = (LENGTH_BITS + VALUE_BITS) * (uint32_t)where;
  new_bit_position(bit_to_read);
}

static void advance_bits(uint8_t len)
{
  uint32_t bit_to_read;
  
#ifdef USE_TWO_ARRAYS
  if (data_in_first_array) {
    bit_to_read = (uint32_t)data_offset * 8;
  } else {
    bit_to_read = (NEW_ARRAY_POINT + (uint32_t)data_offset) * 8;
  }
#else
  bit_to_read = (uint32_t)data_offset * 8;
#endif

  bit_to_read -= read_count;
  bit_to_read += len;

  new_bit_position(bit_to_read);
}

static uint8_t read_bits(uint8_t len)
{
  uint8_t res;
  // Fill the buffer
  if (read_count < len) {
    buffer <<= 8;
#ifdef USE_TWO_ARRAYS
    buffer |= read_byte((data_in_first_array 
												 ? huffman_code : huffman_code2),
												data_offset);
#else
    buffer |= read_byte(huffman_code, data_offset);
#endif
    increment_data(1);
    read_count += 8;
  }

  res = (buffer >> (read_count - len)) & ((1 << len) - 1);
  read_count -= len;
  buffer &= (1 << read_count) - 1;
  return res;
}

void real_write_bits(uint8_t value, uint8_t len)
{
  uint16_t left = bits_left();
  if (left <= len) {
    write_bits(value >> (len - left), left);
    handle_full_buffer(get_buffer());
    reset_buffer();
    len -= left;
  } 
  
  if (len > 0) 
    write_bits(value, len);
}

void write_code(uint16_t where)
{
  uint8_t code_length;
  new_position(where);

  // Read the length
  code_length = read_bits(LENGTH_BITS) + 1;

  advance_bits(VALUE_BITS - code_length);

  while (code_length != 0) {
    uint8_t to_write = min(8, code_length);
    real_write_bits(read_bits(to_write), to_write);
    code_length -= to_write;
  }
}

static int first = 1;

void compress_sample(int16_t digi_x, int16_t digi_y, int16_t digi_z,
		     uint16_t ana_x, uint16_t ana_y)
{
  static uint16_t last_vals[3];

  int16_t vals[3];
  int i;

  vals[0] = digi_x;
  vals[1] = digi_y;
  vals[2] = digi_z;

  if (first) {
    /* Initialize */
    first = 0;
#ifdef HUFFMAN_DIFFERENCE
    new_buffer(vals);
    memcpy(last_vals, vals, sizeof(uint16_t) * 3);
    return;
#else
    reset_buffer();
#endif
  }

  /* Find the codes for each axis */
  for (i = 0; i < 3; i++) {
    uint16_t tmp;
#ifdef HUFFMAN_DIFFERENCE
# ifdef HUFFMAN_WHOLE_SYMBOLS
    tmp = ((vals[i] + 2048) - (last_vals[i] + 2048) + 4096) & 0xFFF;
# else
    tmp = (vals[i] + 2048) - (last_vals[i] + 2048) + 4096;
# endif
#else
# ifdef HUFFMAN_WHOLE_SYMBOLS
    tmp = vals[i] + 2048;
# else
    tmp = vals[i];
# endif
#endif

#ifdef HUFFMAN_WHOLE_SYMBOLS
    write_code(tmp);
#else
    write_code(tmp & 0xFF);
    write_code((tmp >> 8) & 0xFF);
#endif
  }

  memcpy(last_vals, vals, sizeof(uint16_t) * 3);
} 

void flush()
{
  uint8_t *tmp = get_unwritten();
  memset(tmp, 0, MEMBUFSIZE - (tmp - get_buffer()));
  handle_full_buffer(get_buffer());
  first = 1;
}
