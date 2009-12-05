//$Id$

/**
 * Copyright (C) 2006 WSU All Rights Reserved
 * Permission to use, copy, modify, and distribute this software and its
 * documentation for any purpose, without fee, and without written agreement is
 * hereby granted, provided that the above copyright notice, the following
 * two paragraphs and the author appear in all copies of this software.
 * 
 * IN NO EVENT SHALL THE WASHINGTON STATE UNIVERSITY BE LIABLE TO ANY PARTY FOR
 * DIRECT, INDIRECT, SPECIAL, INCIDENTAL, OR CONSEQUENTIAL DAMAGES ARISING OUT
 * OF THE USE OF THIS SOFTWARE AND ITS DOCUMENTATION, EVEN IF THE WASHINGTON 
 * STATE UNIVERSITY HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 * 
 * THE WASHINGTON STATE UNIVERSITY SPECIFICALLY DISCLAIMS ANY WARRANTIES,
 * INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY
 * AND FITNESS FOR A PARTICULAR PURPOSE.  THE SOFTWARE PROVIDED HEREUNDER IS
 * ON AN "AS IS" BASIS, AND THE WASHINGTON STATE UNIVERSITY HAS NO OBLIGATION TO
 * PROVIDE MAINTENANCE, SUPPORT, UPDATES, ENHANCEMENTS, OR MODIFICATIONS."
 */

/**
 * This is a Stub App for testing all the modules required 
 * by Oasis ground segment features.
 *
 * @author oasis-wsu@googlegroups.com
 */


#include "OasisType.h"
#include "MultiHop.h"
configuration OasisApp {
}

implementation {
  components  Main;
  components  SmartSensingC as SensingC;
  components  LQIMultiHopRouter as multihopM;
#ifdef USE_GENERICCOMM_PRO
  components  GenericCommPro as Comm;
#else
  components  GenericComm as Comm;
#endif

#ifdef USE_FTSP
  components TimeSyncC;
#endif

#ifdef USE_SNMS
  components  SNMSC;
#endif

#ifdef USE_CASCADES
  components  CascadesC as BroadCasting;
#else
  components  Bcast as BroadCasting;
#endif

#ifdef USE_TREEMAC
  components TreeMACAgtC;
#endif

#ifdef USE_NEIGHBORMGMT
  components NeighborMgmtC;
#endif

  /* Wire StdControl of all modules to Main */
  Main.StdControl -> SensingC;
  Main.StdControl -> multihopM;

  Main.StdControl -> Comm;

#ifdef USE_FTSP
  Main.StdControl -> TimeSyncC;
#endif

#ifdef USE_SNMS
  Main.StdControl -> SNMSC;
#endif

#ifdef USE_TREEMAC
  Main.StdControl -> TreeMACAgtC;
#endif

  Main.StdControl -> BroadCasting;

  SensingC.Send -> multihopM.Send[NW_DATA];
#ifdef USE_SNMS
  SensingC.EventReport -> SNMSC.EventReport[EVENT_TYPE_SENSING];
	#ifdef PLATFORM_MICAZ
  SensingC.WDT -> SNMSC.WDT;
	#endif
#endif

#ifdef USE_SNMS
  SNMSC.EventSend -> multihopM.Send[NW_SNMS];
	#ifdef USE_RPC
  SNMSC.ResponseSend -> multihopM.Send[NW_RPCR];
  SNMSC.CommandReceive -> BroadCasting.Receive[NW_RPCC];    //YFH: temp ID for NetworkMsg in this wiring!!!
	#endif
#endif

  multihopM.ReceiveMsg -> Comm.ReceiveMsg[AM_NETWORKMSG];
  multihopM.SendMsg -> Comm.SendMsg[AM_NETWORKMSG];

  multihopM.BeaconReceiveMsg -> Comm.ReceiveMsg[AM_BEACONMSG];
  multihopM.BeaconSendMsg -> Comm.SendMsg[AM_BEACONMSG];
  Comm.RouteControl -> multihopM.RouteControl;

#ifdef USE_CASCADES
  BroadCasting.ReceiveMsg[AM_CASCTRLMSG] -> Comm.ReceiveMsg[AM_CASCTRLMSG];
  BroadCasting.SendMsg[AM_CASCTRLMSG] -> Comm.SendMsg[AM_CASCTRLMSG];
  BroadCasting.ReceiveMsg[AM_CASCADESMSG] -> Comm.ReceiveMsg[AM_CASCADESMSG];
  BroadCasting.SendMsg[AM_CASCADESMSG] -> Comm.SendMsg[AM_CASCADESMSG];
#endif

#ifdef USE_NEIGHBORMGMT
  Main.StdControl -> NeighborMgmtC.StdControl;
  multihopM.NeighborCtrl -> NeighborMgmtC.NeighborCtrl;
  #ifdef USE_GENERICCOMM_PRO
    NeighborMgmtC.Snoop -> Comm.Intercept;
  #endif
#endif
}
