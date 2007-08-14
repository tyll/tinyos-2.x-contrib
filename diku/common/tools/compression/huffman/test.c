#ifndef __AVR_ATmega128__
#define prog_uint8_t uint8_t
#endif

#include <inttypes.h>
#include <stdio.h>
#include "huffman_codes.h"

#if VALUE_BITS < 9
typedef uint8_t huffman_t;
#elif VALUE_BITS < 17
typedef uint16_t huffman_t;
#elif VALUE_BITS < 33
typedef uint32_t huffman_t;
#elif VALUE_BITS < 65
typedef uint64_t huffman_t;
#else
#error "Cannot find appropriate type for huffman_t"
#endif

struct huffman_code_t {
  uint8_t bits;
  huffman_t value;
};

uint8_t const *data;
uint8_t read_count; /* What we already have read of the current data */
uint16_t buffer;

static void new_position(uint16_t where)
{
  uint32_t bit_to_read = (LENGTH_BITS + VALUE_BITS) * where;
  uint32_t byte = bit_to_read / 8;
  read_count = (8 - bit_to_read % 8);

  data = huffman_code + byte;
  buffer = *data++;
  buffer &= (1 << read_count) - 1;
}

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

void extract_code(uint16_t where, struct huffman_code_t *c)
{
  uint8_t left;
  new_position(where);

  // Read the length
  c->bits = read_bits(LENGTH_BITS) + 1;
  c->value = 0;

  left = VALUE_BITS;
  while (left != 0) {
    if (left > 8) {
      uint8_t val;
      c->value <<= 8;
      val = read_bits(8);
      c->value |= val;
      left -= 8;
    } else {
      c->value <<= left;
      c->value |= read_bits(left);
      left = 0;
    }
  }
}

int main() {
  struct huffman_code_t c;
  int i;
  for (i = 0; i < NUMBER_OF_HUFFMAN_CODES; i++) {
    extract_code(i, &c);
    printf("Bits: %d Value: %d\n", c.bits, c.value);
  }
  return 0;
}
