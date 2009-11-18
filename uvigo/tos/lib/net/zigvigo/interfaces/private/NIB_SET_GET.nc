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
 * NIB_SET_GET
 */
#include "Nwk.h"

interface NIB_SET_GET {
  /**
   * This primitives allow the Network layer to read/write the value of custom
   * attributes from the NIB.
   */

  /** bool joined tells us if the node is already joined to a network*/
  command bool getJoined();
  command void setJoined(bool value);

  /** Returns an incremented nwkSequenceNumber from the NIB */
  command nwkSequenceNumber_t getNwkSequenceNumber();

  /** nwk_device_type_t device_type tells us what role has the node */
  command nwk_device_type_t getDeviceType();
  command void setDeviceType(nwk_device_type_t value);

  /** uint8_t LogicalChannel tells us which is the channel being used */
  command uint8_t getLogicalChannel();
  command void setLogicalChannel(uint8_t value);

  /** uint8_t RouterChilds tell us how many routers are already joined */
  command uint8_t getRouterChilds();
  command void setRouterChilds(uint8_t value);
  command void decRouterChilds();
  command void incRouterChilds();

  /** uint8_t EndDeviceChilds tell us how many End Devices are already joined */
  command uint8_t getEndDeviceChilds();
  command void setEndDeviceChilds(uint8_t value);
  command void decEndDeviceChilds();
  command void incEndDeviceChilds();

  /** Commands for setting attributes according to role */
  command void setIamCoordinator(uint8_t LogicalChannel);
  command void setIamRouter(uint8_t LogicalChannel);
  command void setIamEndDevice(uint8_t LogicalChannel);

  /** Commands for managing the Neighbor Table */
  //  command void addNeighbourTableBeacon(message_t* beaconFrame);
  //  command void addNeighbourTableBeacon(nwk_NetworkDescriptor_t* nd,
  //				       ieee154_PANDescriptor_t* pd);
  command void addNTBeacon(message_t* beaconFrame, ieee154_PANDescriptor_t* pd);
  command uint8_t searchSuitableParent(uint64_t ExtendedPANId);
  command void notSuitableParent(uint8_t i);
  command uint8_t searchNeighbor(uint64_t ExtendedAddress);
  command uint8_t searchNeighborOn(uint16_t ShortAddress, bool* isOnWhenIdle);
  command void freeNeighbor(uint8_t i);
  command uint8_t searchFreeNeighbor();
  command uint16_t searchParentNwkAddress();

  /** Command for setting NIB's nwkCapabilityInformation attribute.
   *  It is Read Only, so we do not edit it through NLME_SET */
  command void setNwkCapabilityInformation(nwkCapabilityInformation_t value);

  /** uint8_t Depth tells us which is this node's depth */
  command uint8_t getDepth();
  command void setDepth(uint8_t value);

  /** Commands for obtaining the Address for a device trying to associate */
  command uint16_t getAssocAddressRouter();
  command uint16_t getAssocAddressEndDevice();

  /** Command for calculation CSKIP based on the nwkMaxDepth, nwkMaxChildren
      and nwkMaxRouters in the NIB */
  command uint16_t getCskip(uint8_t depth);

  /** Command for clearing the routing table and the route discovery table and
      issue an MLME_RESET.request primitive to the MAC sublayer. It will also
      set the relationship field of the neighbor table entry corresponding to
      its former parent to 0x03, indicating no relationship. */
  command void ownLeaveDone();
  command void childLeaveDone(uint8_t i_leaving);
  command bool otherLeaveDone(uint16_t leaving_addr);
  
}