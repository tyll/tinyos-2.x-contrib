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

module CoordinatorP {
  provides {
    interface NLME_NETWORK_FORMATION;
  }
  uses {
    interface NIB_SET_GET;
    interface Random;
    interface Get<uint64_t> as GetLocalExtendedAddress;

    interface MLME_SCAN;
    interface MLME_SET;
    interface MLME_START;
    interface IEEE154TxBeaconPayload;

    interface NLME_GET;
    interface NLME_SET;
  }
}

implementation {

  //Different steps in the network formation
  enum {
    S_OFF,
    S_ENERGY_DETECTION_SCAN,
    S_ACTIVE_SCAN,
    S_SETTING_BEACON_PAYLOAD,
    S_STARTING_NETWORK,
  };

  uint8_t nwk_formation_step = S_OFF;
  uint32_t scan_channels;
  uint8_t scan_duration;
  //  uint16_t buffer_size;
  //  uint8_t* buffer;
  uint8_t num_channels_to_scan;
  uint32_t unscanned_channels, scanned_channels_ed, noisy_channels;

  //Static memory used for storing results from scans and later computations
  //TODO: This may be changed for a buffer supplied by the caller later
  int8_t ED_list[NWK_NUM_AVAILABLE_CHANNELS];
  uint8_t NumNetsInChannel[NWK_NUM_AVAILABLE_CHANNELS];
  ieee154_PANDescriptor_t PanDescriptorList[NWK_MAX_PAN_DESCRIPTORS];

  uint8_t SelectedLogicalChannel;

  nwk_beacon_payload_t beacon_payload;

  uint8_t countchannels(uint32_t);
  uint8_t popcount(uint8_t);

  // Counts the number of bits set in ScanChannels
  uint8_t countchannels(uint32_t ScanChannels) {
    uint8_t* ptr;//first byte ignored, we consider b11-26 = 2450Mhz band
    ptr = (uint8_t*)&ScanChannels + 1;
    return (popcount(*ptr++ & 0xF8) + popcount(*ptr++) + popcount(*ptr & 0x07));
  }
  
  uint8_t popcount(uint8_t x) {//goes through as many iterations as set bits
    uint8_t count;
    for (count = 0; x; count++) x &= x-1;
    return count;
  }
  

  /****************************************************************************
   * NLME_NETWORK_FORMATION
   ***************************************************************************/
  command void NLME_NETWORK_FORMATION.request(uint32_t ScanChannels,
					      uint8_t ScanDuration,
					      uint8_t BeaconOrder,
					      uint8_t SuperframeOrder,
					      bool BatteryLifeExtension
					      //uint16_t BufferSize,
					      //uint8_t* Buffer
					      ) {
    ieee154_status_t status;

    if ((nwkcCoordinatorCapable != 0x01) || call NIB_SET_GET.getJoined()) {
      // Not coordinator capable or already joined to a network
      signal NLME_NETWORK_FORMATION.confirm(NWK_INVALID_REQUEST);
      return;
    }
    else if (//(BufferSize == 0) || (Buffer == NULL) ||
	     ((num_channels_to_scan =
	       countchannels(ScanChannels & NWK_MICAZ_SUPPORTED_CHANNELS))
	      == 0)) {
      //We need a buffer for storing the results of MLME_SCAN
      signal NLME_NETWORK_FORMATION.confirm(NWK_INVALID_PARAMETER);
      return;
    }

    scan_channels = ScanChannels;
    scan_duration = ScanDuration;
    //    buffer_size = BufferSize;
    //    buffer = Buffer;
    unscanned_channels = noisy_channels = 0;

    // ENERGY_DETECTION_SCAN not necessary for only one channel in ScanChannels
    if (num_channels_to_scan != 1) {
      nwk_formation_step = S_ENERGY_DETECTION_SCAN;
      status = call MLME_SCAN.request(ENERGY_DETECTION_SCAN,
				      scan_channels,
				      scan_duration,
				      0x00, //ChannelPage
				      NWK_NUM_AVAILABLE_CHANNELS,//(buffer_size < num_channels_to_scan) ? buffer_size : num_channels_to_scan,
				      ED_list,//(int8_t*)Buffer,
				      0,    //PANDescriptorListSize
				      NULL, //PANDescriptorList
				      NULL  //*security
				      );
    }
    else {//only one channel specified => we do the ACTIVE_SCAN directly
      nwk_formation_step = S_ACTIVE_SCAN;
      status = call MLME_SCAN.request(ACTIVE_SCAN,
				      scan_channels,
				      scan_duration,
				      0x00, //ChannelPage
				      0,    //EDListSize,
				      NULL, //EnergyDetectList,
				      NWK_MAX_PAN_DESCRIPTORS,//buffer_size / sizeof(ieee154_PANDescriptor_t),
				      PanDescriptorList,//(ieee154_PANDescriptor_t*)Buffer,
				      NULL  //*security
				      );
    }
    if (status != IEEE154_SUCCESS) {
      nwk_formation_step = S_OFF;
      signal NLME_NETWORK_FORMATION.confirm(status);
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
    uint8_t i;
    ieee154_status_t result;
    uint8_t num_scanned_channels;
    uint32_t scanned_channels, msk;
    // ACTIVE_SCAN
    uint8_t min_nets = S_OFF;
    int8_t min_noise = NWK_ACCEPTABLE_ENERGY_LEVEL;
    int8_t tmp;
    uint16_t panid;

    if ((nwk_formation_step == S_ENERGY_DETECTION_SCAN)
	|| (nwk_formation_step == S_ACTIVE_SCAN)) {//Started scan with NLME_NETWORK_FORMATION
      if ((status != IEEE154_SUCCESS)
	  && ((nwk_formation_step != S_ACTIVE_SCAN)
	      && (status != IEEE154_NO_BEACON))) {
	//any problem => abort; except NO_BEACON in ACTIVE_SCAN
	nwk_formation_step = S_OFF;
	signal NLME_NETWORK_FORMATION.confirm(status);
	return;//we may continue if we get a IEEE154_LIMIT_REACHED?
      }

      switch (nwk_formation_step) {
      case S_ENERGY_DETECTION_SCAN:
	nwk_formation_step = S_OFF;
	unscanned_channels = UnscannedChannels;
	scanned_channels = scanned_channels_ed = ~unscanned_channels & scan_channels;
	num_scanned_channels = countchannels(scanned_channels);

	//We check the energy in the scanned channels
	if (num_scanned_channels != 0) {
	  for (msk = NWK_MIN_CHANNEL_MASK, i = 0; msk <= NWK_MAX_CHANNEL_MASK;
	       msk <<= 1) {
	    if (msk & scanned_channels) {//we have a reading for that channel
	      if (EnergyDetectList[i] > NWK_ACCEPTABLE_ENERGY_LEVEL){
		noisy_channels |= msk;//energy level beyond acceptable level
	      }
	      i++;
	    }
	  }
	}
	
	if ((num_scanned_channels == 0)
	    || (num_scanned_channels != EnergyDetectNumResults)
	    || ((~noisy_channels & scanned_channels) == 0)) {
	  //zero channels scanned => NWK_STARTUP_FAILURE
	  //|| num_scanned_channels should be = EnergyDetectNumResults
	  //|| No suitable channels, too noise in all channels
	  signal NLME_NETWORK_FORMATION.confirm(NWK_STARTUP_FAILURE);
	  return;
	}

	scanned_channels = ~noisy_channels & scanned_channels;
	num_scanned_channels = countchannels(scanned_channels);
	// We do an ACTIVE_SCAN in the suitable channels
	result = call MLME_SCAN.request(ACTIVE_SCAN,
					scanned_channels,
					scan_duration,
					0x00, //ChannelPage
					0,    //EDListSize,
					NULL, //EnergyDetectList,
					NWK_MAX_PAN_DESCRIPTORS,//(buffer_size < num_scanned_channels * (sizeof(ieee154_PANDescriptor_t)) ? (buffer_size / sizeof(ieee154_PANDescriptor_t)) : num_scanned_channels),
					PanDescriptorList,//(ieee154_PANDescriptor_t*)Buffer,
					NULL  //*security
					);
	if (result != IEEE154_SUCCESS) {
	  signal NLME_NETWORK_FORMATION.confirm(result);
	} else nwk_formation_step = S_ACTIVE_SCAN;
	break;
      case S_ACTIVE_SCAN:
	nwk_formation_step = S_OFF;
	unscanned_channels |= UnscannedChannels;
	scanned_channels = ~unscanned_channels & scan_channels;
	num_scanned_channels = countchannels(scanned_channels);

	if (num_scanned_channels == 0) {
	  //zero channels scanned => NWK_STARTUP_FAILURE
	  signal NLME_NETWORK_FORMATION.confirm(NWK_STARTUP_FAILURE);
	  return;
	}

	if (num_scanned_channels == 1) {//One single channel to choose
	  //we set all the lower bits for knowing which channel is it
	  SelectedLogicalChannel = countchannels((scanned_channels - 1) & NWK_MICAZ_SUPPORTED_CHANNELS) + NWK_MIN_LOGICAL_CHANNEL;
	}
	else {
	  //We have to choose the channel with less detected networks
	  memset(NumNetsInChannel, 0, NWK_NUM_AVAILABLE_CHANNELS);
	  for (i = 0; i < PANDescriptorListNumResults; i++)
	    NumNetsInChannel[PANDescriptorList[i].LogicalChannel - NWK_MIN_LOGICAL_CHANNEL] += 1;

	  //We check what are the channels with the lowest number of nets
	  //We choose the channel with the lowest noise among that ones
	  for (msk = NWK_MIN_CHANNEL_MASK, i = 0; msk <= NWK_MAX_CHANNEL_MASK; msk <<= 1, i++) {
	    if (scanned_channels & msk) {//A channel that was actively scanned
	      if (NumNetsInChannel[i] < min_nets) {
		min_nets = NumNetsInChannel[i];
		//The position in the ED_list is the number of
		//channels scanned before this one
		//Scanned channels in ED & All channels before this one set =>
		// => Remain set all the channels below this one
		min_noise = ED_list[countchannels(scanned_channels_ed & (msk - 1))];
		SelectedLogicalChannel = NWK_MIN_LOGICAL_CHANNEL + i;
	      }
	      else if (NumNetsInChannel[i] == min_nets) {
		if ((tmp = ED_list[countchannels(scanned_channels_ed & (msk - 1))]) < min_noise) {
		  min_noise =  tmp;
		  SelectedLogicalChannel = NWK_MIN_LOGICAL_CHANNEL + i;
		}
	      }
	    }
	  }
	}

	//We select a random PANId that is not being used in that channel
	do {
	  panid = call Random.rand16();
	  for (i = 0; i < PANDescriptorListNumResults; i++)
	    if ((PANDescriptorList[i].LogicalChannel == SelectedLogicalChannel)
		&& (PANDescriptorList[i].CoordPANId == panid)) {
	      panid = 0xFFFF;
	      break;
	    }
	} while (panid > 0xFFF7);//Range for nwkNetworkAddress 0x0000 -0xFFF7

	//we set some NIB custom attributes with NIB_SET_GET.setIamCoordinator
	call NIB_SET_GET.setIamCoordinator(SelectedLogicalChannel);
	call NLME_SET.nwkPANId(panid);
	//	call MLME_SET.macPANId(panid);//done in NibP.nc
	call NLME_SET.nwkNetworkAddress(0x0000);
	//	call MLME_SET.macShortAddress(0x0000);//done in NibP.nc
	call NIB_SET_GET.setDepth(0);
	if (call NLME_GET.nwkExtendedPANId() == 0x0000000000000000)
	  call NLME_SET.nwkExtendedPANId(call GetLocalExtendedAddress.get());

	//Update the beacon payload
	beacon_payload.ProtocolID = 0x00;
	beacon_payload.StackProfile = call NLME_GET.nwkStackProfile();
	beacon_payload.nwkcProtocolVersion = nwkcProtocolVersion;
	beacon_payload.Reserved = 0;
	beacon_payload.RouterCapacity =
	  (call NIB_SET_GET.getRouterChilds() < call NLME_GET.nwkMaxRouters());
	beacon_payload.DeviceDepth = 0x0;//0x0 for the coordinator
	beacon_payload.EndDeviceCapacity =
	  (call NIB_SET_GET.getEndDeviceChilds() < call NLME_GET.nwkMaxChildren() - call NLME_GET.nwkMaxRouters());
	beacon_payload.nwkExtendedPANId = call NLME_GET.nwkExtendedPANId();
	beacon_payload.TxOffset = 0xFFFFFF;//0xFFFFFF in beaconless networks
	beacon_payload.nwkUpdateId = call NLME_GET.nwkUpdateId();
	nwk_formation_step = S_SETTING_BEACON_PAYLOAD;
	result = call IEEE154TxBeaconPayload.setBeaconPayload(&beacon_payload, sizeof(nwk_beacon_payload_t));
	
	if (result != IEEE154_SUCCESS) {
	  nwk_formation_step = S_OFF;
	  signal NLME_NETWORK_FORMATION.confirm(result);
	}
	break;
      }
    }
  }

  event void IEEE154TxBeaconPayload.setBeaconPayloadDone(void *beaconPayload,
							  uint8_t length) {
    ieee154_status_t status;

    if (nwk_formation_step == S_SETTING_BEACON_PAYLOAD) {
      status = call MLME_START.request(call NLME_GET.nwkPANId(),
				       SelectedLogicalChannel,
				       0x00, //ChannelPage
				       0,    //StartTime
				       15,   //BeaconOrder
				       15,    //SuperframeOrder <- Ignored
				       TRUE, //PanCoordinator
				       FALSE,//BatteryLifeExtension <- Ignored
				       FALSE,//CoordRealignment
				       NULL, //*coordRealignSecurity,
				       NULL  //*beaconSecurity
				       );
      if (status != IEEE154_SUCCESS) {
	nwk_formation_step = S_OFF;
	signal NLME_NETWORK_FORMATION.confirm(status);
      } else nwk_formation_step = S_STARTING_NETWORK;
    }
  }

  event void MLME_START.confirm(ieee154_status_t status) {
    if (nwk_formation_step == S_STARTING_NETWORK) {
      if (status == IEEE154_SUCCESS)
	call NIB_SET_GET.setJoined(TRUE);//We are finally done
      nwk_formation_step = S_OFF;
      signal NLME_NETWORK_FORMATION.confirm(status);
    }
  }

  event void IEEE154TxBeaconPayload.modifyBeaconPayloadDone(uint8_t offset, void *buffer, uint8_t bufferLength) {};

  event void IEEE154TxBeaconPayload.aboutToTransmit() {
  };

  event void IEEE154TxBeaconPayload.beaconTransmitted() {};
}