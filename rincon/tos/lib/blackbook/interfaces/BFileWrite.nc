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
 * Blackbook File Write Interface
 * @author David Moss
 */

interface BFileWrite {

  /**
   * Open a file for writing. 
   * @param fileName - name of the file to write to
   * @param minimumSize The minimum requested amount of total data space
   *            to reserve in the file.  The physical amount of flash 
   *            consumed by the file may be more.
   */ 
  command error_t open(char *fileName, uint32_t minimumSize);

  /**
   * @return TRUE if the given parameterized interface has a file open
   */
  command bool isOpen();
  
  /**
   * Close any currently opened write file.
   */
  command error_t close();

  /**
   * Save the current state of the file, guaranteeing the next time
   * we experience a catastrophic failure, we will at least be able to
   * recover data from the open write file up to the point
   * where save was called.
   *
   * If data is simply being logged for a long time, use save() 
   * periodically but probably more infrequently.
   *
   * @return SUCCESS if the currently open file will be saved.
   */
  command error_t save();

  /**
   * Append the specified amount of data from a given buffer
   * to the open write file.  
   *
   * @param data - the buffer of data to append
   * @param amount - the amount of data in the buffer to write.
   * @return SUCCESS if the data will be written, FAIL if there
   *     is no open file to write to.
   */ 
  command error_t append(void *data, uint16_t amount);

  /**
   * Obtain the remaining bytes available to be written in this file
   * This is the total reserved length minus your current 
   * write position
   * @return the remaining length of the file.
   */
  command uint32_t getRemaining();
  


  /**
   * Signaled when a file has been opened, with the errors
   * @param fileName - the name of the opened write file
   * @param len - The total reserved length of the file
   * @param error - SUCCSES if the file was opened successfully
   */
  event void opened(uint32_t len, error_t error);

  /** 
   * Signaled when the opened file has been closed
   * @param error - SUCCESS if the file was closed properly
   */
  event void closed(error_t error);

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
  event void saved(error_t error);

  /**
   * Signaled when data is written to flash. On some media,
   * the data is not guaranteed to be written to non-volatile memory
   * until save() or close() is called.
   * @param fileName
   * @param data The buffer of data appended to flash
   * @param amountWritten The amount written to flash
   * @param error
   */
  event void appended(void *data, uint16_t amountWritten, error_t error);

} 
