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
 * NLME_SET
 * Zigbee-2007
 * Sect. 3.2.2.28 and 3.2.2.29
 */
#include "Nwk.h"

interface NLME_SET {
  /**
   * This primitives allow the next higher layer to write the value of an
   * attribute into the NIB. Instead of passing the NIB attribute identifier,
   * there is a separate command per attribute (and no confirm events).
   */


  /** @param value new NIB attribute value for nwkPANId (0x80)
   *  @returns NWK_SUCCESS if NIB attribute was updated */
  command nwk_status_t nwkPANId(nwkPANId_t value);

  /** @param value new NIB attribute value for nwkSequenceNumber (0x81)
   *  @returns NWK_UNSUPPORTED_ATTRIBUTE, this is a read only attribute */
  command nwk_status_t nwkSequenceNumber(nwkSequenceNumber_t value);

  /** @param value new NIB attribute value for nwkPassiveAckTimeout (0x82)
   *  @returns NWK_SUCCESS if NIB attribute was updated, NWK_INVALID_PARAMETER
   *                       if parameter value is out of valid range and NIB was
   *                       not updated */
  command nwk_status_t nwkPassiveAckTimeout(nwkPassiveAckTimeout_t value);

  /** @param value new NIB attribute value for nwkMaxBroadcastRetries (0x83)
   *  @returns NWK_SUCCESS if NIB attribute was updated, NWK_INVALID_PARAMETER
   *                       if parameter value is out of valid range and NIB was
   *                       not updated */
  command nwk_status_t nwkMaxBroadcastRetries(nwkMaxBroadcastRetries_t value);

  /** @param value new NIB attribute value for nwkMaxChildren (0x84)
   *  @returns NWK_SUCCESS if NIB attribute was updated */
  command nwk_status_t nwkMaxChildren(nwkMaxChildren_t value);

  /** @param value new NIB attribute value for nwkMaxDepth (0x85)
   *  @returns NWK_UNSUPPORTED_ATTRIBUTE, this is a read only attribute */
  command nwk_status_t nwkMaxDepth(nwkMaxDepth_t value);

  /** @param value new NIB attribute value for nwkMaxRouters (0x86)
   *  @returns NWK_SUCCESS if NIB attribute was updated, NWK_INVALID_PARAMETER
   *                       if parameter value is out of valid range and NIB was
   *                       not updated */
  command nwk_status_t nwkMaxRouters(nwkMaxRouters_t value);

  /** @param value new NIB attribute value for nwkNeighborTable (0x87)
   *  @returns NWK_SUCCESS if NIB attribute was updated */
  command nwk_status_t nwkNeighborTable(nwkNeighborTable_t value);//***

  /** @param value new NIB attribute value for nwkNetworkBroadcastDeliveryTime (0x88)
   *  @returns NWK_SUCCESS if NIB attribute was updated */
  command nwk_status_t nwkNetworkBroadcastDeliveryTime(nwkNetworkBroadcastDeliveryTime_t value);

  /** @param value new NIB attribute value for nwkReportConstantCost (0x89)
   *  @returns NWK_SUCCESS if NIB attribute was updated, NWK_INVALID_PARAMETER
   *                       if parameter value is out of valid range and NIB was
   *                       not updated */
  command nwk_status_t nwkReportConstantCost(nwkReportConstantCost_t value);

  /** @param value new NIB attribute value for nwkRouteDiscoveryRetriesPermitted (0x8A)
   *  @returns NWK_SUCCESS if NIB attribute was updated, NWK_INVALID_PARAMETER
   *                       if parameter value is out of valid range and NIB was
   *                       not updated */
  command nwk_status_t nwkRouteDiscoveryRetriesPermitted(nwkRouteDiscoveryRetriesPermitted_t value);

  /** @param value new NIB attribute value for nwkRouteTable (0x8B)
   *  @returns NWK_SUCCESS if NIB attribute was updated */
  command nwk_status_t nwkRouteTable(nwkRouteTable_t value);//***

  /** @param value new NIB attribute value for nwkTimeStamp (0x8C)
   *  @returns NWK_SUCCESS if NIB attribute was updated */
  command nwk_status_t nwkTimeStamp(nwkTimeStamp_t value);

  /** @param value new NIB attribute value for nwkTxTotal (0x8D)
   *  @returns NWK_SUCCESS if NIB attribute was updated */
  command nwk_status_t nwkTxTotal(nwkTxTotal_t value);

  /** @param value new NIB attribute value for nwkSymLink (0x8E)
   *  @returns NWK_SUCCESS if NIB attribute was updated */
  command nwk_status_t nwkSymLink(nwkSymLink_t value);

  /** @param value new NIB attribute value for nwkCapabilityInformation (0x8F)
   *  @returns NWK_UNSUPPORTED_ATTRIBUTE, this is a read only attribute */
  command nwk_status_t nwkCapabilityInformation(nwkCapabilityInformation_t value);

  /** @param value new NIB attribute value for nwkAddrAlloc (0x90)
   *  @returns NWK_SUCCESS if NIB attribute was updated, NWK_INVALID_PARAMETER
   *                       if parameter value is out of valid range and NIB was
   *                       not updated */
  command nwk_status_t nwkAddrAlloc(nwkAddrAlloc_t value);

  /** @param value new NIB attribute value for nwkUseTreeRouting (0x91)
   *  @returns NWK_SUCCESS if NIB attribute was updated */
  command nwk_status_t nwkUseTreeRouting(nwkUseTreeRouting_t value);

  /** @param value new NIB attribute value for nwkManagerAddr (0x92)
   *  @returns NWK_SUCCESS if NIB attribute was updated, NWK_INVALID_PARAMETER
   *                       if parameter value is out of valid range and NIB was
   *                       not updated */
  command nwk_status_t nwkManagerAddr(nwkManagerAddr_t value);

  /** @param value new NIB attribute value for nwkMaxSourceRoute (0x93)
   *  @returns NWK_SUCCESS if NIB attribute was updated */
  command nwk_status_t nwkMaxSourceRoute(nwkMaxSourceRoute_t value);

  /** @param value new NIB attribute value for nwkUpdateId (0x94)
   *  @returns NWK_SUCCESS if NIB attribute was updated */
  command nwk_status_t nwkUpdateId(nwkUpdateId_t value);

  /** @param value new NIB attribute value for nwkTransactionPersistenceTime (0x95)
   *  @returns NWK_SUCCESS if NIB attribute was updated */
  command nwk_status_t nwkTransactionPersistenceTime(nwkTransactionPersistenceTime_t value);

  /** @param value new NIB attribute value for nwkNetworkAddress (0x96)
   *  @returns NWK_SUCCESS if NIB attribute was updated, NWK_INVALID_PARAMETER
   *                       if parameter value is out of valid range and NIB was
   *                       not updated */
  command nwk_status_t nwkNetworkAddress(nwkNetworkAddress_t value);

  /** @param value new NIB attribute value for nwkStackProfile (0x97)
   *  @returns NWK_SUCCESS if NIB attribute was updated, NWK_INVALID_PARAMETER
   *                       if parameter value is out of valid range and NIB was
   *                       not updated */
  command nwk_status_t nwkStackProfile(nwkStackProfile_t value);

  /** @param value new NIB attribute value for nwkBroadcastTransactionTable (0x98)
   *  @returns NWK_UNSUPPORTED_ATTRIBUTE, this is a read only attribute */
  command nwk_status_t nwkBroadcastTransactionTable(nwkBroadcastTransactionTable_t value);//***

  /** @param value new NIB attribute value for nwkGroupIDTable (0x99)
   *  @returns NWK_SUCCESS if NIB attribute was updated */
  command nwk_status_t nwkGroupIDTable(nwkGroupIDTable_t value);//***

  /** @param value new NIB attribute value for nwkExtendedPANId (0x9A)
   *  @returns NWK_SUCCESS if NIB attribute was updated, NWK_INVALID_PARAMETER
   *                       if parameter value is out of valid range and NIB was
   *                       not updated */
  command nwk_status_t nwkExtendedPANId(nwkExtendedPANId_t value);

  /** @param value new NIB attribute value for nwkUseMulticast (0x9B)
   *  @returns NWK_SUCCESS if NIB attribute was updated */
  command nwk_status_t nwkUseMulticast(nwkUseMulticast_t value);

  /** @param value new NIB attribute value for nwkRouteRecordTable (0x9C)
   *  @returns NWK_SUCCESS if NIB attribute was updated */
  command nwk_status_t nwkRouteRecordTable(nwkRouteRecordTable_t value);//***

  /** @param value new NIB attribute value for nwkIsConcentrator (0x9D)
   *  @returns NWK_SUCCESS if NIB attribute was updated */
  command nwk_status_t nwkIsConcentrator(nwkIsConcentrator_t value);

  /** @param value new NIB attribute value for nwkConcentratorRadius (0x9E)
   *  @returns NWK_SUCCESS if NIB attribute was updated */
  command nwk_status_t nwkConcentratorRadius(nwkConcentratorRadius_t value);

  /** @param value new NIB attribute value for nwkConcentratorDiscoveryTime (0x9F)
   *  @returns NWK_SUCCESS if NIB attribute was updated */
  command nwk_status_t nwkConcentratorDiscoveryTime(nwkConcentratorDiscoveryTime_t value);

  /** @param value new NIB attribute value for nwkSecurityLevel (0xA0)
   *  @returns NWK_UNSUPPORTED_ATTRIBUTE, security not implemented */
  command nwk_status_t nwkSecurityLevel(nwkSecurityLevel_t value);//***

  /** @param value new NIB attribute value for nwkSecurityMaterialSet (0xA1)
   *  @returns NWK_SUCCESS if NIB attribute was updated *
  //command nwk_status_t nwkSecurityMaterialSet(nwkSecurityMaterialSet_t value);// ***

  ** @param value new NIB attribute value for nwkActiveKeySeqNumber (0xA2)
   *  @returns NWK_SUCCESS if NIB attribute was updated *
  //command nwk_status_t nwkActiveKeySeqNumber(nwkActiveKeySeqNumber_t value);// ***

  / ** @param value new NIB attribute value for nwkAllFresh (0xA3)
   *  @returns NWK_SUCCESS if NIB attribute was updated *
  //command nwk_status_t nwkAllFresh(nwkAllFresh_t value);// ***

  / ** @param value new NIB attribute value for nwkSecureAllFrames (0xA5)
   *  @returns NWK_SUCCESS if NIB attribute was updated *
  //command nwk_status_t nwkSecureAllFrames(nwkSecureAllFrames_t value);// ***

  / ** @param value new NIB attribute value for nwkLinkStatusPeriod (0xA6)
   *  @returns NWK_SUCCESS if NIB attribute was updated */
  command nwk_status_t nwkLinkStatusPeriod(nwkLinkStatusPeriod_t value);

  /** @param value new NIB attribute value for nwkRouterAgeLimit (0xA7)
   *  @returns NWK_SUCCESS if NIB attribute was updated */
  command nwk_status_t nwkRouterAgeLimit(nwkRouterAgeLimit_t value);

  /** @param value new NIB attribute value for nwkUniqueAddr (0xA8)
   *  @returns NWK_SUCCESS if NIB attribute was updated */
  command nwk_status_t nwkUniqueAddr(nwkUniqueAddr_t value);

  /** @param value new NIB attribute value for nwkAddressMap (0xA9)
   *  @returns NWK_SUCCESS if NIB attribute was updated */
  command nwk_status_t nwkAddressMap(nwkAddressMap_t value);//***

  /*  command nwk_status_t request(
			  uint8_t NIBAttribute,
			  uint16_t NIBAttributeLength,
			  uint8_t NIBAttriabuteValue
			  );

  event void confirm(
			nwk_status_t Status,
			uint8_t NIBAttribute
			);*/
}