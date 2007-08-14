/**************************************************************************
 *
 * lz77_comp.c
 *
 * The LZ77 compression algorithm.
 *
 * This file is licensed under the GNU GPL.
 *
 * (C) 2005, Klaus S. Madsen <klaussm@diku.dk>
 *
 */
#include "../compressor.h"
#include "../buffer.h"
#include "lz77.h"
#ifdef HAVE_ASSERT
# include <assert.h>
#else
# define assert(x) 
#endif

#include <string.h>

uint8_t window[WINDOW_SIZE] __attribute((xdata)); 
uint8_t *search_start = window ;
uint8_t *search_end = window ; /* Doubles as look_ahead_start */
uint8_t *look_ahead_end  = window;

uint16_t cyclic_difference(uint8_t *start, uint8_t *end)
{
  if (start > end) {
    end += WINDOW_SIZE;
  }

  return end - start;
}

uint8_t *cyclic_adjust(uint8_t *v) 
{
  if (v < window) {
    v += WINDOW_SIZE;    
  } else if (v >= window + WINDOW_SIZE) {
    v -= WINDOW_SIZE;
  }

  assert(v < window + WINDOW_SIZE && v >= window);

  return v;
}

uint8_t find_match_length(uint8_t *search_pos)
{
  uint8_t res = 0;
  uint8_t *cur_search_pos = search_pos;
  uint8_t *cur_look_ahead = search_end;

  while (cur_search_pos == search_pos) {
    /* Iterate for as long as we haven't reached the end of neither the
       search buffer nor the look-ahead buffer, and as long as the two
       buffers match */
    while (cur_search_pos != search_end 
	   && cur_look_ahead != look_ahead_end 
	   && *cur_search_pos == *cur_look_ahead
	   && res < LOOK_AHEAD_SIZE) {
      cur_look_ahead = cyclic_adjust(cur_look_ahead + 1);
      cur_search_pos = cyclic_adjust(cur_search_pos + 1);
      res++;
    } 

    if (cur_search_pos == search_end && res < LOOK_AHEAD_SIZE
	&& cur_look_ahead != look_ahead_end) {
      //      fprintf(stderr, "Going for another round\n");
      cur_search_pos = search_pos;
    } else {
      break;
    }
  }

  if (res == 0) {
    /* Something's fishy */
#ifdef DEBUG
    fprintf(stderr, "find_match_length returns 0!?!\n");
#endif
  }

  assert(res <= LOOK_AHEAD_SIZE);

  return res; 
}

#ifdef DEBUG
void output_match(uint16_t match_offset, uint8_t len)
{
  uint8_t *pos = cyclic_adjust(search_end - match_offset);
  int i;
  
  for (i = 0; i < len; i++) {
    fprintf(stderr, "%02x", *pos);
    pos = cyclic_adjust(pos + 1);
  }
}
#endif

/*
 * do_compress will compress at least a single byte.
 */
void do_compress()
{
  /* Search the search buffer for the first character of the
     look-ahead buffer */
  uint8_t *cur_search = search_start;

  uint8_t match_length = 0;
  uint16_t match_offset = 0; /* The offset is the number of bytes
				backwards from search_end we must go
				to find the match */

  while (cur_search != search_end) {
    if (*cur_search == *search_end) {
      /* If the first symbol in the look-ahead buffer matches our
	 current search character, calculate the length */
      uint8_t tmp_length = find_match_length(cur_search);

      if (tmp_length > match_length) {
	/* If we have found a match with a greater length than the
	   previous match, update our match */
	match_length = tmp_length;
	match_offset = cyclic_difference(cur_search, search_end);
      }
    }
    cur_search = cyclic_adjust(cur_search + 1);
  }

  if (match_length <= 1) {
    /* If we didn't find a match, we just output the original
       value. Also if we found a match and the length was only 1 byte,
       the original value actually takes up less space than the
       offset/length token. If the length is 2 we will use 18 bits  exactly 1
       bit ;-) */

    write_bits(1, 1); /* This is a real value */
    write_bits(*search_end, 8); 

#ifdef DEBUG
    fprintf(stderr, "Outputting single byte %d\n", *search_end);
#endif
    
    /* Set the match_length to 1, so that when we move the window
       later on, we will move the current item to the search buffer */
    match_length = 1; 
  } else { 
    /* We did find a match. Now write a token */

    write_bits(0, 1); /* This is a token */

#ifdef DEBUG
    fprintf(stderr, "Outputting offset %d and length %d. Values: ", 
	    match_offset, match_length);

    output_match(match_offset, match_length);
    fprintf(stderr, "\n");
#endif
    
    /* Write the offset */
    write_bits(match_offset >> 8, OFFSET_BITS - 8);
    write_bits(match_offset & 0xFF, 8);

    /* Write the length */
    write_bits((match_length - 1) & ((1 << LENGTH_BITS) - 1),  LENGTH_BITS);
  }

  /* Now we need to update the window */
  {
    uint16_t tmp_diff;
    search_end = cyclic_adjust(search_end + match_length);
    
    tmp_diff = cyclic_difference(search_start, search_end);
    if (tmp_diff >= WINDOW_SIZE - LOOK_AHEAD_SIZE) {
      /* We only update the start pointer if we have filled the buffer */
      search_start = cyclic_adjust(search_start + tmp_diff 
				   - WINDOW_SIZE + LOOK_AHEAD_SIZE);
    }
  }

  /* Check if there is room enough for a nother token */
  if (bits_left() < OFFSET_BITS + LENGTH_BITS + 1) {
    handle_full_buffer(get_buffer(), bits_left()/(uint8_t)8);
    reset_buffer();
  }    
}

void add_byte(uint8_t b)
{
  /* Put the byte a the end of the look ahead buffer */
  
  assert(look_ahead_end < window + WINDOW_SIZE && look_ahead_end >= window);

  *look_ahead_end = b;
  look_ahead_end = cyclic_adjust(look_ahead_end + 1);

  /* Adjust the search_start if necessary. This happens when our
     window is filled. */
  if (search_start == look_ahead_end) {
    search_start = cyclic_adjust(search_start + 1);
  }

#ifdef DEBUG
  if (bits_left() < 17) {
    fprintf(stderr, "We are here, and we have less than 17 bits left?\n");
  } 
#endif 

  /* Now we should have a window with as much data as possible */

  /* Check if we have our look-ahead buffer filled */
  if (cyclic_difference(search_end, look_ahead_end) == LOOK_AHEAD_SIZE)
    do_compress();
}

int first = 1;

void compress_sample(int16_t digi_x, int16_t digi_y, int16_t digi_z,
		     uint16_t ana_x, uint16_t ana_y)
{
#ifdef DIFFERENCE
  static int16_t last_vals[3];
#endif

  if (first) {
    reset_buffer();
    first = 0;
#ifdef DIFFERENCE
    add_byte((digi_x >> 8) & 0xFF);
    add_byte(digi_x & 0xFF);
    add_byte((digi_y >> 8) & 0xFF);
    add_byte(digi_y & 0xFF);
    add_byte((digi_z >> 8) & 0xFF);
    add_byte(digi_z & 0xFF);
    last_vals[0] = digi_x;
    last_vals[1] = digi_y;
    last_vals[2] = digi_z;
    return;
#endif
  } 

#ifndef DIFFERENCE
  add_byte((digi_x >> 8) & 0xFF);
  add_byte(digi_x & 0xFF);
  add_byte((digi_y >> 8) & 0xFF);
  add_byte(digi_y & 0xFF);
  add_byte((digi_z >> 8) & 0xFF);
  add_byte(digi_z & 0xFF);
#else
  {
    int16_t vals[3];
    int i;
    vals[0] = digi_x - last_vals[0];
    vals[1] = digi_y - last_vals[1];
    vals[2] = digi_z - last_vals[2];
    
    for (i = 0; i < 3; i++) {
      add_byte((vals[i] >> 8) & 0xFF);
      add_byte(vals[i] & 0xFF);
    }
  }
  last_vals[0] = digi_x;
  last_vals[1] = digi_y;
  last_vals[2] = digi_z;
#endif
} 

void flush()
{
  /* Ok. Now we need to empty our look-ahead buffer */
  while (search_end != look_ahead_end) {
    do_compress();
  }

  /* Empty the last buffer in the system */
  handle_full_buffer(get_buffer(), MEMBUFSIZE - bits_left()/(uint8_t)8);
  search_start = window;
  search_end = window;
  look_ahead_end = window;
  first = 1;
}
