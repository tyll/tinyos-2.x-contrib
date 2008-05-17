/*
 * "Copyright (c) 2006 Washington University in St. Louis.
 * All rights reserved.
 *
 * Permission to use, copy, modify, and distribute this software and its
 * documentation for any purpose, without fee, and without written agreement is
 * hereby granted, provided that the above copyright notice, the following
 * two paragraphs and the author appear in all copies of this software.
 *
 * IN NO EVENT SHALL WASHINGTON UNIVERSITY IN ST. LOUIS BE LIABLE TO ANY PARTY
 * FOR DIRECT, INDIRECT, SPECIAL, INCIDENTAL, OR CONSEQUENTIAL DAMAGES ARISING
 * OUT OF THE USE OF THIS SOFTWARE AND ITS DOCUMENTATION, EVEN IF WASHINGTON
 * UNIVERSITY IN ST. LOUIS HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 *
 * WASHINGTON UNIVERSITY IN ST. LOUIS SPECIFICALLY DISCLAIMS ANY WARRANTIES,
 * INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY
 * AND FITNESS FOR A PARTICULAR PURPOSE.  THE SOFTWARE PROVIDED HEREUNDER IS
 * ON AN "AS IS" BASIS, AND WASHINGTON UNIVERSITY IN ST. LOUIS HAS NO
 * OBLIGATION TO PROVIDE MAINTENANCE, SUPPORT, UPDATES, ENHANCEMENTS, OR
 * MODIFICATIONS."
 */

/**
 * This is the PrintfC component. It provides the printf service for
 * printing data over the serial interface using the standard c-style
 * printf command.  The serial port is started is stared upon
 * boot. Data printed using printf are buffered and only sent over the
 * serial line when a '\n' is encounter or when the data accumulated
 * exceeds one packet. Printf statements can be made anywhere
 * throughout your code, so long as you include the "printf.h" header
 * file in every file you wish to use it.
 *
 * This is a modified version of the original printf from tinos-2.x.
 *
 * @author Kevin Klues (klueska@cs.wustl.edu)
 * @author Razvan Musaloiu-E. (razvanm@cs.jhu.edu)
 * @version $Revision$
 * @date $Date$
 */

#include "printf.h"

configuration PrintfC { }
implementation
{
  components MainC, LedsC;
  components SerialActiveMessageC;
  components new SerialAMSenderC(AM_PRINTF_MSG);
  components new PoolC(message_t, 10);
  components new QueueC(message_t*, 10);
  components PrintfP;
  
  PrintfP.Boot -> MainC;
  PrintfP.SerialSplitControl -> SerialActiveMessageC;
  PrintfP.AMSend -> SerialAMSenderC;
  PrintfP.Packet -> SerialAMSenderC;
  PrintfP.Pool -> PoolC;
  PrintfP.Queue -> QueueC;
  PrintfP.Leds -> LedsC;
}

