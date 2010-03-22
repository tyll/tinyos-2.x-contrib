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
 * @author David Moss
 * @author Mark Siner
 */
 
#warning "*** INCLUDING SOFTWARE CRC-32 ***"
module PacketCrcP {
  provides {
    interface PacketCrc;
  }
  
  uses {
    interface CrcX<uint32_t>;
  }
}

implementation {
 
  /**
   * Append a CRC to the end of the message.  The first byte of the
   * message MUST be the length byte of the full packet (header + payload + footer)
   * minus the length byte itself.
   *
   * @param msg the packet to calculate and append a CRC.  The length byte
   *     will always increase by 2.
   */
  async command void PacketCrc.computeCrc(void *msg) {
    uint8_t footerlessLength = *((uint8_t *)msg) + 1 - sizeof(blaze_footer_t);
    blaze_footer_t *footer = (blaze_footer_t *)(msg + footerlessLength);
    
    footer->crc = call CrcX.crc((uint8_t *) msg, footerlessLength);
  }
  
  
  /**
   * Verify a CRC at the end of a message.  The first byte of the
   * message MUST be exactly as received - the full packet, including the 
   * 32-bit CRC at the end, minus the length byte itself.  
   *
   * @param msg the packet to verify the CRC.  
   * @return TRUE if the CRC check passed and the data is most likely ok
   */
  async command bool PacketCrc.verifyCrc(void *msg) {
    uint8_t footerlessLength = *((uint8_t *)msg) + 1 - sizeof(blaze_footer_t);
    blaze_footer_t *footer = (blaze_footer_t *)(msg + footerlessLength);
    
    return (footer->crc == call CrcX.crc((uint8_t *) msg, footerlessLength));
  }
  
}

