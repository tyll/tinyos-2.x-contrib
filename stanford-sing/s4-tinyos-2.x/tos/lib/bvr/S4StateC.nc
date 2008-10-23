// ex: set tabstop=2 shiftwidth=2 expandtab syn=c:
// $Id$
                                    
/*                                                                      
 * "Copyright (c) 2000-2003 The Regents of the University  of California.  
 * All rights reserved.             
 *                                  
 * Permission to use, copy, modify, and distribute this software and its
 * documentation for any purpose, without fee, and without written agreement is
 * hereby granted, provided that the above copyright notice, the following
 * two paragraphs and the author appear in all copies of this software.
 *                                  
 * IN NO EVENT SHALL THE UNIVERSITY OF CALIFORNIA BE LIABLE TO ANY PARTY FOR
 * DIRECT, INDIRECT, SPECIAL, INCIDENTAL, OR CONSEQUENTIAL DAMAGES ARISING OUT
 * OF THE USE OF THIS SOFTWARE AND ITS DOCUMENTATION, EVEN IF THE UNIVERSITY OF
 * CALIFORNIA HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 *                                  
 * THE UNIVERSITY OF CALIFORNIA SPECIFICALLY DISCLAIMS ANY WARRANTIES,
 * INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY
 * AND FITNESS FOR A PARTICULAR PURPOSE.  THE SOFTWARE PROVIDED HEREUNDER IS
 * ON AN "AS IS" BASIS, AND THE UNIVERSITY OF CALIFORNIA HAS NO OBLIGATION TO
 * PROVIDE MAINTENANCE, SUPPORT, UPDATES, ENHANCEMENTS, OR MODIFICATIONS."
 *                                  
 * Copyright (c) 2002-2003 Intel Corporation
 * All rights reserved.             
 *                                  
 * This file is distributed under the terms in the attached INTEL-LICENSE     
 * file. If you do not find these files, copies can be found by writing to
 * Intel Research Berkeley, 2150 Shattuck Avenue, Suite 1300, Berkeley, CA, 
 * 94704.  Attention:  Intel License Inquiry.
 */                                 
                                    
/*                                  
 * Authors:  Rodrigo Fonseca        
 * Date Last Modified: 2005/05/26
 */

/*                                  
 * Authors:  Feng Wang, Univ. of Texas at Austin, CS Department        
 * Date Last Modified: 2006/02/04
 */

configuration S4StateC {
  provides {
    interface Init;
    interface StdControl;
    interface S4Neighborhood;
    interface S4Locator;
    interface S4StateCommand;
    interface FreezeThaw;
    interface RoutingTable;
  }
}
implementation {
  components S4StateM as S4State 
           , S4CommStack as Comm //assumes StdControl elsewhere
#ifdef FW_COORD_TABLE
           , CoordinateTableC     //StdControl here
#endif
           , LinkEstimatorC       //assumes StdControl elsewhere
           

           
#ifdef PLATFORM_MICA2
           , CC1000RadioC
           , LogicalTime
#endif

           , RandomLfsrC as Random
           , ActiveMessageC
           , LedsC, S4TopologyC;          //assumes StdControl elsewhere
  
  components new TimerMilliC() as BeaconTimer;
  components new TimerMilliC() as BeaconRetransmitTimer;
  components new TimerMilliC() as BeaconUpdateTimer;
  components new TimerMilliC() as CheckLinkTimer;
  components new TimerMilliC() as ClusterTimer;
  components new TimerMilliC() as ClusterRetransmitTimer;
  components new TimerMilliC() as ClusterUpdateTimer;
  
#ifdef TOSSIM
  components new TimerMilliC() as BeaconDisplayTimer;
#endif
  
  //provided
  Init = S4State;
  StdControl = S4State;
  S4Neighborhood = S4State;
  S4Locator = S4State;
  S4StateCommand = S4State;
  FreezeThaw = S4State;

    //added by Yun Mao
    RoutingTable = S4State;

  //wiring
  //  S4StateM
  S4State.BeaconTimer -> BeaconTimer;
  S4State.BeaconRetransmitTimer -> BeaconRetransmitTimer;
  S4State.Random -> Random;
  S4State.AMPacket -> ActiveMessageC;

  //S4State.Logger -> UARTLogger;

#ifdef FW_COORD_TABLE
  S4State.CoordinateTable -> CoordinateTableC.CoordinateTable;
  S4State.CoordinateTableControl -> CoordinateTableC.StdControl;
  
#endif

  S4State.CoordinateTableControlInit -> CoordinateTableC.Init;

  S4State.LinkEstimator -> LinkEstimatorC;
  S4State.LinkEstimatorSynch -> LinkEstimatorC;

  S4State.S4StateAMSend -> Comm.AMSend[AM_S4_BEACON_MSG];
  S4State.S4StateReceive -> Comm.Receive[AM_S4_BEACON_MSG];

  //S4State.UARTLoggerInit -> UARTLogger.Init;


  //added by Feng Wang

  S4State.BeaconUpdateTimer -> BeaconUpdateTimer;
#ifdef CHECK_LINK
  S4State.CheckLinkTimer -> CheckLinkTimer;
#endif

  S4State.Leds -> LedsC;
#ifdef PLATFORM_MICA2
  S4State.CC1000Control -> CC1000RadioC.CC1000Control;
  S4State.Time -> LogicalTime.Time;
#endif

#ifdef CRROUTING

#ifdef LOCAL_DV
  S4State.ClusterAMSend -> Comm.AMSend[AM_DV_MSG];
  S4State.ClusterReceive -> Comm.Receive[AM_DV_MSG];
#endif

  S4State.ClusterTimer -> ClusterTimer;
  S4State.ClusterRetransmitTimer -> ClusterRetransmitTimer;

#ifdef LOCAL_DV
  S4State.ClusterUpdateTimer -> ClusterUpdateTimer;
#endif

#endif
  S4State.Leds -> LedsC;
  
  S4State.S4Topology -> S4TopologyC;
  S4State.S4TopologyInit -> S4TopologyC;

#ifdef TOSSIM
  S4State.BeaconDisplayTimer -> BeaconDisplayTimer;
#endif

}
