/*
 * Copyright (c) 2008 Polaric
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
 * - Neither the name of Polaric nor the names of its contributors may
 *   be used to endorse or promote products derived from this software
 *   without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND
 * CONTRIBUTORS ``AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES,
 * INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
 * MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 * DISCLAIMED.  IN NO EVENT SHALL POLARIC OR ITS CONTRIBUTORS BE
 * LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
 * EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
 * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS
 * OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
 * CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
 * STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
 * ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

/**
 *
 * @author Martin Leopold <leopold@polaric.dk>
 */

/*
 * USBSerialCDCP
 *
 * This component transforms the packet based
 * CommunicationsClassDevice into a standard byte based
 * SerialByteComm.
 *
 * The performance of this approach is limited by the USB packet rate,
 * given that each "put" command will be translated into one packet
 * with a single byte. With a 1 ms packet length the performance
 * cannot exceed 8 kbit.
 */

module  USBSerialCDCP {
  uses interface StdOut;
  uses interface PacketComm<usb_pkt_t> as PacketComm;
  uses interface BufferManager<usb_pkt_t> as BufferManager;

  provides interface SerialByteComm;
} implementation{

  async event void StdOut.get(uint8_t data) { }

  usb_pkt_t* rxPkt = NULL;
  task void putter() {
    uint8_t i;
    for (i=0 ; i<rxPkt->length ; i++) {
      signal SerialByteComm.get(rxPkt->page[i]);
    }
    call BufferManager.free(rxPkt);
    rxPkt = NULL;
  }

  event void PacketComm.receive(usb_pkt_t* pkt) {
    if (rxPkt == NULL) {
      rxPkt = pkt;
      post putter();
    } else {
      call BufferManager.free(pkt);
    }
  }

  
  async command error_t SerialByteComm.put(uint8_t data){
    usb_pkt_t *txBuf;
    txBuf = call BufferManager.get();
    if (txBuf != NULL) {
      txBuf->length=1;
      txBuf->page[0] = data;
      return call PacketComm.send(txBuf);
    }
    return FAIL;
  }
  event void PacketComm.sendDone(usb_pkt_t* pkt) {
    call BufferManager.free(pkt);
  }
}
