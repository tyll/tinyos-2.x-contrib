
/*
 * "Copyright (c) 2005 The Regents of the University of California.  
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
 */

/** 
 * The public component of the link estimator that provides the
 * quality to and from a neighbor 
 *
 * The CompareBit interface should be provided by the collection protocol's
 * routing engine.
 * 
 * @author Rodrigo Fonseca
 * @author David Moss
 */
 
configuration LinkEstimatorC {
  provides {
    interface LinkEstimator;
    interface AMSend;
    interface Receive;
    interface Packet;
  }
}

implementation {

  components MainC,
      LinkEstimatorP;
  
  LinkEstimator = LinkEstimatorP;
  AMSend = LinkEstimatorP.AMSend;
  Receive = LinkEstimatorP.Receive;
  Packet = LinkEstimatorP.Packet;
          
  MainC.SoftwareInit -> LinkEstimatorP;
  
  components new AMSenderC(AM_CTP_ROUTING);
  LinkEstimatorP.SubAMSend -> AMSenderC;
  LinkEstimatorP.SubAMPacket -> AMSenderC;
  LinkEstimatorP.SubPacket -> AMSenderC;
  
  components new AMReceiverC(AM_CTP_ROUTING);
  LinkEstimatorP.SubReceive -> AMReceiverC;
  
  components CtpRoutingEngineC;
  LinkEstimatorP.CompareBit -> CtpRoutingEngineC;
  
  components RandomC;      
  LinkEstimatorP.Random -> RandomC;
  
  
#if defined(PLATFORM_TELOSB) || defined(PLATFORM_MICAZ)

#ifndef TOSSIM
  components CC2420ActiveMessageC as PlatformActiveMessageC;
#else
  components DummyActiveMessageP as PlatformActiveMessageC;
#endif

#elif defined (PLATFORM_MICA2) || defined (PLATFORM_MICA2DOT)
  components CC1000ActiveMessageC as PlatformActiveMessageC;

#elif defined (HAS_CCXX00_RADIO)
  components BlazeC as PlatformActiveMessageC;

#else 
#warning "Connecting LinkPacketMetadata to DummyActiveMessageP"
  components DummyActiveMessageP as PlatformActiveMessageC;
#endif

  LinkEstimatorP.LinkPacketMetadata -> PlatformActiveMessageC;
  
}


