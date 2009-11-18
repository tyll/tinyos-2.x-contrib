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

/**
 * The TinyOS 2.x base station that forwards packets between the UART
 * and radio.It replaces the GenericBase of TinyOS 1.0 and the
 * TOSBase of TinyOS 1.1.
 *
 * <p>On the serial link, BaseStation sends and receives simple active
 * messages (not particular radio packets): on the radio link, it
 * sends radio active messages, whose format depends on the network
 * stack being used. BaseStation will copy its compiled-in group ID to
 * messages moving from the serial link to the radio, and will filter
 * out incoming radio messages that do not contain that group ID.</p>
 *
 * <p>BaseStation includes queues in both directions, with a guarantee
 * that once a message enters a queue, it will eventually leave on the
 * other interface. The queues allow the BaseStation to handle load
 * spikes.</p>
 *
 * <p>BaseStation acknowledges a message arriving over the serial link
 * only if that message was successfully enqueued for delivery to the
 * radio link.</p>
 *
 * <p>The LEDS are programmed to toggle as follows:</p>
 * <ul>
 * <li><b>RED Toggle:</b>: Message bridged from serial to radio</li>
 * <li><b>GREEN Toggle:</b> Message bridged from radio to serial</li>
 * <li><b>YELLOW/BLUE Toggle:</b> Dropped message due to queue overflow in either direction</li>
 * </ul>
 *
 * @author Phil Buonadonna
 * @author Gilman Tolle
 * @author David Gay
 * @author Philip Levis
 * @date August 10 2005
 *
 * Security Integration by Philip Kuryloski using implementation from 
 * <http://hinrg.cs.jhu.edu/git/?p=jgko/tinyos-2.x.git;a=summary>
 */


configuration SecureBaseStationC {
}
implementation {
  components MainC, SecureBaseStationP, LedsC;
  components SerialActiveMessageC as Serial;
  components ActiveMessageC as Radio;
  
#ifdef SECURE
  components new SecAMSenderC(DEFAULT_AM_TYPE) as SecSender;
  components CC2420KeysC;
  
  SecureBaseStationP.SecSender -> SecSender;
  SecureBaseStationP.CC2420SecurityMode -> SecSender;
  SecureBaseStationP.CC2420Keys -> CC2420KeysC;
  
  SecureBaseStationP.SecRadioPacket -> SecSender;
#endif

  MainC.Boot <- SecureBaseStationP;

  SecureBaseStationP.SerialControl -> Serial;
  SecureBaseStationP.RadioControl -> Radio;
  
  SecureBaseStationP.RadioSend -> Radio;
  SecureBaseStationP.RadioReceive -> Radio.Receive;
  SecureBaseStationP.RadioSnoop -> Radio.Snoop;
  SecureBaseStationP.RadioPacket -> Radio;
  SecureBaseStationP.RadioAMPacket -> Radio;
 
  SecureBaseStationP.UartSend -> Serial;
  SecureBaseStationP.UartReceive -> Serial.Receive;
  SecureBaseStationP.UartPacket -> Serial;
  SecureBaseStationP.UartAMPacket -> Serial;

  SecureBaseStationP.Leds -> LedsC;
}
