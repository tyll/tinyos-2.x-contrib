/**
 *
 * $Rev:: 112         $:  Revision of last commit
 * $Author$:  Author of last commit
 * $Date$:  Date of last commit
 *
 **/
/*
  HCIPacket interface collects bytes from an Ericsson ROK 101 007 modules
  and provides a packet-oriented 
  Copyright (C) 2002 Martin Leopold <leopold@diku.dk>

  This program is free software; you can redistribute it and/or modify
  it under the terms of the GNU General Public License as published by
  the Free Software Foundation; either version 2 of the License, or
  (at your option) any later version.

  This program is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  GNU General Public License for more details.

  You should have received a copy of the GNU General Public License
  along with this program; if not, write to the Free Software
  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
*/

#include "btpackets.h"
//#include "printf.h"
#define DONEBUFFERS 4

module HCIPacketM {
  provides {
    interface HCIPacket;
  }
  uses {
    interface GeneralIO as UartRTS;
    //interface GeneralIO as UartCTS; //For development purposes only.
    interface GpioInterrupt as UartCTS;
    interface SplitControl as Device;
    interface StdControl as UartStdControl;
    interface UartStream;
    interface UartByte;
    interface Leds;
    interface PointerQueue<uint8_t> as ByteQueue;
    interface Timer<TMilli> as Timer; //For Development Purposes Only
  }
}

implementation {
  gen_pkt *recvBuffer;  // recvBuffer holds the current buffer that
                        // we store data in.
    enum {
    PS_Transport = 0,
    PS_Header = 1,
    PS_Body = 2,
  };
    enum {
      P_Off = 0,
      P_On = 1,
      P_Reset = 2,
      P_Boot = 3,
      P_Halt = 4,
    };
  uint8_t remaining, remaining_header, packet_state, power = P_Off;
  task void handle_byte_task();
  // dlen is a 16 bit integer - usually max i 672 on ROK 101 007
  command error_t HCIPacket.init() {
    return SUCCESS;

     

  }
  
  command error_t HCIPacket.powerOn() {
    atomic if (power == P_Off) {
      recvBuffer = signal HCIPacket.getPacket();
      if (recvBuffer)
	  rst_pkt(recvBuffer);
		  packet_state = PS_Transport;
	      remaining = 0,
	      remaining_header = 0;
	      call ByteQueue.flush();
    } else power = P_Reset;
    return SUCCESS;
  }

  command error_t HCIPacket.init_BT() {
    atomic if (power == P_Reset) return call HCIPacket.powerOff();
    //Start Bluetooth Device and UART control
    atomic power = P_Off;
    call UartRTS.makeOutput();
    call UartRTS.set();
    call UartCTS.enableFallingEdge();
    call UartStdControl.start();
    call UartStream.enableReceiveInterrupt();
    call Device.start();
    call Timer.startPeriodic(1000);
    return SUCCESS;
  }
  event void Device.startDone(error_t err){
    atomic power = P_On;
    signal HCIPacket.BT_ready(SUCCESS);
  }
  event void Device.stopDone(error_t err) {
    if (power == P_Reset) {
      power = P_Off;
      call HCIPacket.init_BT();
    }
    
  }
  event void Timer.fired(){
   // if (call UartRTS.get()) printf("CTS is high. \r\n");
  //  else printf("CTS is low. \r\n");
  //  printfflush();    
  }
  
  command error_t HCIPacket.powerOff() {
    
    // Turn off the bluetooth device & UART.
    call UartStdControl.stop();
    call Device.stop();
    //call UartCTS.disable();

    return SUCCESS;
  }
  command error_t HCIPacket.putRawPacket(gen_pkt *data) {
    //printHex(*(data->start));
    //printHex(*(data->start + 1));
    //printHex(*(data->start + 2));
   error_t res = call UartStream.send(data->start, (uint16_t) (data->end - data->start));
   data->start++; //Remove UART Transport
   return res;
  }
  command void HCIPacket.addTransport(gen_pkt *data, hci_data_t type) {
		    data->start = data->start - 1;
		    //Why did the second bit become zero..
			* (data->start) = (uint8_t) type; //UART transport

  }
  async event void UartStream.receiveDone( uint8_t* buf, uint16_t len, error_t error ) {
  /*
  Command is not needed because packet length is indeterminate
  */
  }
  async event void UartStream.sendDone( uint8_t* buf, uint16_t len, error_t error ) {
//    gen_pkt *tmp;
//    atomic {
//      tmp = sendBuffer;
//      sendBuffer = 0;
//    }
    //call Leds.led3Off();
    //call UartStream.enableReceiveInterrupt();
    // tmp can be 0, if we have turned off the bluetooth module.
//    if (tmp)
//      signal HCIPacket.putPacketDone(tmp);
  }

  async event void UartStream.receivedByte( uint8_t data ) {

//    uint8_t ctr, pkttype;
//    gen_pkt* recv;
    uint8_t s;
    atomic s = power;
    if (s == P_On) {
      *(call ByteQueue.enqueue()) = data;
      post handle_byte_task();
    }
    //printf("\r\n");
    
    //recv is now never 0 (dbl chk this)
//    if (recv == 0) {
//      signal HCIPacket.error(NO_FREE_RECV_PACKET, 2);
//      call UartRTS.clr();	     
//      return;
//    }
    return;
  }
  async event void UartCTS.fired() {

      call UartRTS.clr();
    //call UartCTS.enableFallingEdge();
  }
  
  /**
   * Task - handle_byte_task() handles each byte that is received from the Bluetooth Module
   * The handling is set to byte based because the entry of bytes maybe too fast for the
   * processor to handle.
   *
   * @param
   * @author sengjea
   * @modified 4 Nov 2009.
   *
   **/
  
  task void handle_byte_task() {
    uint8_t processed_length;
    gen_pkt* newPkt;
    //printf("p: ");
    while (packet_state == PS_Transport || (call ByteQueue.size() && (remaining && remaining--))) {
    // exploits the laziness rule: 
    //a && b, b is never evaluated if a is false
    //a || b, b is never evaluated if a is true
    *(recvBuffer->end++) = *(call ByteQueue.head());
    //if (packet_state == PS_Header)
    //printf("%.2X ",*(call ByteQueue.head()));  
    call ByteQueue.dequeue();
    if (packet_state == PS_Transport) break;
    }
    //printfflush();
    processed_length = recvBuffer ->end - recvBuffer->start;
      if (packet_state == PS_Transport && processed_length == 1) {
        
        // The first byte is always the UART transport
	      switch(*(recvBuffer->start)) { // look at the UART transport byte
	      case HCI_EVENT_PKT:
	      remaining = HCI_EVENT_HDR_SIZE;
	      packet_state = PS_Header;
	      break;
	      case HCI_ACLDATA_PKT:
	      remaining = HCI_ACL_HDR_SIZE;
	      packet_state = PS_Header;
	      break;
	      case HCI_SCODATA_PKT: // Not implemented yet
	      case HCI_COMMAND_PKT: // Should never _get_ any of these
	      default: //Unknown packet type
	      	{
			  /* If init and we get a 0, it doesn't matter */
			  signal HCIPacket.error(UNKNOWN_PTYPE, (uint16_t) *(recvBuffer->start));
			  rst_pkt(recvBuffer);
			  break;
			}
	      }  
	      
      }
      else if (!remaining && packet_state == PS_Header) {
      // If there are no more remaining headers, time to process remaining length
         switch(*(recvBuffer->start)) {
           case HCI_EVENT_PKT:
           remaining = ((hci_event_hdr*) (recvBuffer->start + 1))->plen;
	       	  if (processed_length + remaining > HCIPACKET_BUF_SIZE)
	            signal HCIPacket.error(EVENT_PKT_TOO_LONG, processed_length + remaining);
           break;
           case HCI_ACLDATA_PKT:
           remaining = ((hci_acl_hdr*) (recvBuffer->start + 1))->dlen;
           	  if (processed_length + remaining > HCIPACKET_BUF_SIZE)
	            signal HCIPacket.error(ACL_PKT_TOO_LONG, processed_length + remaining);
           break;
         }
         packet_state = PS_Body;
     }
      else if (!remaining && packet_state == PS_Body) {
	// We have read an entire packet.
	
//	bool outofspace;
    // newPkt is NEVER zero.
//	if (!newPkt) {
//	  atomic rst_pkt(recvBuffer);
//	  signal HCIPacket.error(NO_FREE_RECV_PACKET, 3);
//	  call UartRTS.clr();
//	  return;
//	}

//	// Move the head and tail pointers.
//	atomic {
//	  uint8_t oldHead = doneHead;
//	  doneHead++;
//	  if (doneHead >= DONEBUFFERS)
//	    doneHead = 0;
//	  outofspace = doneHead == doneTail;
//	  if (outofspace)
//	    doneHead = oldHead;
//	}
//
//	if (outofspace) {
//	  signal HCIPacket.putPacketDone(newPkt); // Return the new
//						  // packet.
//	  signal HCIPacket.error(NO_FREE_RECV_PACKET, 0);	     
//	  rst_pkt(recv);
//	  call UartRTS.clr();
//	  return;
//	} 
//	
//	doneBuffer[doneHead] = recv;

	// Prepare for reading the next packet.
//	header_done = 0;

	// Look at the packet and signal the event
    // that corresponds with its packet-type.
    // Remove the UART transport from the packet

    switch(*(recvBuffer->start++)) {
    case HCI_EVENT_PKT:
      signal HCIPacket.gotEvent(recvBuffer);
      break;
    case HCI_ACLDATA_PKT:
      signal HCIPacket.gotAclData(recvBuffer);
      break;
    case (uint8_t) 0x00:
    break;
      //Ignore the weirdos.
    default: // If we get here doneBuffer has been corrupted
      signal HCIPacket.error(UNKNOWN_PTYPE_DONE, (uint16_t) recvBuffer->start);
      }
    newPkt = signal HCIPacket.getPacket();
	rst_pkt(newPkt);
	recvBuffer = newPkt;
	// Post a task to handle the current packet. Used to break
	// out of interrupt context.
	packet_state = PS_Transport;
      }
   // call ByteQueue.dequeue();
   call UartRTS.clr();
    //printf("\r\n");
    if (call ByteQueue.size()) post handle_byte_task();
  }


  async event void ByteQueue.bufferLow(){
    call UartRTS.set();
  }
  async event void ByteQueue.bufferBlown(){
    //die
  }
  async event void ByteQueue.bufferFull(uint8_t *bin){
    //jialat
  }
}
