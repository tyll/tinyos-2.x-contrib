/**************************************************************************
 *
 * compressor.h
 *
 * The platform specific parts needed by the compressors.
 *
 * This file is licensed under the GNU GPL.
 *
 * (C) 2005, Klaus S. Madsen <klaussm@diku.dk>
 *
 */
#ifndef __MSP430__
#include <inttypes.h>
#endif

/* 
 * buffer is a pointer to nobytes of data
 */
void handle_full_buffer(uint8_t *buffer, uint16_t nobytes);
