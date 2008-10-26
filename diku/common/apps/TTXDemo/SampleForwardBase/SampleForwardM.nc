
/*
 * Copyright (c) 2007 University of Copenhagen
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 * - Redistributions of source code must retain the above copyright
 *   notice, this list of conditions and the following disclaimer.
 * - Redistributions in binary form must reproduce the above copyright
 *   notice, this list of conditions and the following disclaimer in the
 *   documentation and/or other materials provided with the
 *   distribution.
 * - Neither the name of University of Copenhagen nor the names of
 *   its contributors may be used to endorse or promote products derived
 *   from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 * ``AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
 * FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL THE UNIVERSITY
 * OF COPENHAGEN OR ITS CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
 * INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
 * STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
 * OF THE POSSIBILITY OF SUCH DAMAGE.
 */

/**
 *
 * @author Marcus Chang <marcus@diku.dk>
 */

module SampleForwardM
{
  provides interface Init;
  uses interface Boot;
  uses interface StdOut;

  uses interface SimpleMac;
  uses interface StdControl as SimpleMacControl;
}
implementation
{

  mac_addr_t adr = 0x000B;

  command error_t Init.init() {

    TOS_NODE_ID = 0x000B;

    return SUCCESS;
  }

  event void Boot.booted() {

    call StdOut.print("SampleForwardBase\n\r");

    call SimpleMac.setChannel(20);
    call SimpleMacControl.start();      

    call SimpleMac.setPanAddress(&adr);
  }


  event void SimpleMac.sendPacketDone(packet_t *packet, error_t result)
  {
      if (result == SUCCESS) {
        call StdOut.print("Transmission done\r\n");
      } else {
        call StdOut.print("Transmission failed: ");
        call StdOut.printHex(result);
        call StdOut.print("\r\n");
      }
    
    return;
  }
  
  event packet_t * SimpleMac.receivedPacket(packet_t *packet)
  {
    uint8_t length, i;
    
    length = packet->length;
          
    for (i = 0; i < length - 9; )
    {
      call StdOut.printHexword(packet->src);
      
      // x
      call StdOut.printHex(packet->data[i++]);
      call StdOut.printHex(packet->data[i++]);
      // y
      call StdOut.printHex(packet->data[i++]);
      call StdOut.printHex(packet->data[i++]);
      // z
      call StdOut.printHex(packet->data[i++]);
      call StdOut.printHex(packet->data[i++]);
      
      call StdOut.print("\n\r");
    }

    return packet;
  }

  uint8_t buffer;
  task void echoTask();

  async event void StdOut.get( uint8_t byte ) {
    buffer = byte;

    post echoTask();
  }

  uint16_t i;

  task void echoTask() {
    uint8_t tmp[2];

    atomic tmp[0] = buffer;
    tmp[1] = '\0';

    switch (tmp[0]) {

        case '\r':
            call StdOut.print("\n\r");
            break;

        default:
            call StdOut.print(tmp);
    }
  }

}

