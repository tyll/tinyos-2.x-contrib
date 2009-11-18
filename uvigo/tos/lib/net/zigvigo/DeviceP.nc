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

module DeviceP {
  provides {
    /* NLME-SAP Management Service*/
    interface NLME_NETWORK_DISCOVERY;
    interface BEACON_NOTIFY;
    interface NLME_SYNC;
    interface NLME_ED_SCAN;
  }
  uses {
    // MLME-SAP
    interface MLME_GET;
    interface MLME_SCAN;
    interface MLME_POLL;

    interface NIB_SET_GET;
    interface MLME_BEACON_NOTIFY;
    interface IEEE154BeaconFrame;

    // NMLE-SAP
    interface NLME_GET;
  }
}
implementation {

  enum {
    S_OFF,
    S_NLME_NETWORK_DISCOVERY,
    S_NLME_JOIN,
    S_ED_SCAN,
  };

  uint8_t nwk_discovery_ongoing = S_OFF;
  uint64_t extended_panid;
  nwk_NetworkDescriptor_t* nwk_descriptor;
  uint8_t nwk_count, nwk_limit;
  bool syncInProgress = FALSE;

  void copyExtendedPANIdfromBeacon(nwk_NetworkDescriptor_t* dest, nwk_beacon_payload_t* src) {
    // on msp430 and ATmega128 nxle_uint64_t doesn't work, this is a workaround
    uint32_t lower = *((nxle_uint32_t*) (((uint8_t*)src)+3));
    uint64_t upper = *((nxle_uint32_t*) (((uint8_t*)src)+7));
    dest->ExtendedPANId = (upper << 32) + lower;
  }

  /****************************************************************************
   * NLME_NETWORK_DISCOVERY
   ***************************************************************************/
  command void NLME_NETWORK_DISCOVERY.request(uint32_t ScanChannels,
			      uint8_t ScanDuration,
			      uint8_t NetworkCount,
			      nwk_NetworkDescriptor_t* NetworkDescriptor,
			      uint8_t PANDescriptorListNumEntries,
                              ieee154_PANDescriptor_t* PANDescriptorList) {
    ieee154_status_t status;

    if ((NetworkCount == 0) || (NetworkDescriptor == NULL)) {
      signal NLME_NETWORK_DISCOVERY.confirm(NWK_INVALID_PARAMETER,
					    0,
					    NetworkDescriptor);
      return;
    }
    nwk_descriptor = NetworkDescriptor;
    nwk_count = 0;
    nwk_limit = NetworkCount;
    status = call MLME_SCAN.request(ACTIVE_SCAN,
				    ScanChannels,
				    ScanDuration,
				    0x00,         //ChannelPage
				    0,            //EnergyDetectListNumEntries
				    NULL,         //EnergyDetectList
				    PANDescriptorListNumEntries,
				    PANDescriptorList,
				    NULL          // *security
				    );
    if (status != IEEE154_SUCCESS)
      signal NLME_NETWORK_DISCOVERY.confirm(status, 0, NetworkDescriptor);
    else nwk_discovery_ongoing = S_NLME_NETWORK_DISCOVERY;
  }

  event message_t* MLME_BEACON_NOTIFY.indication(message_t *beaconFrame) {
    nwk_beacon_payload_t* payload;
    uint8_t payload_l;
    ieee154_PANDescriptor_t pd;

    if (nwk_discovery_ongoing == S_NLME_NETWORK_DISCOVERY) {
      if (nwk_count < nwk_limit) {
	//	uint8_t kk;
	//once reached the limit of descriptors we can store, we ignore

	if (call IEEE154BeaconFrame.parsePANDescriptor(beaconFrame,
					      call MLME_GET.phyCurrentChannel(),
					      0,//ChannelPage
					      &pd) != IEEE154_SUCCESS)
	  return beaconFrame;
	payload_l = call IEEE154BeaconFrame.getBeaconPayloadLength(beaconFrame);
	payload = call IEEE154BeaconFrame.getBeaconPayload(beaconFrame);
	
	/*for (kk = 0;kk<20;kk++)
	printf("%02X ", *(((uint8_t*)payload)+kk));
	printf("\n");*/

	if ((payload_l == sizeof(nwk_beacon_payload_t))//guard check...
	    && (payload->ProtocolID == 0x00)) {
	  //add to the Neighbor Table
	  //Done later for not repeating the beacon parsing, we'll use the data
	  //in the NetworkDescriptor List and the PANDescriptorList
	  call NIB_SET_GET.addNTBeacon(beaconFrame, &pd);
	  //and store for later indication

	  //	  nwk_descriptor[nwk_count].ExtendedPANId = payload->nwkExtendedPANId;
	  copyExtendedPANIdfromBeacon(&nwk_descriptor[nwk_count], payload);
	  nwk_descriptor[nwk_count].StackProfile = payload->StackProfile;
	  nwk_descriptor[nwk_count].ZigBeeVersion = payload->nwkcProtocolVersion;
	  nwk_descriptor[nwk_count].RouterCapacity = payload->RouterCapacity;
	  nwk_descriptor[nwk_count].EndDeviceCapacity = payload->EndDeviceCapacity;
	  nwk_descriptor[nwk_count].PermitJoining = pd.SuperframeSpec.AssociationPermit;
	  nwk_descriptor[nwk_count].LogicalChannel = pd.LogicalChannel;
	  nwk_descriptor[nwk_count].BeaconOrder = pd.SuperframeSpec.BeaconOrder;
	  nwk_descriptor[nwk_count].SuperframeOrder = pd.SuperframeSpec.SuperframeOrder;
	  nwk_count++;
	}
      }
    } else if (nwk_discovery_ongoing == S_NLME_JOIN) {      
      //We are scanning in a nwk rejoing...
      if (call IEEE154BeaconFrame.parsePANDescriptor(beaconFrame,
					      call MLME_GET.phyCurrentChannel(),
					      0,//ChannelPage
					      &pd) != IEEE154_SUCCESS)
	return beaconFrame;
      payload_l = call IEEE154BeaconFrame.getBeaconPayloadLength(beaconFrame);
      payload = call IEEE154BeaconFrame.getBeaconPayload(beaconFrame);  

      if ((payload_l == sizeof(nwk_beacon_payload_t))//guard check...
	  && (memcmp(((uint8_t*)payload) + 3, &extended_panid, 8) == 0)) {
	call NIB_SET_GET.addNTBeacon(beaconFrame, &pd);
      }
    }
    return beaconFrame;
  }

  command void BEACON_NOTIFY.doNwkRejoinScan(uint64_t ExtendedPANId) {
    nwk_discovery_ongoing = S_NLME_JOIN;
    extended_panid = ExtendedPANId;
  }

  command void BEACON_NOTIFY.endNwkRejoinScan() {
    nwk_discovery_ongoing = S_OFF;
  }

  event void MLME_SCAN.confirm(ieee154_status_t status,
			       uint8_t ScanType,
			       uint8_t ChannelPage,
			       uint32_t UnscannedChannels,
			       uint8_t EnergyDetectNumResults,
			       int8_t* EnergyDetectList,
			       uint8_t PANDescriptorListNumResults,
			       ieee154_PANDescriptor_t* PANDescriptorList) {
    if (nwk_discovery_ongoing == S_NLME_NETWORK_DISCOVERY) {
      nwk_discovery_ongoing = S_OFF;
      //*** The potential parent bit should be set to 1 for every entry in the
      //*** neighbor table each time an MLME_SCAN.request primitive is issued
      //*** 3.6.1.4.1.1
      //*** We have to set the previous entries in the Neighbor table too!!!
      signal NLME_NETWORK_DISCOVERY.confirm(status, nwk_count, nwk_descriptor);
    }
    else if (nwk_discovery_ongoing == S_ED_SCAN) {
      nwk_discovery_ongoing = S_OFF;
      signal NLME_ED_SCAN.confirm(status, UnscannedChannels, EnergyDetectNumResults, EnergyDetectList);
    }
  }


  /****************************************************************************
   * NLME_ED_SCAN
   ***************************************************************************/
  command void NLME_ED_SCAN.request(uint32_t ScanChannels,
				    uint8_t ScanDuration,
				    uint8_t EDListSize,
				    int8_t* EnergyDetectList) {
    ieee154_status_t status;

    if ((status = call MLME_SCAN.request(ENERGY_DETECTION_SCAN,
					 ScanChannels,
					 ScanDuration,
					 0x00,         //ChannelPage
					 EDListSize,
					 EnergyDetectList,
					 0,            //PANDescriptorListSize
					 NULL,         //PANDescriptorList
					 NULL          //*security
					 )) != IEEE154_SUCCESS)
      signal NLME_ED_SCAN.confirm(status, ScanChannels, 0, EnergyDetectList);
    else nwk_discovery_ongoing = S_ED_SCAN;
  }


  /****************************************************************************
   * NLME_SYNC
   ***************************************************************************/
  command void NLME_SYNC.request(bool Track) {
    ieee154_status_t status;
    ieee154_address_t coordAddress;//Address of the coordinator...

    if (Track == TRUE) {
      /* If the TRACK parameter is set to TRUE and the device is operating on a
	 non-beacon enabled network, the NLME will issue the NLME-SYNC.confirm
	 primitive with a Status parameter set to INVALID_PARAMETER. */
      signal NLME_SYNC.confirm(NWK_INVALID_PARAMETER);
      return;
    }

    /* If the TRACK parameter is set to FALSE and the device is operating on
       a non-beacon enabled network, the NLME issues the MLME-POLL.request
       primitive to the MAC sub-layer. On receipt of the corresponding
       MLME-POLL.confirm primitive, the NLME issues the NLME-SYNC.confirm
       primitive with the Status parameter set to the value reported in the
       MLME-POLL.confirm. */
    coordAddress.shortAddress = call MLME_GET.macCoordShortAddress();
    /*    printf("Polling %04X\n",coordAddress.shortAddress);
    printfflush();*/
    if ((status = call MLME_POLL.request(ADDR_MODE_SHORT_ADDRESS,
					 call NLME_GET.nwkPANId(),
					 coordAddress,
					 NULL)) != IEEE154_SUCCESS)
      signal NLME_SYNC.confirm(status);
    else syncInProgress = TRUE;
    //*** Warning we have to poll our "father"!!! Is this the correct father?
    //*** Maybe we should check that macRxOnWhenIdle is FALSE for POLLing!!??
  }

  event void MLME_POLL.confirm (ieee154_status_t status) {
    if (syncInProgress == TRUE) {
      syncInProgress = FALSE;
      signal NLME_SYNC.confirm(status);
    }
  }
}