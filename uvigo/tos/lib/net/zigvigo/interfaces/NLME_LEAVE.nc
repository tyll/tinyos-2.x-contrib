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
 * NLME_LEAVE
 * Zigbee-2007
 * Sect. 3.2.2.16, 3.2.2.17, 3.2.2.18 and 3.6.1.10
 */
#include "Nwk.h"

interface NLME_LEAVE {
  /**
   * This primitive allows the next higher layer to request that it or another
   * device leaves the network.
   * @param DeviceAddress  The 64-bit IEEE address of the entity to be removed
   *                       from the network or NULL if the device removes
   *                       itself from the network.
   * @param RemoveChildren This parameter has a value of TRUE if the device
   *                       being asked to leave the network is also being asked
   *                       to remove its child devices, if any. Otherwise, it
   *                       has a value of FALSE.
   * @param Rejoin         This parameter has a value of TRUE if the device
   *                       being asked to leave from the current parent is
   *                       requested to rejoin the network. Otherwise, the
   *                       parameter has a value of FALSE.
   */
  command void request(
		       uint64_t DeviceAddress,
		       bool RemoveChildren,
		       bool Rejoin
		       );
  
  /**
   * This primitive allows the next higher layer of a ZigBee device to be
   * notified if that ZigBee device has left the network or if a neighboring
   * device has left the network.
   * @param DeviceAddress The 64-bit IEEE address of an entity that has removed
   *                      itself from the network or NULL in the case that the
   *                      device issuing the primitive has been removed from
   *                      the network by its parent.
   * @param Rejoin        This parameter has a value of TRUE if the device
   *                      being asked to leave the current parent is requested
   *                      to rejoin the network. Otherwise, this parameter has
   *                      a value of FALSE.
   */
  event void indication(
			uint64_t DeviceAddress,
			bool Rejoin
			);

  /**
   * This primitive allows the next higher layer of the initiating device to be
   * notified of the results of its request for itself or another device to
   * leave the network.
   * @param Status        The status of the corresponding request.
   * @param DeviceAddress The 64-bit IEEE address in the request to which this
   *                      is a confirmation or null if the device requested to
   *                      remove itself from the network.
   */
  event void confirm(
		     nwk_status_t Status,
		     uint64_t DeviceAddress
		     );
}