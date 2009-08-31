/*
 * Copyright (c) 2008 Rincon Research Corporation
 * All rights reserved.
 *
 * Use, copying, modifying and distribution of this software and its 
 * documentation for any purpose is prohibited without written consent
 * by Rincon Research Corporation
 */
 
/**
 * Basic string writing interface
 * @author David Moss
 */
 
#include "TinyosString.h"

interface StringWriter {
 
  /**
   * @param string The string to clear
   */
  command void clear(string_t *string);
  
  /**
   * Append a full buffer to the given string
   * @param string the string to append to
   * @param buf the buffer to append
   * @param len the length of the buffer
   * @return ESIZE if there is not enough room for the operation
   */
  command error_t appendBuffer(string_t *string, void *buf, uint8_t len);
  
  /**
   * Append a 2-byte integer to the given string
   * @param string the string to append to
   * @param value the integer to append
   * @return ESIZE if there is not enough room for the operation
   */
  command error_t appendInt(string_t *string, uint16_t value);
  
  /**
   * Append a byte to the given string
   * @param string the string to append to
   * @param value the byte to append
   * @return ESIZE if there is not enough room for the operation
   */
  command error_t appendByte(string_t *string, uint8_t value);
  
  /**
   * Insert a byte to the beginning of the string and shift the rest of
   * the string over 
   * @param string the string to insert a byte into
   * @param value the byte to insert
   * @return ESIZE if there is not enough room for the operation
   */
  command error_t insertByte(string_t *string, uint8_t value);
  
  /**
   * Get the length of a string 
   * @param string the string to get the length of
   * @return the length of the string.
   */
  command uint8_t getLength(string_t *string);
  
}

