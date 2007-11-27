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
 * With a 16-bit CRC, there is always a 1 in 65535 chance of obtaining
 * a corrupted packet that passes the CRC check.  It can and will happen, given
 * enough time.
 * 
 * If your messages need a higher integrity, I recommend adding your own
 * 8- or 16-bit CRC check in your application layer at the end of your 
 * payload.  I wouldn't recommend using this particular interface / component 
 * to do it, this interface is to be used only by AsyncTransmitP and 
 * BlazeReceiveP.
 * 
 * @author David Moss
 */
 
interface PacketCrc {

  /**
   * Append a CRC to the end of the message.  The first byte of the
   * message MUST be the length byte of the full packet (header + payload)
   * minus the length byte itself.  The length byte of the packet will be
   * increased by 2 to show the packet now contains a 2-byte CRC-16 at the end.
   *
   * @param msg the packet to calculate and append a CRC.  The length byte
   *     will always increase by 2.
   */
  async command void appendCrc(uint8_t *msg);
  
  /**
   * This command MUST be called after the message has been sent, so the
   * original message is not corrupted by a larger length. Without doing
   * this, it is possible to call appendCrc() many times on the same message
   * causing an overflow.
   * @param msg the message that was recently sent
   */
  async command void removeCrc(uint8_t *msg);
  
  /**
   * Verify a CRC at the end of a message.  The first byte of the
   * message MUST be exactly as received - the full packet, including the 
   * 16-bit CRC at the end, minus the length byte itself.  After CRC
   * confirmation, the length byte will be decremented by 2 to remove
   * the existance of the CRC.
   *
   * @param msg the packet to verify the CRC.  The length byte will decrease
   *     by 2 regardless of the result, removing the CRC.
   * @return TRUE if the CRC check passed and the data is most likely ok
   */
  async command bool verifyCrc(uint8_t *msg);
  
}
