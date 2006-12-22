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
 * Blackbook Checkpoint Interface 
 * Saves the state of open binary nodes to a Checkpoint
 * dicationary file on flash for catastrophic failure recovery.
 * @author David Moss
 */
 
interface Checkpoint {

  /**
   * After boot is complete, open the checkpoint file
   * in the BDictionary
   * @return SUCCESS if the checkpoint file will be 
   *     created and/or opened.
   */
  command error_t openCheckpoint();
  
  /**
   * Update a node.
   * @param focusedNode - the flashnode_t to save or delete
   * @return SUCCESS if the information will be updated
   */
  command error_t update(flashnode_t *focusedNode);
  
  /**
   * Recover a node's dataLength and dataCrc
   * from the Checkpoint.
   *
   * If the flashnode_t cannot be recovered, it is deleted.
   *
   * @param focusedNode - the flashnode_t to recover, with client set to its element number
   * @return SUCCESS if recovery will proceed
   */
  command error_t recover(flashnode_t *focusedNode);
  
  
  /**
   * The checkpoint file was opened.
   * @param error - SUCCESS if it was opened successfully
   */
  event void checkpointOpened(error_t error);
  
  /**
   * The given flashnode_t was updated in the Checkpoint
   * @param focusedNode - the flashnode_t that was updated
   * @param error - SUCCESS if everything's ok
   */
  event void updated(flashnode_t *focusedNode, error_t error);
  
  /** 
   * A flashnode_t was recovered.
   * @param error - SUCCESS if it was recovered correctly.
   *                 FAIL if it should be deleted.
   */
  event void recovered(flashnode_t *recoveredNode, error_t error);
  
}



