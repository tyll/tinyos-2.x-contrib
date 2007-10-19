/*
 * Copyright (c) 2005-2006 Rincon Research Corporation
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
 * - Neither the name of the Rincon Research Corporation nor the names of
 *   its contributors may be used to endorse or promote products derived
 *   from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 * ``AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
 * FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL THE
 * RINCON RESEARCH OR ITS CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
 * INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
 * STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
 * OF THE POSSIBILITY OF SUCH DAMAGE
 */

/**
 * Not used!  This remains only to save development time next time software 
 * packet CRC's are required in some radio.
 * 
 * 
 * Since CRC's are somewhat broken on the CCxx00 radios, this was one solution
 * that was fully unit tested.  However, it made acknowledgements a nightmare.
 * So we switched strategies on the CCxx00 radios to make the RX FIFO
 * autoflush if the CRC was incorrect, which worked around the CRC problem
 * described in the errata.  This component is left over, not plugged in 
 * anywhere in the blaze radio stack, but can be applied elsewhere as needed
 * since the code for it is already done.
 * 
 *
 * Rather than make the CRC checking an explicit layer in the radio stack,
 * we simply allow Receive and Transmit to connect into the PacketCrc in
 * parallel.  The PacketCrc interface modifies the length byte of the packet!
 * If the transmit branch is sending with CRC's enabled, then the receive
 * branch must also have CRC's enabled to obtain the correct packet length.
 * 
 * Making this functionality modular, rather than splitting it between
 * the Transmit and Receive branches, makes it possible to unit test.
 * 
 * @author David Moss
 */
 
configuration PacketCrcC {
  provides {
    interface PacketCrc;
  }
}

implementation {

  components PacketCrcP;
  PacketCrc = PacketCrcP;

  components CrcC;
  PacketCrcP.Crc -> CrcC;
  
}
