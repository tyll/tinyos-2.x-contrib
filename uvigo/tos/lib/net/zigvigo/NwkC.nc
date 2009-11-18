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

configuration NwkC {
  provides {
    // NLDE-SAP Data Service
    interface NLDE_DATA;

    // NLME-SAP Management Service
    interface NLME_NETWORK_DISCOVERY;
    interface NLME_NETWORK_FORMATION;
    interface NLME_PERMIT_JOINING;
    interface NLME_START_ROUTER;
    interface NLME_ED_SCAN;
    interface NLME_JOIN;
    interface NLME_DIRECT_JOIN;
    interface NLME_LEAVE;
    interface NLME_RESET;
    interface NLME_SYNC;
    //    interface NLME_SYNC_LOSS;//Not used in non-beaconed mode
    interface NLME_GET;
    interface NLME_SET;
    interface NLME_NWK_STATUS;
    interface NLME_ROUTE_DISCOVERY;
  }
}

implementation {
  components Ieee802154NonBeaconEnabledC as MAC;
  components NibP, RouterP, CoordinatorP, DeviceP, NwkDataP;
  components NwkTreeRoutingP as RoutingP;
  components RandomC, LedsC;

  NLDE_DATA = NwkDataP;
  NLME_NETWORK_DISCOVERY = DeviceP;
  NLME_NETWORK_FORMATION = CoordinatorP;
  NLME_PERMIT_JOINING = RouterP;
  NLME_START_ROUTER = RouterP;
  NLME_ED_SCAN = DeviceP;
  NLME_JOIN = NwkDataP;
  NLME_JOIN = RouterP;
  NLME_DIRECT_JOIN = RouterP;
  NLME_LEAVE = NwkDataP;
  NLME_SYNC = DeviceP;
  //  NLME_SYNC_LOSS = DeviceP;
  NLME_NWK_STATUS = NwkDataP;
  NLME_ROUTE_DISCOVERY = NwkDataP;
  NLME_GET = NibP;
  NLME_SET = NibP;
  NLME_RESET = NibP;

  components MainC;
  NibP.Random -> RandomC;
  NibP.LocalInit <- MainC.SoftwareInit;
  NibP.MLME_RESET -> MAC;
  NibP.IEEE154BeaconFrame -> MAC;
  NibP.MLME_SET -> MAC;
  NibP.MLME_GET -> MAC;

  components new TimerMilliC() as PermitJoiningTimer;
  RouterP.PermitJoiningTimer -> PermitJoiningTimer;
  RouterP.MLME_GET -> MAC;
  RouterP.MLME_SET -> MAC;
  RouterP.MLME_START -> MAC;
  RouterP.MLME_ASSOCIATE -> MAC;
  RouterP.MLME_COMM_STATUS -> MAC;
  RouterP.MLME_ORPHAN -> MAC;
  RouterP.IEEE154TxBeaconPayload -> MAC;
  RouterP.NLME_GET -> NibP;
  RouterP.NLME_SET -> NibP;
  RouterP.NIB_SET_GET -> NibP;
  //*** Remove
  //  RouterP.Leds -> LedsC;
  //*** Remove

  CoordinatorP.NIB_SET_GET -> NibP;
  CoordinatorP.Random -> RandomC;
  CoordinatorP.MLME_SCAN -> MAC;
  CoordinatorP.MLME_SET -> MAC;
  CoordinatorP.MLME_START -> MAC;
  CoordinatorP.GetLocalExtendedAddress -> MAC;
  CoordinatorP.NLME_GET -> NibP;
  CoordinatorP.NLME_SET -> NibP;
  CoordinatorP.IEEE154TxBeaconPayload -> MAC;

  DeviceP.MLME_SCAN -> MAC;
  DeviceP.MLME_POLL -> MAC;
  DeviceP.NIB_SET_GET -> NibP;
  DeviceP.MLME_BEACON_NOTIFY -> MAC;
  DeviceP.IEEE154BeaconFrame -> MAC;
  DeviceP.MLME_GET -> MAC;
  DeviceP.NLME_GET -> NibP;
  
  components new TimerMilliC() as RejoinResponseTimer;
  NwkDataP.RejoinResponseTimer -> RejoinResponseTimer;
  NwkDataP.MCPS_DATA -> MAC;
  NwkDataP.MLME_ASSOCIATE -> MAC;
  //  NwkDataP.MLME_COMM_STATUS -> MAC;
  NwkDataP.MLME_GET -> MAC;
  NwkDataP.MLME_POLL -> MAC;
  NwkDataP.MLME_SCAN -> MAC;
  NwkDataP.MLME_SET -> MAC;
  NwkDataP.IEEE154Frame -> MAC;
  NwkDataP.GetLocalExtendedAddress -> MAC;
  NwkDataP.IEEE154TxBeaconPayload -> MAC;

  NwkDataP.NLME_GET -> NibP;
  NwkDataP.NLME_SET -> NibP;

  NwkDataP.NIB_SET_GET -> NibP;
  NwkDataP.NWK_ROUTING -> RoutingP;
  NwkDataP.BEACON_NOTIFY -> DeviceP;
  NwkDataP.Random -> RandomC;
  //*** Remove
  NwkDataP.Leds -> LedsC;
  //*** Remove

  RoutingP.NLME_GET -> NibP;
  RoutingP.NIB_SET_GET -> NibP;
}