// $Id$

/*									tab:4
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
 *
 * Authors:		Jason Hill, David Gay, Philip Levis
 * Date last modified:  6/25/02
 *
 */

/**
 * @author Jason Hill
 * @author David Gay
 * @author Philip Levis
 */


//Modified to decouple RADIO and UART for performance reasons.

configuration RadioComm
{
  provides {
    interface StdControl as Control;

    // The interface are as parameterised by the active message id
    interface SendMsg[uint8_t id];
    interface ReceiveMsg[uint8_t id];

    // How many packets were received in the past second
    command uint16_t activity();
  }
  uses {
    // signaled after every send completion for components which wish to
    // retry failed sends
    event result_t sendDone();
  }
}
implementation
{
  // CRCPacket should be multiply instantiable. As it is, I have to use
  // RadioCRCPacket for the radio, and UARTNoCRCPacket for the UART to
  // avoid conflicting components of CRCPacket.
  components RadioAMStandard as AMS, 
    RadioCRCPacket as RadioPacket, 
    NoLeds as Leds, 
    TimerC, HPLPowerManagementM;

  Control = AMS.Control;
  SendMsg = AMS.SendMsg;
  ReceiveMsg = AMS.ReceiveMsg;
  sendDone = AMS.sendDone;

  activity = AMS.activity;
  AMS.TimerControl -> TimerC.StdControl;  
  AMS.ActivityTimer -> TimerC.Timer[unique("Timer")];
  
  
  AMS.RadioControl -> RadioPacket.Control;
  AMS.RadioSend -> RadioPacket.Send;
  AMS.RadioReceive -> RadioPacket.Receive;
  AMS.PowerManagement -> HPLPowerManagementM.PowerManagement;
  
}
