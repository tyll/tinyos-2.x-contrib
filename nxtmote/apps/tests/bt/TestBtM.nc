/*
 * Copyright (c) 2007 Copenhagen Business School
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
 * - Neither the name of CBS nor the names of
 *   its contributors may be used to endorse or promote products derived
 *   from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 * ``AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
 * FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL THE
 * ARCHED ROCK OR ITS CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
 * INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
 * STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
 * OF THE POSSIBILITY OF SUCH DAMAGE
 */

/**
 * Test of Bluetooth.
 *
 * @author Rasmus Ulslev Pedersen
 */
 
#include "c_comm.h"
#include "c_comm.iom" 

#include "BtRadioCountToLeds.h"

#define MASTER

module TestBtM
{
  uses { 
    interface HalBt;
    interface Boot;
    interface HalLCD;
    interface AMSend;
    interface Packet;
    interface Receive;
    interface BTIOMapComm;
  }
}

implementation
{
  VARSCOMM* pVarsComm;
  IOMAPCOMM* pIOMapComm;
  
  uint8_t flag; //tmp flag
  
  message_t packet;
  
  message_t rcvpkt;
  message_t* prcvpkt;
  
  event void Boot.booted() {
    call HalBt.getFullControl(&pVarsComm, &pIOMapComm);
  }
  
  event void HalBt.btUpdateEvent(UBYTE ActiveUpdate, UBYTE UpdateState) {
    if(ActiveUpdate == UPD_IDLE){
      switch(flag)
      {
				case 0:
				{
				  uint8_t* btAddr = call BTIOMapComm.getBtAddr();
				  sprintf((char *)lcdstr,"BT ADDR aquired...");
				  call HalLCD.displayString(lcdstr,0);
				  sprintf((char *)lcdstr,"%X.%X.%X.%X.%X.%X", btAddr[0], btAddr[1], btAddr[2], btAddr[3], btAddr[4], btAddr[5]);
				  call HalLCD.displayString(lcdstr,1);
				  //togglepin(0);
				  flag++;
				}
        break;

        case 1:
        {
					#ifdef MASTER
					//search state on master
					if (SUCCESS == (call HalBt.cCommReq(SEARCH, 0x00, 0x00, 0x00, NULL, &(pVarsComm->RetVal))))
					{
					  sprintf((char *)lcdstr,"MASTER SEARCH...");
					  call HalLCD.displayString(lcdstr,0);
						flag++;
					}
					#endif
        }
        break;
		
		    case 2:
				{
          am_addr_t a = 0xC39A;
          radio_count_msg_t* rcm = (radio_count_msg_t*)(call Packet.getPayload(&packet, NULL));
          rcm->counter = 12;
          call AMSend.send(a, &packet, sizeof(radio_count_msg_t));	
					flag++;
					sprintf((char *)lcdstr,"SENDING");
					call HalLCD.displayString(lcdstr,2);						
				}
				break;
      }
    }
  }
  
  event void AMSend.sendDone(message_t *msg, error_t error){
		sprintf((char *)lcdstr,"SENT OK!");
		call HalLCD.displayString(lcdstr,3);
		togglepin(0);
  }
  
  event message_t* Receive.receive(message_t* msg, void* payload, uint8_t len){
    radio_count_msg_t* rcmrcv;
    
    memcpy((uint8_t*)call Packet.getPayload(&packet, NULL), (uint8_t*)call Packet.getPayload(msg, NULL), len);
    rcmrcv = call Packet.getPayload(&packet, NULL);
		sprintf((char *)lcdstr,"R:%d", rcmrcv->counter);
		call HalLCD.displayString(lcdstr,0);
    return msg;
  }
  
  event void HalBt.dataReceived(){}
}
