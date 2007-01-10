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
 * Dictionary Demo:
 * Keep track of the number of times the mote has been
 * rebooted through the use of non-volatile memory and
 * the dictionary.
 *
 * Each reboot will increment a 16-bit variable, and display
 * the 3 LSB's on the LED's.
 *
 * @author David Moss
 */
 
module DictionaryDemoP { 
  uses {
    interface BBoot;
    interface BDictionary;
    interface Leds;
  }
}

implementation {
  
  /** The number of times this device has rebooted */
  uint16_t reboots;
  
  enum {
    REBOOT_KEY = 0xB007,
  };
  

  /***************** BBoot events ****************/
  /**
   * The file system finished booting
   * @param totalNodes - the total number of nodes found on flash
   * @param result - SUCCESS if the file system is ready for use.
   */
  event void BBoot.booted(uint16_t totalNodes, uint8_t totalFiles, error_t error) {
    call BDictionary.open("dicdemo", 0x100);
  }

  
  /***************** BDictionary Events ****************/  
  /**
   * A Dictionary file was opened successfully.
   * @param totalSize - the total amount of flash space dedicated to storing
   *     key-value pairs in the file
   * @param remainingBytes - the remaining amount of space left to write to
   * @param error - SUCCESS if the file was successfully opened.
   */
  event void BDictionary.opened(uint32_t totalSize, uint32_t remainingBytes, error_t error) {
    // If your system may attempt to access Blackbook multiple times in 
    // parallel, you should put your commands in a spinning task.
    // Since this program only accesses Blackbook one step at a time,
    // there is no need to post a task to open or retrieve data from Blackbook.
    call BDictionary.retrieve(REBOOT_KEY, &reboots, sizeof(reboots));
  }
  
  /** 
   * The opened Dictionary file is now closed
   * @param error - SUCCSESS if there are no open files
   */
  event void BDictionary.closed(error_t error) {
  }
  
  /**
   * A key-value pair was inserted into the currently opened Dictionary file.
   * @param key - the key used to insert the value
   * @param value - pointer to the buffer containing the value.
   * @param valueSize - the amount of bytes copied from the buffer into flash
   * @param error - SUCCESS if the key was written successfully.
   */
  event void BDictionary.inserted(uint32_t key, void *value, uint16_t valueSize, error_t error) {
  }
  
  /**
   * A value was retrieved from the given key.
   * @param key - the key used to find the value
   * @param valueHolder - pointer to the buffer where the value was stored
   * @param valueSize - the actual size of the value.
   * @param error - SUCCESS if the value was pulled out and is uncorrupted
   */
  event void BDictionary.retrieved(uint32_t key, void *valueHolder, uint16_t valueSize, error_t error) {
    if(!error) {
      // Loaded the value from non-volatile memory!
      reboots++;
      
    } else {
      // Set the default value, store it to flash for next time.
      reboots = 1;
    }
    
    // Update the LEDs and update the number of times we've rebooted.
    call Leds.set(reboots);
    call BDictionary.insert(REBOOT_KEY, &reboots, sizeof(reboots));
  }
  
  /**
   * A key-value pair was removed
   * @param key - the key that should no longer exist
   * @param error - SUCCESS if the key was really removed
   */
  event void BDictionary.removed(uint32_t key, error_t error) {
  }
  
  /**
   * The next key in the open Dictionary file
   * @param nextKey - the next key
   * @param error - SUCCESS if this is the really the next key,
   *     FAIL if the presentKey was invalid or there is no next key.
   */
  event void BDictionary.nextKey(uint32_t nextKey, error_t error) {
  }

  /**
   * @param isDictionary - TRUE if the file is a dictionary
   * @param error - SUCCESS if the reading is valid
   */
  event void BDictionary.fileIsDictionary(bool isDictionary, error_t error) {
  }
  
  /**
   * @param totalKeys the total keys in the open dictionary file
   */
  event void BDictionary.totalKeys(uint16_t totalKeys) {
  }
}



