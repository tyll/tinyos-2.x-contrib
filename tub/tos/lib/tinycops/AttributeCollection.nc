/*
 * Copyright (c) 2007, Technische Universitaet Berlin
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 * - Redistributions of source code must retain the above copyright notice,
 *   this list of conditions and the following disclaimer.
 * - Redistributions in binary form must reproduce the above copyright
 *   notice, this list of conditions and the following disclaimer in the
 *   documentation and/or other materials provided with the distribution.
 * - Neither the name of the Technische Universitaet Berlin nor the names
 *   of its contributors may be used to endorse or promote products derived
 *   from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
 * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
 * OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
 * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED
 * TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA,
 * OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY
 * OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE
 * USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 *
 * - Revision -------------------------------------------------------------
 * $Revision$
 * $Date$
 * @author: Jan Hauer <hauer@tkn.tu-berlin.de>
 * ========================================================================
 */

#include "TinyCOPS.h" 
interface AttributeCollection 
{ 
  /**
   * Checks whether an attribute is registered in the attribute collector.
   *
   * @param attributeID     the attribute identifier
   * @return                TRUE, if the attribute is present, FALSE otherwise 
   */  
  command bool isRegisteredAttribute(attribute_id_t attributeID);

  /**
   * Returns the length of the value of a registered attribute or 255 if
   * no attribute is registered with the given ID.
   *
   * @param attributeID     the attribute identifier
   * @return                value size if the attribute is present, 255 otherwise 
   */ 
  command uint8_t getValueSize(attribute_id_t attributeID);

  /**
   * Determines the matching between a single constraint and attribute-value pair.
   *
   * @param avpair     the attribute value pair
   * @param constraint the constraint
   * @return           TRUE, if the constraint is matched, FALSE otherwise 
   */ 
  command bool isMatching(avpair_t *avpair, constraint_t* constraint);

  /**
   * Gets an attribute from the attribute collector.
   *
   * @param attributeID     the attribute identifier
   * @param avpair          a pointer to the attribute value pair (will be written)
   * @param maxValueSize    the maximum size of the value portion in the passed avpair
   * @param handle          a handle to a subscription that the publisher is trying
   *                        to answer or NULL if the publisher is not answering to
   *                        a specific subscription (in the last case ASECs are disabled
   *                        for this call)
   * @return                SUCCESS, if the the command was accepted and getAttributeDone
   *                        will be signalled, FAIL otherwise (getAttributeDone will not
   *                        be signalled)
   */ 
  command error_t getAttribute(attribute_id_t attributeID, avpair_t *avpair, uint8_t maxValueSize, subscription_handle_t handle);

  /**
   * Signalled in response to a getAttribute call.
   *
   * @param attributeID     the attribute identifier 
   * @param avpair          a pointer to the previously passed attribute value pair
   * @param handle          the handle (or NULL) as passed in the previous getAttribute call
   * @param error           SUCCESS, if the the attribute was written, FAIL otherwise 
   */ 
  event void getAttributeDone(avpair_t *avpair, uint8_t valueSize, subscription_handle_t handle, error_t result);
}
