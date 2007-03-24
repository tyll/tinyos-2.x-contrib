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
 * Blackbook File Dir Interface
 * Allows the application to find out information about the
 * file system and flash usage.
 * @author David Moss
 */

interface BFileDir { 
 
  /**
   * @return the total number of files in the file system
   */
  command uint8_t getTotalFiles();
  
  
  /**
   * @return the total number of nodes in the file system
   */
  command uint16_t getTotalNodes();

  /**
   * @return the approximate free space on the flash
   */
  command uint32_t getFreeSpace();
  
  /**
   * Will signal the event existsCheckDone() after determining if the file
   * exists or not.
   */
  command error_t checkExists(char *fileName);

  /**
   * An optional way to read the first filename of 
   * the system.  This is the same as calling
   * BFileDir.readNext(NULL)
   */
  command error_t readFirst();
   
  /**
   * Read the next file in the file system, based on the
   * current filename.  If you want to find the first
   * file in the file system, pass in NULL.
   *
   * If the next file exists, it will be returned in the
   * nextFile event with error SUCCESS
   *
   * If there is no next file, the nextFile event will
   * signal with the filename passed in and FAIL.
   *
   * If the present filename passed in doesn't exist,
   * then this command returns FAIL and no signal is given.
   *
   * @param presentFilename - the name of the current file,
   *     of which you want to find the next valid file after.
   */
  command error_t readNext(char *presentFilename);

  /**
   * Get the total reserved bytes of an existing file
   * @param fileName - the name of the file to pull the reservedLength from.
   * @return the reservedLength of the file, 0 if it doesn't exist
   */
  command uint32_t getReservedLength(char *fileName);
  
  /**
   * Get the total amount of data written to the file with
   * the given fileName.
   * @param fileName - name of the file to pull the dataLength from.
   * @return the dataLength of the file, 0 if it doesn't exist
   */
  command uint32_t getDataLength(char *fileName);
 
  /**
   * Find if a file is corrupt. This will read each node
   * from the file and verify it against its dataCrc.
   * If the calculated data CRC from a node does
   * not match the node's recorded CRC, the file is corrupt.
   * @return SUCCESS if the corrupt check will proceed.
   */
  command error_t checkCorruption(char *fileName);



  /**
   * The corruption check on a file is complete
   * @param fileName - the name of the file that was checked
   * @param isCorrupt - TRUE if the file's actual data does not match its CRC
   * @param error - SUCCESS if this information is valid.
   */
  event void corruptionCheckDone(char *fileName, bool isCorrupt, error_t error);

  /**
   * The check to see if a file exists is complete
   * @param fileName - the name of the file
   * @param doesExist - TRUE if the file exists
   * @param error - SUCCESS if this information is valid
   */
  event void existsCheckDone(char *fileName, bool doesExist, error_t error);
  
  
  /**
   * This is the next file in the file system after the given
   * present file.
   * @param fileName - name of the next file
   * @param error - SUCCESS if this is actually the next file, 
   *     FAIL if the given present file is not valid or there is no
   *     next file.
   */  
  event void nextFile(char *fileName, error_t error);  
    
}
