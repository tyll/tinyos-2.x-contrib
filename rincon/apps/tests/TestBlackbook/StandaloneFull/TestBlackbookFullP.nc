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
 * Test Blackbook
 * @author David Moss - dmm@rincon.com
 */
 
module TestBlackbookFullP {
  uses {
    interface BBoot;
    interface BFileRead;
    interface BFileWrite;
    interface BFileDelete;
    interface BFileDir;
    interface BDictionary;
    interface BClean;
  }
}

implementation {

  
  /***************** BBoot Events ****************/
  /**
   * The file system finished booting
   * @param totalNodes - the total number of nodes found on flash
   * @param error - SUCCESS if the file system is ready for use.
   */
  event void BBoot.booted(uint16_t totalNodes, uint8_t totalFiles, error_t error) {
  }
  
  /***************** BClean Events ****************/
  
  /**
   * The Garbage Collector is erasing a sector - this may take awhile
   */
  event void BClean.erasing() {
  }
  
  /**
   * Garbage Collection is complete
   * @return SUCCESS if any sectors were erased.
   */
  event void BClean.gcDone(error_t error) {
  }
  
  
  /***************** BFileRead Events ****************/

  /**
   * A file has been opened
   * @param fileName - name of the opened file
   * @param len - the total data length of the file
   * @param error - SUCCESS if the file was successfully opened
   */
  event void BFileRead.opened(uint32_t amount, error_t error) {
  }

  /**
   * Any previously opened file is now closed
   * @param error - SUCCESS if the file was closed properly
   */
  event void BFileRead.closed(error_t error) {
  }

  /**
   * File read complete
   * @param *buf - this is the buffer that was initially passed in
   * @param amount - the length of the data read into the buffer
   * @param error - SUCCESS if there were no problems reading the data
   */
  event void BFileRead.readDone(void *dataBuffer, uint16_t amount, error_t error) {
  }
  
  /***************** BFileWrite Events ****************/

  /**
   * Signaled when a file has been opened, with the errors
   * @param fileName - the name of the opened write file
   * @param len - The total reserved length of the file
   * @param error - SUCCSES if the file was opened successfully
   */
  event void BFileWrite.opened(uint32_t len, error_t error) {
  }

  /** 
   * Signaled when the opened file has been closed
   * @param error - SUCCESS if the file was closed properly
   */
  event void BFileWrite.closed(error_t error) {
  }

  /**
   * Signaled when this file has been saved.
   * This does not require the save() command to be called
   * before being signaled - this would happen if another
   * file was open for writing and that file was saved, but
   * the behavior of the checkpoint file required all files
   * on the system to be saved as well.
   * @param fileName - name of the open write file that was saved
   * @param error - SUCCESS if the file was saved successfully
   */
  event void BFileWrite.saved(error_t error) {
  }

  /**
   * Signaled when data is written to flash. On some media,
   * the data is not guaranteed to be written to non-volatile memory
   * until save() or close() is called.
   * @param fileName
   * @param data The buffer of data appended to flash
   * @param amountWritten The amount written to flash
   * @param error
   */
  event void BFileWrite.appended(void *data, uint16_t amountWritten, error_t error) {
  }
  
  
  /***************** BFileDelete Events ****************/
  /**
   * A file was deleted
   * @param error - SUCCESS if the file was deleted from flash
   */
  event void BFileDelete.deleted(error_t error) {

  }
  
  
  /***************** BFileDir Events ****************/
  /**
   * The corruption check on a file is complete
   * @param fileName - the name of the file that was checked
   * @param isCorrupt - TRUE if the file's actual data does not match its CRC
   * @param error - SUCCESS if this information is valid.
   */
  event void BFileDir.corruptionCheckDone(char *fileName, bool isCorrupt, error_t error) {

  }

  /**
   * The check to see if a file exists is complete
   * @param fileName - the name of the file
   * @param doesExist - TRUE if the file exists
   * @param error - SUCCESS if this information is valid
   */
  event void BFileDir.existsCheckDone(char *fileName, bool doesExist, error_t error) {

  }
  
  
  /**
   * This is the next file in the file system after the given
   * present file.
   * @param fileName - name of the next file
   * @param error - SUCCESS if this is actually the next file, 
   *     FAIL if the given present file is not valid or there is no
   *     next file.
   */  
  event void BFileDir.nextFile(char *fileName, error_t error) {

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


