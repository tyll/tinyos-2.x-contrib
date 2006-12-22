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
 * Blackbook BDictionary Interface
 * @author David Moss
 */

#include "Blackbook.h"

interface BDictionary {

  /**
   * Open a Dictionary file.  If the file does not exist on flash, the
   * minimumSize will be used to set the length of the file.
   * @param name - name of the Dictionary file to open
   * @param minimumSize - the minimum reserved size for the file on flash
   * @return SUCCESS if the file will be opened
   */
  command error_t open(char *fileName, uint32_t minimumSize);
  
  /**
   * @return TRUE if the given parameterized interface has a file open
   */
  command bool isOpen();
  
  /**
   * Close any opened Dictionary files
   * @return SUCCESS if the open Dictionary file was closed.
   */
  command error_t close();
  
  /**
   * Because Dictionary files are special, and NodeMap does not give an
   * accurate reflection of what's going on with Dictionary file sizes,
   * this command will return the size of the Dictionary file up to the
   * point where valid data ends.
   * @return the size of the valid data in the open dictionary file
   */
  command uint32_t getFileLength();
  
  /**
   * @return SUCCESS if the event totalKeys will be signaled
   */
  command error_t getTotalKeys();
  
  /**
   * Insert a key-value pair into the opened Dictionary file.
   * This will invalidate any old key-value pairs using the
   * associated key.
   * @param key - the key to use
   * @param value - pointer to a buffer containing the value to insert.
   * @param valueSize - the amount of bytes to copy from the buffer
   * @return SUCCESS if the key-value pair will be inserted
   */
  command error_t insert(uint32_t key, void *value, uint16_t valueSize);
  
  /**
   * Retrieve a key from the opened Dictionary file.
   * @param key - the key to find
   * @param valueHolder - pointer to the memory location to store the value
   * @param maxValueSize - used to prevent buffer overflows incase the
   *     recorded size of the value does not match the space allocated to
   *     the valueHolder
   * @return SUCCESS if the key will be retrieved.
   */
  command error_t retrieve(uint32_t key, void *valueHolder, uint16_t maxValueSize);
  
  /**
   * Remove a key from the opened dictionary file
   * @param key - the key for the key-value pair to remove
   * @return SUCCESS if the attempt to remove the key will proceed
   */
  command error_t remove(uint32_t key);
    
  /**
   * This command will signal event nextKey
   * when the first key is found.
   * @return SUCCESS if the command will be processed.
   */
  command error_t getFirstKey();
  
  /**
   * Get the last key inserted into the file.
   * @return the last key, or 0xFFFFFFFF (-1) if it doesn't exist
   */
  command uint32_t getLastKey();
  
  /**
   * Get the next recorded key in the file.
   * @return SUCCESS if the command will be processed
   */
  command error_t getNextKey(uint32_t presentKey);
  
  /**
   * Find out if a given file is a dictionary file
   * @param fileName - the name of the file
   * @return SUCCESS if the command will go through
   */
  command error_t isFileDictionary(char *fileName);
  
  
  
  /**
   * A Dictionary file was opened successfully.
   * @param totalSize - the total amount of flash space dedicated to storing
   *     key-value pairs in the file
   * @param remainingBytes - the remaining amount of space left to write to
   * @param error - SUCCESS if the file was successfully opened.
   */
  event void opened(uint32_t totalSize, uint32_t remainingBytes, error_t error);
  
  /** 
   * The opened Dictionary file is now closed
   * @param error - SUCCSESS if there are no open files
   */
  event void closed(error_t error);
  
  /**
   * A key-value pair was inserted into the currently opened Dictionary file.
   * @param key - the key used to insert the value
   * @param value - pointer to the buffer containing the value.
   * @param valueSize - the amount of bytes copied from the buffer into flash
   * @param error - SUCCESS if the key was written successfully.
   */
  event void inserted(uint32_t key, void *value, uint16_t valueSize, error_t error);
  
  /**
   * A value was retrieved from the given key.
   * @param key - the key used to find the value
   * @param valueHolder - pointer to the buffer where the value was stored
   * @param valueSize - the actual size of the value.
   * @param error - SUCCESS if the value was pulled out and is uncorrupted
   */
  event void retrieved(uint32_t key, void *valueHolder, uint16_t valueSize, error_t error);
  
  /**
   * A key-value pair was removed
   * @param key - the key that should no longer exist
   * @param error - SUCCESS if the key was really removed
   */
  event void removed(uint32_t key, error_t error);
  
  /**
   * The next key in the open Dictionary file
   * @param nextKey - the next key
   * @param error - SUCCESS if this is the really the next key,
   *     FAIL if the presentKey was invalid or there is no next key.
   */
  event void nextKey(uint32_t nextKey, error_t error);

  /**
   * @param isDictionary - TRUE if the file is a dictionary
   * @param error - SUCCESS if the reading is valid
   */
  event void fileIsDictionary(bool isDictionary, error_t error);
  
  /**
   * @param totalKeys the total keys in the open dictionary file
   */
  event void totalKeys(uint16_t totalKeys);
}


