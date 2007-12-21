/*
 * Copyright (c) 2007 nxtmote project
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
 * - Neither the name of nxtmote project nor the names of
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


#include "BtRadioCountToLeds.h"

#include "BT.h"
#include "c_comm.h"
#include "c_comm.iom" 

module BC4ControlP {
  provides {
    interface Init;
    interface Send;
    interface Receive;
  }
  
  uses {
    interface HalBt;
    interface BTIOMapComm;
    interface Packet;
    interface Bc4Packet;
interface BTAMAddress;    
interface HalLCD;    
  }
}

implementation {

  // The intention/goal
  uint8_t ActiveUpdateGoal = UPD_IDLE;
  
  //The current completed state
  uint8_t UpdateStateGoal = 0;
  
  // Updated by btUpdate event
  uint8_t ActiveUpdate = UPD_IDLE;;
  
  // Updated by btUpdate event
  uint8_t UpdateState = 0;
  
  // Message pointer
  message_t *mymsg;
  // Message length
  uint8_t mylen;
  
  // Receive msg
  message_t msgrcv;
  message_t* pmsgrcv = &msgrcv;
  
  VARSCOMM* pVarsComm;
  IOMAPCOMM* pIOMapComm;

  task void btUpdateTask();
  
  void connect();
  void senddata();  

  command error_t Init.init() {
    call HalBt.getFullControl(&pVarsComm, &pIOMapComm);
    return SUCCESS;
  }
  
  command error_t Send.cancel(message_t *msg) {
    
    return SUCCESS;
  }

  command void* Send.getPayload(message_t *msg) {
    return NULL;
  }

  command uint8_t Send.maxPayloadLength() {
    return 0;
  }

  command error_t Send.send(message_t *msg, uint8_t len) { 
    mymsg = msg;

    ActiveUpdateGoal = UPD_SENDDATA;
    UpdateStateGoal = 0;

    return SUCCESS;
  }
  
  command void* Receive.getPayload(message_t *msg, uint8_t *len){
    return NULL;  
  }

  command uint8_t Receive.payloadLength(message_t *msg){
    return 0;
  }
  
  void connect(){
	  bt_addr_t b;
	  nx_uint8_t* bnx;
	  uint8_t ix = 255;
	    
	  bc4_header_t* header = call Bc4Packet.getHeader( mymsg );
	  bnx = header->btdest;
	  call BTAMAddress.nxToBT(b,bnx);
	  call BTIOMapComm.getDeviceIndex(b, &ix);  
	  call HalBt.cCommReq(CONNECT, ix, 0x01, 0x00, NULL, &(pVarsComm->RetVal)); //slot ?

	}
  
  void senddata(){
	  uint8_t pllen;
	  uint8_t* pl;
	  uint8_t txlen = 0;
	  
	  bc4_header_t* header = call Bc4Packet.getHeader( mymsg );
	  pl = call Packet.getPayload(mymsg, &pllen);
	  
	  txlen = pllen + sizeof(bc4_header_t);

sprintf((char *)lcdstr,"SDX:%d",txlen);
call HalLCD.displayString(lcdstr,4);
	
	  call HalBt.cCommReq(SENDDATA, txlen, 0x01, FALSE, (uint8_t*)header, &(pVarsComm->RetVal)); //slot 1
    //pMapComm->pFunc(SENDDATA, (UBYTE)BufLength, Connection, FALSE, pBuf, (UWORD*)&(VarsCmd.CommStat));	  
  }

  event void HalBt.btUpdateEvent(UBYTE au, UBYTE us) {
    ActiveUpdate = au;
    UpdateState = us;
    post btUpdateTask();
  }
  
  task void btUpdateTask(){
	  if(ActiveUpdate == UPD_IDLE){
	    if(ActiveUpdateGoal == UPD_SENDDATA) {
				switch(UpdateStateGoal)
				{
					case 0:
					{
	          connect();
	          UpdateStateGoal++;
					}
					break;
					case 1:
					{
	          senddata();
	          UpdateStateGoal++;
					}
					break;
					case 2:
					{
sprintf((char *)lcdstr,"SDA");
call HalLCD.displayString(lcdstr,5);
togglepin(0);	
            signal Send.sendDone(mymsg, SUCCESS);
						UpdateStateGoal = 0;
						ActiveUpdateGoal = UPD_IDLE;
					}
					break;
        }
	    }
	  }
  }
  
  void reverseSrcDst(){
    bc4_header_t* header;
    nxle_uint16_t tmp;
    nx_uint8_t* bp;
    
    header = call Bc4Packet.getHeader( pmsgrcv );
    
    call BTAMAddress.swapBTNx(header->btdest, header->btsrc);
    
    tmp          = header->dest;
    header->dest = header->src;
    header->src  = tmp;
  }
  
  event void HalBt.dataReceived(){
    bc4_header_t* header;
    uint8_t pllen;
    uint8_t* pl;
    
    sprintf((char *)lcdstr,"D:%d,%p",pIOMapComm->BtInBuf.InPtr,pIOMapComm);
    call HalLCD.displayString(lcdstr,6);
	  header = call Bc4Packet.getHeader( pmsgrcv );
    memcpy((uint8_t*)header,(uint8_t*)&(pIOMapComm->BtInBuf), pIOMapComm->BtInBuf.InPtr);
    
    pllen = pIOMapComm->BtInBuf.InPtr - sizeof(bc4_header_t); 
    call Packet.setPayloadLength(pmsgrcv, pllen);
    sprintf((char *)lcdstr, "P:%d", call Packet.payloadLength(pmsgrcv));
    call HalLCD.displayString(lcdstr,7);
    
    //src
    reverseSrcDst();  
    
    pl = call Packet.getPayload(pmsgrcv, &pllen);
    pmsgrcv = signal Receive.receive(pmsgrcv, pl, pllen);   
  }
}
