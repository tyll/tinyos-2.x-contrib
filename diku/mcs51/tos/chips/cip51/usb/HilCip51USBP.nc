
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
 * This module provides a interface to the USB controller of the
 * SiLabs 8051F34x (and possible other SiLab generations).
 *
 * It is roughly based on an example posted in the Cygnal forum:
 *  http://www.cygnal.org/ubb/Forum9/HTML/000945.html
 *  http://www.cygnal.org/ubb/Forum9/HTML/001050.html
 */

/**
 * @author Martin Leopold <leopold@polaric.dk>
 */

#include <iocip51.h>
#include <usb.h>
#include <usb-cdc.h>
#include <cip51-usb.h>


module HilCip51USBP {
  provides interface Init;
  provides interface USBControl;
  provides interface USBEndpoint as EP0;
  provides interface USBEndpoint as EP1;
  provides interface USBEndpoint as EP2;
/*   uses interface Queue<in_queue_item_t> as InQueue; */
  uses interface StdOut;
} implementation {

  /**
   * Prototypes
   */
  void Fifo_Read(uint8_t addr, uint16_t uNumBytes, uint8_t * pData);
  void Fifo_Write(uint8_t addr, uint16_t uNumBytes, uint8_t* pData);
  task void inPacket();
/*   task void endpoint_out(); */
  task void usb_reset();

  async event void StdOut.get(uint8_t data) { }

  /**
    * Global varialbes for the IN dataPump
    */
  norace in_queue_item_t cur_in_item; // protected by in_item_more
  norace uint8_t *in_item_cur_p;      // protected by in_item_more  
  bool in_item_wait_done; // Signals that next event indicates IN item done
  bool in_item_more;      // Is the transmission cycle over (incl. any 0-len packets)
  bool in_item_signal_done;
  uint8_t out_endpoint_ready;


#define MAX_ENDPOINT 3
  uint8_t in_ep;
  in_item_t in_items[MAX_ENDPOINT+1];

  command error_t Init.init() {
    uint8_t tmp;
    atomic{
      CIP51_USBPOLL_READ_BYTE(CIP51_USBADR_CLKREC, tmp);
      tmp |= 0x80; // Enable clock recovery for full speed mode
      CIP51_USBPOLL_WRITE_BYTE(CIP51_USBADR_CLKREC, tmp);
    }
    post usb_reset();
    return SUCCESS;
  }

  command error_t USBControl.setMode(usb_mode_t mode){
    uint8_t tmp;
    error_t r = FAIL;

    switch(mode) {
    case USB_LOW_SPEED: tmp=0xC0; break;
    case USB_FULL_SPEED: tmp=0xE0; break;
      //case USB_HIGH_SPEED: break;
    }
    USB0XCN = tmp;
    return (r);
  }

  command error_t USBControl.configure(uint8_t ep, usb_ep_config_t c){
    uint8_t EINCSRH, EOUTCSRH;
    uint8_t OUT1IE, IN1IE;

    /* EP0 is always interrupt and IN/OUT */
    if (ep==0 && ( (c & _BV(USB_EP_INISO)) || 
                   (c & _BV(USB_EP_OUTISO)) ||
                   // Logical XOR
                   ((c & _BV(USB_EP_IN)) && (!(c & _BV(USB_EP_OUT)))) ||
                   ((!(c & _BV(USB_EP_IN))) && (c & _BV(USB_EP_OUT)))
                   )
        ){
      return (FAIL);
    }

    EINCSRH = 0;
    EOUTCSRH = 0;
    /* Enable double buffer */
    EOUTCSRH |= _BV(CIP51_EOUTCSRH_DBOEN);
    EINCSRH  |= _BV(CIP51_EINCSRH_DBIEN);
  
    /* Endpoint IN/OUT - split FIFO into IN/OUT portion*/
    if((c & _BV(USB_EP_IN)) && (c & _BV(USB_EP_OUT))) {
      EINCSRH |= _BV(CIP51_EINCSRH_SPLIT);
    }

    /* Endpoint is IN */
    /* Documentation mentions that DIRSEL is only valid when SPLIT==0,
       otherwise the endpoint is IN/OUT, however in Windows this does
       not seem to be the case - if this is not enabled the endpoint
       cannot transmit in the IN direction (in Linux it works just
       fine!?)*/
/*     if((c & _BV(USB_EP_IN)) && !(c & _BV(USB_EP_OUT))) { */
    if((c & _BV(USB_EP_IN))) {
      EINCSRH |= _BV(CIP51_EINCSRH_DIRSEL);
    }
    if (c & _BV(USB_EP_INISO)) {
      EINCSRH |= _BV(CIP51_EINCSRH_ISO);
    }
    if (c & _BV(USB_EP_OUTISO)) {
      EOUTCSRH |= _BV(CIP51_EOUTCSRH_ISO);
    }

    atomic {
      CIP51_USBPOLL_READ_BYTE(CIP51_USBADR_OUT1IE, OUT1IE);
      CIP51_USBPOLL_READ_BYTE(CIP51_USBADR_IN1IE, IN1IE);
      if (c == USB_EP_DISABLED){
        OUT1IE &= ~_BV(ep);
        IN1IE  &= ~_BV(ep);
      } else {
        OUT1IE |= _BV(ep);
        IN1IE  |= _BV(ep);
      }
      OUT1IE = 0xFF;
      IN1IE = 0xFF;

      CIP51_USBPOLL_WRITE_BYTE(CIP51_USBADR_OUT1IE, OUT1IE);
      CIP51_USBPOLL_WRITE_BYTE(CIP51_USBADR_IN1IE,  IN1IE);

      CIP51_USBPOLL_WRITE_BYTE(CIP51_USBADR_INDEX, ep);
      CIP51_USBPOLL_WRITE_BYTE(CIP51_USBADR_EOUTCSRH, EOUTCSRH);
      CIP51_USBPOLL_WRITE_BYTE(CIP51_USBADR_EINCSRH,  EINCSRH);
      CIP51_USBPOLL_WRITE_BYTE(CIP51_USBADR_INDEX, 0);
    }

    return (SUCCESS);
  }

  void sub_reset() {
    uint8_t i;
    for (i=0 ; i<=MAX_ENDPOINT ; i++) {
      in_items[i].start = NULL;
      in_items[i].p = NULL;
      in_items[i].done = FALSE;
      in_items[i].more = FALSE;
      in_items[i].wait_done = FALSE;
    }

    out_endpoint_ready = 0;
    in_ep = 0;
    in_item_cur_p = NULL;
    in_item_signal_done = FALSE;
    in_item_more = FALSE;
    in_item_wait_done=FALSE;

    // USB Interrupt enable flags are reset by USB bus reset
    // Enable Reset and Suspend interrupts
    atomic {
      CIP51_USBPOLL_WRITE_BYTE(CIP51_USBADR_CMIE,	  0x07);
      // Enable transceiver; select full speed
      USB0XCN = 0xE0;
      // Enable clock recovery, single-step mode disabled
      CIP51_USBPOLL_WRITE_BYTE(CIP51_USBADR_CLKREC, 0x80);
      // Return index to 0
      CIP51_USBPOLL_WRITE_BYTE(CIP51_USBADR_INDEX,  0);
    }

    /* Configure USB endpoint prior to enabling USB */
    call USBControl.configure(0, _BV(USB_EP_IN) | _BV(USB_EP_OUT));
    call USBControl.configure(1, USB_EP_DISABLED);
    call USBControl.configure(2, USB_EP_DISABLED);
    call USBControl.enable();
  }

  void task usb_reset() {
    // Force Asynchronous USB Reset
    atomic {
      CIP51_USBPOLL_WRITE_BYTE(CIP51_USBADR_POWER, 0x08);
    }
    sub_reset();
  }

  void task usb_reset_detected() {
    sub_reset();
    signal USBControl.reset();
  }

  /**
   * ACK/NACK the request to the serial engine (SIE)
   */
  command void USBControl.enable(){
    // Enable USB0 by clearing the USB Inhibit bit
    // and enable suspend detection
    atomic {
      CIP51_USBPOLL_WRITE_BYTE(CIP51_USBADR_POWER, 0x01);
    }
    EIE1	|= 0x02; // Enable USB0 interrupt
  }

  command void USBControl.disable(){
    // Set inhibit bit
    atomic {
      CIP51_USBPOLL_WRITE_BYTE(CIP51_USBADR_POWER, 0x10);
    }
    EIE1	&= ~0x02; // Disable USB0 interrupt
  }

  /**
   * Writing SOPRDY indicated that the received packet has been accepted,
   * setting DATAEND if no data is expected to be received
   */
  command void USBControl.setupDone(usb_device_request_t r){
    uint8_t TempReg;
    atomic {
      CIP51_USBPOLL_READ_BYTE(CIP51_USBADR_E0CSR, TempReg );
      if (r==USB_SETUP_DONE) {
        TempReg |= _BV(CIP51_E0CSR_DATAEND);
      }
      TempReg |= _BV(CIP51_E0CSR_SOPRDY); 
      CIP51_USBPOLL_WRITE_BYTE(CIP51_USBADR_E0CSR, TempReg );
    }
  }

  command void USBControl.setDevAdress(uint8_t add) {
    atomic {
      CIP51_USBPOLL_WRITE_BYTE(CIP51_USBADR_FADDR, add);
    }
  }

  void Fifo_Read(uint8_t addr, uint16_t uNumBytes, uint8_t * pData) {
    if (uNumBytes){			// Check if >0 bytes requested,
      atomic {
        if ( --uNumBytes == 0 )      {
          USB0ADR = addr | 0x80;	// Set address and initiate read
          while(USB0ADR & 0x80);	// Wait for BUSY->'0' (data ready)
          *pData = USB0DAT;		// Copy data byte
          return;
        } else  {
          USB0ADR = addr | 0xC0;	// Set address
                                        // Set auto-read and initiate first read
          do {
            while(USB0ADR & 0x80);	// Wait for BUSY->'0' (data ready)
            *pData = USB0DAT;
            pData++;
          } while ( --uNumBytes != 0 );
          while(USB0ADR & 0x80);	// Wait for BUSY->'0' (data ready)
          USB0ADR = 0;			// Clear auto-read
          *pData = USB0DAT;		// Copy data byte
      }
      }
    }
  }

  void Fifo_Write(uint8_t addr, uint16_t uNumBytes, uint8_t* pData) {
    uint8_t *start;
    if (uNumBytes)  {
      atomic {
        while(USB0ADR & 0x80);   // Wait for BUSY->'0'
        USB0ADR = (addr & 0x3f); // Set address (mask out bits7-6)
        
        for (start=pData ; start < (pData+uNumBytes) ; start++) {
          USB0DAT = *start;
          while(USB0ADR & 0x80);			// Wait for BUSY->'0'
        }
      }
    }
  }

/**
 * This task handles the communiction with the host, through the
 * serial interface engine (SIE) of the Silabs MCU. This involves
 * going through the setup negotiation and returning propper host
 * identification.
 *
 * The task is posted when an EP0 interrupt is generated. This
 * interrupt is generated in a number of cases, that must be
 * checked separately:
 *  1) An packet from the host (OUT) has been received (eg. setup)
 *  2) A packet to the host (IN) has been offloaded
 * 
 * For more see datasheet 16.10: Endpoint0 (p.184)
 * www.silabs.com/public/documents/tpub_doc/dsheet/Microcontrollers/USB/en/C8051F34x.pdf
 */

  usb_setup_pkt_t fromHost;
  uint8_t pkt_cnt=0;

  /*
   * The combined IN/OUT event for endpoint0, if the datapump is
   * running repost the task.
   */
  void task endpoint0() {
    uint8_t E0CSR;
    bool in_event = TRUE; // Signal in event by exclusion

    atomic {
      CIP51_USBPOLL_WRITE_BYTE(CIP51_USBADR_INDEX, 0);
      CIP51_USBPOLL_READ_BYTE(CIP51_USBADR_E0CSR, E0CSR);
      // SIE indicates Setup Phase is over (or setup is received inappropriately)
      if (E0CSR & _BV(CIP51_E0CSR_SUEND)) {
	CIP51_USBPOLL_WRITE_BYTE(CIP51_USBADR_E0CSR, _BV(CIP51_E0CSR_SSUEND)); 
	in_event=FALSE;
      }
    }

    // Reset if host requests stall
    if (E0CSR & _BV(CIP51_E0CSR_STSTL) ) {
      atomic {
	CIP51_USBPOLL_WRITE_BYTE(CIP51_USBADR_INDEX, 0);
        CIP51_USBPOLL_WRITE_BYTE(CIP51_USBADR_E0CSR, 0);
      }
      post usb_reset();
      call StdOut.print("Stall");
      in_event=FALSE;
      return;
    }

    /* Read OUT packet, or flush if no buffer is ready */
    if (E0CSR & _BV(CIP51_E0CSR_OPRDY)){
      uint8_t *pkt_buf, tmp;
      atomic {
	CIP51_USBPOLL_WRITE_BYTE(CIP51_USBADR_INDEX, 0);
        CIP51_USBPOLL_READ_BYTE(CIP51_USBADR_E0CNT, tmp); // length of packet
        if (signal EP0.receiveReady((uint16_t) tmp, &pkt_buf) == SUCCESS) {
          Fifo_Read(CIP51_USBADR_FIFO_EP0, (uint16_t) tmp, pkt_buf);
          signal EP0.receiveDone(tmp, pkt_buf);
        } else { // Flush
          call StdOut.print("Flush!");
          while ((tmp--)!=0){
            CIP51_USBPOLL_READ_BYTE(CIP51_USBADR_FIFO_EP0, tmp);
          }
        }
      }
      // OUT is ack'ed through setupDone
      in_event=FALSE;
    }
    /* Post dataPump if we are not working on the previous packet */
/*     if (in_event==TRUE && cur_in_item.endpoint == 0 && /\*(in_item_more==TRUE) &&*\/ (!(E0CSR & _BV(CIP51_E0CSR_INPRDY)))){ */
/*       if(in_item_wait_done == TRUE || in_item_more==TRUE) { */
/* 	call StdOut.print("X"); */
/*         in_item_signal_done=TRUE;  */
/*         post dataPump(); */
/*       } */
/*     } */

    if ((in_event==TRUE) && /*(in_item_more==TRUE) &&*/ (!(E0CSR & _BV(CIP51_E0CSR_INPRDY)))){
      if( (in_items[0].wait_done==TRUE) || (in_items[0].more==TRUE)) {
        in_items[0].done=TRUE; 
        post inPacket();
      }
    }
  }

/*   Handle OUT events for endpoint > 0 */
/*    Replaced by interrupt handler */
  uint8_t count=0;

/*   void task endpoint_out() { */
/*     uint8_t tmp, outCSRL, endpoint; */
/*     uint8_t *pkt_buf; */

/*     /\* */
/*      * This will obviously fail if more than 1 endpoint has data ready */
/*      * at the same time - hopefully the serial part of USB will ensure */
/*      * this never happens ;] */
/*      *\/ */
/*     atomic { */
/*       endpoint = out_endpoint_ready; */
/*       out_endpoint_ready=0; */
/*     } */
/*     count++; */
/*     if (count==0){ */
/*       call StdOut.printHex(endpoint); */
/*     } */

/*     /\*   call StdOut.print("Out"); *\/ */
/*     // Get Control Status Register */
/*     CIP51_USBPOLL_WRITE_BYTE(CIP51_USBADR_INDEX, endpoint); */
/*     CIP51_USBPOLL_READ_BYTE(CIP51_USBADR_EOUTCSRL, outCSRL); */

/*     /\* Flush in case of error *\/ */
/*     if (outCSRL & _BV(CIP51_EOUTCSRL_DATERR)){ */
/*       call StdOut.print("Flush"); */
/*       outCSRL = _BV(CIP51_EOUTCSRL_FLUSH); */
/*       CIP51_USBPOLL_WRITE_BYTE(CIP51_USBADR_EOUTCSRL, outCSRL); */
/*       return; */
/*     } */

/*     // Reset if host requests stall */
/*     if (outCSRL & _BV(CIP51_EOUTCSRL_STSTL)) { */
/*       CIP51_USBPOLL_WRITE_BYTE(CIP51_USBADR_EOUTCSRL, 0); */
/*       post usb_reset(); */
/*       call StdOut.print("Stall\n\r"); */
/*       return; */
/*     } */
/*     /\* Read OUT packet *\/ */
/*     tmp = outCSRL & _BV(CIP51_EOUTCSRL_OPRDY); // == CIP51_E0CSR_OPRDY */
/*     if (tmp){ */
/*       uint16_t pktLen; */
/*       error_t ready; */
/* /\*       call StdOut.print("OP"); *\/ */
/*       // Read length of packet */
/*       CIP51_USBPOLL_READ_BYTE(CIP51_USBADR_EOUTCNTL, tmp); */
/*       pktLen = (uint16_t) tmp; */
/*       CIP51_USBPOLL_READ_BYTE(CIP51_USBADR_EOUTCNTH, tmp); */
/*       pktLen = pktLen + (256*((uint16_t)tmp)); */

/*       switch (endpoint) { */
/*       case 1: ready=signal EP1.receiveReady(pktLen, &pkt_buf); break; */
/*       case 2: ready=signal EP2.receiveReady(pktLen, &pkt_buf); break; */
/*       default: ready=FAIL; */
/*       } */
/*       if (ready == SUCCESS) { */
/*         Fifo_Read(CIP51_USBADR_FIFO_EP0+endpoint, pktLen, pkt_buf); */
/*         switch (endpoint) { */
/*         case 1: signal EP1.receiveDone(pktLen, pkt_buf);break; */
/*         case 2: signal EP2.receiveDone(pktLen, pkt_buf);break; */
/*         } */
/*         outCSRL &= ~_BV(CIP51_EOUTCSRL_OPRDY); */
/*       } else { */
/*         outCSRL |= _BV(CIP51_EOUTCSRL_FLUSH); */
/*       } */
/*       // Ack OUT event */
/*       CIP51_USBPOLL_WRITE_BYTE(CIP51_USBADR_EOUTCSRL, outCSRL); */
/*     } */

/*     // Return index to 0 */
/*     CIP51_USBPOLL_WRITE_BYTE(CIP51_USBADR_INDEX, 0); */
/*   } */

  /*
   * The send/dataPump pair handles the transmission of packets to the
   * host. It handles splitting the packet and sending it in pieces
   * that fit into the USB FIFO.
   *
   * dataPumpMore handles sending 0-length packets ie. if
   * dataPumpMore==SUCCESS and dataPumpRemain==0 a 0-length packet will
   * be sent.
   */

  error_t setupSend(uint8_t ep, uint8_t* pkt, uint16_t pkt_len) {

    if ( (in_items[ep].done == FALSE) &&
	 (in_items[ep].more == FALSE) &&
	 (in_items[ep].wait_done == FALSE)
	 ){
      atomic {
	in_items[ep].start = pkt;
	in_items[ep].p = pkt;
	in_items[ep].len = pkt_len;
	in_items[ep].more = TRUE;
	in_items[ep].done = TRUE;
      }
      post inPacket();
      return SUCCESS;
    }
    return FAIL;
  }

  command error_t EP0.send(uint8_t* pkt, uint16_t pkt_len) {
/*     error_t r; */
/*     in_queue_item_t q; */
/*     q.endpoint = 0; */
/*     q.start = pkt; */
/*     q.len = pkt_len; */
/*     r = call InQueue.enqueue(q); */
/*     post dataPump(); */
/*     return r; */
    return setupSend(0, pkt, pkt_len);
  }

  command error_t EP1.send(uint8_t* pkt, uint16_t pkt_len) {
/*     error_t r; */
/*     in_queue_item_t q; */
/*     q.endpoint = 1; */
/*     q.start = pkt; */
/*     q.len = pkt_len; */
/*     r = call InQueue.enqueue(q); */
/*     post dataPump(); */
/*     call StdOut.print("S1"); */
/*     call StdOut.printHex(q.endpoint); */
/*     return r; */
    return setupSend(1, pkt, pkt_len);
  }

  command error_t EP2.send(uint8_t* pkt, uint16_t pkt_len) {
/*     error_t r; */
/*     in_queue_item_t q; */
/*     q.endpoint = 2; */
/*     q.start = pkt; */
/*     q.len = pkt_len; */
/*     r = call InQueue.enqueue(q); */
/*     post dataPump(); */
/*     return r; */
    return setupSend(2, pkt, pkt_len);
  }

  /**
   * This dataPump handles all IN bound (device->host) endpoints, but
   * bare in mind that the bus is serial meaning, that only one item
   * can be pending at a time.
   *
   * If a in-item needs to be split in several packets no other
   * in-items will be dequed in the mean time. As a consequence if an
   * IN pipe is blocked all endpoints might end up being blocked.
   *
   * To compensate a timeout should be introduced! A simple retry
   * counter will not work, since we rely on the interrupt handler to
   * repost this task when ever an IN transaction finishes. Running
   * each endpoint separately (as oposed to the InQueue) could solve
   * this problem, but could lead to other problems (starvation,
   * etc.).
   *
   * Start the USB transaction by filling the FIFO. If the packet is
   * larger than the FIFO we need to start the event drive data-pump
   */

/*    task void dataPump3() { */
/*      call StdOut.print("DP"); */

/*      /\* Signal send done when SIE indicates that a send is completed *\/ */
/*      if (in_item_signal_done == TRUE && in_item_wait_done == TRUE) { */
/*        call StdOut.print("DN"); */
/*        call StdOut.printHex(cur_in_item.endpoint); */
/*        switch(cur_in_item.endpoint){ */
/*        case 0: signal EP0.sendDone(cur_in_item.start); break; */
/*        case 1: signal EP1.sendDone(cur_in_item.start); break; */
/*        case 2: signal EP2.sendDone(cur_in_item.start); break; */
/*        } */
/*        in_item_signal_done = FALSE; */
/*        in_item_wait_done = FALSE; */
/*      } */

/*      /\** */
/*       * Don't start a new tx untill previous is done */
/*       *\/ */
/*      if (in_item_wait_done == TRUE) { */
/*        return; */
/*      } */

/*      /\* */
/*       * Start the pump if a new item is in the queue or if an old */
/*       * item is pending (possibly a 0-length packet) */
/*       *\/ */
/*      if ((in_item_signal_done == FALSE) && */
/*          (in_item_more==FALSE) && */
/*          (call InQueue.empty() != TRUE)) { */
/*        cur_in_item = call InQueue.dequeue(); */
/*        in_item_signal_done = FALSE; */
/*        in_item_more = TRUE; */
/*        in_item_cur_p = cur_in_item.start; */
/*        call StdOut.print("DQ"); */
/*      } */
/*      call StdOut.printHex(cur_in_item.endpoint); */

/*      if (in_item_more == TRUE) { */
/*        uint8_t TempReg, INCSRL, pendingAction; */
/*        call StdOut.print("MO"); */
/*        /\* disabling USB interrupts might be enough *\/ */
/*        //EIE1 &= ~0x02;// Disable USB interrupt */
/*        atomic{ */
/*          CIP51_USBPOLL_WRITE_BYTE(CIP51_USBADR_INDEX, cur_in_item.endpoint); */
/*          CIP51_USBPOLL_READ_BYTE(CIP51_USBADR_EINCSRL, INCSRL);//Aka E0CSR */

/*          // Clear stall flag, if any */
/*          TempReg = INCSRL & (cur_in_item.endpoint == 0 ?  */
/*                              _BV(CIP51_EINCSRL_SDSTL) :  */
/*                              _BV(CIP51_E0CSR_SDSTL)); */
/*          if (TempReg) { */
/*            CIP51_USBPOLL_WRITE_BYTE(CIP51_USBADR_EINCSRL, ~TempReg); */
/*          } */
/*        } */
/*        /\* */
/*         * In the general case we check that the IN fifo is ready, EP0 */
/*         * is slightly different since it is always IN/OUT - in */
/*         * addition we check that no new OUT packet is ready or that */
/*         * setup is over */
/*         *\/ */
/*        if (cur_in_item.endpoint == 0) { */
/*          pendingAction = INCSRL & (_BV(CIP51_E0CSR_INPRDY) | */
/*                                    _BV(CIP51_E0CSR_SUEND) | */
/*                                    _BV(CIP51_E0CSR_OPRDY)); */
/*        } else  { */
/*          pendingAction = INCSRL & _BV(CIP51_EINCSRL_INPRDY); */
/*        } */
/*        if ( !(pendingAction) ){ // don't overwrite last packet */
/*          uint8_t FIFOSize; */
/*          uint16_t remain; */
/*          switch(cur_in_item.endpoint){ */
/*          case 0: FIFOSize = EP0_PACKET_SIZE; break; */
/*          case 1: FIFOSize = EP1_PACKET_SIZE; break; */
/*          case 2: FIFOSize = EP2_PACKET_SIZE; break; */
/*          } */
        
/*          /\* If packet fits in FIFO, just send it otherwise break it up *\/ */
/*          remain = (uint16_t)(cur_in_item.start + */
/*                              cur_in_item.len - */
/*                              in_item_cur_p); */

/*          call StdOut.printHexword(remain); */
/*          /\*call StdOut.printHexword(cur_in_item.endpoint);*\/ */

/*          in_item_more = FALSE; // Default guess: no more data */

/*          /\* Packet size multiple of buf size, retur 0-length pkt next *\/ */
/*          if(remain >= (uint16_t) FIFOSize) { */
/*            in_item_more = TRUE;        // more to send (possibly 0-length) */
/*            remain = FIFOSize;          // data to send in this cycle */
/*          } */
/*          Fifo_Write(CIP51_USBADR_FIFO_EP0 + cur_in_item.endpoint, */
/*                     remain,in_item_cur_p ); */
/*          in_item_cur_p += FIFOSize; */

/*          /\* Notify pkt ready and possibly dataend in case of EP0 *\/ */
/*          if( cur_in_item.endpoint == 0 ) { */
/*            TempReg = in_item_more==TRUE ? _BV(CIP51_E0CSR_INPRDY) : */
/*              _BV(CIP51_E0CSR_INPRDY)|_BV(CIP51_E0CSR_DATAEND); */
/*          } else { */
/*            TempReg = _BV(CIP51_EINCSRL_INPRDY); */
/*          } */
/*          // Write mask to E0CSR/EINCSRL */
/*          atomic { */
/*            if(in_item_more == FALSE) { */
/*              in_item_wait_done = TRUE; */
/*              // Zero length packet does not generate interrupt */
/* /\*              if (remain == 0) { *\/ */
/* /\*                in_item_signal_done=TRUE; *\/ */
/* /\*                post dataPump(); *\/ */
/* /\*              } *\/ */
/*            } */
/*            CIP51_USBPOLL_WRITE_BYTE(CIP51_USBADR_EINCSRL, TempReg);  */
/*          } */
/*        } */
/*      } */
/*    } */



  /**
   * inPacket
   * This task handles the communication from the device to the host (IN)
   * direction for all endpoints. It is written as an event driven data
   * pump submitting new packets when ever the INPRDY interrupt signals
   * that a packet has been transmitted. It does not use the double
   * buffering feature of the fifo, as that would coplicate generating the
   * sendDone event.
   * 
   * While the bus is serial more than one item may be pending at any given
   * time, so sTo track the state of each fifo it uses a queue of length 1
   * for each endpoint (in_items[n]). This further ensures that if any
   * endpoint is blocked, no other endpoints will be blocked.
   *
   * It transmit packets to the endpoints in a round-robbin fashion to
   * ensure that no endpoint is starved. 
   *
   * It uses the more/wait_done to identify the end of a packet (instead
   * of the remaining ammount of data) since the packet may be a multiple
   * of the FIFO-length in which case we must finish by sending a 0 length
   * packet. The wait_done flag could be left out, but having it ensures
   * that no stray-events from the hardware generates a sendDone event.
   * Further it helps us generate sendDone events appropriately for ep0.
   *
   */

  task void inPacket() {
    uint8_t last_ep, i;

    /**
     * First check if any operations were completed since last visit
     */

    for (i=0 ; i<=MAX_ENDPOINT ; i++) {
      if (in_items[i].wait_done && in_items[i].done) {
	in_items[i].wait_done = FALSE;
	in_items[i].done = FALSE;
	switch(i){
	case 0: signal EP0.sendDone(in_items[i].start); break;
	case 1: signal EP1.sendDone(in_items[i].start); break;
	case 2: signal EP2.sendDone(in_items[i].start); break;
	}
      }
    }

     /*
      * Find next item to service, in a round-robin fashion
      *  - the interrupt handler marks each endpoint as ready once a
      *    packet has been offloaded
      */
     last_ep = in_ep++;
     while (in_ep != last_ep) {
       if(in_items[in_ep].more &&
	  in_items[in_ep].done) { break;}
       in_ep = (in_ep+1) % MAX_ENDPOINT;
     }
    
     if (in_items[in_ep].more == TRUE) {
       uint8_t TempReg, INCSRL, pendingAction;
       /* disabling USB interrupts might be enough */
       //EIE1 &= ~0x02;// Disable USB interrupt
       atomic{
         CIP51_USBPOLL_WRITE_BYTE(CIP51_USBADR_INDEX, in_ep);
         CIP51_USBPOLL_READ_BYTE(CIP51_USBADR_EINCSRL, INCSRL);//Aka E0CSR

         // Clear stall flag, if any
         TempReg = INCSRL & (in_ep == 0 ?
                             _BV(CIP51_EINCSRL_SDSTL) :
                             _BV(CIP51_E0CSR_SDSTL));
         if (TempReg) {
           CIP51_USBPOLL_WRITE_BYTE(CIP51_USBADR_EINCSRL, ~TempReg);
         }
       }
       /*
        * In the general case we check that the IN fifo is ready, EP0
        * is slightly different since it is always IN/OUT - in
        * addition we check that no new OUT packet is ready or that
        * setup is over
        */
       if (in_ep == 0) {
         pendingAction = INCSRL & (_BV(CIP51_E0CSR_INPRDY) |
                                   _BV(CIP51_E0CSR_SUEND) |
                                   _BV(CIP51_E0CSR_OPRDY));
       } else  {
         pendingAction = INCSRL & _BV(CIP51_EINCSRL_INPRDY);
       }
       if ( !(pendingAction) ){ // don't overwrite last packet
         uint8_t FIFOSize;
         uint16_t remain;
         switch(in_ep){
         case 0: FIFOSize = EP0_PACKET_SIZE; break;
         case 1: FIFOSize = EP1_PACKET_SIZE; break;
         case 2: FIFOSize = EP2_PACKET_SIZE; break;
         }
        
         /* If packet fits in FIFO, just send it otherwise break it up */
         remain = (uint16_t)(in_items[in_ep].start +
                             in_items[in_ep].len -
                             in_items[in_ep].p);


         /* Packet size multiple of buf size, retur 0-length pkt next */
         in_items[in_ep].more = FALSE;      // Default guess: no more data
         if(remain >= (uint16_t) FIFOSize) {
           in_items[in_ep].more = TRUE;     // more to send (possibly 0-length)
           remain = FIFOSize;               // data to send in this cycle
         }
	 Fifo_Write(CIP51_USBADR_FIFO_EP0 + in_ep, remain,in_items[in_ep].p );
         in_items[in_ep].p += FIFOSize;

         /* Notify pkt ready and possibly dataend in case of EP0 */
         if( in_ep == 0 ) {
           TempReg = in_items[in_ep].more==TRUE ? _BV(CIP51_E0CSR_INPRDY) :
             _BV(CIP51_E0CSR_INPRDY)|_BV(CIP51_E0CSR_DATAEND);
         } else {
           TempReg = _BV(CIP51_EINCSRL_INPRDY);
         }
         // Write mask to E0CSR/EINCSRL
         atomic {
           CIP51_USBPOLL_WRITE_BYTE(CIP51_USBADR_EINCSRL, TempReg);
         }
	 if(in_items[in_ep].more == FALSE) {
	   in_items[in_ep].wait_done = TRUE;
	 }
       }
     }
  }


  uint8_t other_b = 0;

  void task other(){
    uint8_t ControlReg, o1, o2, o3, i1, i2, i3;

    atomic {
      CIP51_USBPOLL_WRITE_BYTE(CIP51_USBADR_INDEX, 1);
      CIP51_USBPOLL_READ_BYTE (CIP51_USBADR_EOUTCSRL, o1);
      CIP51_USBPOLL_READ_BYTE (CIP51_USBADR_EINCSRL,  i1);

      CIP51_USBPOLL_WRITE_BYTE(CIP51_USBADR_INDEX, 2);
      CIP51_USBPOLL_READ_BYTE (CIP51_USBADR_EOUTCSRL, o2);
      CIP51_USBPOLL_READ_BYTE (CIP51_USBADR_EINCSRL,  i2);

      CIP51_USBPOLL_WRITE_BYTE(CIP51_USBADR_INDEX, 3);
      CIP51_USBPOLL_READ_BYTE (CIP51_USBADR_EOUTCSRL, o3);
      CIP51_USBPOLL_READ_BYTE (CIP51_USBADR_EINCSRL,  i3);

      CIP51_USBPOLL_WRITE_BYTE(CIP51_USBADR_INDEX, 0);
      CIP51_USBPOLL_READ_BYTE(CIP51_USBADR_E0CSR, ControlReg);// ctrl register
    }
/*     CIP51_USBPOLL_READ_BYTE(CIP51_USBADR_CMIE, o1); */
/*     CIP51_USBPOLL_READ_BYTE(CIP51_USBADR_IN1IE, o2); */
/*     CIP51_USBPOLL_READ_BYTE(CIP51_USBADR_OUT1IE, o3); */

    call StdOut.print("Other ");
    call StdOut.printHex(other_b);
    if (o1|| o2|| o3|| i1|| i2 || i3){
      call StdOut.print(" ");
      call StdOut.printBase2(ControlReg);
      call StdOut.print(" ");
      call StdOut.printBase2(o1);
      call StdOut.print(" ");
      call StdOut.printBase2(o2);
      call StdOut.print(" ");
      call StdOut.printBase2(o3);
      call StdOut.print(" ");
      call StdOut.printBase2(i1);
      call StdOut.print(" ");
      call StdOut.printBase2(i2);
      call StdOut.print(" ");
      call StdOut.printBase2(i3);
    }
    call StdOut.print("\n\r");
  } 

  MCS51_INTERRUPT(SIG_USB0) {
    uint8_t outint, inint, cmint;
    atomic {
    
      /* Reading the USB registers is a two step process */

      // Clears any pending interrupt flags
      CIP51_USBPOLL_READ_BYTE(CIP51_USBADR_CMINT, cmint);
      CIP51_USBPOLL_READ_BYTE(CIP51_USBADR_IN1INT, inint);
      CIP51_USBPOLL_READ_BYTE(CIP51_USBADR_OUT1INT, outint);

      // Make sure that we do not service a disabled event
      /*     uint8_t outint_en, inint_en, cmint_en; */
      /*     CIP51_USBPOLL_READ_BYTE(CIP51_USBADR_CMIE, cmint_en); */
      /*     CIP51_USBPOLL_READ_BYTE(CIP51_USBADR_IN1IE, inint_en); */
      /*     CIP51_USBPOLL_READ_BYTE(CIP51_USBADR_OUT1IE, outint_en); */
      /*     cmint = cmint & cmint_en; */
      /*     inint = inint & inint_en; */
      /*     outint = outint & outint_en; */

      if(cmint & _BV(CIP51_CMINT_SOF)){post other();other_b=1;};

      /* Indicates that the bus detects reset
         - in which case something should be done ;]
      */
      if(cmint & _BV(CIP51_CMINT_RSTINT)){post usb_reset_detected();};
      if(cmint & _BV(CIP51_CMINT_RSUINT)){post other();other_b=2;}; // Resume
      if(cmint & _BV(CIP51_CMINT_SUSINT)){post other();other_b=3;}; // Suspend

      // Check endpoint 0 interrupt (IN or OUT)
      // This interrupt is generated on a number of conditions, that must be
      // be handled separately
      if(inint & _BV(CIP51_IN1INT_EP0)){
        post endpoint0();
      };
        
      // Check IN (to host) interrupts
/*       if(inint & (_BV(CIP51_IN1INT_IN1)| */
/*                   _BV(CIP51_IN1INT_IN2)| */
/*                   _BV(CIP51_IN1INT_IN3))){ */
/*         in_item_signal_done = TRUE; */
/*         post dataPump(); */
/*       }; */

      if(inint & _BV(CIP51_IN1INT_IN1)) {
	in_items[1].done = TRUE;
      }
      if(inint & _BV(CIP51_IN1INT_IN2)) {
	in_items[2].done = TRUE;
      }
      if(inint & _BV(CIP51_IN1INT_IN3)) {
	in_items[3].done = TRUE;
      }
      if(inint & (_BV(CIP51_IN1INT_IN1)|
                  _BV(CIP51_IN1INT_IN2)|
                  _BV(CIP51_IN1INT_IN3))){
	post inPacket();
      }

      // Check OUT (from host) interrupts
      if(outint & _BV(CIP51_OUT1INT_OUT1)){
        out_endpoint_ready=1;
      };
      if(outint & _BV(CIP51_OUT1INT_OUT2)){
        out_endpoint_ready=2;
      };
      if(outint & _BV(CIP51_OUT1INT_OUT3)){
        out_endpoint_ready=3;
      };
 
      if(out_endpoint_ready){
        uint8_t tmp, outCSRL;
        count++;
        if (count==0){
          call StdOut.printHex(out_endpoint_ready);
        }

        // Get Control Status Register
        CIP51_USBPOLL_WRITE_BYTE(CIP51_USBADR_INDEX, out_endpoint_ready);
        CIP51_USBPOLL_READ_BYTE(CIP51_USBADR_EOUTCSRL, outCSRL);

        /* Flush in case of error */
        if (outCSRL & _BV(CIP51_EOUTCSRL_DATERR) ||
            outCSRL & _BV(CIP51_EOUTCSRL_OVRUN)){
          outCSRL = _BV(CIP51_EOUTCSRL_FLUSH);
          CIP51_USBPOLL_WRITE_BYTE(CIP51_USBADR_EOUTCSRL, outCSRL);
          call StdOut.print("Flush!");
          return;
        }

        // Reset if host requests stall
        if (outCSRL & _BV(CIP51_EOUTCSRL_STSTL)) {
          CIP51_USBPOLL_WRITE_BYTE(CIP51_USBADR_EOUTCSRL, 0);
          post usb_reset();
          call StdOut.print("Stall\n\r");
          return;
        }

        /*
         * Read OUT packet
         *
         * This must be done in an atomic section, since Fifo_Read will
         * not be able to handle an interrupt while the FIFO is beeing
         * emptied.
         */
        tmp = outCSRL & _BV(CIP51_EOUTCSRL_OPRDY); // == CIP51_E0CSR_OPRDY
        if (tmp){
          uint16_t pktLen;
          uint8_t *pkt_buf;
          error_t ready;
          // Read length of packet
          CIP51_USBPOLL_READ_BYTE(CIP51_USBADR_EOUTCNTL, tmp);
          pktLen = (uint16_t) tmp;
          CIP51_USBPOLL_READ_BYTE(CIP51_USBADR_EOUTCNTH, tmp);
          pktLen = pktLen + (256*((uint16_t)tmp));

          switch (out_endpoint_ready) {
          case 1: ready=signal EP1.receiveReady(pktLen, &pkt_buf); break;
          case 2: ready=signal EP2.receiveReady(pktLen, &pkt_buf); break;
          default: ready=FAIL;
          }
          if (ready == SUCCESS) {
            Fifo_Read(CIP51_USBADR_FIFO_EP0+out_endpoint_ready, pktLen, pkt_buf);
            switch (out_endpoint_ready) {
            case 1: signal EP1.receiveDone(pktLen, pkt_buf);break;
            case 2: signal EP2.receiveDone(pktLen, pkt_buf);break;
            }
            outCSRL &= ~_BV(CIP51_EOUTCSRL_OPRDY);
          } else {
            call StdOut.print("Flush!");
            outCSRL |= _BV(CIP51_EOUTCSRL_FLUSH);
          }
          // Ack OUT event
          CIP51_USBPOLL_WRITE_BYTE(CIP51_USBADR_EOUTCSRL, outCSRL);
        }
        // Return index to 0
        CIP51_USBPOLL_WRITE_BYTE(CIP51_USBADR_INDEX, 0);
      }
    }
  } 
}
