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

/** 
 * This interface is used and provided by Attribute Service Extension
 * Components (ASECs). An ASEC can intercept requests for attribute data from
 * the application to the Attribute Collector. When an ASEC is present, an
 * application's request for data (via the AttributeCollection interface) is
 * forwarded to the ASEC before the actual attribute component is queried - if
 * there are multiple ASECs they must be arranged in a chain. If an ASEC can
 * serve the request for attribute data, it may return SUCCESS on the
 * getAttribute() call; then it MUST also signal a getAttributeDone() event. If
 * it cannot serve a request, it MUST forward the getAttribute() call to the
 * next ASEC in the chain, where the AttributeCollectorP is always the last
 * element in the chain. On the reverse path, every ASEC MUST forward the
 * getAttributeDone() event which is initially signalled by
 * AttributeCollectorP, but it may modify the content of attribute value,
 * depending on the metadata in the corresponding subscription.
 */

#include "TinyCOPS.h"
interface AttributeIntercept 
{ 
  /**
   * The application has requested an attribute value and the ASEC may
   * serve this request.
   *
   * @param avpair          the attribute value pair (attribute ID is present,
   *                        attribute value is requested, i.e. empty)
   * @param maxValueSize    maximum size for the attribute value
   * @param subscription    the subscription the publisher is trying to serve (may be NULL!)
   * @return                SUCCESS, if it can be served, then a getAttributeDone
   *                        must be signalled, the return value from the next
   *                        ASEC otherwise.
   */  
  command error_t getAttribute(avpair_t *avpair, 
      uint8_t maxValueSize, subscription_handle_t subscription);

  /**
   * Signalled in return to a getAttribute request.
   *
   * @param avpair          the attribute value pair
   * @param size            attribute value size
   * @param result          SUCCESS means, attribute value is valid, FAIL means it was not
   * @param subscription    the subscription the publisher is trying to serve (may be NULL!)
   */  
  event void getAttributeDone(avpair_t *avpair, uint8_t size, error_t result, 
      subscription_handle_t subscription);
}
