/*
 * Copyright (c) 2008 Rincon Research Corporation
 * All rights reserved.
 *
 * Use, copying, modifying and distribution of this software and its 
 * documentation for any purpose is prohibited without written consent
 * by Rincon Research Corporation
 */
 
#include "TinyosString.h"

/**
 * @author David Moss
 */
module StringWriterP {
  provides {
    interface StringWriter;
  }
}

implementation {


  /**
   * @param string The string to clear
   */
  command void StringWriter.clear(string_t *string) {
    string->length = 0;
    memset(string->data, 0x0, DEFAULT_STRING_LENGTH);
  }
  
  /**
   * Append a full buffer to the given string
   * @param string the string to append to
   * @param buf the buffer to append
   * @param len the length of the buffer
   * @return ESIZE if there is not enough room for the operation
   */
  command error_t StringWriter.appendBuffer(string_t *string, void *buf, uint8_t len) {
    if(string->length + len > DEFAULT_STRING_LENGTH) {
      return ESIZE;
    }
    
    memcpy(string->data + string->length, buf, len);
    string->length += len;
    return SUCCESS;    
  }
  
  /**
   * Append a 2-byte integer to the given string
   * @param string the string to append to
   * @param value the integer to append
   * @return ESIZE if there is not enough room for the operation
   */
  command error_t StringWriter.appendInt(string_t *string, uint16_t value) {
    if(string->length + 2 > DEFAULT_STRING_LENGTH) {
      return ESIZE;
    }

    call StringWriter.appendByte(string, value >> 8);
    call StringWriter.appendByte(string, value);
    
    return SUCCESS;
  }
  
  /**
   * Append a byte to the given string
   * @param string the string to append to
   * @param value the byte to append
   * @return ESIZE if there is not enough room for the operation
   */
  command error_t StringWriter.appendByte(string_t *string, uint8_t value) {
    if(string->length + 1 > DEFAULT_STRING_LENGTH) {
      return ESIZE;
    }
    
    *(string->data + string->length) = value;
    string->length += 1;
    return SUCCESS;
  }
  
  /**
   * Insert a byte to the beginning of the string and shift the rest of
   * the string over 
   * @param string the string to insert a byte into
   * @param value the byte to insert
   * @return ESIZE if there is not enough room for the operation
   */
  command error_t StringWriter.insertByte(string_t *string, uint8_t value) {
    int i;
    uint8_t *data = string->data;
    
    if(string->length + 1 > DEFAULT_STRING_LENGTH) {
      return ESIZE;
    }
    
    for(i = DEFAULT_STRING_LENGTH - 1; i > 0; i--) {
      *(data + i) = *(data + i - 1);
    }
    
    string->length++;
    
    *data = value;
    return SUCCESS;
  }
  
  /**
   * Get the length of a string 
   * @param string the string to get the length of
   * @return the length of the string.
   */
  command uint8_t StringWriter.getLength(string_t *string) {
    return string->length;
  }
  

}


