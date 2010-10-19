/* ex: set tabstop=2 shiftwidth=2 expandtab syn=c:*/
/* $Id$ */

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


configuration S4QueuedSendComm {
  provides {
    interface Init;
    interface StdControl;
    interface AMSend[uint8_t id];
    interface Receive[uint8_t id];
  }
  uses {    
    interface StdControl as BottomStdControl;
    interface AMSend as BottomSendMsg[uint8_t id];
    interface Receive as BottomReceiveMsg[uint8_t id];
  }
}
  
implementation {
  components 
             S4QueuedSendM as QueuedSendM
           , LedsC as Leds        /////Diff
           , ActiveMessageC        
           , S4ActiveMessageC   
#ifdef SERIAL_LOGGING
           , new SerialAMSenderC(AM_RTLOGGINGPACKET)  
           , SerialActiveMessageC  
#endif
           , new TimerMilliC() as QueueRetransmitTimer
           , RandomLfsrC	     
           ;
            

  
  StdControl = BottomStdControl;
  StdControl = QueuedSendM;
  Init = QueuedSendM;

  AMSend = QueuedSendM.QueueSendMsg;
  Receive = BottomReceiveMsg;
 
  QueuedSendM.AirSendMsg = BottomSendMsg;   
  QueuedSendM.Leds -> Leds;  
  QueuedSendM.Acks -> S4ActiveMessageC;
  
  
  

/////////////////////////////////////////// Qasim 1/15/2007

#ifdef EXP_BACKOFF
QueuedSendM.QueueRetransmitTimer->QueueRetransmitTimer;
QueuedSendM.Random->RandomLfsrC;
#endif

#ifdef SERIAL_LOGGING 
  QueuedSendM.SerialActiveMessagePkt -> SerialAMSenderC;
  QueuedSendM.SerialAMSend -> SerialAMSenderC;
  QueuedSendM.SerialAMControl -> SerialActiveMessageC;
  QueuedSendM.SerialPacketInterface -> SerialAMSenderC;
#endif
}
