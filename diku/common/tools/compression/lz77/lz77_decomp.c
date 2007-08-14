/**************************************************************************
 *
 * lz77_decomp.c
 *
 * The LZ77 decompression algorithm.
 *
 * This file is licensed under the GNU GPL.
 *
 * (C) 2005, Klaus S. Madsen <klaussm@diku.dk>
 *
 */
#include "lz77.h"
#include <inttypes.h>
#include <errno.h>
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <assert.h>
#include "../buffer.h"

uint8_t membuffer[MEMBUFSIZE];
uint8_t *data;
uint8_t read_count;
uint16_t buffer;

int lengths[33];
int offsets[2000];

void init_comp()
{
  memset(lengths, 0, sizeof(lengths));
  memset(offsets, 0, sizeof(offsets));
}

void end_comp()
{
  int i;

  printf("Lengths:\n");

  for (i = 0; i < 33; i++) {
    printf("%02d: %d\n", i, lengths[i]);
  }

  printf("Offsets:\n");

  for (i = 0; i < 1501; i++) {
    printf("%04d: %d\n", i, offsets[i]);
  }
}

static uint8_t read_bits(uint8_t len)
{
  assert(len <= 8);

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
  
  res *= 8;
  res += read_count; // Bits read, but not outputted yet.
  
  return res;
}

#define SEARCH_SIZE WINDOW_SIZE

uint8_t window[SEARCH_SIZE];
uint8_t *search_end;

void fill_buffer()
{
#ifdef DEBUG
  fprintf(stderr, "**Filling buffer\n");
#endif

  if (fread(membuffer, MEMBUFSIZE, 1, stdin) != 1) {
    fprintf(stderr, "Error reading from stdin: %s\n", 
	    strerror(errno));
    exit(1);
  }
  
  read_count = 0;
  buffer = 0;
  data = membuffer;
}

uint16_t cyclic_difference(uint8_t *start, uint8_t *end)
{
  if (start > end) {
    end += SEARCH_SIZE;
  }

  return end - start;
}

uint8_t *cyclic_adjust(uint8_t *v) 
{
  if (v < window) {
    v += SEARCH_SIZE;    
  } else if (v >= window + SEARCH_SIZE) {
    v -= SEARCH_SIZE;
  }

  assert(v < window + SEARCH_SIZE && v >= window);

  return v;
}

void insert_into_buffer(uint8_t b)
{
  assert(search_end >= window && search_end < window + SEARCH_SIZE);
  *search_end = b;

  search_end = cyclic_adjust(search_end + 1);
  //  fprintf(stderr, "Buffer contains %d elements\n", 
  //	  cyclic_difference(search_start, search_end));
}

uint8_t match_length = 0;
uint8_t *match_pos;
uint8_t *orig_match_pos;

int max_length = 0;

#ifdef DEBUG
void output_match(uint8_t *pos, uint8_t len)
{
  int i;

  fprintf(stderr, "@%p (window starts @ %p): ", pos, window);
  
  for (i = 0; i < len; i++) {
    fprintf(stderr, "%02x", *pos);
    pos = cyclic_adjust(pos + 1);
  }
  fprintf(stderr, "\n");
}
#endif
uint8_t get_byte()
{
  if (match_length) {
    uint8_t tmp;

    if (match_pos == search_end) {
      match_pos = orig_match_pos;
    }

    tmp = *match_pos;
    match_pos = cyclic_adjust(match_pos + 1);
    insert_into_buffer(tmp);
    match_length--;
    return tmp;
  } else {
    uint8_t tmp;
    
    if (bits_left() < OFFSET_BITS + LENGTH_BITS + 1) 
      fill_buffer();

    tmp = read_bits(1); 
    
    if (tmp) {
      /* This was a single byte. */
      uint8_t res = read_bits(8);
      insert_into_buffer(res);
#ifdef DEBUG
      fprintf(stderr, "Reading single byte %d\n", (int)res);
#endif
      lengths[0]++;
      offsets[0]++;
      return res;
    } else {
      uint16_t offset;

      offset = (uint16_t) read_bits(OFFSET_BITS - 8) << 8;
      offset |= read_bits(8);

      offsets[offset]++;
      
      match_length = read_bits(LENGTH_BITS);
      if (match_length == (1 << LENGTH_BITS) - 1) {
	max_length++;
      }

      lengths[match_length + 1]++;

      orig_match_pos = match_pos = cyclic_adjust(search_end - offset);

#ifdef DEBUG
      fprintf(stderr, "Read offset %d and length %d. Values: ", offset, 
	      match_length);
      output_match(match_pos, match_length + 1);
#endif
      
      tmp = *match_pos;
      match_pos = cyclic_adjust(match_pos + 1);
      insert_into_buffer(tmp);
      return tmp;
    }
  }
}

int decompress_sample(int16_t *digi_x, int16_t *digi_y, 
		      int16_t *digi_z, uint16_t *analog_x,
		      uint16_t *analog_y)
{
  static int first = 1;
#ifdef DIFFERENCE
  static int16_t last_vals[3];
  int i;
#endif

  if (first) {
    first = 0;
    fill_buffer();
    search_end = window;

#ifdef DIFFERENCE
    for (i = 0; i < 3; i++) {
      last_vals[i] = (get_byte() << 8) | get_byte();
    }
  } else {
    for (i = 0; i < 3; i++) {
      last_vals[i] += (get_byte() << 8) | get_byte();
    }
#endif 
  }
  
#ifdef DIFFERENCE
  *digi_x = last_vals[0];
  *digi_y = last_vals[1];
  *digi_z = last_vals[2];
#else
  *digi_x = (get_byte() << 8) | get_byte();
  *digi_y = (get_byte() << 8) | get_byte();
  *digi_z = (get_byte() << 8) | get_byte();
#endif

  return max_length;
}
