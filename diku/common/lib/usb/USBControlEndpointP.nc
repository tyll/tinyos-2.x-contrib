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

#include <usb.h>
#include <usb-cdc.h>

module USBControlEndpointP {
  uses interface USBControl;
  uses interface USBEndpoint as EP0;
  uses interface StdOut;
  provides interface USBDevice;
} implementation {

  /**
   * Prototypes
   */
  void debug_setup(usb_setup_pkt_t *setup);
  error_t descriptorResp(usb_setup_pkt_t* Setup, uint8_t* respLen, uint8_t** respPkt);
  
  bool deviceConfigured = FALSE;
  usb_setup_pkt_t setup_pkt_r; 
  uint8_t *cur_pkt = (uint8_t*) &setup_pkt_r;
  uint8_t *receiveEnd = NULL;  // Indicate that we are in receive mode
  uint8_t *receiveStart;
  
  task void handleSetup();
  
  default event usb_device_request_t USBDevice.classRequest(usb_setup_pkt_t *p){
    return USB_SETUP_DONE;
  }
  default event usb_device_request_t USBDevice.vendorRequest(usb_setup_pkt_t *p){
    return USB_SETUP_DONE;
  }
  command error_t USBDevice.send(uint8_t* pkt, uint16_t pkt_len){
    return call EP0.send(pkt, pkt_len);
  }
  event void USBControl.reset() {}
  async event void StdOut.get(uint8_t data) { }

  async event error_t EP0.receiveReady(uint16_t recv_len, uint8_t **next_buf){
    /**
     * Return appropriate pointer, either as an incoming data packet or setup
     */
    if (((recv_len==8) && cur_pkt!=NULL) ||
	(receiveEnd!=NULL && receiveEnd<=(recv_len+cur_pkt))
	) {
      (*next_buf) = (uint8_t*) cur_pkt;
      return (SUCCESS);
    }
    return (FAIL);
  }

  async event void EP0.receiveDone(uint16_t recv_len, uint8_t *recv_pkt){
    if ((receiveEnd!=NULL) && (cur_pkt+recv_len<receiveEnd)){
      // We need to receive more
      cur_pkt += recv_len;
    } else {
      post handleSetup();
    }
  }

  event void EP0.sendDone(uint8_t* pkt_sent){
  }

  /**
   * Handle a setup packet packet received on endpoint 0
   */

  command void USBDevice.receive(uint8_t *pkt, uint16_t pkt_len) {
    call StdOut.print("RS");
    cur_pkt = pkt;
    receiveStart = pkt;
    receiveEnd = pkt + pkt_len;
  }

  task void handleSetup() {
    error_t  respOK = FAIL;
    uint8_t  respLen = 0;
    uint8_t *respBuf = NULL;
    uint8_t  deviceAddress;
    usb_setup_pkt_t *setup;
    // This idicate whether to ack setup or dataEnd+setup
    usb_device_request_t dataEnd = USB_RECEIVE_FOLLOW_SETUP;

    /**
     * Handle the end of a receive cycle
     */
    if (receiveEnd != NULL) {
      call USBControl.setupDone(USB_SETUP_DONE);
      receiveEnd = NULL;
      call StdOut.print("R ");
      signal USBDevice.receiveDone(receiveStart);

      // Reset buffer to setup buffer
      cur_pkt = (uint8_t*) &setup_pkt_r;
      return;
    }

/*     call StdOut.print("EP0"); */

    setup = (usb_setup_pkt_t*) cur_pkt;

    setup->wValue  = usbToHost16(setup->wValue);
    setup->wIndex  = usbToHost16(setup->wIndex);
    setup->wLength = usbToHost16(setup->wLength);

    //debug_setup(setup);

    /* Chech Device Request Type (DRT) */
    switch(setup->bmRequestType & USB_BMREQUEST_MASK){
    case USB_REQUEST_STD:
      switch(setup->bRequest){
      case USB_GET_STATUS:break;
      case USB_CLEAR_FEATURE: break;
      case USB_SET_FEATURE: break;
      case USB_SET_ADDRESS://Second
        deviceAddress = ((uint8_t)(setup->wValue & 0xFF));
        call USBControl.setDevAdress(deviceAddress);
        respLen = 0;
        respOK = FAIL; // Apparently no resp. requres
        dataEnd=USB_SETUP_DONE;
        break;
        
      case USB_GET_DESCRIPTOR: //First
        respOK = descriptorResp(setup, &respLen, &respBuf);
        // Send only requested bytes
        // packet includes real length => host will requst appropriate length
        if (respLen > setup->wLength)
          {respLen = setup->wLength;}
        break;

      case USB_SET_DESCRIPTOR: break;
      case USB_GET_CONFIGURATION:
        respOK = SUCCESS;
        respLen = 1;
        if (deviceConfigured == TRUE){ //USB_State == DEV_CONFIGURED) {
          respBuf = (uint8_t*) OnesPacket;
        } else {
          respBuf = (uint8_t*) ZerosPacket;
        }
        break;

      case USB_SET_CONFIGURATION:
        if ( (uint8_t)(setup->wValue & 0xFF) == 
              (uint8_t)(MyConfigDescSet.config_desc.bConfigurationValue & 0xFF) ) {
          deviceConfigured = TRUE;
          respOK = FAIL;
          respLen = 0;
          signal USBDevice.setConfiguration((uint8_t)setup->wValue & 0xFF);
          dataEnd = USB_RECEIVE_FOLLOW_SETUP;
        }
        break;

      case USB_GET_INTERFACE: break;
      case USB_SET_INTERFACE: break;
        //case USB_SYNCH_FRAME: break;
      }
      break;

    case USB_REQUEST_CLASS:
      call StdOut.print(" CR");
      dataEnd =  signal USBDevice.classRequest(setup);
      respLen = 0;
      respOK = FAIL; /* Let event hander respond if requred */
      break;
    case USB_REQUEST_VENDOR:
      dataEnd = signal USBDevice.vendorRequest(setup);
      respLen = 0;
      respOK = FAIL;
      break;
    }

    // Acknowledge OUT or SETUP pakcet
    call USBControl.setupDone(dataEnd);

    if (respOK==SUCCESS) {
      call EP0.send(respBuf, respLen);
    }
    return;
  }
  
  void debug_setup(usb_setup_pkt_t *setup){
    uint8_t MSB = (uint8_t) ((setup->wValue & 0xFF00u)>>8);
    uint8_t LSB = (uint8_t) (setup->wValue & 0xFFu);

    switch(setup->bmRequestType & USB_BMREQUEST_MASK){
    case USB_REQUEST_STD:
      switch(setup->bRequest){
      case USB_GET_STATUS:
        call StdOut.print(" GS");
        break;
      case USB_CLEAR_FEATURE:
        call StdOut.print(" CF");
        break;
      case USB_SET_FEATURE:
        call StdOut.print(" SF");
        break;
      case USB_SET_ADDRESS://Second
        call StdOut.print(" SA");
        call StdOut.printHexword(setup->bmRequestType);
        call StdOut.print(" ");
        call StdOut.printHexword(setup->wLength);
        call StdOut.print(" add: ");
        call StdOut.printHexword(setup->wValue);
        break;
      case USB_GET_DESCRIPTOR: //First
        {        uint8_t DA;
        CIP51_USBPOLL_READ_BYTE(CIP51_USBADR_FADDR, DA);

        call StdOut.print(" GD: ");
        call StdOut.printHexword(setup->bmRequestType);
        call StdOut.print(" add: ");
        call StdOut.printHexword(DA);
        call StdOut.print(" wLength: ");
        call StdOut.printHexword(setup->wLength);

        call StdOut.print(" wValue: ");
        call StdOut.printHexword(setup->wValue);
        call StdOut.print(" Msb: ");
        call StdOut.printHex(MSB);
        call StdOut.print(" Lsb: ");
        call StdOut.printHex(LSB);}
        break;
      case USB_GET_CONFIGURATION:
        call StdOut.print(" GC");
        call StdOut.print(" wLength: ");
        call StdOut.printHexword(setup->wLength);
        call StdOut.print(" wValue: ");
        call StdOut.printHexword(setup->wValue);
        break;
      case USB_SET_CONFIGURATION:
        call StdOut.print(" SC");
        call StdOut.print(" wLength: ");
        call StdOut.printHexword(setup->wLength);
        call StdOut.print(" wValue: ");
        call StdOut.printHexword(setup->wValue);
        break;
      case USB_GET_INTERFACE:
        call StdOut.print(" GI");
        break;
      case USB_SET_INTERFACE:
        call StdOut.print(" SI");
        break;
        //case USB_SYNCH_FRAME: break;
      default:
        call StdOut.print(" US");
        break;
      }
      break;
    case USB_REQUEST_CLASS:
/*       call StdOut.print(" CR"); */
      break;
    case USB_REQUEST_VENDOR:
      call StdOut.print(" VR");
      break;
    default:
      call StdOut.print(" UR");
      break;
    }
    call StdOut.print("\n\r");
  }
  
  error_t descriptorResp(usb_setup_pkt_t* Setup, 
                         uint8_t* respLen,
                         uint8_t** respBuf) {
  
    // Request must be directed to device
    if ( Setup->bmRequestType == USB_IN_DEVICE){
      // Argh: wValue is in host order, which may varry!!!!
      uint8_t MSB = (uint8_t) ((Setup->wValue & 0xFF00u)>>8);
      uint8_t LSB = (uint8_t) (Setup->wValue & 0xFFu);
      switch( MSB ) {
						
      case USB_DESCRIPTOR_DEVICE: // eq 0x01
        if ( (LSB == 0) && (Setup->wIndex == 0) ) {
          (*respLen) = sizeof( usb_device_descriptor_t );
          (*respBuf) = (uint8_t*)&MyDeviceDesc;
          //memcpy(respPkt, , (*respLen));
        }
        break;
      case USB_DESCRIPTOR_CONFIG:  // eq 0x02  
        // Config index (we only have one)
        if ( (LSB == 0) && (Setup->wIndex == 0) )  {
          (*respLen) = sizeof( configuration_desc_set_t );
          (*respBuf) = (uint8_t*)&MyConfigDescSet;
          //memcpy(respPkt, (uint8_t*)&MyConfigDescSet, (*respLen));
        }
        break;
      case USB_DESCRIPTOR_STRING: // eq 0x03
	// wValue.LSB holds string index, wIndex holds language ID
        if ( LSB < sizeof(StringDescTable) ) {
          (*respLen) = *(StringDescTable[LSB]); // First field contains length
          (*respBuf) =(uint8_t*)&StringDescTable[LSB];
          //memcpy(respPkt, (uint8_t*)&StringDescTable[LSB], (*respLen));
        }
        break;
      default: // If the descriptor is unknown return a 0 length packet
        (*respLen) = 0;
        (*respBuf) = NULL;
      }
    }
    return SUCCESS; // Allways return something to the host
  }
}
