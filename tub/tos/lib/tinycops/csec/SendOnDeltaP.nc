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
#include "Attributes.h"
module SendOnDeltaP {
  provides interface Get<uint32_t> as GetNumDropped;
  uses {
     interface NotificationFilter<CSEC_OUTBOUND> as NotificationFilterOut;
     interface PSMessageAccess;
     interface Leds;
  }
} implementation {
  enum {
    MAX_VALUE_SIZE = sizeof(nx_uint32_t),
    MAX_SIZE = sizeof(avpair_t) + MAX_VALUE_SIZE,
  };
  bool init = TRUE;
  uint8_t buf[MAX_SIZE];
  avpair_t *lastAVPair = (avpair_t *) buf;
  uint32_t numDropped = 0;

  event bool NotificationFilterOut.forward(notification_handle_t nHandle, subscription_handle_t sHandle, bool ignored)
  {
    // note: this currently supports only one subscriber
    uint8_t valueSize;
    nx_uint16_t *diff;
    avpair_t *avpair;
    avpair_t *metadata;
    bool forward = TRUE; // forward !

    metadata = call PSMessageAccess.getMetadataViaId(sHandle, ATTRIBUTE_SEND_ON_DELTA, 0);
    if (metadata){
      attribute_id_t id = *((nx_uint16_t*) (metadata->value));
      diff = (nx_uint16_t*) metadata->value;
      diff += 1;
      avpair = call PSMessageAccess.getAttributeViaId(nHandle, id, &valueSize);
      if (!avpair)
        return TRUE;
      if (valueSize > MAX_VALUE_SIZE || *diff == 0)
        return TRUE;

      if (init){
        memcpy(lastAVPair, avpair, MAX_SIZE);
        init = FALSE;
      } else {
        
        forward = FALSE; // only forward if diff is bigger than delta
        call Leds.led0Toggle();
        switch (valueSize)
        {
          case 1: 
            {
              nx_uint8_t valueOld, valueNew;
              valueOld = lastAVPair->value[0];
              valueNew = avpair->value[0]; 
              if (valueOld > valueNew){
                if (valueOld - valueNew > *diff)
                  forward = TRUE; 
              } else {
                if (valueNew - valueOld > *diff)
                  forward = TRUE;
              }
            }
            break;
          case 2: 
            {
              nx_uint16_t valueOld, valueNew;
              valueOld = *((nx_uint16_t*) (lastAVPair->value));
              valueNew = *((nx_uint16_t*) (avpair->value));
              call Leds.led0Toggle();
              if (valueOld > valueNew){
                if (valueOld - valueNew > *diff)
                  forward = TRUE; // forward !
              } else {
                if (valueNew - valueOld > *diff)
                  forward = TRUE;
              }
            }
            break;
          case 4: 
            {
              nx_uint32_t valueOld, valueNew;
              valueOld = *((nx_uint32_t*) (lastAVPair->value));
              valueNew = *((nx_uint32_t*) (avpair->value));
              if (valueOld > valueNew){
                if (valueOld - valueNew > *diff)
                  forward = TRUE;
              } else {
                if (valueNew - valueOld > *diff)
                  forward = TRUE;
              }
            }
            break;
          default:
            return TRUE;
        }
      }
      if (forward == TRUE){
        // forward (update last sent value)
        memcpy(lastAVPair, avpair, MAX_SIZE);
      } else {
        numDropped++;
        call Leds.led1Toggle();
      }

    }
    return forward;
  }

  command uint32_t GetNumDropped.get(){
    return numDropped;
  }
}
