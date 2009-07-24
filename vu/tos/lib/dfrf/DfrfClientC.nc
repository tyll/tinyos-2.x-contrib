/*
 * Copyright (c) 2009, Vanderbilt University
 * All rights reserved.
 *
 * Permission to use, copy, modify, and distribute this software and its
 * documentation for any purpose, without fee, and without written agreement is
 * hereby granted, provided that the above copyright notice, the following
 * two paragraphs and the author appear in all copies of this software.
 * 
 * IN NO EVENT SHALL THE VANDERBILT UNIVERSITY BE LIABLE TO ANY PARTY FOR
 * DIRECT, INDIRECT, SPECIAL, INCIDENTAL, OR CONSEQUENTIAL DAMAGES ARISING OUT
 * OF THE USE OF THIS SOFTWARE AND ITS DOCUMENTATION, EVEN IF THE VANDERBILT
 * UNIVERSITY HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 * 
 * THE VANDERBILT UNIVERSITY SPECIFICALLY DISCLAIMS ANY WARRANTIES,
 * INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY
 * AND FITNESS FOR A PARTICULAR PURPOSE.  THE SOFTWARE PROVIDED HEREUNDER IS
 * ON AN "AS IS" BASIS, AND THE VANDERBILT UNIVERSITY HAS NO OBLIGATION TO
 * PROVIDE MAINTENANCE, SUPPORT, UPDATES, ENHANCEMENTS, OR MODIFICATIONS.
 *
 * Author: Janos Sallai
 */

generic configuration DfrfClientC(uint8_t appId, typedef payload_t, uint8_t uniqueLength, uint16_t bufferSize) {
  provides {
    interface StdControl;
    interface DfrfSend<payload_t>;
    interface DfrfReceive<payload_t>;
  }
  uses {
    interface DfrfPolicy as Policy;
  }
} implementation {
  components new DfrfClientP(payload_t, uniqueLength, bufferSize) as Client, DfrfEngineC as Engine;

  StdControl = Client;
  Client.SubDfrfControl -> Engine.DfrfControl[appId];
  Client.SubDfrfSend -> Engine.DfrfSend[appId];
  Client.SubDfrfReceive -> Engine.DfrfReceive[appId];

  DfrfSend = Client.DfrfSend;
  DfrfReceive = Client.DfrfReceive;

  Engine.DfrfPolicy[appId] = Policy;
}
