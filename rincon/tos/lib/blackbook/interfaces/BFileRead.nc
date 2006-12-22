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
 * Blackbook File Reading Interface
 * @author David Moss
 */

interface BFileRead {

  /**
   * Open a file for reading
   * @param fileName - name of the file to open
   * @return SUCCESS if the attempt to open for reading proceeds
   */ 
  command error_t open(char *fileName);

  /**
   * @return TRUE if the given parameterized interface has a file open
   */
  command bool isOpen();
  
  /**
   * Close any currently opened file
   */
  command error_t close();

  /**
   * Read a specified amount of data from the open
   * file into the given buffer
   * @param *dataBuffer - the buffer to read data into
   * @param amount - the amount of data to read
   * @return SUCCESS if the command goes through
   */
  command error_t read(void *dataBuffer, uint16_t amount);

  /**
   * Seek a given address to read from in the file.
   *
   * This will point the current internal read pointer
   * to the given address if the address is within
   * bounds of the file.  When BFileRead.read(...) is
   * called, the first byte of the buffer
   * will be the byte at the file address specified here.
   *
   * If the address is outside the bounds of the
   * data in the file, the internal read pointer
   * address will not change.
   * @param fileAddress - the address to seek
   * @return SUCCESS if the read pointer is adjusted,
   *         FAIL if the read pointer didn't change
   */
  command error_t seek(uint32_t fileAddress);

  /**
   * Skip the specified number of bytes in the file
   * @param skipLength - number of bytes to skip
   * @return SUCCESS if the internal read pointer was 
   *      adjusted, FAIL if it wasn't because
   *      the skip length is beyond the bounds of the file.
   */
  command error_t skip(uint16_t skipLength);

  /**
   * Get the remaining bytes available to read from this file.
   * This is the total size of the file minus your current position.
   * @return the number of remaining bytes in this file 
   */
  command uint32_t getRemaining();



  /**
   * A file has been opened
   * @param fileName - name of the opened file
   * @param len - the total data length of the file
   * @param error - SUCCESS if the file was successfully opened
   */
  event void opened(uint32_t amount, error_t error);

  /**
   * Any previously opened file is now closed
   * @param error - SUCCESS if the file was closed properly
   */
  event void closed(error_t error);

  /**
   * File read complete
   * @param *buf - this is the buffer that was initially passed in
   * @param amount - the length of the data read into the buffer
   * @param error - SUCCESS if there were no problems reading the data
   */
  event void readDone(void *dataBuffer, uint16_t amount, error_t error);

}


