
/*									tab:4
 * "Copyright (c) 2009 NUS  
 * All rights reserved.
 *
 * Permission to use, copy, modify, and distribute this software and its
 * documentation for any purpose, without fee, and without written agreement is
 * hereby granted, provided that the above copyright notice, the following
 * two paragraphs and the author appear in all copies of this software.
 * 
 * IN NO EVENT SHALL THE NATIONAL UNIVERSITY OF SINGAPORE BE LIABLE TO ANY PARTY FOR
 * DIRECT, INDIRECT, SPECIAL, INCIDENTAL, OR CONSEQUENTIAL DAMAGES ARISING OUT
 * OF THE USE OF THIS SOFTWARE AND ITS DOCUMENTATION, EVEN IF THE UNIVERSITY OF
 * CALIFORNIA HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 * 
 * THE NATIONAL UNIVERSITY OF SINGAPORE SPECIFICALLY DISCLAIMS ANY WARRANTIES,
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
 /**
 * Application to Test Bluetooth Capabilities of BTNode
 * @author Lee Seng Jea
 * @date   Oct 22 2009
 */


configuration BluetoothTesterAppC {}
implementation {
  components MainC,LedsC, BluetoothTesterC as App;
  components BluetoothC;
  components FluC;
  //components new Atm128CounterC(T32khz,uint16_t) as OriginalStamp, HplAtm128Timer3C as HplStamp,
  //new TransformCounterC(TMilli,uint32_t,T32khz,uint16_t,15,uint32_t) as Timestamp;
  components new TimerMilliC() as Timer, new TimerMilliC() as Heartbeat;
  

  
  App -> MainC.Boot;
  App.Leds -> LedsC;
  App.Bluetooth -> BluetoothC;
  App.Flu -> FluC;
  FluC -> MainC.Boot;
  //OriginalStamp.Timer -> HplStamp;
  //Timestamp.CounterFrom -> OriginalStamp.Counter;
  //App.Timestamp -> Timestamp.Counter;
  App.Timer0 -> Timer;
  
  
//  components new SerialAMReceiverC(AM_FLUREC_T) as ReceiverC;
//  components SerialActiveMessageC;
//  components new SerialAMSenderC(AM_FLUREC_T);
//  components new PointerQueueC(message_t,4);  
//  App.Receive -> ReceiverC;
//  App.Packet -> SerialAMSenderC;
//  App.AMPacket -> SerialAMSenderC;
//  App.AMSend -> SerialAMSenderC;
//  App.AMControl -> SerialActiveMessageC;
//  App.PointerQueue -> PointerQueueC;
  
  App.Heartbeat -> Heartbeat;
}


