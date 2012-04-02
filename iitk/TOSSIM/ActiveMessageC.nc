// $Id$
/*
 * "Copyright (c) 2005 Stanford University. All rights reserved.
 *
 * Permission to use, copy, modify, and distribute this software and
 * its documentation for any purpose, without fee, and without written
 * agreement is hereby granted, provided that the above copyright
 * notice, the following two paragraphs and the author appear in all
 * copies of this software.
 * 
 * IN NO EVENT SHALL STANFORD UNIVERSITY BE LIABLE TO ANY PARTY FOR
 * DIRECT, INDIRECT, SPECIAL, INCIDENTAL, OR CONSEQUENTIAL DAMAGES
 * ARISING OUT OF THE USE OF THIS SOFTWARE AND ITS DOCUMENTATION, EVEN
 * IF STANFORD UNIVERSITY HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH
 * DAMAGE.
 * 
 * STANFORD UNIVERSITY SPECIFICALLY DISCLAIMS ANY WARRANTIES,
 * INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
 * MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.  THE SOFTWARE
 * PROVIDED HEREUNDER IS ON AN "AS IS" BASIS, AND STANFORD UNIVERSITY
 * HAS NO OBLIGATION TO PROVIDE MAINTENANCE, SUPPORT, UPDATES,
 * ENHANCEMENTS, OR MODIFICATIONS."
 */

/**
 *
 * The basic chip-independent TOSSIM Active Message layer for radio chips
 * that do not have simulation support.
 *
 * @author Philip Levis
 * @date December 2 2005
 * @author Himanshu Singh (contributor)
 *         -- configuration for switching MAC layer 
 */

configuration ActiveMessageC {
  provides {
    interface SplitControl;

    interface AMSend[uint8_t id];
    interface Receive[uint8_t id];
    interface Receive as Snoop[uint8_t id];

    interface Packet;
    interface AMPacket;
    interface PacketAcknowledgements;
  }
}
implementation {
  components TossimActiveMessageC as AM;
  
  #if defined(SMAC)
      components MAC_SMAC as Network; 

      components new TimerMilliC() as gotrts_sleepTimer;
      components new TimerMilliC() as RTSwaitTimer;
      components new cTimerMilliC() as CTSwaitTimer;
      components new TimerMilliC() as SYNwaitTimer;
      components new TimerMilliC() as activeTimer;
      components new TimerMilliC() as sleepTimer;
      components new AMSenderC(6);

  #endif

  #if defined(DMAC)
      components MAC_DMAC as Network; 

      components new TimerMilliC() as du_Timer;
      components new TimerMilliC() as SYNwaitTimer;
      components new TimerMilliC() as cycleTimer;
      components new TimerMilliC() as TX_Timer;
      components new TimerMilliC() as RX_Timer;
      components new AMSenderC(6);

  #endif
 
  #if defined(CSMACA)
      components MAC_CSMACA as Network; 

      components new TimerMilliC() as SleepTimer;
      components new TimerMilliC() as RTSwaitTimer;
      components new TimerMilliC() as CTSwaitTimer;
      components new TimerMilliC() as SYNwaitTimer;
      components new TimerMilliC() as RadioTimer;
      components new AMSenderC(6);

  #endif
  
  #if defined(BMACPLUS)
      components MAC_BMACP as Network;
      components new TimerMilliC() as activeTimer;
      components new TimerMilliC() as sleepTimer;
      components new AMSenderC(6);
  #endif
 
 
  #if defined(BMAC)    
      components MAC_BMACwithack as Network;
 components new TimerMilliC() as activeTimer;
  components new TimerMilliC() as sleepTimer;
components new AMSenderC(6);
  #endif
 
  #if defined(XMAC)    
      components MAC_XMAC2 as Network;
 components new TimerMilliC() as activeTimer;
  components new TimerMilliC() as sleepTimer;
//    components new TimerMilliC() as P_ackWaitTimer;
components new AMSenderC(6);
  #endif
 
  #if defined(TMAC)
      components MAC_TMAC2 as Network;
      
      components new TimerMilliC() as gotrts_sleepTimer;
      components new TimerMilliC() as RTSwaitTimer;
      components new TimerMilliC() as CTSwaitTimer;
      components new TimerMilliC() as SYNwaitTimer;
      components new TimerMilliC() as cycleTimer;
      components new TimerMilliC() as TA_Timer;
      components new AMSenderC(6);
      
  #endif    
      
  #if defined(CSMA)    
      components MAC_CSMA as Network;
  #endif

  components CpmModelC as Model;

  components ActiveMessageAddressC as Address;
  components MainC;
  
  
  
  AMSend       = AM;
  Receive      = AM.Receive;
  Snoop        = AM.Snoop;
  Packet       = AM;
  AMPacket     = AM;
  PacketAcknowledgements = Network;


  MainC.SoftwareInit -> Network;
  SplitControl = Network;
  AM.Model -> Network.Packet;
  AM.amAddress -> Address;
  Network.GainRadioModel -> Model;


  #if defined(CSMACA)
      Network.RTSwaitTimer -> RTSwaitTimer;
      Network.CTSwaitTimer -> CTSwaitTimer;
      Network.SYNwaitTimer -> SYNwaitTimer;
      Network.RadioTimer -> RadioTimer;
      Network.SleepTimer -> SleepTimer;
      Network.MacAMSend -> AMSenderC;
      Network.ConPacket -> AMSenderC;
  #endif

  #if defined(SMAC)
      Network.gotrts_sleepTimer -> gotrts_sleepTimer;
      Network.RTSwaitTimer -> RTSwaitTimer;
      Network.CTSwaitTimer -> CTSwaitTimer;
      Network.SYNwaitTimer -> SYNwaitTimer;
      Network.activeTimer -> activeTimer;
      Network.sleepTimer -> sleepTimer;
      Network.MacAMSend ->AMSenderC;
      Network.ConPacket -> AMSenderC;
  #endif



#if defined(BMAC)
    
      Network.activeTimer -> activeTimer;
      Network.sleepTimer -> sleepTimer;
      Network.MacAMSend ->AMSenderC;
      Network.ConPacket -> AMSenderC;
      
  #endif



#if defined(XMAC)
    
      Network.activeTimer -> activeTimer;
      Network.sleepTimer -> sleepTimer;
//      Network.P_ackWaitTimer -> P_ackWaitTimer;
      Network.MacAMSend ->AMSenderC;
      Network.ConPacket -> AMSenderC;
      
  #endif




#if defined(BMACPLUS)
    
      Network.activeTimer -> activeTimer;
      Network.sleepTimer -> sleepTimer;
      Network.MacAMSend ->AMSenderC;
      Network.ConPacket -> AMSenderC;
      
  #endif


  #if defined(TMAC)

      Network.gotrts_sleepTimer -> gotrts_sleepTimer;
      Network.RTSwaitTimer -> RTSwaitTimer;
      Network.CTSwaitTimer -> CTSwaitTimer;
      Network.SYNwaitTimer -> SYNwaitTimer;
      Network.cycleTimer -> cycleTimer;
      Network.TA_Timer -> TA_Timer;
      Network.MacAMSend ->AMSenderC;
      Network.ConPacket -> AMSenderC;
      

  #endif
  
  
  #if defined(DMAC)



      Network.du_Timer -> du_Timer;
      Network.SYNwaitTimer -> SYNwaitTimer;
      Network.cycleTimer -> cycleTimer;
      Network.TX_Timer -> TX_Timer;
      Network.RX_Timer -> RX_Timer;
      Network.MacAMSend ->AMSenderC;
      Network.ConPacket -> AMSenderC;
      

  #endif

  #if defined(POWERTOSSIMZ)
    components PacketEnergyEstimatorP;
    Network.Energy -> PacketEnergyEstimatorP;
    Network.AMPacket -> AM;
  #endif
}

