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
 * Blackbook NodeBooter interface
 * This interface controls the existence of nodes in the NodeMap.
 * The Boot mechanism can use it to load nodes, and
 * other mechanisms can use it to clear the nodes out of RAM
 * when rebooting
 *
 * @author David Moss
 */

interface NodeBooter {

  /**
   * Request to add a flashnode_t to the file system.
   * It is the responsibility of the calling function
   * to properly setup:
   *   > flashAddress
   *   > dataLength
   *   > reserveLength
   *   > dataCrc
   *   > filenameCrc
   *   > client = fileElement from nodemeta
   * 
   * Unless manually linked, state and nextNode are handled by NodeMap.
   * @return a pointer to an empty flashnode_t if one is available
   *     NULL if no more exist
   */
  command flashnode_t *requestAddNode();
  
  /**
   * Request to add a file to the file system
   * It is the responsibility of the calling function
   * to properly setup:
   *   > filename
   *   > filenameCrc
   *   > type
   *
   * Unless manually linked, state and nextNode are handled in NodeMap.
   * @return a pointer to an empty file if one is available
   *     NULL if no more exist
   */
  command file_t *requestAddFile();

  /**
   * After the boot process finishes, the nodes loaded from flash must
   * be corrected linked before the file system
   * is ready for use.
   */
  command error_t link();
  
}

