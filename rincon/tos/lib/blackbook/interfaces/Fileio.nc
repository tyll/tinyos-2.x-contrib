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
 * Blackbook Fileio Interface
 * Allows data to be appended to a node, and automatically
 * update the node's dataCrc.  This will not enforce
 * the amount of data written to a node, because the
 * FileWriter is responsible for that level of architecture.
 *
 * @author David Moss
 */
 
interface Fileio {

  /**
   * Write data to the flashnode belonging to the given file
   * at the given address in the file
   * @param focusedFile - the file_t to write to
   * @param fileAddress - the address to write to in the file
   * @param *data - the data to write
   * @param amount - the amount of data to write
   * @return SUCCESS if the data will be written
   */
  command error_t writeData(file_t *focusedFile, uint32_t fileAddress, void *data, uint32_t amount);
  
  /**
   * Read data from the flashnode belonging to the given file
   * at the given address in the file
   * @param focusedFile - the file_t to read from
   * @param fileAddress - the address to read from in the file
   * @param *data - pointer to the buffer to store the data in
   * @param amount - the amount of data to read
   */
  command error_t readData(file_t *focusedFile, uint32_t fileAddress, void *data, uint32_t amount);
  
  /**
   * Flush any written data to flash 
   * @return SUCCESS if the data is flushed, and an event will be signaled.
   */
  command error_t flushData();
  
  
  /**
   * Data was appended to the flashnode in the flash.
   * @param writeBuffer - pointer to the buffer containing the data written
   * @param amountWritten - the amount of data appended to the node.
   * @param error - SUCCESS if the data was successfully written
   */
  event void writeDone(void *writeBuffer, uint32_t amountWritten, error_t error);
  
  /**
   * Data was read from the file
   * @param *readBuffer - pointer to the location where the data was stored
   * @param amountRead - the amount of data actually read
   * @param error - SUCCESS if the data was successfully read
   */
  event void readDone(void *readBuffer, uint32_t amountRead, error_t error);
  
  /**
   * Data was flushed to flash
   * @param error - SUCCESS if the data was flushed
   */
  event void flushDone(error_t error);
}


