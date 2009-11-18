/*
* Copyright (c) 2009 GTI/TC-1 Research Group.  Universidade de Vigo.
*                    Gradiant (www.gradiant.org)
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
* - Neither the name of Universidade de Vigo nor the names of its
*   contributors may be used to endorse or promote products derived
*   from this software without specific prior written permission.
*
* THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
* ``AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
* LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
* FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL STANFORD
* UNIVERSITY OR ITS CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
* INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
* (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
* SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
* HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
* STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
* ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
* OF THE POSSIBILITY OF SUCH DAMAGE.
*
* - Revision -------------------------------------------------------------
* $Revision$
* $Date$
* @author Daniel F. Piñeiro-Santos <danips@enigma.det.uvigo.es>
* @author Felipe Gil-Castiñeira <xil@det.uvigo.es>
* @author David Chaves-Diéguez <dchaves@gradiant.org>
* ========================================================================
*/

/**
 * NLME_RESET
 * Zigbee-2007
 * Sect. 3.2.2.19, 3.2.2.20, 3.2.2.21 and 3.6.1.12
 */
#include "Nwk.h"

interface NLME_RESET {
  /**
   * This primitive allows the next higher layer to request the NWK layer to
   * perform a reset operation.
   *
   * @param WarmStart This parameter has a value of FALSE if the request is
   *                  expected reset all stack values to their initial default
   *                  values. If this value is TRUE, the device is expected to
   *                  resume operations according to the NIB settings prior to
   *                  the call.
   */
  command void request(
		       bool WarmStart
		       );

  /**
   * This primitive allows the next higher layer of the initiating device to be
   * notified of the results of the request to reset the NWK layer
   *
   * @param Status The result of the reset operation
   */
  event void confirm(
		     nwk_status_t Status
		     );
}

