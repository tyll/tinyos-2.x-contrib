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
 * NLME_ROUTE_DISCOVERY
 * Zigbee-2007
 * Sect. 3.2.2.31, 3.2.2.32 and 3.6.3.5
 */
#include "Nwk.h"

interface NLME_ROUTE_DISCOVERY {
  /**
   * This primitive allows the next higher layer to initiate route discovery.
   * @param DstAddrMode  A parameter specifying the kind of destination address
   *                     provided. The DstAddrMode parameter may take one of
   *                     the following three values:
   *                     0x00 = No destination address
   *                     0x01 = 16-bit network address of a multicast group
   *                     0x02 = 16-bit network address of an individual device
   * @param DstAddr      The destination of the route discovery.
   *                     If the DstAddrMode parameter has a value of 0x00 then
   *                     no DstAddr will be supplied. This indicates that the
   *                     route discovery will be a many-to-one discovery with
   *                     the device issuing the discovery command as a target.
   *                     If the DstAddrMode parameter is 0x01, indicating
   *                     multicast route discovery then the destination will be
   *                     the 16-bit network address of a multicast group.
   *                     If the DstAddrMode parameter is 0x02, this indicates
   *                     unicast route discovery. The DstAddr will be the
   *                     16-bit network address of a device to be discovered.
   * @param Radius       This optional parameter describes the number of hops
   *                     that the route request will travel through the network.
   * @param NoRouteCache In the case DstAddrMode has a zero value, indicating
   *                     many-to-one route discovery, this flag determines
   *                     whether the NWK should establish a route record table.
   *                     TRUE = no route record table should be established
   *                     FALSE = establish a route record table
   */
  command void request(
		       uint8_t DstAddrMode,
		       uint16_t DstAddr,
		       uint8_t Radius,
		       bool NoRouteCache
		       );

  /**
   * This primitive informs the next higher layer about the results of an
   * attempt to initiate route discovery.
   * @param Status            Status of an attempt to initiate route discovery.
   * @param NetowrkStatusCode In the case where the Status parameter has a
   *                          value of ROUTE_ERROR, this code gives further
   *                          information about the kind of error that
   *                          occurred. Otherwise, it should be ignored.
   */
  event void confirm(
		     nwk_status_failure_t Status,
		     uint8_t NetworkStatusCode
		     );
}