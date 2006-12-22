/*
 * Copyright (c) 2005-2006 Rincon Research Corporation
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 * - Redistributions of source code must retain the above copyright
 *   notice, this list of conditions and the following disclaimer.
 * - Redistributions in binary form must reproduce the above copyright
 *   notice, this list of conditions and the following disclaimer in the
 *   documentation and/or other materials provided with the
 *   distribution.
 * - Neither the name of the Rincon Research Corporation nor the names of
 *   its contributors may be used to endorse or promote products derived
 *   from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 * ``AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
 * FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL THE
 * ARCHED ROCK OR ITS CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
 * INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
 * STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
 * OF THE POSSIBILITY OF SUCH DAMAGE
 */

/**
 * @author David Moss
 */
 
#ifndef BDICTIONARY_H
#define BDICTIONARY_H

#include "Blackbook.h"

#define UQ_BDICTIONARY "BDictionary"

/**
 * Keeping the most recently used keys from a file_t in memory 
 * decreases search time at the expense of RAM.
 */
typedef struct keycache_t {

  /** The key */
  uint32_t key;
  
  /** 
   * The data offset in the file_t to reach the beginning of the key
   * 0xFFFF means this entire cache key is invalid 
   */
  uint32_t keyOffset;
  
} keycache_t;


/**
 * This is a key-value pair to be inserted into
 * a Dictionary file.  The value can be any size,
 * and the address of the valueStart variable
 * is where to start writing the data
 */
typedef struct keymeta_t {
  
  /** The magic number for a valid key-value pair entry */
  uint16_t magicNumber;
  
  /** The key */
  uint32_t key;
  
  /** The CRC of the value */
  uint16_t valueCrc;
    
  /** The length of the value */
  uint16_t valueLength;

} keymeta_t;

/**
 * Dictionary Magic Words
 */
enum {
  KEY_EMPTY = 0xFFFF,      // binary 1111
  KEY_VALID = 0xAAAA,      // binary 1010
  KEY_INVALID = 0x8888,    // binary 1000
  
  ENTRY_INVALID = 0xFFFFFFFF,
  
  DICTIONARY_HEADER = 0xD1C7,
};

#endif

