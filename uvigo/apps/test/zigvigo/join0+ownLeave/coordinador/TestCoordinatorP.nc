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

module TestCoordinatorP {
  uses {
    interface Boot;
    interface NLDE_DATA;
    interface NLME_ED_SCAN;
    interface NLME_JOIN;
    interface NLME_LEAVE;
    interface NLME_NETWORK_DISCOVERY;
    interface NLME_NETWORK_FORMATION;
    interface NLME_PERMIT_JOINING;
    interface NLME_RESET;
    interface NLME_START_ROUTER;
    interface NLME_SYNC;
    interface Leds;
  }
}

implementation {
  event void Boot.booted() {
    call NLME_RESET.request(FALSE);
  }

  event void NLME_RESET.confirm(nwk_status_t Status) {
    call NLME_NETWORK_FORMATION.request((uint32_t)1 << 26, 4, 15, 0, FALSE);
  }

  event void NLME_NETWORK_FORMATION.confirm(nwk_status_t Status) {
    call NLME_PERMIT_JOINING.request(0xFF);
  }

  event void NLME_JOIN.indication(uint16_t NetworkAddress,
			 uint64_t ExtendedAddress,
			 ieee154_CapabilityInformation_t CapabilityInformation,
			 uint8_t RejoinNetwork,
			 bool SecureRejoin) {
    call Leds.led0On();
  }

  event void NLDE_DATA.indication(uint8_t DstAddrMode,
				  uint16_t DstAddr,
				  uint16_t SrcAddr,
				  uint8_t NsduLength,
				  uint8_t *Nsdu,
				  uint8_t LinkQuality,
				  uint32_t RxTime,
				  bool SecurityUse) {
    call Leds.led1Toggle();
  }

  event void NLME_LEAVE.indication(uint64_t DeviceAddress,
				   bool Rejoin) {
    call Leds.led2On();
  }

  /***** Implementaciones de comandos no usados *****/
  event void NLDE_DATA.confirm(nwk_status_t Status,
			       uint8_t NsduHandle,
			       uint32_t TxTime) {}

  event void NLME_ED_SCAN.confirm(nwk_status_t Status,
				  uint32_t UnscannedChannels,
				  uint8_t EDListSize,
				  int8_t* EnergyDetectList) {}

  event void NLME_JOIN.confirm(nwk_status_t Status,
			       uint16_t NetworkAddress,
			       uint64_t ExtendedPANId,
			       uint8_t ActiveChannel) {}

  event void NLME_LEAVE.confirm(nwk_status_t Status, uint64_t DeviceAddress) {}

  event void NLME_NETWORK_DISCOVERY.confirm(nwk_status_t Status,
					    uint8_t NetworkCount,
					    nwk_NetworkDescriptor_t* NetworkDescriptor) {}

  event void NLME_PERMIT_JOINING.confirm(nwk_status_t Status) {}

  event void NLME_START_ROUTER.confirm(nwk_status_t Status) {}

  event void NLME_SYNC.confirm(nwk_status_t Status) {}
}
