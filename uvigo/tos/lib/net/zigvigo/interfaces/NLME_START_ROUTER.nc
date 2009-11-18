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
 * NLME_START_ROUTER
 * Zigbee-2007
 * Sect. 3.2.2.7 and 3.2.2.8
 */
#include "Nwk.h"

interface NLME_START_ROUTER {
  /**
   * This primitive allows the next higher layer of a ZigBee router to initiate
   * the activities expected of a ZigBee router including the routing of data
   * frames, route discovery, and the accepting of requests to join the network
   * from other devices.
   * @param BeaconOrder          The beacon order of the network to form.
   * @param SuperframeOrder      The superframe order of the network to form.
   * @param BatteryLifeExtension If this value is TRUE, the NLME will request
   *                             that the ZigBee coordinator is started
   *                             supporting battery life extension mode; If
   *                             this value is FALSE, the NLME will request
   *                             that the ZigBee coordinator is started without
   *                             supporting battery life extension mode.
   */
  command void request(
		       uint8_t BeaconOrder,
		       uint8_t SuperframeOrder,
		       bool BatteryLifeExtension
		       );
  
  /**
   * This primitive reports the results of the request to initialize a router.
   * @param Status The result of the attempt to initialize a ZigBee router.
   */
  event void confirm(
		     nwk_status_t Status
		     );
}