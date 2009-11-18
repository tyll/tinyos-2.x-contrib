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

module NibP {
  provides {
    interface Init as LocalInit;
    interface NIB_SET_GET;

    interface NLME_GET;
    interface NLME_RESET;
    interface NLME_SET;
  }
  uses {
    interface Random;
    interface MLME_RESET;
    interface MLME_SET;
    interface MLME_GET;
    interface IEEE154BeaconFrame;
  }
}
implementation {
  NIB_t nib;
  bool joined;
  nwk_device_type_t device_type;
  uint8_t logical_channel;
  uint8_t router_childs;
  uint8_t end_device_childs;
  uint8_t depth;
  uint16_t cskip;
  bool nwk_reset;
  

  void resetAttributesToDefault();
  void resetRoutingAndNeighbourTables();
  uint8_t link_cost(uint8_t lqi);
  uint16_t calcCskip(uint16_t value);

  // Returns the link cost based on the lqi. Assumes there's a linear relation
  // between lqi and the probability of packet delivery on the link (p_l)
  // LQI is in the 50-110 range (50 lowest quality, 110 maximum quality)
  // lqi = 50  => p_l = 0%
  // lqi = 110 => p_l = 100%
  // Cost 1 means (1/p_l^4) < 1.5, p_l > 90.360, lqi > 104.216
  // Cost 2 means (1/p_l^4) < 2.5, p_l > 79.527, lqi >  97.716
  // Cost 3 means (1/p_l^4) < 3.5, p_l > 73.111, lqi >  93.867
  // Cost 4 means (1/p_l^4) < 4.5, p_l > 68.659, lqi >  91.195
  // Cost 5 means (1/p_l^4) < 5.5, p_l > 65.299, lqi >  89.180
  // Cost 6 means (1/p_l^4) < 6.5, p_l > 62.628, lqi >  87.577
  // Consult: http://www.polastre.com/papers/spots05-telos.pdf
  //          http://enl.usc.edu/~om_p/etxlqirss/
  uint8_t link_cost(uint8_t lqi) {
    if (lqi > 104) return 1;
    else if (lqi > 97) return 2;
    else if (lqi > 93) return 3;
    else if (lqi > 91) return 4;
    else if (lqi > 89) return 5;
    else if (lqi > 87) return 6;
    else return 7;
/*    int p_l = ((lqi-50)/60)*100;

    if (p_l <= 61) return 7;
    else return (1/pow(p_l, 4));*/
  }

  // Function for calculating cskip based on the values of the NIB
  uint16_t calcCskip(uint16_t value) {
    if (nib.nwkMaxRouters == 1)
      return (1 + (nib.nwkMaxChildren * (nib.nwkMaxDepth - value - 1)));
    else return ((1 + nib.nwkMaxChildren - nib.nwkMaxRouters - (nib.nwkMaxChildren * pow(nib.nwkMaxRouters, nib.nwkMaxDepth - value - 1)))/(1 - nib.nwkMaxRouters));
  }

  void copyExtendedPANIdfromBeacon(uint64_t* dest, nwk_beacon_payload_t* src) {
    // on msp430 and ATmega128 nxle_uint64_t doesn't work, this is a workaround
    uint32_t lower = *((nxle_uint32_t*) (((uint8_t*)src)+3));
    uint64_t upper = *((nxle_uint32_t*) (((uint8_t*)src)+7));
    *dest = (upper << 32) + lower;
  }

  command error_t LocalInit.init() {
    //NWK layer of device is reset immediately following initial power-up
    resetAttributesToDefault();
    return SUCCESS;
  }

  void resetAttributesToDefault() {
    nib.nwkPANId = NWK_DEFAULT_nwkPANId;
    nib.nwkSequenceNumber = (nwkSequenceNumber_t) call Random.rand16();
    nib.nwkPassiveAckTimeout = NWK_PROFILE_nwkPassiveAckTimeout;
    nib.nwkMaxBroadcastRetries = NWK_DEFAULT_nwkMaxBroadcastRetries;
    nib.nwkMaxChildren = NWK_PROFILE_nwkMaxChildren;//+++
    nib.nwkMaxDepth = NWK_PROFILE_nwkMaxDepth;//+++
    nib.nwkMaxRouters = NWK_PROFILE_nwkMaxRouters;//+++
    //    nib.nwkNeighborTable = NWK_DEFAULT_nwkNeighborTable;//***
    memset(nib.nwkNeighborTable, 0,
	   sizeof(nwkNeighborTable_t) * NWK_NEIGHBOR_TABLE_SIZE);
    //nib.nwkNetworkBroadcastDeliveryTime = 2 * nib.nwkMaxDepth * ((0.05 + (nwkcMaxBroadcastJitter / 2)) + nib.nwkPassiveAckTimeout * nib.nwkMaxBroadcastRetries / 1000);
    nib.nwkNetworkBroadcastDeliveryTime = NWK_PROFILE_nwkNetworkBroadcastDeliveryTime;
    nib.nwkReportConstantCost = NWK_DEFAULT_nwkReportConstantCost;
    nib.nwkRouteDiscoveryRetriesPermitted = NWK_DEFAULT_nwkRouteDiscoveryRetriesPermitted;
    //    nib.nwkRouteTable = NWK_DEFAULT_nwkRouteTable;//***
    memset(nib.nwkRouteTable, 0,
	   sizeof(nwkRouteTable_t) * NWK_ROUTE_TABLE_SIZE);
    nib.nwkTimeStamp = NWK_DEFAULT_nwkTimeStamp;
    nib.nwkTxTotal = NWK_DEFAULT_nwkTxTotal;
    nib.nwkSymLink = NWK_DEFAULT_nwkSymLink;
    memset(&nib.nwkCapabilityInformation, 0, sizeof(nwkCapabilityInformation_t));
    //    nib.nwkCapabilityInformation = memset((nwkCapabilityInformation_t)NWK_DEFAULT_nwkCapabilityInformation;
    nib.nwkAddrAlloc = NWK_DEFAULT_nwkAddrAlloc;
    nib.nwkUseTreeRouting = NWK_DEFAULT_nwkUseTreeRouting;
    nib.nwkManagerAddr = NWK_DEFAULT_nwkManagerAddr;
    nib.nwkMaxSourceRoute = NWK_DEFAULT_nwkMaxSourceRoute;
    nib.nwkUpdateId = NWK_DEFAULT_nwkUpdateId;
    nib.nwkTransactionPersistenceTime = NWK_DEFAULT_nwkTransactionPersistenceTime;
    nib.nwkNetworkAddress = NWK_DEFAULT_nwkNetworkAddress;
    nib.nwkStackProfile = NWK_PROFILE_nwkStackProfile;//+++
    //    nib.nwkBroadcastTransactionTable = NWK_DEFAULT_nwkBroadcastTransactionTable;
    memset(nib.nwkBroadcastTransactionTable, 0,
	   sizeof(nwkBroadcastTransactionTable_t)
	   * NWK_BROADCAST_TRANSACTION_TABLE_SIZE);
    //    nib.nwkGroupIDTable = NWK_DEFAULT_nwkGroupIDTable;
    memset(nib.nwkGroupIDTable, 0,
	   sizeof(nwkGroupIDTable_t) * NWK_GROUP_ID_TABLE_SIZE);
    nib.nwkExtendedPANId = NWK_DEFAULT_nwkExtendedPANId;
    nib.nwkUseMulticast = NWK_DEFAULT_nwkUseMulticast;
    //    nib.nwkRouteRecordTable = NWK_DEFAULT_nwkRouteRecordTable;
    memset(nib.nwkRouteRecordTable, 0,
	   sizeof(nwkRouteRecordTable_t) * NWK_ROUTE_RECORD_TABLE_SIZE);
    nib.nwkIsConcentrator = NWK_DEFAULT_nwkIsConcentrator;
    nib.nwkConcentratorRadius = NWK_DEFAULT_nwkConcentratorRadius;
    nib.nwkConcentratorDiscoveryTime = NWK_DEFAULT_nwkConcentratorDiscoveryTime;
    nib.nwkSecurityLevel = NWK_DEFAULT_nwkSecurityLevel;//***
    //  nib.nwkSecurityMaterialSet = NWK_DEFAULT_nwkSecurityMaterialSet;//***
    //  nib.nwkActiveKeySeqNumber = NWK_DEFAULT_nwkActiveKeySeqNumber;//***
    //  nib.nwkAllFresh = NWK_DEFAULT_nwkAllFresh;//***
    //  nib.nwkSecureAllFrames = NWK_DEFAULT_nwkSecureAllFrames;//***
    nib.nwkLinkStatusPeriod = NWK_DEFAULT_nwkLinkStatusPeriod;
    nib.nwkRouterAgeLimit = NWK_DEFAULT_nwkRouterAgeLimit;
    nib.nwkUniqueAddr = NWK_DEFAULT_nwkUniqueAddr;
    //    nib.nwkAddressMap = NWK_DEFAULT_nwkAddressMap;//***
    memset(nib.nwkAddressMap, 0,
	   sizeof(nwkAddressMap_t) * NWK_ADDRESS_MAP_SIZE);

    joined = FALSE;
    device_type = NWK_ZIGBEE_END_DEVICE;
    logical_channel = 0;
    router_childs = 0;
    end_device_childs = 0;
    nwk_reset = FALSE;
  }

  void resetRoutingAndNeighbourTables() {
    memset(nib.nwkNeighborTable, 0,
	   sizeof(nwkNeighborTable_t) * NWK_NEIGHBOR_TABLE_SIZE);
    memset(nib.nwkRouteTable, 0,
	   sizeof(nwkRouteTable_t) * NWK_ROUTE_TABLE_SIZE);
    memset(nib.nwkRouteRecordTable, 0,
	   sizeof(nwkRouteRecordTable_t) * NWK_ROUTE_RECORD_TABLE_SIZE);
    //    nib.nwkNeighborTable = NWK_DEFAULT_nwkNeighborTable;//***
    //    nib.nwkRouteTable = NWK_DEFAULT_nwkRouteTable;//***
    //    nib.nwkRouteRecordTable = NWK_DEFAULT_nwkRouteRecordTable;
  }

  /****************************************************************************
   * NMLE_RESET
   ***************************************************************************/
  command void NLME_RESET.request(bool WarmStart) {
    if (WarmStart == FALSE){
      nwk_reset = TRUE;
      call MLME_RESET.request(TRUE);
      //continues in MLME_RESET.confirm
    }
    else {
      resetRoutingAndNeighbourTables();
      signal NLME_RESET.confirm(NWK_SUCCESS);
    }
  }

  event void MLME_RESET.confirm(ieee154_status_t status) {
    if (nwk_reset == TRUE) {
      nwk_reset = FALSE;
      if (status != IEEE154_SUCCESS)
	signal NLME_RESET.confirm(status);
      else {
	resetAttributesToDefault();
	signal NLME_RESET.confirm(NWK_SUCCESS);
      }
    }
    //else => it is a reset after an own leave command
  }

  /****************************************************************************
   * NMLE_GET
   ***************************************************************************/
  command nwkPANId_t NLME_GET.nwkPANId() { return nib.nwkPANId;}

  command nwkSequenceNumber_t NLME_GET.nwkSequenceNumber() { return nib.nwkSequenceNumber;}

  command nwkPassiveAckTimeout_t NLME_GET.nwkPassiveAckTimeout() { return nib.nwkPassiveAckTimeout;}

  command nwkMaxBroadcastRetries_t NLME_GET.nwkMaxBroadcastRetries() { return nib.nwkMaxBroadcastRetries;}

  command nwkMaxChildren_t NLME_GET.nwkMaxChildren() { return nib.nwkMaxChildren;}

  command nwkMaxDepth_t NLME_GET.nwkMaxDepth() { return nib.nwkMaxDepth;}

  command nwkMaxRouters_t NLME_GET.nwkMaxRouters() { return nib.nwkMaxRouters;}

  command nwkNeighborTable_t* NLME_GET.nwkNeighborTable() { return nib.nwkNeighborTable;}//***

  command nwkNetworkBroadcastDeliveryTime_t NLME_GET.nwkNetworkBroadcastDeliveryTime() { return nib.nwkNetworkBroadcastDeliveryTime;}

  command nwkReportConstantCost_t NLME_GET.nwkReportConstantCost() { return nib.nwkReportConstantCost;}

  command nwkRouteDiscoveryRetriesPermitted_t NLME_GET.nwkRouteDiscoveryRetriesPermitted() { return nib.nwkRouteDiscoveryRetriesPermitted;}

  command nwkRouteTable_t* NLME_GET.nwkRouteTable() { return nib.nwkRouteTable;}//***

  command nwkTimeStamp_t NLME_GET.nwkTimeStamp() { return nib.nwkTimeStamp;}

  command nwkTxTotal_t NLME_GET.nwkTxTotal() { return nib.nwkTxTotal;}

  command nwkSymLink_t NLME_GET.nwkSymLink() { return nib.nwkSymLink;}

  command nwkCapabilityInformation_t NLME_GET.nwkCapabilityInformation() { return nib.nwkCapabilityInformation;}

  command nwkAddrAlloc_t NLME_GET.nwkAddrAlloc() { return nib.nwkAddrAlloc;}

  command nwkUseTreeRouting_t NLME_GET.nwkUseTreeRouting() { return nib.nwkUseTreeRouting;}

  command nwkManagerAddr_t NLME_GET.nwkManagerAddr() { return nib.nwkManagerAddr;}

  command nwkMaxSourceRoute_t NLME_GET.nwkMaxSourceRoute() { return nib.nwkMaxSourceRoute;}

  command nwkUpdateId_t NLME_GET.nwkUpdateId() { return nib.nwkUpdateId;}

  command nwkTransactionPersistenceTime_t NLME_GET.nwkTransactionPersistenceTime() { return nib.nwkTransactionPersistenceTime;}

  command nwkNetworkAddress_t NLME_GET.nwkNetworkAddress() { return nib.nwkNetworkAddress;}

  command nwkStackProfile_t NLME_GET.nwkStackProfile() { return nib.nwkStackProfile;}

  command nwkBroadcastTransactionTable_t* NLME_GET.nwkBroadcastTransactionTable() { return nib.nwkBroadcastTransactionTable;}//***

  command nwkGroupIDTable_t* NLME_GET.nwkGroupIDTable() { return nib.nwkGroupIDTable;}//***

  command nwkExtendedPANId_t NLME_GET.nwkExtendedPANId() { return nib.nwkExtendedPANId;}

  command nwkUseMulticast_t NLME_GET.nwkUseMulticast() { return nib.nwkUseMulticast;}

  command nwkRouteRecordTable_t* NLME_GET.nwkRouteRecordTable() { return nib.nwkRouteRecordTable;}//***

  command nwkIsConcentrator_t NLME_GET.nwkIsConcentrator() { return nib.nwkIsConcentrator;}

  command nwkConcentratorRadius_t NLME_GET.nwkConcentratorRadius() { return nib.nwkConcentratorRadius;}

  command nwkConcentratorDiscoveryTime_t NLME_GET.nwkConcentratorDiscoveryTime() { return nib.nwkConcentratorDiscoveryTime;}

  command nwkSecurityLevel_t NLME_GET.nwkSecurityLevel() { return nib.nwkSecurityLevel;}//***

  //  command nwkSecurityMaterialSet_t NLME_GET.nwkSecurityMaterialSet() { return nib.nwkSecurityMaterialSet;}//***

  //  command nwkActiveKeySeqNumber_t NLME_GET.nwkActiveKeySeqNumber() { return nib.nwkActiveKeySeqNumber;}//***

  //  command nwkAllFresh_t NLME_GET.nwkAllFresh() { return nib.nwkAllFresh;}//***

  //  command nwkSecureAllFrames_t NLME_GET.nwkSecureAllFrames() { return nib.nwkSecureAllFrames;}//***

  command nwkLinkStatusPeriod_t NLME_GET.nwkLinkStatusPeriod() { return nib.nwkLinkStatusPeriod;}

  command nwkRouterAgeLimit_t NLME_GET.nwkRouterAgeLimit() { return nib.nwkRouterAgeLimit;}

  command nwkUniqueAddr_t NLME_GET.nwkUniqueAddr() { return nib.nwkUniqueAddr;}

  command nwkAddressMap_t* NLME_GET.nwkAddressMap() { return nib.nwkAddressMap;}//***

  /****************************************************************************
   * NMLE_SET
   ***************************************************************************/

  command nwk_status_t NLME_SET.nwkPANId(nwkPANId_t value) {
    nib.nwkPANId = value;
    call MLME_SET.macPANId(value);//any change reflected in the PIB
    return NWK_SUCCESS;
  }

  command nwk_status_t NLME_SET.nwkSequenceNumber(nwkSequenceNumber_t value) {
    return NWK_UNSUPPORTED_ATTRIBUTE;//Read Only
  }

  command nwk_status_t NLME_SET.nwkPassiveAckTimeout(nwkPassiveAckTimeout_t value) {
    if (value > 2710) return NWK_INVALID_PARAMETER;
    nib.nwkPassiveAckTimeout = value;
    return NWK_SUCCESS;
  }

  command nwk_status_t NLME_SET.nwkMaxBroadcastRetries(nwkMaxBroadcastRetries_t value) {
    if (value > 5) return NWK_INVALID_PARAMETER;
    nib.nwkMaxBroadcastRetries = value;
    return NWK_SUCCESS;
  }

  command nwk_status_t NLME_SET.nwkMaxChildren(nwkMaxChildren_t value) {
    nib.nwkMaxChildren = value;
    return NWK_SUCCESS;
  }

  command nwk_status_t NLME_SET.nwkMaxDepth(nwkMaxDepth_t value) {
    return NWK_UNSUPPORTED_ATTRIBUTE;//Read Only
  }

  command nwk_status_t NLME_SET.nwkMaxRouters(nwkMaxRouters_t value) {
    if (value == 0) return NWK_INVALID_PARAMETER;
    nib.nwkMaxRouters = value;
    return NWK_SUCCESS;
  }

  command nwk_status_t NLME_SET.nwkNeighborTable(nwkNeighborTable_t value) {
    
  }//***

  command nwk_status_t NLME_SET.nwkNetworkBroadcastDeliveryTime(nwkNetworkBroadcastDeliveryTime_t value) {
    nib.nwkNetworkBroadcastDeliveryTime = value;
    return NWK_SUCCESS;
  }

  command nwk_status_t NLME_SET.nwkReportConstantCost(nwkReportConstantCost_t value) {
    if (value > 1) return NWK_INVALID_PARAMETER;
    nib.nwkReportConstantCost = value;
    return NWK_SUCCESS;
  }

  command nwk_status_t NLME_SET.nwkRouteDiscoveryRetriesPermitted(nwkRouteDiscoveryRetriesPermitted_t value) {
    if (value > 3) return NWK_INVALID_PARAMETER;
    nib.nwkRouteDiscoveryRetriesPermitted = value;
    return NWK_SUCCESS;
  }

  command nwk_status_t NLME_SET.nwkRouteTable(nwkRouteTable_t value) {
    
  }//***

  command nwk_status_t NLME_SET.nwkTimeStamp(nwkTimeStamp_t value) {
    nib.nwkTimeStamp = value;
    return NWK_SUCCESS;
  }

  command nwk_status_t NLME_SET.nwkTxTotal(nwkTxTotal_t value) {
    nib.nwkTxTotal = value;
    return NWK_SUCCESS;
  }

  command nwk_status_t NLME_SET.nwkSymLink(nwkSymLink_t value) {
    nib.nwkSymLink = value;
    return NWK_SUCCESS;
  }

  command nwk_status_t NLME_SET.nwkCapabilityInformation(nwkCapabilityInformation_t value) {
    return NWK_UNSUPPORTED_ATTRIBUTE;//Read Only
  }

  command nwk_status_t NLME_SET.nwkAddrAlloc(nwkAddrAlloc_t value) {
    /*    if (value > 2) return NWK_INVALID_PARAMETER;
    nib.nwkAddrAlloc = value;
    return NWK_SUCCESS;*/
    return NWK_UNSUPPORTED_ATTRIBUTE;
  }

  command nwk_status_t NLME_SET.nwkUseTreeRouting(nwkUseTreeRouting_t value) {
    nib.nwkUseTreeRouting = value;
    return NWK_SUCCESS;
  }

  command nwk_status_t NLME_SET.nwkManagerAddr(nwkManagerAddr_t value) {
    if (value > 0xFFF7) return NWK_INVALID_PARAMETER;
    nib.nwkManagerAddr = value;
    return NWK_SUCCESS;
  }

  command nwk_status_t NLME_SET.nwkMaxSourceRoute(nwkMaxSourceRoute_t value) {
    nib.nwkMaxSourceRoute = value;
    return NWK_SUCCESS;
  }

  command nwk_status_t NLME_SET.nwkUpdateId(nwkUpdateId_t value) {
    nib.nwkUpdateId = value;
    return NWK_SUCCESS;
  }

  command nwk_status_t NLME_SET.nwkTransactionPersistenceTime(nwkTransactionPersistenceTime_t value) {
    nib.nwkTransactionPersistenceTime = value;//any change reflected in the PIB
    call MLME_SET.macTransactionPersistenceTime(value);
    return NWK_SUCCESS;
  }

  command nwk_status_t NLME_SET.nwkNetworkAddress(nwkNetworkAddress_t value) {
    if (value > 0xFFF7) return NWK_INVALID_PARAMETER;
    nib.nwkNetworkAddress = value;
    call MLME_SET.macShortAddress(value);//any change reflected in the PIB
    return NWK_SUCCESS;
  }

  command nwk_status_t NLME_SET.nwkStackProfile(nwkStackProfile_t value) {
    if (value > 0x0F) return NWK_INVALID_PARAMETER;
    nib.nwkStackProfile = value;
    return NWK_SUCCESS;
  }

  command nwk_status_t NLME_SET.nwkBroadcastTransactionTable(nwkBroadcastTransactionTable_t value) {
    return NWK_UNSUPPORTED_ATTRIBUTE;//Read Only
  }//***

  command nwk_status_t NLME_SET.nwkGroupIDTable(nwkGroupIDTable_t value) {
    
  }//***

  command nwk_status_t NLME_SET.nwkExtendedPANId(nwkExtendedPANId_t value) {
    if (value > 0xFFFFFFFFFFFFFFFELLU)
      return NWK_INVALID_PARAMETER;
    nib.nwkExtendedPANId = value;
    return NWK_SUCCESS;
  }

  command nwk_status_t NLME_SET.nwkUseMulticast(nwkUseMulticast_t value) {
    nib.nwkUseMulticast = value;
    return NWK_SUCCESS;
  }

  command nwk_status_t NLME_SET.nwkRouteRecordTable(nwkRouteRecordTable_t value) {
    
  }//***

  command nwk_status_t NLME_SET.nwkIsConcentrator(nwkIsConcentrator_t value) {
    nib.nwkIsConcentrator = value;
    return NWK_SUCCESS;
  }

  command nwk_status_t NLME_SET.nwkConcentratorRadius(nwkConcentratorRadius_t value) {
    nib.nwkConcentratorRadius = value;
    return NWK_SUCCESS;
  }

  command nwk_status_t NLME_SET.nwkConcentratorDiscoveryTime(nwkConcentratorDiscoveryTime_t value) {
    nib.nwkConcentratorDiscoveryTime = value;
    return NWK_SUCCESS;
  }

  command nwk_status_t NLME_SET.nwkSecurityLevel(nwkSecurityLevel_t value) {
    return NWK_UNSUPPORTED_ATTRIBUTE;
  }//***

  //  command nwk_status_t NLME_SET.nwkSecurityMaterialSet(nwkSecurityMaterialSet_t value) { }//***

  //  command nwk_status_t NLME_SET.nwkActiveKeySeqNumber(nwkActiveKeySeqNumber_t value) { }//***

  //  command nwk_status_t NLME_SET.nwkAllFresh(nwkAllFresh_t value) { }//***

  //  command nwk_status_t NLME_SET.nwkSecureAllFrames(nwkSecureAllFrames_t value) { }//***

  command nwk_status_t NLME_SET.nwkLinkStatusPeriod(nwkLinkStatusPeriod_t value) {
    nib.nwkLinkStatusPeriod = value;
    return NWK_SUCCESS;
  }

  command nwk_status_t NLME_SET.nwkRouterAgeLimit(nwkRouterAgeLimit_t value) {
    nib.nwkRouterAgeLimit = value;
    return NWK_SUCCESS;
  }

  command nwk_status_t NLME_SET.nwkUniqueAddr(nwkUniqueAddr_t value) {
    nib.nwkUniqueAddr = value;
    return NWK_SUCCESS;
  }

  command nwk_status_t NLME_SET.nwkAddressMap(nwkAddressMap_t value) {
    
  }//***


  /****************************************************************************
   * NIB_SET_GET
   ***************************************************************************/
  command bool NIB_SET_GET.getJoined() {
    return joined;
  }
  
  command void NIB_SET_GET.setJoined(bool value) {
    joined = value;
  }

  command nwkSequenceNumber_t NIB_SET_GET.getNwkSequenceNumber(){
    nib.nwkSequenceNumber++;
    return nib.nwkSequenceNumber;
  }

  command nwk_device_type_t NIB_SET_GET.getDeviceType() {
    return device_type;
  }

  command void NIB_SET_GET.setDeviceType(nwk_device_type_t value) {
    device_type = value;
  }

  command uint8_t NIB_SET_GET.getLogicalChannel() {
    return logical_channel;
  }

  command void NIB_SET_GET.setLogicalChannel(uint8_t value) {
    logical_channel = value;
  }

  command uint8_t NIB_SET_GET.getRouterChilds() {
    return router_childs;
  }

  command void NIB_SET_GET.setRouterChilds(uint8_t value) {
    router_childs = value;
  }

  command void NIB_SET_GET.decRouterChilds() {
    router_childs--;
  }

  command void NIB_SET_GET.incRouterChilds() {
    router_childs++;
  }

  command uint8_t NIB_SET_GET.getEndDeviceChilds() {
    return end_device_childs;
  }

  command void NIB_SET_GET.setEndDeviceChilds(uint8_t value) {
    end_device_childs = value;
  }

  command void NIB_SET_GET.decEndDeviceChilds() {
    end_device_childs--;
  }

  command void NIB_SET_GET.incEndDeviceChilds() {
    end_device_childs++;
  }

  command void NIB_SET_GET.setIamCoordinator(uint8_t LogicalChannel) {
    device_type = NWK_ZIGBEE_COORDINATOR;
    router_childs = 0;
    end_device_childs = 0;
    logical_channel = LogicalChannel;
    call MLME_SET.macRxOnWhenIdle(TRUE);//Coordinator and routers are always ON
  }

  command void NIB_SET_GET.setIamRouter(uint8_t LogicalChannel) {
    device_type = NWK_ZIGBEE_ROUTER;
    router_childs = 0;
    end_device_childs = 0;
    logical_channel = LogicalChannel;
    call MLME_SET.macRxOnWhenIdle(TRUE);//Coordinator and routers are always ON
  }

  command void NIB_SET_GET.setIamEndDevice(uint8_t LogicalChannel) {
    device_type = NWK_ZIGBEE_END_DEVICE;
    router_childs = 0;
    end_device_childs = 0;
    logical_channel = LogicalChannel;
  }

  command void NIB_SET_GET.setNwkCapabilityInformation(nwkCapabilityInformation_t value) {
    nib.nwkCapabilityInformation = value;
    call MLME_SET.macRxOnWhenIdle(value.ReceiverOnWhenIdle);
  }

  command uint8_t NIB_SET_GET.getDepth() {
    return depth;
  }

  command void NIB_SET_GET.setDepth(uint8_t value) {
    depth = (value >= 0x0F) ? 0x0F : value;
    cskip = calcCskip(value);
  }

  // Function for calculating cskip based on the values of the NIB
  command uint16_t NIB_SET_GET.getCskip(uint8_t value) {
    return calcCskip(value);
  }

  command uint16_t NIB_SET_GET.getAssocAddressRouter() {
    if (nib.nwkAddrAlloc == 0x00)
      return (nib.nwkNetworkAddress + (cskip * router_childs) + 1);
    //else if (nib.nwkAddrAlloc == 0x02)
    return call Random.rand16();//We should check it is not already in the NIB
  }

  command uint16_t NIB_SET_GET.getAssocAddressEndDevice() {
    if (nib.nwkAddrAlloc == 0x00)
      return (nib.nwkNetworkAddress + (cskip * nib.nwkMaxRouters) + end_device_childs + 1);
    //else if (nib.nwkAddrAlloc == 0x02)
    return call Random.rand16();//We should check it is not already in the NIB
  }

  command void NIB_SET_GET.ownLeaveDone() {
    uint8_t i;
    //The NLME will clear its routing table and route discovery table and
    //issue an MLME_RESET.request primitive to the MAC sublayer. The NLME
    //will also set the relationship field of the neighbor table entry
    //corresponding to its former parent to 0x03, indicating no relationship.
    memset(nib.nwkRouteTable, 0,
	   sizeof(nwkRouteTable_t) * NWK_ROUTE_TABLE_SIZE);
    memset(nib.nwkRouteRecordTable, 0,
	   sizeof(nwkRouteRecordTable_t) * NWK_ROUTE_RECORD_TABLE_SIZE);
    nwk_reset = FALSE;
    call MLME_RESET.request(TRUE);
    for (i = 0; i < NWK_NEIGHBOR_TABLE_SIZE; i++) {
      if (nib.nwkNeighborTable[i].Relationship == NWK_NEIGHBOR_IS_PARENT) {
	nib.nwkNeighborTable[i].Relationship = NWK_NONE_OF_ABOVE;
	break;
      }
      if (nib.nwkNeighborTable[i].used == FALSE) break;
    }
  }

  command void NIB_SET_GET.childLeaveDone(uint8_t i_leaving) {
    //***After the child device has been removed, the NWK layer of the parent
    //should modify its neighbor table, and any other internal data structures
    //that refer to the child device, to indicate that the device is no longer
    //on the network. It is an error for the next higher layer to address and
    //transmit frames to a child device after that device has been removed.
    nwkNeighborTable_t* ptr;

    ptr = call NLME_GET.nwkNeighborTable() + i_leaving;
    ptr->Relationship = NWK_PREVIOUS_CHILD;
  }

  command bool NIB_SET_GET.otherLeaveDone(uint16_t leaving_addr) {
    uint8_t i;

    for (i = 0; i < NWK_NEIGHBOR_TABLE_SIZE; i++) {
      if (nib.nwkNeighborTable[i].NetworkAddress == leaving_addr) {
	if ((nib.nwkNeighborTable[i].Relationship == NWK_NEIGHBOR_IS_PARENT)
	    && (device_type == NWK_ZIGBEE_ROUTER)){
	  return TRUE;
	}
	else {//device no longer in the network => forget it
	  memset(&nib.nwkNeighborTable[i], 0, sizeof(nwkNeighborTable_t));
	  nib.nwkNeighborTable[i].used = TRUE;
	}
	break;
      }
      if (nib.nwkNeighborTable[i].used == FALSE) break;
    }
    return FALSE;
  }
  
  /** Commands for managing the Neighbor Table */
  command void NIB_SET_GET.addNTBeacon(message_t* beaconFrame, ieee154_PANDescriptor_t* pd) {
    uint8_t i;
    //    ieee154_PANDescriptor_t pd;
    nwk_beacon_payload_t* beacon_payload;
    uint8_t beacon_payload_l;

    //    if (call IEEE154BeaconFrame.parsePANDescriptor(beaconFrame,
    //					    call MLME_GET.phyCurrentChannel(),
    //					    0,//ChannelPage
    //					    &pd) != IEEE154_SUCCESS) return;

    beacon_payload_l = call IEEE154BeaconFrame.getBeaconPayloadLength(beaconFrame);
    beacon_payload = call IEEE154BeaconFrame.getBeaconPayload(beaconFrame);

    //We check if it is already in the table
    for (i = 0; i < NWK_NEIGHBOR_TABLE_SIZE; i++) {
      if (nib.nwkNeighborTable[i].used == FALSE) {
	//we reached never used cells in the table
	//Not in the table, fill the new cell

	nib.nwkNeighborTable[i].used = TRUE;

	if (pd->CoordAddrMode == 0x02)
	  nib.nwkNeighborTable[i].NetworkAddress = pd->CoordAddress.shortAddress;//Mandatory
	else if (pd->CoordAddrMode == 0x03) {
	  /*	  printf("ExtAddr@Beacon.Check!\n");
		  printfflush();*/
	  //	  nib.nwkNeighborTable[i].ExtendedAddress = pd->CoordAddress.extendedAddress;//Mandatory;
	}

	nib.nwkNeighborTable[i].DeviceType = (pd->SuperframeSpec.PANCoordinator) ? 0x00 : 0x01;//Mandatory

	//*** There's no way for knowing if parent has RxOnWhenIdle !!!!!
	nib.nwkNeighborTable[i].RxOnWhenIdle = 1;//*** Not in nd nor pd!!!!!!
	//*** There's no way for knowing if parent has RxOnWhenIdle !!!!!

	nib.nwkNeighborTable[i].Relationship = 0x03;//Mandatory
	//	nib.nwkNeighborTable[i].TransmitFailure = ;//Mandatory
	nib.nwkNeighborTable[i].LQI = pd->LinkQuality;//Mandatory
	//nib.nwkNeighborTable[i].OutgoingCost = ;//Mandatory if nwkSymLink == TRUE
	nib.nwkNeighborTable[i].Age = 0;//Mandatory if nwkSymLink == TRUE

	//Additional Neighbor Table Fields
	copyExtendedPANIdfromBeacon(&nib.nwkNeighborTable[i].ExtendedPANId,beacon_payload);
	nib.nwkNeighborTable[i].LogicalChannel = pd->LogicalChannel;
	nib.nwkNeighborTable[i].Depth = beacon_payload->DeviceDepth;
	nib.nwkNeighborTable[i].BeaconOrder = pd->SuperframeSpec.BeaconOrder;
	nib.nwkNeighborTable[i].PermitJoining = pd->SuperframeSpec.AssociationPermit;

	nib.nwkNeighborTable[i].PotentialParent = 1;

	nib.nwkNeighborTable[i].StackProfile = beacon_payload->StackProfile;
	nib.nwkNeighborTable[i].RouterCapacity = beacon_payload->RouterCapacity;
	nib.nwkNeighborTable[i].EndDeviceCapacity = beacon_payload->EndDeviceCapacity;
	nib.nwkNeighborTable[i].nwkUpdateId = beacon_payload->nwkUpdateId;
	nib.nwkNeighborTable[i].PANId = pd->CoordPANId;

	/*printf("NT ");
	for (k=0;k<sizeof(nwkNeighborTable_t);k++)
	  printf("%02X ",*(((uint8_t*)nib.nwkNeighborTable)+k));
	printf("\n");
	printfflush();*/
	return;
      }

      if ((pd->CoordAddress.shortAddress
	   == nib.nwkNeighborTable[i].NetworkAddress)
	  && (memcmp(((uint8_t*)beacon_payload)+3,&nib.nwkNeighborTable[i].ExtendedPANId,8) == 0)) {
	//***Check extended panid and shortaddress, what we have in beacons!
	//(pd->CoordAddress.extendedAddress == nib.nwkNeighborTable[i].ExtendedAddress) {
	//update what we have to update ***
	/*	printf("Already in NeighborTable\n");
		printfflush();*/
	nib.nwkNeighborTable[i].Relationship = 0x03;
	nib.nwkNeighborTable[i].LQI = pd->LinkQuality;
	nib.nwkNeighborTable[i].PermitJoining = pd->SuperframeSpec.AssociationPermit;
	nib.nwkNeighborTable[i].RouterCapacity = beacon_payload->RouterCapacity;
	nib.nwkNeighborTable[i].EndDeviceCapacity = beacon_payload->EndDeviceCapacity;
	nib.nwkNeighborTable[i].PotentialParent = 1;
	return;
      }
    }
    //*** we reach this if the NeighborTable is FULL
  }

  command uint8_t NIB_SET_GET.searchSuitableParent(uint64_t ExtendedPANId) {
    uint8_t i, j = 0xFF, tmp_depth = 0xFF;
    for (i = 0; i < NWK_NEIGHBOR_TABLE_SIZE; i++) {
      nwkNeighborTable_t* ptr = &nib.nwkNeighborTable[i];

      if (ptr->used == FALSE) //reached never used cells in the table
	break;

      if (ExtendedPANId == ptr->ExtendedPANId) {
	if ((ptr->PermitJoining) &&
	    (((device_type == NWK_ZIGBEE_END_DEVICE) && ptr->EndDeviceCapacity)
	     || ((device_type == NWK_ZIGBEE_ROUTER) && ptr->RouterCapacity))) {
	  //Open to join requests and with capacity of the correct device type
	  if ((link_cost(ptr->LQI) <= 3) && (ptr->PotentialParent)
	      && (ptr->nwkUpdateId >= call NLME_GET.nwkUpdateId())) {//SUITABLE!
	    if (ptr->Depth < tmp_depth) {
	      j = i;
	      tmp_depth = ptr->Depth;
	    }
	    else if (ptr->Depth == tmp_depth) {//same depth, choose better LQI
	      //j has been set before, depth from router cannot be == 0xFF
	      if (ptr->LQI > nib.nwkNeighborTable[j].LQI) j = i;
	      //We couldn continue comparing OutgoingCost, Age...
	      //This way we are favoring the first found routers
	      //They are first in the table.
	    }
	  }
	}
      }
    }

    return j;
  }

  command void NIB_SET_GET.notSuitableParent(uint8_t i) {
    nib.nwkNeighborTable[i].PotentialParent = FALSE;
  }

  command uint8_t NIB_SET_GET.searchNeighbor(uint64_t ExtendedAddress) {
    uint8_t i;

    for (i = 0; i < NWK_NEIGHBOR_TABLE_SIZE; i++) {
      if (ExtendedAddress == nib.nwkNeighborTable[i].ExtendedAddress) return i;
      if (nib.nwkNeighborTable[i].used == FALSE) break;
    }
    return 0xFF;
  }

  command uint8_t NIB_SET_GET.searchNeighborOn(uint16_t ShortAddress, bool* isOnWhenIdle) {
    uint8_t i;

    for (i = 0; i < NWK_NEIGHBOR_TABLE_SIZE; i++) {
      if (ShortAddress == nib.nwkNeighborTable[i].NetworkAddress) {
	*isOnWhenIdle = nib.nwkNeighborTable[i].RxOnWhenIdle;
	return i;
      }
      if (nib.nwkNeighborTable[i].used == FALSE) break;
    }
    return 0xFF;
  }

  command void NIB_SET_GET.freeNeighbor(uint8_t i) {
    memset(&nib.nwkNeighborTable[i], 0, sizeof(nwkNeighborTable_t));
    nib.nwkNeighborTable[i].used = TRUE;
  }

  command uint8_t NIB_SET_GET.searchFreeNeighbor() {
    uint8_t i;

    for (i = 0; i < NWK_NEIGHBOR_TABLE_SIZE; i++)
      if (nib.nwkNeighborTable[i].ExtendedAddress == 0) return i;
    return 0xFF;
  }

  command uint16_t NIB_SET_GET.searchParentNwkAddress() {
    uint8_t i;

    for (i = 0; i < NWK_NEIGHBOR_TABLE_SIZE; i++) {
      if (nib.nwkNeighborTable[i].Relationship == NWK_NEIGHBOR_IS_PARENT)
	return nib.nwkNeighborTable[i].NetworkAddress;
      if (nib.nwkNeighborTable[i].used == FALSE) break;
    }
    return 0x00;//We return 0x00 (coordinator's default address) when no result
  }
}