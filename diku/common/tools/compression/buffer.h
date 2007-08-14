/**************************************************************************
 *
 * buffer.h
 *
 * An implementation of the most basic buffer manipulation functions,
 * needed for the compression algorithms.
 *
 * This file is licensed under the GNU GPL.
 *
 * (C) 2005, Klaus S. Madsen <klaussm@diku.dk>
 *
 */

#ifndef _BUFFER_H
#define _BUFFER_H

#ifndef __MSP430__
#include <inttypes.h>
#endif

#define MEMBUFSIZE 256

/*
 The reset_buffer function initializes the pointers to the
 buffer. This function must be called before write_bits and bits_left.
*/
void reset_buffer();

uint8_t *get_unwritten();
uint8_t *get_buffer();

/*
  bits_left() returns the number of bits left in the memory buffer.
*/
uint16_t bits_left();

/*
  write_bits writes at most 8 bits of data to the memory buffer.
*/
void write_bits(uint8_t data, uint8_t len);

#endif
