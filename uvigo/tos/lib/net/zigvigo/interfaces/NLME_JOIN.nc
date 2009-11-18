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
 * NLME_JOIN
 * Zigbee-2007
 * Sect. 3.2.2.11, 3.2.2.12 and 3.6.1.4
 */
#include "Nwk.h"

interface NLME_JOIN {
  /**
   * This primitive allows the next higher layer to request to join or rejoin a
   * network, or to change the operating channel for the device while within an
   * operating network.
   * @param ExtendedPANId  The 64-bit PAN identifier of the network to join.
   * @param RejoinNetwork  This parameter controls the method of joining.
   *                       0x00 if requesting to join through association.
   *                       0x01 if joining directly or rejoining using
   *                       the orphaning procedure.
   *                       0x02 if joining using the NWK rejoining procedure.
   *                       0x03 if it is to change the operational channel to
   *                       that identified in the ScanChannels parameter.
   * @param ScanChannels   The five most significant bits (b27,...,b31) are
   *                       reserved. The 27 least significant bits (b0,b1,
   *                       ...b26) indicate which channels are to be scanned
   *                       (1 = scan, 0 = do not scan) for each of the 27 valid
   *                       channels.
   * @param ScanDuration   A value used to calculate the time to spend scanning
   *                       each channel: The time spent scanning each channel
   *                       is (aBaseSuperframeDuration * (2^n + 1)) symbols,
   *                       where n is the value of the ScanDuration parameter.
   * @param CapabilityInformation The operating capabilities of the device
   *                              being directly joined.
   * @param SecurityEnable If the value of RejoinNetwork is 0x02 and this is
   *                       TRUE than the device will try to rejoin securely.
   *                       Otherwise, this is set to FALSE.
   */
  command void request(
		       uint64_t ExtendedPANId,
		       uint8_t RejoinNetwork,
		       uint32_t ScanChannels,
		       uint8_t ScanDuration,
		       nwkCapabilityInformation_t CapabilityInformation,
		       bool SecurityEnable
		       );
  
  /**
   * This primitive allows the next higher layer of a ZigBee coordinator or
   * ZigBee router to be notified when a new device has successfully joined its
   * network by association or rejoined using the NWK rejoin procedure as
   * described in sub-clause 3.6.1.4.3.
   * @param NetworkAddress  The network address of an entity that has been
   *                        added to the network.
   * @param ExtendedAddress The 64-bit IEEE address of an entity that has been
   *                        added to the network.
   * @param CapabilityInformation Specifies the operational capabilities of the
   *                              joining device.
   * @param RejoinNetwork   This parameter indicates the method of joining.
   *                        0x00 if joined through association.
   *                        0x01 if joined directly or rejoined using orphaning
   *                        0x02 if joined using the NWK rejoining procedure.
   * @param SecureRejoin    This parameter will be TRUE if the rejoin was
   *                        performed in a secure manner. Otherwise, this
   *                        parameter will be FALSE.
   */
  event void indication(
			uint16_t NetworkAddress,
			uint64_t ExtendedAddress,
			ieee154_CapabilityInformation_t CapabilityInformation,
			uint8_t RejoinNetwork,
			bool SecureRejoin
			);

  /**
   * This primitive allows the next higher layer to be notified of the results
   * of its request to join a network.
   * @param Status         The status of the corresponding request.
   * @param NetworkAddress The 16-bit network address that was allocated to
   *                       this device. This parameter will be equal to 0xffff
   *                       if the join attempt was unsuccessful.
   * @param ExtendedPANId  The 64-bit extended PAN identifier for the network
   *                       of which the device is now a member.
   * @param ActiveChannel  The value of phyCurrentChannel attribute of the PHY
   *                       PIB, which is equal to the current channel of the
   *                       network that has been joined.
   */
  event void confirm(
		     nwk_status_t Status,
		     uint16_t NetworkAddress,
		     uint64_t ExtendedPANId,
		     uint8_t ActiveChannel
		     );
}