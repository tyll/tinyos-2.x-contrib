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

module NwkDataP {
  provides {
    /* NLDE-SAP Data Service*/
    interface NLDE_DATA;

    /* NLME-SAP Management Service*/
    interface NLME_LEAVE;
    interface NLME_JOIN;
    interface NLME_NWK_STATUS;
    interface NLME_ROUTE_DISCOVERY;
  } uses {
    // MCPS-SAP
    interface MCPS_DATA;

    // MLME-SAP
    interface MLME_ASSOCIATE;
    //    interface MLME_COMM_STATUS;
    interface MLME_GET;
    interface MLME_POLL;
    interface MLME_SCAN;
    interface MLME_SET;
    interface IEEE154Frame;
    interface Get<uint64_t> as GetLocalExtendedAddress;
    interface IEEE154TxBeaconPayload;

    // NMLE-SAP
    interface NLME_GET;
    interface NLME_SET;

    interface NIB_SET_GET;
    interface NWK_ROUTING;
    interface BEACON_NOTIFY;

    interface Timer<TMilli> as RejoinResponseTimer; //Tmilli 1024Hz
    interface Random;

    interface Leds;
  }
}

implementation {
  enum {
    S_OFF,

    //txType
    S_NLME_JOIN,
    S_NLME_LEAVE,
    S_NLDE_DATA,
    S_REJOIN_RESPONSE,
    S_LEAVE_FROM_NWK,

    //joining
    S_JOINING_WITH_ASSOCIATION,
    S_JOINING_WITH_NWK_REJOIN,
  };

  uint8_t txType = S_OFF;
  uint64_t leavingAddr;
  bool doRejoin;

  uint8_t joining = S_OFF;
  uint64_t ExtendedPANId_to_join;
  uint8_t i_neighbor, i_joining, i_leaving;
  uint8_t scan_type = 0xFF;

  nwk_beacon_payload_t beacon_payload;

  //Static memory used for storing results from scans and later computations
  //TODO: This may be changed later for a buffer supplied by the caller
  ieee154_PANDescriptor_t PanDescriptorList[NWK_MAX_PAN_DESCRIPTORS];

  //counts the number of set bits in a byte
  uint8_t popcount(uint8_t x) {//goes through as many iterations as set bits
    uint8_t count;
    for (count = 0; x; count++) x &= x-1;
    return count;
  }

  // Counts the number of bits set in ScanChannels
  uint8_t countchannels(uint32_t ScanChannels) {
    uint8_t* ptr;//first byte ignored, we consider b11-26 = 2450Mhz band
    ptr = (uint8_t*)&ScanChannels + 1;
    return (popcount(*ptr++ & 0xF8) + popcount(*ptr++) + popcount(*ptr & 0x07));
  }

  /****************************************************************************
   * NLME_JOIN
   ***************************************************************************/
  void tryParentLoop(uint8_t status){//used while joining through association
    nwkNeighborTable_t* ptr;
    ieee154_address_t address;
    ieee154_status_t result;

    do {
      if ((i_neighbor = call
	   NIB_SET_GET.searchSuitableParent(ExtendedPANId_to_join)) == 0xFF) {
	//no suitable parent found in the neighbor table
	//we return the status parameter in this MLME_ASSOCIATE.confirm
	/*	printf("Maaal2\n");
		printfflush();*/
	signal NLME_JOIN.confirm(status, 0xFFFF, 0, 0);
	return;
      }
      ptr = call NLME_GET.nwkNeighborTable() + i_neighbor;
      //      address.extendedAddress = ptr->ExtendedAddress;
      address.shortAddress = ptr->NetworkAddress;
      joining = S_JOINING_WITH_ASSOCIATION;
      call NIB_SET_GET.setLogicalChannel(ptr->LogicalChannel);
      result = call MLME_ASSOCIATE.request(ptr->LogicalChannel,
				       0x00,//ChannelPage
				       0x02,
				       ptr->PANId,
				       address,
				       call NLME_GET.nwkCapabilityInformation(),
				       NULL//security
				       );
      if (result != IEEE154_SUCCESS) {//We mark as not suitable parent
	joining = S_OFF;
	call NIB_SET_GET.notSuitableParent(i_neighbor);
      }
    } while (result != IEEE154_SUCCESS);
  }

  task void tryParentLoop2();
  
  message_t tpl2_frame;
  uint8_t tpl2_sequenceNumber, tpl2_extraBytes;
  task void tpl2_dataSend() {
    ieee154_status_t result = 0;

    result = call MCPS_DATA.request(&tpl2_frame,// frame
		sizeof(nwk_header_common_t) + tpl2_extraBytes + 8 + 2,//payloadLength
		tpl2_sequenceNumber,//msduHandle: the SequenceNumber
		TX_OPTIONS_ACK// TxOptions
		);
    if (result != IEEE154_SUCCESS) {//We mark as not suitable parent
      joining = S_OFF;
      call NIB_SET_GET.notSuitableParent(i_neighbor);
      post tryParentLoop2();
    } else {
      txType = S_NLME_JOIN;//continues in MCPS_DATA.confirm
      //the allocate address sub-field of the capability info field shall be set to 0
    }
  }

  task void tryParentLoop2() {//Joining through NWK Rejoin procedure
    nwkNeighborTable_t* ptr;
    ieee154_address_t address;
    //    ieee154_status_t result = 0;
    //    message_t frame;
    nwk_header_common_t* nwkHeader;
    //    uint8_t extraBytes = 0;//, k;
    uint8_t* ptrPayload;
    uint64_t localExtendedAddress = call GetLocalExtendedAddress.get();
    nwkCapabilityInformation_t localCapabilityInformation = call NLME_GET.nwkCapabilityInformation();
    uint16_t tmp = 0;

    //    do {
      if ((i_neighbor = call NIB_SET_GET.searchSuitableParent(ExtendedPANId_to_join)) == 0xFF) {
	//no suitable parent found in the neighbor table
	/*	printf("Maaal %u\n",result);
		printfflush();*/
	signal NLME_JOIN.confirm(NWK_NOT_PERMITTED, 0xFFFF, 0, 0);
	return;
      }
      ptr = call NLME_GET.nwkNeighborTable() + i_neighbor;

      //Construct the NPDU
      address.shortAddress = ptr->NetworkAddress;

      if (call NLME_GET.nwkNetworkAddress() == 0xFFFF) {
	//joining for the first time => select a random 16-bit network address
	// *** check that it is not in any entry in the NIB
	tmp = call Random.rand16();
	call NLME_SET.nwkNetworkAddress(tmp);
      }
      call NLME_SET.nwkPANId(ptr->PANId);

      call IEEE154Frame.setAddressingFields(&tpl2_frame,
					  ADDR_MODE_SHORT_ADDRESS,//SrcAddrMode
					  ADDR_MODE_SHORT_ADDRESS,//DstAddrMode
					  ptr->PANId,//DstPANId
					  &address,//DstAddr
					  NULL//security
					  );
      nwkHeader = call IEEE154Frame.getPayload(&tpl2_frame);
      nwkHeader->FrameControl.FrameType = 1;
      nwkHeader->FrameControl.ProtocolVersion = nwkcProtocolVersion;
      nwkHeader->FrameControl.DiscoverRoute = 0;
      nwkHeader->FrameControl.MulticastFlag = 0;
      nwkHeader->FrameControl.Security = 0;
      nwkHeader->FrameControl.SourceRoute = 0;
      //nwkHeader->FrameControl.DestinationIEEEAddress = 1;
      nwkHeader->FrameControl.SourceIEEEAddress = 1;
      nwkHeader->FrameControl.Reserved = 0;

      nwkHeader->DestinationAddress = ptr->NetworkAddress;
      nwkHeader->SourceAddress = call NLME_GET.nwkNetworkAddress();
      nwkHeader->Radius = 1;
      nwkHeader->SequenceNumber = call NIB_SET_GET.getNwkSequenceNumber();

      if (ptr->ExtendedAddress != 0x0000000000000000) {
	//Known Destination IEEE address
	nwkHeader->FrameControl.DestinationIEEEAddress = 1;
	memcpy(((uint8_t*)nwkHeader) + sizeof(nwk_header_common_t),
	       &ptr->ExtendedAddress, 8);
	tpl2_extraBytes = 8;
      }
      else nwkHeader->FrameControl.DestinationIEEEAddress = 0;
      memcpy(((uint8_t*)nwkHeader) + sizeof(nwk_header_common_t) + tpl2_extraBytes,
	     &localExtendedAddress, 8);

      //Fill the payload of the command...
      ptrPayload = ((uint8_t*)nwkHeader) + sizeof(nwk_header_common_t)
	+ tpl2_extraBytes + 8;
      *ptrPayload = NWK_REJOIN_REQUEST;
      ptrPayload++;
      memcpy(ptrPayload, &localCapabilityInformation, sizeof(nwkCapabilityInformation_t));
      
      /*      for (k=0;k<sizeof(nwk_header_common_t) + extraBytes + 10;k++)
	printf("%02X ",*(((uint8_t*)nwkHeader)+k));
      printf("\n");
      printfflush();*/

      joining = S_JOINING_WITH_NWK_REJOIN;
      call NIB_SET_GET.setLogicalChannel(ptr->LogicalChannel);
      tpl2_sequenceNumber = nwkHeader->SequenceNumber;
      //      tpl2_extraBytes = extraBytes;
      post tpl2_dataSend();
      /*      result = call MCPS_DATA.request(&frame,// frame
		sizeof(nwk_header_common_t) + extraBytes + 8 + 2,//payloadLength
		nwkHeader->SequenceNumber,//msduHandle: the SequenceNumber
		TX_OPTIONS_ACK// TxOptions
		);
      if (result != IEEE154_SUCCESS) {//We mark as not suitable parent
	joining = S_OFF;
	call NIB_SET_GET.notSuitableParent(i_neighbor);
	post tryParentLoop2();
      } else {
	txType = S_NLME_JOIN;//continues in MCPS_DATA.confirm
	//the allocate address sub-field of the capability info field shall be set to 0
	}*/
      //    } while (result != IEEE154_SUCCESS);
  }  

  void sendRejoinResponse(message_t* frame, uint16_t assoc_short_address, ieee154_status_t status, uint64_t dstIEEEAddr, bool RxOnWhenIdle) {
    ieee154_address_t dstAddr;
    uint16_t dstPANId = 0;
    nwk_header_common_t* nwkHeader;
    nwk_frame_rejoin_response* ptrPayload;
    uint8_t result;
    uint64_t localExtendedAddress = call GetLocalExtendedAddress.get();

    call IEEE154Frame.getSrcAddr(frame, &dstAddr);
    call IEEE154Frame.getSrcPANId(frame, &dstPANId);

    call IEEE154Frame.setAddressingFields(frame,
					  ADDR_MODE_SHORT_ADDRESS,//SrcAddrMode
					  ADDR_MODE_SHORT_ADDRESS,//DstAddrMode
					  dstPANId,//DstPANId
					  &dstAddr,//DstAddr
					  NULL//security
					  );
    nwkHeader = call IEEE154Frame.getPayload(frame);
    nwkHeader->FrameControl.FrameType = 1;
    nwkHeader->FrameControl.ProtocolVersion = nwkcProtocolVersion;
    nwkHeader->FrameControl.DiscoverRoute = 0;
    nwkHeader->FrameControl.MulticastFlag = 0;
    nwkHeader->FrameControl.Security = 0;
    nwkHeader->FrameControl.SourceRoute = 0;
    nwkHeader->FrameControl.DestinationIEEEAddress = 1;
    nwkHeader->FrameControl.SourceIEEEAddress = 1;
    nwkHeader->FrameControl.Reserved = 0;
    
    nwkHeader->DestinationAddress = dstAddr.shortAddress;
    nwkHeader->SourceAddress = call NLME_GET.nwkNetworkAddress();
    nwkHeader->Radius = 1;
    nwkHeader->SequenceNumber = call NIB_SET_GET.getNwkSequenceNumber();
    memcpy(((uint8_t*)nwkHeader) + sizeof(nwk_header_common_t), &dstIEEEAddr, 8);
    memcpy(((uint8_t*)nwkHeader) + sizeof(nwk_header_common_t) + 8, &localExtendedAddress, 8);

    //Fill the payload of the command...
    ptrPayload = (nwk_frame_rejoin_response*)(((uint8_t*)nwkHeader) + sizeof(nwk_header_common_t) + 16);
    ptrPayload->CommandIdentifier = NWK_REJOIN_RESPONSE;
    ptrPayload->NetworkAddress = assoc_short_address;
    ptrPayload->RejoinStatus = status;

    /*    for (k=0;k<sizeof(nwk_header_common_t) + 20;k++)
      printf("%02X ",*(((uint8_t*)nwkHeader)+k));
    printf("<<< %u...\n",RxOnWhenIdle);
    printfflush();*/

    
    result = call MCPS_DATA.request(frame,// frame
	     sizeof(nwk_header_common_t) + 20,//payloadLength
	     nwkHeader->SequenceNumber,// msduHandle, we use the SequenceNumber
	     TX_OPTIONS_ACK | ((RxOnWhenIdle) ? 0 : TX_OPTIONS_INDIRECT)
	     );

    if (result == IEEE154_SUCCESS) txType = S_REJOIN_RESPONSE;
    else {
      /*      printf("Done %u\n",result);
	      printfflush();*/
    }
  }

  event void RejoinResponseTimer.fired() {
    /*    printf("FIRED\n");
	  printfflush();*/
    //*** Complete this for finishing nwk rejoin at device side ***
    joining = S_OFF;
    if (call MLME_GET.macRxOnWhenIdle() == TRUE) {
      //received nothing and we were awake waiting
      call NIB_SET_GET.notSuitableParent(i_neighbor);
      post tryParentLoop2();
    } else {
      ieee154_status_t status;
      nwkNeighborTable_t* ptr;
      ieee154_address_t address;

      ptr = call NLME_GET.nwkNeighborTable() + i_neighbor;

      address.shortAddress = ptr->NetworkAddress;
      status = call MLME_POLL.request(ADDR_MODE_SHORT_ADDRESS,
				      ptr->PANId,
				      address,
				      NULL // *security
				      );

      if (status != IEEE154_SUCCESS) {
	call NIB_SET_GET.notSuitableParent(i_neighbor);
	post tryParentLoop2();
      } else joining = S_JOINING_WITH_NWK_REJOIN;//ready for incoming response
    }
  }

  event void MLME_POLL.confirm(ieee154_status_t status) {
    if (joining == S_JOINING_WITH_NWK_REJOIN) {
      joining = S_OFF;
      if (status != IEEE154_SUCCESS) {//try with another
	call NIB_SET_GET.notSuitableParent(i_neighbor);
	post tryParentLoop2();
      }
      //wait for the MCPS_DATA.indication now...
    }
  }

  command void NLME_JOIN.request(uint64_t ExtendedPANId,
			       uint8_t RejoinNetwork,
			       uint32_t ScanChannels,
			       uint8_t ScanDuration,
			       nwkCapabilityInformation_t CapabilityInformation,
			       bool SecurityEnable) {
    ieee154_status_t status;
    uint32_t logical_channel;

    if (((call NIB_SET_GET.getJoined() == TRUE) && (RejoinNetwork == 0x00))
	|| ((RejoinNetwork == 0x03) && (countchannels(ScanChannels) > 1))
	|| (!(ScanChannels & NWK_MICAZ_SUPPORTED_CHANNELS))) {
      signal NLME_JOIN.confirm(NWK_INVALID_REQUEST, 0xFFFF, 0, 0);
      return;
    }
    switch (RejoinNetwork) {
    case 0x00: //The device is requesting to join a network through association
      call NIB_SET_GET.setDeviceType((CapabilityInformation.DeviceType)?
				     NWK_ZIGBEE_ROUTER:NWK_ZIGBEE_END_DEVICE);
      ExtendedPANId_to_join = ExtendedPANId;
      call NIB_SET_GET.setNwkCapabilityInformation(CapabilityInformation);
      tryParentLoop(NWK_NOT_PERMITTED);
      break;
    case 0x01://joining directly or rejoining using the orphaning procedure
      call NIB_SET_GET.setDeviceType((CapabilityInformation.DeviceType)?
				     NWK_ZIGBEE_ROUTER:NWK_ZIGBEE_END_DEVICE);
      ExtendedPANId_to_join = ExtendedPANId;
      status = call MLME_SCAN.request(ORPHAN_SCAN,
				      ScanChannels,
				      ScanDuration,//ignored
				      0x00,//ChannelPage
				      0,   //EnergyDetectListNumEntries
				      NULL,//EnergyDetectList
				      0,   //PANDescriptorListNumEntries
				      NULL,//PANDescriptorList,
				      NULL // *security
				      );
      if (status != IEEE154_SUCCESS)
	signal NLME_JOIN.confirm(status, 0xFFFF, 0, 0);
      else scan_type = ORPHAN_SCAN;
      break;
    case 0x02://joining the network using the NWK rejoining procedure
      call NIB_SET_GET.setDeviceType((CapabilityInformation.DeviceType)?
				     NWK_ZIGBEE_ROUTER:NWK_ZIGBEE_END_DEVICE);
      ExtendedPANId_to_join = ExtendedPANId;
      call NIB_SET_GET.setNwkCapabilityInformation(CapabilityInformation);
      status = call MLME_SCAN.request(ACTIVE_SCAN,
				      ScanChannels,
				      ScanDuration,
				      0x00,//ChannelPage
				      0,   //EnergyDetectListNumEntries
				      NULL,//EnergyDetectList
				      NWK_MAX_PAN_DESCRIPTORS, //PANDescriptorListNumEntries
				      PanDescriptorList,//PANDescriptorList,
				      NULL // *security
				      );
      if (status != IEEE154_SUCCESS)
	signal NLME_JOIN.confirm(status, 0xFFFF, 0, 0);
      else {
	scan_type = ACTIVE_SCAN;
	call BEACON_NOTIFY.doNwkRejoinScan(ExtendedPANId);
      }
      break;
    case 0x03://The device is to change the operational network channel to that
      //   identified in the ScanChannels parameter
      //   We set all the lower bits for knowing which channel is it
      logical_channel = countchannels(ScanChannels - 1);
      status = call MLME_SET.phyCurrentChannel(logical_channel);
      signal NLME_JOIN.confirm(status,
			       call NLME_GET.nwkNetworkAddress(),
			       call NLME_GET.nwkExtendedPANId(),
			       logical_channel);
      break;
    }
  }

  event void MLME_SCAN.confirm(ieee154_status_t status,
			       uint8_t ScanType,
			       uint8_t ChannelPage,
			       uint32_t UnscannedChannels,
			       uint8_t EnergyDetectNumResults,
			       int8_t* EnergyDetectList,
			       uint8_t PANDescriptorListNumResults,
			       ieee154_PANDescriptor_t* PANDescriptorList) {
    if (scan_type == ORPHAN_SCAN) {
      //joining directly or rejoining using the orphaning procedure
      scan_type = 0xFF;
      /*      printf("Orphan Scan Done %X\n",status);
	      printfflush();*/
      if (status == IEEE154_SUCCESS) {
	/* Note that if the child device is joining for the first time or if
	   the child device has previously been joined to the network, but has
	   failed to retain tree depth information as prescribed in sub-clause
	   3.6.8, it may not be able to operate correctly on the network
	   without taking measures, outside the scope of this specification,
	   for the recovery of this information. */
	call NLME_SET.nwkNetworkAddress(call MLME_GET.macShortAddress());
	call NLME_SET.nwkExtendedPANId(ExtendedPANId_to_join);
	signal NLME_JOIN.confirm(NWK_SUCCESS,
				 call MLME_GET.macShortAddress(),
				 ExtendedPANId_to_join,
				 0);
	//The Network Address has been comunicated back through a Coordinator
	//realignment command. We can find it in the PIB.
      }
      else signal NLME_JOIN.confirm(NWK_NO_NETWORKS, 0xFFFF, 0, 0);
    }
    else if (scan_type == ACTIVE_SCAN) {
      scan_type = 0xFF;
      /* Once the MAC sub-layer signals the completion of the scan by issuing
	 the MLME-SCAN.confirm primitive to the NLME, the NWK layer shall
	 search its neighbor table for a suitable parent device... TODO ...*/
      /* printf("ACTIVE_SCAN done. %u results\n",PANDescriptorListNumResults);
	 printfflush();*/
      call BEACON_NOTIFY.endNwkRejoinScan();

      post tryParentLoop2();
    }
  }

  event void MLME_ASSOCIATE.confirm(uint16_t AssocShortAddress,
				    uint8_t status,
				    ieee154_security_t *security) {
    nwkNeighborTable_t* ptr;
    ieee154_status_t result;

    if (joining != S_OFF) {
      joining = S_OFF;
      if (status == IEEE154_SUCCESS) {//Joined!
	call NIB_SET_GET.setJoined(TRUE);
	//i_neighbor = call NIB_SET_GET.searchNeighbor(parent_extended_address);
	//i_neighbor is supposed to be correct... possible bug?
	ptr = call NLME_GET.nwkNeighborTable() + i_neighbor;
	ptr->Relationship = NWK_NEIGHBOR_IS_PARENT;
	call NLME_SET.nwkNetworkAddress(AssocShortAddress);
	call NLME_SET.nwkUpdateId(ptr->nwkUpdateId);
	call NLME_SET.nwkPANId(ptr->PANId);
	call NLME_SET.nwkExtendedPANId(ptr->ExtendedPANId);
	call NIB_SET_GET.setDepth(ptr->Depth + 1);
	/*** Postpone this for later ***
	signal NLME_JOIN.confirm(status,
				 AssocShortAddress,
				 call NLME_GET.nwkExtendedPANId(),
				 call NIB_SET_GET.getLogicalChannel());
	*** ***/
	if (call NIB_SET_GET.getDeviceType() == NWK_ZIGBEE_ROUTER) {
	  //If it is a router, we have to MLME-SET.request(macBeaconPayload)
	  //HERE, see Figure 3.34
	  call NIB_SET_GET.setIamRouter(call NIB_SET_GET.getLogicalChannel());

	  beacon_payload.ProtocolID = 0x00;
	  beacon_payload.StackProfile = call NLME_GET.nwkStackProfile();
	  beacon_payload.nwkcProtocolVersion = nwkcProtocolVersion;
	  beacon_payload.Reserved = 0;
	  beacon_payload.RouterCapacity =
	    (call NIB_SET_GET.getRouterChilds() < call NLME_GET.nwkMaxRouters());
	  beacon_payload.DeviceDepth = call NIB_SET_GET.getDepth();
	  beacon_payload.EndDeviceCapacity =
	    (call NIB_SET_GET.getEndDeviceChilds() < call NLME_GET.nwkMaxChildren() - call NLME_GET.nwkMaxRouters());
	  beacon_payload.nwkExtendedPANId = call NLME_GET.nwkExtendedPANId();
	  beacon_payload.TxOffset = 0xFFFFFF;//0xFFFFFF in beaconless networks
	  beacon_payload.nwkUpdateId = call NLME_GET.nwkUpdateId();
	  result = call IEEE154TxBeaconPayload.setBeaconPayload(&beacon_payload, sizeof(nwk_beacon_payload_t));
	  /*	  if (result != IEEE154_SUCCESS) {
	    printf("Problem while setting the BeaconPayload!\n");
	    printfflush();
	    }*/
	  /*** Postponed ***/
	  signal NLME_JOIN.confirm(status,
				   AssocShortAddress,
				   call NLME_GET.nwkExtendedPANId(),
				   call NIB_SET_GET.getLogicalChannel());
	  /*** ***/
	}
	else call NIB_SET_GET.setIamEndDevice(call NIB_SET_GET.getLogicalChannel());
	return;
      }
      //Try with another suitable parent...
      call NIB_SET_GET.notSuitableParent(i_neighbor);

      tryParentLoop(status);
    }
  }

  event void MLME_ASSOCIATE.indication(uint64_t DeviceAddress,
		         ieee154_CapabilityInformation_t CapabilityInformation,
			 ieee154_security_t *security) {
  }

  event void IEEE154TxBeaconPayload.setBeaconPayloadDone(void *beaconPayload,
							 uint8_t length) {}

  event void IEEE154TxBeaconPayload.modifyBeaconPayloadDone(uint8_t offset,
						       void *buffer,
						       uint8_t bufferLength) {};

  event void IEEE154TxBeaconPayload.aboutToTransmit() {};

  event void IEEE154TxBeaconPayload.beaconTransmitted() {};


  /****************************************************************************
   * NLME_LEAVE
   ***************************************************************************/
  message_t leaveFrame;
  uint8_t lf_sequenceNumber, lf_txOptions, lf_extraBytes;
  task void sendLeave() {
    ieee154_status_t status = 0;

    status = call MCPS_DATA.request(&leaveFrame,// frame
			    sizeof(nwk_header_common_t) + 8 + lf_extraBytes + sizeof(nwk_frame_leave_t),//payloadLength
			    lf_sequenceNumber,// msduHandle
			    lf_txOptions// TxOptions -> ***Only set for unicast
			    );
    if (status != IEEE154_SUCCESS){
      signal NLME_LEAVE.confirm(status, leavingAddr);
    }
    else {
      txType = S_NLME_LEAVE;
    }
  }

  command void NLME_LEAVE.request(uint64_t DeviceAddress,
				  bool RemoveChildren,
				  bool Rejoin) {
    //    message_t frame;
    nwk_header_common_t* nwkHeader;
    ieee154_address_t address;
    nwk_frame_leave_t* nwkPayload;
    //    ieee154_status_t status;
    uint64_t* ptr;

    if (call NIB_SET_GET.getJoined() == FALSE) {
      signal NLME_LEAVE.confirm(NWK_INVALID_REQUEST, DeviceAddress);
      return;
    }
    else {//It is joined
      if (DeviceAddress == 0x0000000000000000) {//NULL Address
	uint8_t txOptions;
	//	uint8_t i;

	if (call NIB_SET_GET.getDeviceType() == NWK_ZIGBEE_END_DEVICE) {
	  txOptions = TX_OPTIONS_ACK;
	  address.shortAddress = call NIB_SET_GET.searchParentNwkAddress();
	}
	else {
	  txOptions = 0;//no ACK
	  address.shortAddress = 0xFFFF;//broadcast
	}
	call IEEE154Frame.setAddressingFields(&leaveFrame,
					  ADDR_MODE_SHORT_ADDRESS,//SrcAddrMode
					  ADDR_MODE_SHORT_ADDRESS,//DstAddrMode
					  call MLME_GET.macPANId(),//DstPANId
					  &address,//DstAddr
					  NULL//security
					  );
	nwkHeader = call IEEE154Frame.getPayload(&leaveFrame);
	nwkHeader->FrameControl.FrameType = 1;
	nwkHeader->FrameControl.ProtocolVersion = nwkcProtocolVersion;
	nwkHeader->FrameControl.DiscoverRoute = 0;
	nwkHeader->FrameControl.MulticastFlag = 0;
	nwkHeader->FrameControl.Security = 0;
	nwkHeader->FrameControl.SourceRoute = 0;
	nwkHeader->FrameControl.DestinationIEEEAddress = 0;
	nwkHeader->FrameControl.SourceIEEEAddress = 1;
	nwkHeader->FrameControl.Reserved = 0;

	nwkHeader->DestinationAddress = (call NIB_SET_GET.getDeviceType() == NWK_ZIGBEE_END_DEVICE) ? address.shortAddress : 0xFFFD;
	nwkHeader->SourceAddress = call MLME_GET.macShortAddress();
	nwkHeader->Radius = 1;
	nwkHeader->SequenceNumber = call NIB_SET_GET.getNwkSequenceNumber();

	//insert the source IEEE address
	ptr = (uint64_t*)(((uint8_t*)nwkHeader) + sizeof(nwk_header_common_t));
	*ptr = call GetLocalExtendedAddress.get();

	nwkPayload = (nwk_frame_leave_t*)(((uint8_t*)nwkHeader) + sizeof(nwk_header_common_t) + 8);
	nwkPayload->CommandIdentifier = NWK_LEAVE;
	nwkPayload->LeaveCommandOptionsField.Reserved = 0;
	nwkPayload->LeaveCommandOptionsField.Rejoin = Rejoin;
	nwkPayload->LeaveCommandOptionsField.Request = 0;
	nwkPayload->LeaveCommandOptionsField.RemoveChildren = (call NIB_SET_GET.getDeviceType() == NWK_ZIGBEE_END_DEVICE) ? 0 : RemoveChildren;

	/*	for (i=0;i<sizeof(nwk_header_common_t) + 8 + sizeof(nwk_frame_leave_t);i++)
	  printf("%02X ",*(((uint8_t*)nwkHeader)+i));
	printf("__ %u\n",sizeof(nwk_header_common_t) + 8 + sizeof(nwk_frame_leave_t));
	printfflush();*/

	lf_sequenceNumber = nwkHeader->SequenceNumber;
	lf_txOptions = txOptions;
	leavingAddr = DeviceAddress;
	lf_extraBytes = 0;
	post sendLeave();
	/*	status = call MCPS_DATA.request(&frame,// frame
				sizeof(nwk_header_common_t) + 8 + sizeof(nwk_frame_leave_t),//payloadLength
				nwkHeader->SequenceNumber,// msduHandle
				txOptions// TxOptions -> ***Only set for unicast
				);
	if (status != IEEE154_SUCCESS){
	  signal NLME_LEAVE.confirm(status, 0x0000000000000000);
	}
	else {
	  txType = S_NLME_LEAVE;
	  leavingAddr = DeviceAddress;
	  }*/
      }
      else {//DeviceAddress != NULL
	nwkNeighborTable_t* ptrN;

	if (call NIB_SET_GET.getDeviceType() == NWK_ZIGBEE_END_DEVICE) {
	  //ZigBee end devices have no childs and should not do this
	  signal NLME_LEAVE.confirm(NWK_INVALID_REQUEST, DeviceAddress);
	  return;
	}
	if ((i_leaving = call NIB_SET_GET.searchNeighbor(DeviceAddress)) == 0xFF) {//Not in the neighbor table or not a child
	  signal NLME_LEAVE.confirm(NWK_UNKNOWN_DEVICE, DeviceAddress);
	  return;
	}
	ptrN = call NLME_GET.nwkNeighborTable() + i_leaving;

	if (ptrN->Relationship == NWK_UNAUNTHENTICATED_CHILD) {
	  //UNAUNTHENTICATED_CHILD => not to send a network leave command
	  ptrN->Relationship = NWK_NONE_OF_ABOVE;
	  signal NLME_LEAVE.confirm(NWK_SUCCESS, DeviceAddress);
	  //***If an unauthenticated child device is removed from the network
	  //before it is authenticated, then the address formerly in use by the
	  //device being asked to leave may be assigned to another device that
	  //joins subsequently.
	  return;
	}
	else {
	  if (ptrN->Relationship != NWK_NEIGHBOR_IS_CHILD) {
	    //The standard does not specify what to do when receiving a
	    //NLME_LEAVE for a non-child device. We return NWK_INVALID_REQUEST
	    signal NLME_LEAVE.confirm(NWK_INVALID_REQUEST, DeviceAddress);
	    return;
	  }
	}
	//It exists => remove according to 3.6.1.10.2
	address.shortAddress = ptrN->NetworkAddress;
	call IEEE154Frame.setAddressingFields(&leaveFrame,
					  ADDR_MODE_SHORT_ADDRESS,//SrcAddrMode
					  ADDR_MODE_SHORT_ADDRESS,//DstAddrMode
					  call MLME_GET.macPANId(),//DstPANId
					  &address,//DstAddr
					  NULL//security
					  );
	nwkHeader = call IEEE154Frame.getPayload(&leaveFrame);
	nwkHeader->FrameControl.FrameType = 1;
	nwkHeader->FrameControl.ProtocolVersion = nwkcProtocolVersion;
	nwkHeader->FrameControl.DiscoverRoute = 0;
	nwkHeader->FrameControl.MulticastFlag = 0;
	nwkHeader->FrameControl.Security = 0;
	nwkHeader->FrameControl.SourceRoute = 0;
	nwkHeader->FrameControl.DestinationIEEEAddress = 1;
	nwkHeader->FrameControl.SourceIEEEAddress = 1;
	nwkHeader->FrameControl.Reserved = 0;

	nwkHeader->DestinationAddress = address.shortAddress;
	nwkHeader->SourceAddress = call MLME_GET.macShortAddress();
	nwkHeader->Radius = 1;
	nwkHeader->SequenceNumber = call NIB_SET_GET.getNwkSequenceNumber();

	//insert the destination IEEE address
	ptr = (uint64_t*)(((uint8_t*)nwkHeader) + sizeof(nwk_header_common_t));
	*ptr = DeviceAddress;
	ptr++;

	//insert the source IEEE address
	//ptr = (uint64_t*)(((uint8_t*)nwkHeader) + sizeof(nwk_header_common_t));
	*ptr = call GetLocalExtendedAddress.get();

	nwkPayload = (nwk_frame_leave_t*)(((uint8_t*)nwkHeader) + sizeof(nwk_header_common_t) + 16);
	nwkPayload->CommandIdentifier = NWK_LEAVE;
	nwkPayload->LeaveCommandOptionsField.Reserved = 0;
	nwkPayload->LeaveCommandOptionsField.Rejoin = Rejoin;
	nwkPayload->LeaveCommandOptionsField.Request = 1;
	nwkPayload->LeaveCommandOptionsField.RemoveChildren = RemoveChildren;

	lf_sequenceNumber = nwkHeader->SequenceNumber;
	lf_txOptions = TX_OPTIONS_ACK;
	leavingAddr = DeviceAddress;
	lf_extraBytes = 8;
	post sendLeave();
	/*status = call MCPS_DATA.request(&frame,// frame
					sizeof(nwk_header_common_t) + 16 + sizeof(nwk_frame_leave_t),//payloadLength
					nwkHeader->SequenceNumber,// msduHandle
					TX_OPTIONS_ACK// TxOptions
					);
	if (status != IEEE154_SUCCESS) {
	  signal NLME_LEAVE.confirm(status, DeviceAddress);
	}
	else {
	  txType = S_NLME_LEAVE;
	  leavingAddr = DeviceAddress;
	  }*/
      }
    }
  }

  void sendLeaveCommand(bool RemoveChildren, bool Rejoin){
    message_t frame;
    nwk_header_common_t* nwkHeader;
    ieee154_address_t address;
    nwk_frame_leave_t* nwkPayload;
    ieee154_status_t status;
    uint64_t* ptr;

    address.shortAddress = 0xFFFF;//broadcast
    call IEEE154Frame.setAddressingFields(&frame,
					  ADDR_MODE_SHORT_ADDRESS,//SrcAddrMode
					  ADDR_MODE_SHORT_ADDRESS,//DstAddrMode
					  call MLME_GET.macPANId(),//DstPANId
					  &address,//DstAddr
					  NULL//security
					  );
    nwkHeader = call IEEE154Frame.getPayload(&frame);
    nwkHeader->FrameControl.FrameType = 1;
    nwkHeader->FrameControl.ProtocolVersion = nwkcProtocolVersion;
    nwkHeader->FrameControl.DiscoverRoute = 0;
    nwkHeader->FrameControl.MulticastFlag = 0;
    nwkHeader->FrameControl.Security = 0;
    nwkHeader->FrameControl.SourceRoute = 0;
    nwkHeader->FrameControl.DestinationIEEEAddress = 0;
    nwkHeader->FrameControl.SourceIEEEAddress = 1;
    nwkHeader->FrameControl.Reserved = 0;

    nwkHeader->DestinationAddress = 0xFFFD;
    nwkHeader->SourceAddress = call MLME_GET.macShortAddress();
    nwkHeader->Radius = 1;
    nwkHeader->SequenceNumber = call NIB_SET_GET.getNwkSequenceNumber();

    //insert the source IEEE address
    ptr = (uint64_t*)(((uint8_t*)nwkHeader) + sizeof(nwk_header_common_t));
    *ptr = call GetLocalExtendedAddress.get();

    nwkPayload = (nwk_frame_leave_t*)(((uint8_t*)nwkHeader) + sizeof(nwk_header_common_t) + 8);
    nwkPayload->CommandIdentifier = NWK_LEAVE;
    nwkPayload->LeaveCommandOptionsField.Reserved = 0;
    nwkPayload->LeaveCommandOptionsField.Rejoin = Rejoin;
    nwkPayload->LeaveCommandOptionsField.Request = 0;
    nwkPayload->LeaveCommandOptionsField.RemoveChildren = RemoveChildren;

    /*	  for (i=0;i<sizeof(nwk_header_common_t) + 8 + sizeof(nwk_frame_leave_t);i++)
	  printf("%02X ",*(((uint8_t*)nwkHeader)+i));
	  printf("__ %u\n",sizeof(nwk_header_common_t) + 8 + sizeof(nwk_frame_leave_t));
	  printfflush();*/

    status = call MCPS_DATA.request(&frame,// frame
				    sizeof(nwk_header_common_t) + 8 + sizeof(nwk_frame_leave_t),//payloadLength
				    nwkHeader->SequenceNumber,// msduHandle
				    0// TxOptions
				    );
    if (status != IEEE154_SUCCESS) {
      call NLME_SET.nwkExtendedPANId(0x0000000000000000);
      signal NLME_LEAVE.indication(0x0000000000000000, Rejoin);
    }
    else {
      txType = S_LEAVE_FROM_NWK;
      doRejoin = Rejoin;
    }
  }


  /****************************************************************************
   * NLDE_DATA
   ***************************************************************************/
  message_t dataFrame;
  uint8_t dataLength, dataNumber, dataTxOptions;
  task void sendData(){
    ieee154_status_t status = 0;

    status = call MCPS_DATA.request(&dataFrame,// frame
				    dataLength,//payloadLength
				    dataNumber,// msduHandle
				    dataTxOptions// TxOptions
				    );
    if (status != IEEE154_SUCCESS)
      signal NLDE_DATA.confirm(status, dataNumber, 0);
    else txType = S_NLDE_DATA;
  }

  command void NLDE_DATA.request(uint8_t DstAddrMode,
				 uint16_t DstAddr,
				 uint8_t NsduLength,
				 uint8_t *Nsdu,
				 uint8_t NsduHandle,
				 uint8_t Radius,
				 uint8_t NonmemberRadius,
				 uint8_t DiscoverRoute,
				 bool SecurityEnable) {
    //    message_t frame;
    ieee154_address_t address;
    nwk_header_common_t* nwkHeader;
    //    ieee154_status_t status;
    uint8_t extraBytes = 0, txOptions = 0;//, i;

    if (call NIB_SET_GET.getJoined() != TRUE) {
      signal NLDE_DATA.confirm(NWK_INVALID_REQUEST, NsduHandle, 0);
      return;
    }
    
    //Construct the NPDU
    //***If during processing the NLDE issues the NLDE_DATA.confirm primitive
    //***prior to transmission of the NSDU, all further processing is aborted
    address.shortAddress = call NWK_ROUTING.nextHop(DstAddr);
    printf("Enviando a %u (%u)\n",address.shortAddress,DstAddr);
    printfflush();
    call IEEE154Frame.setAddressingFields(&dataFrame,
					  ADDR_MODE_SHORT_ADDRESS,//SrcAddrMode
					  ADDR_MODE_SHORT_ADDRESS,//DstAddrMode
					  call MLME_GET.macPANId(),//DstPANId
					  &address,//DstAddr
					  NULL//security
					  );
    nwkHeader = call IEEE154Frame.getPayload(&dataFrame);
    nwkHeader->FrameControl.FrameType = 0;
    nwkHeader->FrameControl.ProtocolVersion = nwkcProtocolVersion;
    nwkHeader->FrameControl.DiscoverRoute = DiscoverRoute;
    nwkHeader->FrameControl.MulticastFlag = (DstAddrMode == 0x01);
    nwkHeader->FrameControl.Security = 0;
    nwkHeader->FrameControl.SourceRoute = 0;
    nwkHeader->FrameControl.DestinationIEEEAddress = 0;
    nwkHeader->FrameControl.SourceIEEEAddress = 0;
    nwkHeader->FrameControl.Reserved = 0;

    nwkHeader->DestinationAddress = DstAddr;
    nwkHeader->SourceAddress = call MLME_GET.macShortAddress();
    nwkHeader->Radius = (Radius == 0)?(2*call NLME_GET.nwkMaxDepth()):Radius;
    nwkHeader->SequenceNumber = call NIB_SET_GET.getNwkSequenceNumber();

    if (DstAddrMode == 0x01) {//*** TODO!!!
      extraBytes = 1;
      /* If the DstAddrMode parameter has a value of 0x01, the NWK header will
	 contain a multicast control field whose fields will be set as follows:
	 - The multicast mode field will be set to 0x01 if this node is a
	 member of the group specified in the DstAddr parameter.
	 - Otherwise, the multicast mode field will be set to 0x00.
	 - The non-member radius and the max non-member radius fields will be
	 set to the value of the NonmemberRadius parameter. */
    } else if (DstAddr < 0xFFF8) //unicast frame, not a broadcast address
      txOptions = TX_OPTIONS_ACK;

    memcpy(((uint8_t*)nwkHeader) + sizeof(nwk_header_common_t) + extraBytes, Nsdu, NsduLength);

    /*    for (i=0;i<26;i++)
      printf("%02X ",*(((uint8_t*)nwkHeader)+i));
    printf("\n");
    printfflush();*/
    
    //    dataFrame = &frame;
    dataLength = sizeof(nwk_header_common_t) + extraBytes + NsduLength;
    dataNumber = NsduHandle;//msduHandle, we use NsduHandle...
    dataTxOptions = txOptions;//TxOptions -> ***Only set for unicast
    post sendData();
    /*    status = call MCPS_DATA.request(&frame,// frame
	  sizeof(nwk_header_common_t) + extraBytes + NsduLength,//payloadLength
	  NsduHandle,// msduHandle, we use NsduHandle...
	  txOptions// TxOptions -> ***Only set for unicast
	  );
    if (status != IEEE154_SUCCESS)
      signal NLDE_DATA.confirm(status, NsduHandle, 0);
      else txType = S_NLDE_DATA;*/
  }

  event void MCPS_DATA.confirm(message_t *frame,
			       uint8_t msduHandle,
			       ieee154_status_t status,
			       uint32_t Timestamp) {
    switch (txType) {
    case S_NLME_JOIN://NLME_JOIN
      txType = S_OFF;
      if (status != IEEE154_SUCCESS) {
	// *** REMOVE ***
	//	call Leds.led2On();
	// *** REMOVE ***
	joining = S_OFF;
	call NIB_SET_GET.notSuitableParent(i_neighbor);
	post tryParentLoop2();
      } else {
	uint32_t time;

	time = call MLME_GET.macResponseWaitTime() * IEEE154_aBaseSuperframeDuration;
	time = (time << 10) / 62500UL;
	call RejoinResponseTimer.startOneShot(time);
      }
      break;
    case S_NLME_LEAVE://NLME_LEAVE
      txType = S_OFF;
      if (call NIB_SET_GET.getDeviceType() == NWK_ZIGBEE_END_DEVICE)
	call NLME_SET.nwkExtendedPANId(0x0000000000000000);
      /*** Postponed ***
      signal NLME_LEAVE.confirm(status, leavingAddr);
      *** ***/
      if (leavingAddr == 0x0000000000000000) //own leave
	call NIB_SET_GET.ownLeaveDone();
      else call NIB_SET_GET.childLeaveDone(i_leaving);
      /*** ***/
      signal NLME_LEAVE.confirm(status, leavingAddr);
      /*** ***/
      break;
    case S_NLDE_DATA://NLDE_DATA
      txType = S_OFF;
      signal NLDE_DATA.confirm(status,
			       msduHandle,
			       (call NLME_GET.nwkTimeStamp()) ? Timestamp : 0
			       );
      break;
    case S_REJOIN_RESPONSE://Rejoin Response
      txType = S_OFF;
      if (status == IEEE154_SUCCESS) {
	nwk_beacon_payload_t* ptr_beacon_payload;
	nwkNeighborTable_t* ptr;

	//update beacon payload
	ptr_beacon_payload = (nwk_beacon_payload_t*) call IEEE154TxBeaconPayload.getBeaconPayload();
	ptr_beacon_payload->RouterCapacity =
	  (call NIB_SET_GET.getRouterChilds() < call NLME_GET.nwkMaxRouters());
	ptr_beacon_payload->EndDeviceCapacity =
	  (call NIB_SET_GET.getEndDeviceChilds() < call NLME_GET.nwkMaxChildren() - call NLME_GET.nwkMaxRouters());
	call IEEE154TxBeaconPayload.modifyBeaconPayload(0, ptr_beacon_payload, sizeof(nwk_beacon_payload_t));
	//we don't wait for the confirm here... this is not totally correct

	ptr = call NLME_GET.nwkNeighborTable() + i_joining;
	signal NLME_JOIN.indication(ptr->NetworkAddress,
				    ptr->ExtendedAddress,
				    ptr->CapabilityInfo,
				    0x01,//0x01 if joined directly
				    FALSE);
      }
      break;
    case S_LEAVE_FROM_NWK://LEAVE received from the network
      txType = S_OFF;
      call NLME_SET.nwkExtendedPANId(0x0000000000000000);
      signal NLME_LEAVE.indication(0x0000000000000000, doRejoin);
      break;
    }
  }

  const char *m_frametype[] = {"Beacon", "Data","Acknowledgement","MAC command", "Unknown"};
  const char *m_cmdframetype[] = {"unknown command", "Association request","Association response",
    "Disassociation notification","Data request","PAN ID conflict notification",
    "Orphan notification", "Beacon request", "Coordinator realignment", "GTS request"};

  event message_t* MCPS_DATA.indication(message_t* frame) {
    uint8_t i;
    uint8_t *payload = call IEEE154Frame.getPayload(frame);
    uint8_t payloadLen = call IEEE154Frame.getPayloadLength(frame);
    uint8_t *header = call IEEE154Frame.getHeader(frame);
    uint8_t headerLen = call IEEE154Frame.getHeaderLength(frame);
    uint8_t SrcAddrMode, DstAddrMode;
    uint8_t frameType, cmdFrameType;
    ieee154_address_t SrcAddress, DstAddress;
    uint16_t SrcPANId=0, DstPANId=0;

    if (call IEEE154Frame.hasStandardCompliantHeader(frame)){
      frameType = call IEEE154Frame.getFrameType(frame);
      if (frameType > FRAMETYPE_CMD)
        frameType = 4;
      call IEEE154Frame.getSrcPANId(frame, &SrcPANId);
      call IEEE154Frame.getDstPANId(frame, &DstPANId);
      call IEEE154Frame.getSrcAddr(frame, &SrcAddress);
      call IEEE154Frame.getDstAddr(frame, &DstAddress);
      SrcAddrMode = call IEEE154Frame.getSrcAddrMode(frame);
      DstAddrMode = call IEEE154Frame.getDstAddrMode(frame);

      printf("\n");
      printf("Frametype: %s", m_frametype[frameType]);
      if (frameType == FRAMETYPE_CMD){
        cmdFrameType = payload[0];
        if (cmdFrameType > 9)
          cmdFrameType = 0;
        printf(" (%s)", m_cmdframetype[cmdFrameType]);
      }
      printf("\n");
      printf("SrcAddrMode: %d\n", SrcAddrMode);
      printf("SrcAddr: ");
      if (SrcAddrMode == ADDR_MODE_SHORT_ADDRESS){
        printf("0x%02X\n", SrcAddress.shortAddress);
        printf("SrcPANId: 0x%02X\n", SrcPANId);
      } else if (SrcAddrMode == ADDR_MODE_EXTENDED_ADDRESS){
        for (i=0; i<8; i++)
          printf("0x%02X ", ((uint8_t*) &(SrcAddress.extendedAddress))[i]);
        printf("\n");
        printf("SrcPANId: 0x%02X\n", SrcPANId);
      } else printf("\n");
      printf("DstAddrMode: %d\n", DstAddrMode);
      printf("DstAddr: ");
      if ( DstAddrMode == ADDR_MODE_SHORT_ADDRESS){
        printf("0x%02X\n", DstAddress.shortAddress);
        printf("DestPANId: 0x%02X\n", DstPANId);
      } else if  ( DstAddrMode == ADDR_MODE_EXTENDED_ADDRESS) {
        for (i=0; i<8; i++)
          printf("0x%02X ", ((uint8_t*) &(DstAddress.extendedAddress))[i]);
        printf("\n");    
        printf("DestPANId: 0x%02X\n", DstPANId);
      } else printf("\n");

      printf("DSN: %d\n", call IEEE154Frame.getDSN(frame));
      printf("MHRLen: %d\n", headerLen);
      printf("MHR: ");
      for (i=0; i<headerLen; i++){
        printf("0x%02X ", header[i]);
      }
      printf("\n");      
      printf("PayloadLen: %d\n", payloadLen);
      printf("Payload: ");
      for (i=0; i<payloadLen; i++){
        printf("0x%02X ", payload[i]);
      }
      printf("\n");
      printf("MpduLinkQuality: %d\n", call IEEE154Frame.getLinkQuality(frame));

      printf("Timestamp: ");
      if (call IEEE154Frame.isTimestampValid(frame))
        printf("%ld\n", call IEEE154Frame.getTimestamp(frame));
      else
        printf("INVALID\n");
      printfflush(); 
    }
    call Leds.led1Toggle();
    return frame;
  }


  /****************************************************************************
   * NLME_ROUTE_DISCOVERY
   ***************************************************************************/
  command void NLME_ROUTE_DISCOVERY.request(uint8_t DstAddrMode,
					    uint16_t DstAddr,
					    uint8_t Radius,
					    bool NoRouteCache) {
    if ((call NIB_SET_GET.getDeviceType() == NWK_ZIGBEE_END_DEVICE)
	|| ((DstAddrMode != 0x00) && (DstAddr >= 0xFFF8))) {
      signal NLME_ROUTE_DISCOVERY.confirm(NWK_INVALID_REQUEST, 0);
      return;
    }

    // Note: If a device has both routing table capacity and route discovery
    // table capacity then it may be said to have "routing capacity."

    //Routing feature is not implemented, we indicate a NWK_ROUTE_ERROR
    signal NLME_ROUTE_DISCOVERY.confirm(NWK_ROUTE_ERROR,
					NWK_FAILURE_NO_ROUTING_CAPACITY);
  }
  
}