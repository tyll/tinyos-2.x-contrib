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

module RouterP {
  provides {
    interface NLME_PERMIT_JOINING;
    interface NLME_START_ROUTER;
    interface NLME_JOIN;
    interface NLME_DIRECT_JOIN;
  }
  uses {
    interface NIB_SET_GET;
    interface Timer<TMilli> as PermitJoiningTimer; //Tmilli 1024Hz

    interface NLME_SET;
    interface NLME_GET;

    interface MLME_GET;
    interface MLME_SET;
    interface MLME_START;
    interface MLME_ASSOCIATE;
    interface MLME_COMM_STATUS;
    interface MLME_ORPHAN;
    interface IEEE154TxBeaconPayload;

    //    interface Leds;
  }
}
implementation {

  enum {
    S_OFF,
    S_WAITING_MLME_ASSOCIATE_RESPONSE,
    S_WAITING_MLME_ORPHAN_RESPONSE,
    S_WAITING_MLME_START_CONFIRM,
  };

  uint8_t waiting_response = S_OFF;
  ieee154_CapabilityInformation_t capability_info;
  uint16_t assoc_short_address;

  /****************************************************************************
   * NLME_PERMIT_JOINING
   ***************************************************************************/
  command void NLME_PERMIT_JOINING.request(uint8_t PermitDuration) {
    ieee154_status_t status;

    if ((call NIB_SET_GET.getDeviceType() != NWK_ZIGBEE_COORDINATOR)
	&& (call NIB_SET_GET.getDeviceType() != NWK_ZIGBEE_ROUTER)) {
      //Not Router nor coord
      signal NLME_PERMIT_JOINING.confirm(NWK_INVALID_REQUEST);
      return;
    }
    if (PermitDuration == 0) {
      status = call MLME_SET.macAssociationPermit(FALSE);
      if (call PermitJoiningTimer.isRunning())
	call PermitJoiningTimer.stop();
      signal NLME_PERMIT_JOINING.confirm(status);
    }
    else {
      status = call MLME_SET.macAssociationPermit(TRUE);
      if (PermitDuration != 0xFF) //Tmilli 1024Hz, PermitDuration in seconds
	call PermitJoiningTimer.startOneShot(PermitDuration << 10);
      else if (call PermitJoiningTimer.isRunning())
	call PermitJoiningTimer.stop();
      signal NLME_PERMIT_JOINING.confirm(status);
    }
  }

  event void PermitJoiningTimer.fired() {//PermitDuration expired
    call MLME_SET.macAssociationPermit(FALSE);
  }


  /****************************************************************************
   * NLME_START_ROUTER
   ***************************************************************************/
  command void NLME_START_ROUTER.request(uint8_t BeaconOrder,
					 uint8_t SuperframeOrder,
					 bool BatteryLifeExtension) {
    /* In non-beaconed mode BeanconOrder, SuperframeOrder and
       BatteryLifeExtension are useless. We do not check their values, MAC
       sub-layer returns IEEE154_INVALID_PARAMETER if (BeaconOrder != 15).
       There's no need to do a realignment ever => CoordRealignment = FALSE. */
    ieee154_status_t status;

    if ((call NIB_SET_GET.getJoined() == FALSE)
	|| (call NIB_SET_GET.getDeviceType() != NWK_ZIGBEE_ROUTER)) {
      signal NLME_START_ROUTER.confirm(NWK_INVALID_REQUEST);
      return;// device is not joined to a Zigbee network as router
    }

    if ((status = call MLME_START.request(call NLME_GET.nwkPANId(),
					  call NIB_SET_GET.getLogicalChannel(),
					  0x00,    //ChannelPage
					  0,       //StartTime
					  15,      //BeaconOrder,
					  0,       //SuperframeOrder,
					  FALSE,   //PanCoordinator
					  BatteryLifeExtension,
					  FALSE,   //CoordRealignment
					  NULL,    //coordRealignSecurity
					  NULL     //beaconSecurity
					  )) != IEEE154_SUCCESS)
      signal NLME_START_ROUTER.confirm(status);
    else waiting_response = S_WAITING_MLME_START_CONFIRM;
  }

  event void MLME_START.confirm(ieee154_status_t status) {
    if (waiting_response == S_WAITING_MLME_START_CONFIRM) {
      waiting_response = S_OFF;
      signal NLME_START_ROUTER.confirm(status);
    }
  }


  /****************************************************************************
   * NLME_JOIN
   ***************************************************************************/
  event void MLME_ASSOCIATE.indication(uint64_t DeviceAddress,
			  ieee154_CapabilityInformation_t CapabilityInformation,
			  ieee154_security_t *security) {
    uint8_t i_neighbor;
    nwkNeighborTable_t* ptr;
    ieee154_status_t status;

    if ((call MLME_GET.macAssociationPermit() == TRUE)
	&& ((call NIB_SET_GET.getDeviceType() == NWK_ZIGBEE_COORDINATOR)
	    ||(call NIB_SET_GET.getDeviceType() == NWK_ZIGBEE_ROUTER))) {
      i_neighbor = call NIB_SET_GET.searchNeighbor(DeviceAddress);
      if (i_neighbor != 0xFF) {//it is in the neighbor table
	ptr = call NLME_GET.nwkNeighborTable() + i_neighbor;
	if ((((ptr->DeviceType == NWK_ZIGBEE_ROUTER)
	      && (CapabilityInformation.DeviceType == TRUE))
	     ||((ptr->DeviceType == NWK_ZIGBEE_END_DEVICE)
		&& (CapabilityInformation.DeviceType == FALSE)))
	    && (CapabilityInformation.ReceiverOnWhenIdle == ptr->RxOnWhenIdle)){
	  //We check that CapabilityInformation matchs neighbor table
	  call MLME_ASSOCIATE.response(DeviceAddress,
				       ptr->NetworkAddress,
				       IEEE154_SUCCESS,
				       NULL //*security
				       );
	  return;
	}
	else {// remove all records of the device in neighbor table
	      // and restart processing the MLME_ASSOCIATE.indication
	  call NIB_SET_GET.freeNeighbor(i_neighbor);
	}
      }

      if ((CapabilityInformation.DeviceType == TRUE)
	  && (call NIB_SET_GET.getRouterChilds()
	      <= call NLME_GET.nwkMaxRouters())) {//Router
	assoc_short_address = call NIB_SET_GET.getAssocAddressRouter();
	call NIB_SET_GET.incRouterChilds();
	status = IEEE154_SUCCESS;
      }
      else if ((CapabilityInformation.DeviceType == FALSE)
	       && (call NIB_SET_GET.getEndDeviceChilds()
		   <= call NLME_GET.nwkMaxChildren()
		   - call NLME_GET.nwkMaxRouters())) {//End Device
	assoc_short_address = call NIB_SET_GET.getAssocAddressEndDevice();
	call NIB_SET_GET.incEndDeviceChilds();
	status = IEEE154_SUCCESS;
      }
      else {
	status = IEEE154_PAN_AT_CAPACITY;
	assoc_short_address = 0xFFFF;
      }
      
      if (status == IEEE154_SUCCESS) {//Add it to the neighbor table
	if ((i_neighbor = call NIB_SET_GET.searchFreeNeighbor()) != 0xFF) {
	  ptr = call NLME_GET.nwkNeighborTable() + i_neighbor;
	  ptr->used = TRUE;
	  ptr->ExtendedAddress = DeviceAddress;
	  ptr->NetworkAddress = assoc_short_address;
	  ptr->DeviceType = (CapabilityInformation.DeviceType)
	    ? NWK_ZIGBEE_ROUTER : NWK_ZIGBEE_END_DEVICE;
	  ptr->RxOnWhenIdle = CapabilityInformation.ReceiverOnWhenIdle;
	  ptr->Relationship = (call NLME_GET.nwkSecurityLevel() == 0x00)
	    ? NWK_NEIGHBOR_IS_CHILD : NWK_UNAUNTHENTICATED_CHILD;
	}
	else {
	  //If the Neighbor table is full, we send IEEE154_PAN_AT_CAPACITY (*)
	  status = IEEE154_PAN_AT_CAPACITY;
	  assoc_short_address = 0xFFFF;
	  (CapabilityInformation.DeviceType)
	    ? call NIB_SET_GET.decRouterChilds()
	    : call NIB_SET_GET.decEndDeviceChilds();
	}
      }
      
      waiting_response = S_WAITING_MLME_ASSOCIATE_RESPONSE;
      capability_info = CapabilityInformation;
      call MLME_ASSOCIATE.response(DeviceAddress,
				   assoc_short_address,
				   status,
				   NULL //*security
				   );
      //We'll know the result of the associate.response via mlme_comm_status
      //WARNING: If another JOIN request comes before mlme_comm_status
      //everything may fail. Is that possible? use a queue of joins?
    }
  }

  event void MLME_COMM_STATUS.indication(uint16_t PANId,
					 uint8_t SrcAddrMode,
					 ieee154_address_t SrcAddr,
					 uint8_t DstAddrMode,
					 ieee154_address_t DstAddr,
					 ieee154_status_t status,
					 ieee154_security_t *security) {
    nwk_beacon_payload_t* beacon_payload;

    if (waiting_response == S_WAITING_MLME_ASSOCIATE_RESPONSE) {
      waiting_response = S_OFF;//status of tx an MLME_ASSOCIATE.response
      if (status == IEEE154_SUCCESS) {
	//update beacon payload
	beacon_payload = (nwk_beacon_payload_t*) call IEEE154TxBeaconPayload.getBeaconPayload();
	beacon_payload->RouterCapacity =
	  (call NIB_SET_GET.getRouterChilds() < call NLME_GET.nwkMaxRouters());
	beacon_payload->EndDeviceCapacity =
	  (call NIB_SET_GET.getEndDeviceChilds() < call NLME_GET.nwkMaxChildren() - call NLME_GET.nwkMaxRouters());
	call IEEE154TxBeaconPayload.modifyBeaconPayload(0, beacon_payload, sizeof(nwk_beacon_payload_t));
	
	signal NLME_JOIN.indication(assoc_short_address,
				    DstAddr.extendedAddress,
				    capability_info,
				    0x00,//0x00 if joined through association.
				    FALSE);
      }
      else {//??? Repeat? What do to?
	/*printf("Status %X while responding a MLME_ASSOCIATE\n",status);
	  printfflush();*/
      }
    }
    else if (waiting_response == S_WAITING_MLME_ORPHAN_RESPONSE) {
      waiting_response = S_OFF; //Status of tx an MLME_ORPHAN.response
      if (status == IEEE154_SUCCESS) {
	signal NLME_JOIN.indication(assoc_short_address,
				    DstAddr.extendedAddress,
				    capability_info,
				    0x01,//joined directly or using orphaning
				    FALSE);
      }
      else {/* retry X times??? */}
    }
  }

  event void MLME_ASSOCIATE.confirm(uint16_t AssocShortAddress,
				    uint8_t status,
				    ieee154_security_t *security) {}

  command void NLME_JOIN.request(uint64_t ExtendedPANId,
			       uint8_t RejoinNetwork,
			       uint32_t ScanChannels,
			       uint8_t ScanDuration,
			       nwkCapabilityInformation_t CapabilityInformation,
			       bool SecurityEnable) {}

  event void IEEE154TxBeaconPayload.setBeaconPayloadDone(void *beaconPayload,
							 uint8_t length) {}

  event void IEEE154TxBeaconPayload.modifyBeaconPayloadDone(uint8_t offset,
						       void *buffer,
						       uint8_t bufferLength) {};

  event void IEEE154TxBeaconPayload.aboutToTransmit() {};

  event void IEEE154TxBeaconPayload.beaconTransmitted() {};


  /****************************************************************************
   * NLME_DIRECT_JOIN
   ***************************************************************************/
  command void NLME_DIRECT_JOIN.request(uint64_t DeviceAddress,
                       ieee154_CapabilityInformation_t CapabilityInformation) {
    uint8_t i_neighbor;
    nwkNeighborTable_t* ptr;

    if ((call NIB_SET_GET.getDeviceType() != NWK_ZIGBEE_ROUTER)
	&& (call NIB_SET_GET.getDeviceType() != NWK_ZIGBEE_COORDINATOR)) {
      signal NLME_DIRECT_JOIN.confirm(NWK_INVALID_REQUEST, DeviceAddress);
      return;
    }
    if ((i_neighbor = call NIB_SET_GET.searchNeighbor(DeviceAddress)) != 0xFF)
      //already in the neighbor table
      signal NLME_DIRECT_JOIN.confirm(NWK_ALREADY_PRESENT, DeviceAddress);
    else if ((i_neighbor = call NIB_SET_GET.searchFreeNeighbor()) == 0xFF)//full
      signal NLME_DIRECT_JOIN.confirm(NWK_NEIGHBOR_TABLE_FULL, DeviceAddress);
    else {//No problem for adding it
      if ((CapabilityInformation.DeviceType == TRUE)
	  && (call NIB_SET_GET.getRouterChilds()
	      <= call NLME_GET.nwkMaxRouters())) {//Router
	assoc_short_address = call NIB_SET_GET.getAssocAddressRouter();
	call NIB_SET_GET.incRouterChilds();
      }
      else if ((CapabilityInformation.DeviceType == FALSE)
	       && (call NIB_SET_GET.getEndDeviceChilds()
		   <= call NLME_GET.nwkMaxChildren()
		   - call NLME_GET.nwkMaxRouters())) {//End Device
	assoc_short_address = call NIB_SET_GET.getAssocAddressEndDevice();
	call NIB_SET_GET.incEndDeviceChilds();
      }
      else {//This is not specified in the standard, if it is not able to add
	//more nodes of this kind, we return IEEE154_PAN_AT_CAPACITY !!!
	signal NLME_DIRECT_JOIN.confirm(IEEE154_PAN_AT_CAPACITY, DeviceAddress);
	return;
      }

      ptr = call NLME_GET.nwkNeighborTable() + i_neighbor;
      ptr->used = TRUE;
      ptr->ExtendedAddress = DeviceAddress;
      ptr->NetworkAddress = assoc_short_address;
      ptr->DeviceType = (CapabilityInformation.DeviceType)
	? NWK_ZIGBEE_ROUTER : NWK_ZIGBEE_END_DEVICE;
      ptr->RxOnWhenIdle = CapabilityInformation.ReceiverOnWhenIdle;
      ptr->Relationship = (call NLME_GET.nwkSecurityLevel() == 0x00)
	? NWK_NEIGHBOR_IS_CHILD : NWK_UNAUNTHENTICATED_CHILD;

      signal NLME_DIRECT_JOIN.confirm(NWK_SUCCESS, DeviceAddress);
    }
  }

  event void MLME_ORPHAN.indication(uint64_t OrphanAddress,
				    ieee154_security_t *security) {
    uint8_t i_neighbor;
    nwkNeighborTable_t* ptr;
    uint8_t status;

    if (//(call MLME_GET.macAssociationPermit() == TRUE) &&
	((call NIB_SET_GET.getDeviceType() == NWK_ZIGBEE_COORDINATOR)
	 ||(call NIB_SET_GET.getDeviceType() == NWK_ZIGBEE_ROUTER))) {
      i_neighbor = call NIB_SET_GET.searchNeighbor(OrphanAddress);
      if (i_neighbor != 0xFF) {//it is in the neighbor table
	ptr = call NLME_GET.nwkNeighborTable() + i_neighbor;
	if ((ptr->Relationship == NWK_NEIGHBOR_IS_CHILD)
	    || (ptr->Relationship == NWK_UNAUNTHENTICATED_CHILD)) {
	  status = call MLME_ORPHAN.response(OrphanAddress,
					     ptr->NetworkAddress,
					     TRUE,//AssociatedMember
					     NULL//*security
					     );
	  //The status of the transmission is communicated back via
	  //MLME_COMM_STATUS.indication.
	  waiting_response = S_WAITING_MLME_ORPHAN_RESPONSE;
	  assoc_short_address = ptr->NetworkAddress;
	  memset(&capability_info, 0, sizeof(ieee154_CapabilityInformation_t));
	  capability_info.DeviceType = (ptr->DeviceType==NWK_ZIGBEE_ROUTER)?1:0;
	  //capability_info.PowerSource = ptr->;//???
	  capability_info.ReceiverOnWhenIdle = ptr->RxOnWhenIdle;
	  capability_info.SecurityCapability = (security != NULL);
	  capability_info.AllocateAddress = 1;
	}
      }
    }
  }
}