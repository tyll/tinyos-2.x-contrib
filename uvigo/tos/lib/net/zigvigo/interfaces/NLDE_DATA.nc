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
 * NLDE_DATA
 * Zigbee-2007
 * Sect. 3.2.1
 */
#include "Nwk.h"

interface NLDE_DATA {
  /**
   * This primitive requests the transfer of a data PDU (NSDU) from the local
   * APS sub-layer entity to a single or multiple peer APS sub-layer entities.
   * @param DstAddrMode     The type of destination address supplied by the
   *                        DstAddr parameter. One of the following two values:
   *                        0x01 = 16-bit multicast group address
   *                        0x02 = 16-bit network address of a device or a
   *                        16-bit broadcast address
   * @param DstAddr         Destination address.
   * @param NsduLength      The number of octets comprising the NSDU to be
   *                        transferred. This has been modified from the
   *                        aMaxMACFrameSize limit specified in the IEEE
   *                        802.15.4 specification to take into account that
   *                        the ZigBee network layer does not use the extended
   *                        addressing modes. The effect of this is to free the
   *                        unused portion of the header used for payload.
   * @param Nsdu            The set of octets of the NSDU to be transferred.
   * @param NsduHandle      The handle associated with the NSDU to be
   *                        transmitted by the NWK layer entity.
   * @param Radius          The distance, in hops, that a frame will be allowed
   *                        to travel through the network.
   * @param NonmemberRadius The distance, in hops, that a multicast frame will
   *                        be relayed by nodes not a member of the group. A
   *                        value of 0x07 is treated as infinity.
   * @param DiscoverRoute   This parameter may be used to control route
   *                        discovery operations for the transit of this frame:
   *                        0x00 = suppress route discovery
   *                        0x01 = enable route discovery
   * @param SecurityEnable  This parameter may be used to enable NWK layer
   *                        security processing for the current frame. If the
   *                        nwkSecurityLevel attribute of the NIB is 0, meaning
   *                        no security, then this parameter will be ignored.
   *                        Otherwise, a value of TRUE denotes that the
   *                        security processing specified by the security level
   *                        will be applied, and a value of FALSE denotes that
   *                        no security processing will be applied.
   */
  command void request(
		       uint8_t DstAddrMode,
		       uint16_t DstAddr,
		       uint8_t NsduLength,
		       uint8_t* Nsdu,
		       uint8_t NsduHandle,
		       uint8_t Radius,
		       uint8_t NonmemberRadius,
		       uint8_t DiscoverRoute,
		       bool SecurityEnable
		       );

  /**
   * This primitive indicates the transfer of a data PDU (NSDU) from the NWK
   * layer to the local APS sub-layer entity.
   * @param DstAddrMode The type of destination address supplied by the DstAddr
   *                    parameter. One of the following two values:
   *                    0x01 = 16-bit multicast group address
   *                    0x02 = 16-bit network address of a device or a 16-bit
   *                    broadcast address
   * @param DstAddr     The destination address to which the NSDU was sent.
   * @param SrcAddr     The individual device address from which the NSDU
   *                    originated.
   * @param NsduLength  The number of octets comprising the NSDU to be
   *                    transferred. This has been modified from the
   *                    aMaxMACFrameSize limit specified in the IEEE 802.15.4
   *                    specification to take into account that the Zigbee
   *                    network layer does not use the extended addressing
   *                    modes. The effect of this is to free the unused portion
   *                    of the header used for payload.
   * @param Nsdu        The set of octets of the NSDU to be transferred.
   * @param LinkQuality The link quality indication delivered by the MAC on
   *                    receipt of this frame as a parameter of the
   *                    MCPS-DATA.indication primitive.
   * @param RxTime      A time indication for the received packet based on the
   *                    local clock. The time should be based on the same point
   *                    for each received packet on a given implementation.
   *                    This value is only provided if nwkTimeStamp is TRUE.
   * @param SecurityUse An indication of whether the received data frame is
   *                    using security. This value is set to TRUE if security
   *                    was applied to the received frame or FALSE if the
   *                    received frame was unsecured.
   */
  event void indication(
			uint8_t DstAddrMode,
			uint16_t DstAddr,
			uint16_t SrcAddr,
			uint8_t NsduLength,
			uint8_t *Nsdu,
			uint8_t LinkQuality,
			uint32_t RxTime,
			bool SecurityUse
			);
  /**
   * This primitive reports the results of a request to transfer a data PDU
   * (NSDU) from a local APS sub-layer entity to a single peer APS sub-layer
   * entity.
   * @param Status     The status of the corresponding request.
   * @param NsduHandle The handle associated with the NSDU being confirmed.
   * @param TxTime     A time indication for the transmitted packet based on
   *                   the local clock. The time should be based on the same
   *                   point for each transmitted packet in a given
   *                   implementation. This value is only provided if
   *                   nwkTimeStamp is set to TRUE.
   */
  event void confirm(
		     nwk_status_t Status,
		     uint8_t NsduHandle,
		     uint32_t TxTime
		     );
}