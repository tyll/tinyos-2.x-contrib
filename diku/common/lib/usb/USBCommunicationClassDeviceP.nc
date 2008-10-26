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

module USBCommunicationClassDeviceP{
  uses interface USBEndpoint as EP1;
  uses interface USBEndpoint as EP2;
  uses interface USBDevice;
  uses interface StdOut;
  uses interface USBControl;
  uses interface BufferManager<usb_pkt_t> as BufferManager;

  provides interface PacketComm<usb_pkt_t>;

} implementation{
  uint8_t lineCoding[7];
  uint8_t receiveRequest=0;
  bool lineCodingOK = FALSE;
  void task classRequestStage2();

  event void USBDevice.sendDone(uint8_t* pkt) { }
  event void USBControl.reset() {}
  async event void StdOut.get(uint8_t data) { }

  event usb_device_request_t USBDevice.vendorRequest(usb_setup_pkt_t *p){
    return USB_SETUP_DONE;
  }

  /**
   * Class requests (from host)
   *
   * Handle CDC class requests and indicates to the control-endpoint
   * whether any aditional data is to be received.
   */

  uint8_t serialStateResponse[10];
/*  __attribute((code)) =  { */
/*     0xA1, 0x20, 0x00, 0x00, 0x00, 0x00, 0x02, 0x00, 0x00, 0x00 */
/*   }; */
  void task sendSerResp() {
    serialStateResponse[0] = 0xA1; // bmRequest Type: SERIAL_STATE
    serialStateResponse[1] = 0x20; // Notification type: SERIAL_STATE
    serialStateResponse[2] = 0x00;
    serialStateResponse[3] = 0x00;
    serialStateResponse[4] = 0x00;
    serialStateResponse[5] = 0x00;
    serialStateResponse[6] = 0x02;
    serialStateResponse[7] = 0x00;
    serialStateResponse[8] = 0x00; // UART state bitmap #1
    serialStateResponse[9] = 0x00; // UART state bitmap #2
    call EP1.send((uint8_t*) &serialStateResponse, 10);//sizeof(serialStateResponse));
  }

  event usb_device_request_t USBDevice.classRequest(usb_setup_pkt_t *p){
     // Default response: done, set to receive otherwise
    usb_device_request_t res=USB_SETUP_DONE;
    receiveRequest = p->bRequest;

    switch(p->bRequest) {
    case SEND_ENCAPSULATED_COMMAND: 
      call StdOut.print("SER");
      //call USBDevice.receive(recvBuf, (uint16_t) setup->wLength);
      //res=USB_RECEIVE_FOLLOW_SETUP;
      break;
    case GET_ENCAPSULATED_RESPONSE:
      call StdOut.print("GER");
      break;
    case GET_LINE_CODING: 
      call StdOut.print("GLC");
      post classRequestStage2();
      res=USB_RECEIVE_FOLLOW_SETUP;
      break;
    case SET_LINE_CODING:
      call StdOut.print("SLC");
      //Lin Coding Structure (7 bytes)
      //0-3 dwDTERate   DataTerminalRate(baudrate), in bps (LSB first)
      //  4 bCharFormat Stop bits: 0-1 Stop bit, 1-1.5 Stop bits, 2-2 Stop bits
      //  5 bParityType Parity:    0-None, 1-Odd, 2-Even, 3-Mark, 4-Space
      //  6 bDataBits   Data bits: 5, 6, 7, 8, 16
      call USBDevice.receive((uint8_t*) &lineCoding, (uint16_t) 7);
      res=USB_RECEIVE_FOLLOW_SETUP;
      break;
    case SET_CONTROL_LINE_STATE:
      call StdOut.print("SCLS");
      /* Do not reply! */
      //call USBDevice.receive(r, (uint16_t) 7);
      // Set/reset RTS/DTR according to wValue (bit 0 ~ DTR, bit 1 ~ RTS)
      break;
    case SEND_BREAK:
      call StdOut.print("SB");
      break;
    default:
      call StdOut.print("UK");
    }
    //post sendSerResp();
    return res;
  }

  event void USBDevice.receiveDone(uint8_t *pkt) {
    post classRequestStage2();
  }

  void task classRequestStage2 (){
    switch(receiveRequest) {
    case SEND_ENCAPSULATED_COMMAND: break;

    case SET_LINE_CODING:
      lineCodingOK = TRUE;
      // Respond with 0-length packet
      call USBDevice.send(NULL, 0);
      break;

    case GET_LINE_CODING:
      {
        uint8_t *lc_p, i;
        lc_p = lineCodingOK == TRUE ?
          lineCoding :
          (uint8_t*)&cdc_9600_8n1;
        call StdOut.print("GLC ");
        call StdOut.print("lineCoding: ");
        for(i=0 ; i<sizeof(lineCoding) ; i++ ) {
/*           call StdOut.printHex(lc_p[i]); */
        }
        call StdOut.print("\n");
        call USBDevice.send(lc_p, sizeof(line_coding_t));
      }
    }
  }


  // The second but last byte indicates the line-state

  event void USBDevice.setConfiguration(uint8_t c) {
    //call USBControl.configure(1, _BV(USB_EP_IN));//_BV(USB_EP_OUT));
    call USBControl.configure(1, _BV(USB_EP_IN) |_BV(USB_EP_OUT));
    call USBControl.configure(2, _BV(USB_EP_IN)| _BV(USB_EP_OUT)); 
    post sendSerResp();
    //call EP1.send((uint8_t*) &serialStateResponse, sizeof(serialStateResponse));
  }

  /**
   * Endpoint 1
   */

  event void EP1.sendDone(uint8_t* pkt) {
    call StdOut.print("E1SD\n\r");
  }

  async event error_t EP1.receiveReady(uint16_t recv_len,
				       uint8_t** next_buf) {
    call StdOut.print("E1");
    return SUCCESS;
  }
  async event void EP1.receiveDone(uint16_t recv_len, uint8_t* recv_pkt) {
  }

  /**
   * Endpoint 2 handles the actual data bytes
   */

  usb_pkt_t *transmitPkt;
  command error_t PacketComm.send(usb_pkt_t* pkt) {
    error_t r;
    if ((r = call EP2.send(pkt->page, pkt->length)) == SUCCESS) {
      transmitPkt = pkt;
    }
    return r;
  }

  event void EP2.sendDone(uint8_t* pkt) {
    if (transmitPkt != NULL) {
      signal PacketComm.sendDone(transmitPkt);
      transmitPkt = NULL;
    }
  }

  //uint8_t receive_buf[EP2_PACKET_SIZE+1];
  usb_pkt_t *recvPkt = NULL;
  async event error_t EP2.receiveReady(uint16_t recv_len,
				       uint8_t** next_buf) {
    if (recvPkt==NULL && recv_len<=sizeof(recvPkt->page)) {
      atomic {
	recvPkt = call BufferManager.get();
      }
      if (recvPkt != NULL) {
        (*next_buf) = (uint8_t*) recvPkt->page;
        return SUCCESS;
      }
    }
    call StdOut.print("E2 overflow");
    return FAIL;
  }
  async event void EP2.receiveDone(uint16_t recv_len, uint8_t* recv_pkt) {
    recvPkt->length = (uint8_t) recv_len;
    signal PacketComm.receive(recvPkt);
    recvPkt = NULL;
  }
}

