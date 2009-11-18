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
 * NLME_GET
 * Zigbee-2007
 * Sect. 3.2.2.26 and 3.2.2.27
 */
#include "Nwk.h"

interface NLME_GET {
  /**
   * This primitives allow the next higher layer to read the value of an
   * attribute from the NIB. Instead of passing the NIB attribute identifier,
   * there is a separate command per attribute (and no confirm events).
   */

  /** @return NIB attribute nwkPANId (0x80) */
  command nwkPANId_t nwkPANId();

  /** @return NIB attribute nwkSequenceNumber (0x81) */
  command nwkSequenceNumber_t nwkSequenceNumber();

  /** @return NIB attribute nwkPassiveAckTimeout (0x82) */
  command nwkPassiveAckTimeout_t nwkPassiveAckTimeout();

  /** @return NIB attribute nwkMaxBroadcastRetries (0x83) */
  command nwkMaxBroadcastRetries_t nwkMaxBroadcastRetries();

  /** @return NIB attribute nwkMaxChildren (0x84) */
  command nwkMaxChildren_t nwkMaxChildren();

  /** @return NIB attribute nwkMaxDepth (0x85) */
  command nwkMaxDepth_t nwkMaxDepth();

  /** @return NIB attribute nwkMaxRouters (0x86) */
  command nwkMaxRouters_t nwkMaxRouters();

  /** @return NIB attribute nwkNeighborTable (0x87) */
  command nwkNeighborTable_t* nwkNeighborTable();//***

  /** @return NIB attribute nwkNetworkBroadcastDeliveryTime (0x88) */
  command nwkNetworkBroadcastDeliveryTime_t nwkNetworkBroadcastDeliveryTime();

  /** @return NIB attribute nwkReportConstantCost (0x89) */
  command nwkReportConstantCost_t nwkReportConstantCost();

  /** @return NIB attribute nwkRouteDiscoveryRetriesPermitted (0x8A) */
  command nwkRouteDiscoveryRetriesPermitted_t nwkRouteDiscoveryRetriesPermitted();

  /** @return NIB attribute nwkRouteTable (0x8B) */
  command nwkRouteTable_t* nwkRouteTable();//***

  /** @return NIB attribute nwkTimeStamp (0x8C) */
  command nwkTimeStamp_t nwkTimeStamp();

  /** @return NIB attribute nwkTxTotal (0x8D) */
  command nwkTxTotal_t nwkTxTotal();

  /** @return NIB attribute nwkSymLink (0x8E) */
  command nwkSymLink_t nwkSymLink();

  /** @return NIB attribute nwkCapabilityInformation (0x8F) */
  command nwkCapabilityInformation_t nwkCapabilityInformation();

  /** @return NIB attribute nwkAddrAlloc (0x90) */
  command nwkAddrAlloc_t nwkAddrAlloc();

  /** @return NIB attribute nwkUseTreeRouting (0x91) */
  command nwkUseTreeRouting_t nwkUseTreeRouting();

  /** @return NIB attribute nwkManagerAddr (0x92) */
  command nwkManagerAddr_t nwkManagerAddr();

  /** @return NIB attribute nwkMaxSourceRoute (0x93) */
  command nwkMaxSourceRoute_t nwkMaxSourceRoute();

  /** @return NIB attribute nwkUpdateId (0x94) */
  command nwkUpdateId_t nwkUpdateId();

  /** @return NIB attribute nwkTransactionPersistenceTime (0x95) */
  command nwkTransactionPersistenceTime_t nwkTransactionPersistenceTime();

  /** @return NIB attribute nwkNetworkAddress (0x96) */
  command nwkNetworkAddress_t nwkNetworkAddress();

  /** @return NIB attribute nwkStackProfile (0x97) */
  command nwkStackProfile_t nwkStackProfile();

  /** @return NIB attribute nwkBroadcastTransactionTable (0x98) */
  command nwkBroadcastTransactionTable_t* nwkBroadcastTransactionTable();//***

  /** @return NIB attribute nwkGroupIDTable (0x99) */
  command nwkGroupIDTable_t* nwkGroupIDTable();//***

  /** @return NIB attribute nwkExtendedPANId (0x9A) */
  command nwkExtendedPANId_t nwkExtendedPANId();

  /** @return NIB attribute nwkUseMulticast (0x9B) */
  command nwkUseMulticast_t nwkUseMulticast();

  /** @return NIB attribute nwkRouteRecordTable (0x9C) */
  command nwkRouteRecordTable_t* nwkRouteRecordTable();//***

  /** @return NIB attribute nwkIsConcentrator (0x9D) */
  command nwkIsConcentrator_t nwkIsConcentrator();

  /** @return NIB attribute nwkConcentratorRadius (0x9E) */
  command nwkConcentratorRadius_t nwkConcentratorRadius();

  /** @return NIB attribute nwkConcentratorDiscoveryTime (0x9F) */
  command nwkConcentratorDiscoveryTime_t nwkConcentratorDiscoveryTime();

  /** @return NIB attribute nwkSecurityLevel (0xA0) */
  command nwkSecurityLevel_t nwkSecurityLevel();//***

  /** @return NIB attribute nwkSecurityMaterialSet (0xA1) */
  //command nwkSecurityMaterialSet_t nwkSecurityMaterialSet();//***

  /** @return NIB attribute nwkActiveKeySeqNumber (0xA2) */
  //command nwkActiveKeySeqNumber_t nwkActiveKeySeqNumber();//***

  /** @return NIB attribute nwkAllFresh (0xA3) */
  //command nwkAllFresh_t nwkAllFresh();//***

  /** @return NIB attribute nwkSecureAllFrames (0xA5) */
  //command nwkSecureAllFrames_t nwkSecureAllFrames();//***

  /** @return NIB attribute nwkLinkStatusPeriod (0xA6) */
  command nwkLinkStatusPeriod_t nwkLinkStatusPeriod();

  /** @return NIB attribute nwkRouterAgeLimit (0xA7) */
  command nwkRouterAgeLimit_t nwkRouterAgeLimit();

  /** @return NIB attribute nwkUniqueAddr (0xA8) */
  command nwkUniqueAddr_t nwkUniqueAddr();

  /** @return NIB attribute nwkAddressMap (0xA9) */
  command nwkAddressMap_t* nwkAddressMap();//***

  /*  command nwk_status_t request(
			  uint8_t NIBAttribute
			  );

  event void confirm(
			nwk_status_t Status,
			uint8_t NIBAttribute,
			uint16_t NIBAttributeLength,
			uint8_t NIBAttriabuteValue
			);*/
}