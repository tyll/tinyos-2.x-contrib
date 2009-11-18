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
 * NLME_NETWORK_FORMATION
 * Zigbee-2007
 * Sect. 3.2.2.3, 3.2.2.4 and 3.6.1.1
 */
#include "Nwk.h"

interface NLME_NETWORK_FORMATION {
  /**
   * This primitive allows the next higher layer to request that the device
   * start a new ZigBee network with itself as the coordinator and subsequently
   * make changes to its superframe configuration.
   * @param ScanChannels    The five most significant bits (b27,...,b31) are
   *                        reserved. The 27 least significant bits (b0,b1,
   *                        ...b26) indicate which channels are to be scanned
   *                        in preparation for starting a network (1 = scan,
   *                        0 = do not scan) for each of the 27 valid channels.
   * @param ScanDuration    Value used to calculate the time to spend scanning
   *                        each channel: The time spent scanning each channel
   *                        is (aBaseSuperframeDuration * (2^n + 1)) symbols,
   *                        where n is the value of the ScanDuration parameter.
   * @param BeaconOrder     The beacon order of the network to form.
   * @param SuperframeOrder The superframe order of the network to form.
   * @param BatteryLifeExtension If this value is TRUE, the NLME will request
   *                             that the ZigBee coordinator is started
   *                             supporting battery life extension mode; If
   *                             this value is FALSE, the NLME will request
   *                             that the ZigBee coordinator is started without
   *                             supporting battery life extension mode.
   * @param BufferSize      The size in octects of Buffer.
   * @param Buffer          An empty buffer (allocated by the caller) to store
   *                        the result of the scans
   * @param 
   */
  command void request(
		       uint32_t ScanChannels,
		       uint8_t ScanDuration,
		       uint8_t BeaconOrder,
		       uint8_t SuperframeOrder,
		       bool BatteryLifeExtension
		       //uint16_t BufferSize,
		       //uint8_t* Buffer
		       );
  
  /**
   * This primitive reports the results of the request to initialize a ZigBee
   * coordinator in a network.
   * @param Status The result of the attempt to initialize a ZigBee coordinator.
   */
  event void confirm(
		     nwk_status_t Status
		     );
}