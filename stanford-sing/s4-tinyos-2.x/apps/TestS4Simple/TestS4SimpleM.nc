// ex: set tabstop=2 shiftwidth=2 expandtab syn=c:
// $Id$

/*                                                                      
 * "Copyright (c) 2000-2003 The Regents of the University  of California.  
 * All rights reserved.
 *
 * Permission to use, copy, modify, and distribute this software and its
 * documentation for any purpose, without fee, and without written agreement is
 * hereby granted, provided that the above copyright notice, the following
 * two paragraphs and the author appear in all copies of this software.
 * 
 * IN NO EVENT SHALL THE UNIVERSITY OF CALIFORNIA BE LIABLE TO ANY PARTY FOR
 * DIRECT, INDIRECT, SPECIAL, INCIDENTAL, OR CONSEQUENTIAL DAMAGES ARISING OUT
 * OF THE USE OF THIS SOFTWARE AND ITS DOCUMENTATION, EVEN IF THE UNIVERSITY OF
 * CALIFORNIA HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 * 
 * THE UNIVERSITY OF CALIFORNIA SPECIFICALLY DISCLAIMS ANY WARRANTIES,
 * INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY
 * AND FITNESS FOR A PARTICULAR PURPOSE.  THE SOFTWARE PROVIDED HEREUNDER IS
 * ON AN "AS IS" BASIS, AND THE UNIVERSITY OF CALIFORNIA HAS NO OBLIGATION TO
 * PROVIDE MAINTENANCE, SUPPORT, UPDATES, ENHANCEMENTS, OR MODIFICATIONS."
 *
 * Copyright (c) 2002-2003 Intel Corporation
 * All rights reserved.
 *
 * This file is distributed under the terms in the attached INTEL-LICENSE     
 * file. If you do not find these files, copies can be found by writing to
 * Intel Research Berkeley, 2150 Shattuck Avenue, Suite 1300, Berkeley, CA, 
 * 94704.  Attention:  Intel License Inquiry.
 */

/*
 * Authors:  Rodrigo Fonseca
 * Date Last Modified: 2005/05/26
 */

includes message;

includes AM;

includes Timer;

module TestS4SimpleM {
  provides {
    interface StdControl;
  }
  uses {
    interface S4Send as Send;
    interface S4Receive as Receive;
    interface StdControl as RouterControl;
    interface Boot;

    interface LBlink;
    interface StdControl as LBlinkControl;
    interface Leds;
    
    interface Timer<TMilli> as Timer1;
    interface CoordinateTable;
    interface SplitControl as AMControl;
    interface Random;
    
    interface AMPacket;
  }
  
}

implementation {


  message_t send_buffer;
  uint8_t *pAppMsg;
  uint16_t payloadLength;
  Coordinates dest;
  bool busy_sending;

  uint16_t d; //used to store the data that is passed around

  uint16_t mode;
  uint16_t dest_id;

  uint16_t msg_id;
   
  task void sendAnother();

  event void Boot.booted() { 
    call AMControl.start();
  
    if (call AMPacket.address()==82)
      call Timer1.startOneShot(900000u);
    
    pAppMsg = (uint8_t*) call Send.getBuffer(&send_buffer,&payloadLength);    
    dbg("TestBVR"," init ended\n", mode);
        
    msg_id = call AMPacket.address();
    busy_sending = 0;
     
    mode = 0;    
  }
  
  event void Timer1.fired() {
    CoordinateTableEntry* cte = NULL;
    CoordinateTableEntry* selectedCte=NULL;
    int i=0;
  
#ifdef TOSSIM
      sim_add_channel("BVR-debug", stdout);
#endif

    dbg("TestBVR", "Timer1.fired at %s\n", sim_time_string());
    
    for (i=0; i<200; i++) {
      cte = call CoordinateTable.getEntry(i);
    
      if ( cte!=NULL ){
        selectedCte = cte;
        coordinates_print(&cte->coords);        
      }
    }

    dbg("TestBVR", "cte=%x, dest=%x\n", cte, &dest);

    if (cte== NULL)
        call Timer1.startOneShot(900000u);

    cte = selectedCte;
    if (!busy_sending /*&& cte!=NULL*/ && call AMPacket.address()==82) {

      //coordinates_copy(&cte->coords, &dest);
      
      dest.comps[0] = 255;
      dest.comps[1] = 255;
      dest.comps[2] = 255;
      dest.comps[3] = 255;
      dest.comps[4] = 255;
      dest.comps[5] = 255;
      dest.comps[6] = 0;
      dest.comps[7] = 255;
      dest_id = 203;
      
      coordinates_print(&dest);
      *((uint16_t*)pAppMsg) = msg_id;
      
      if ( post sendAnother() == SUCCESS ) {
        busy_sending = TRUE;            
      }
      else {
        dbg("TestBVR", "132 routeTo failed\n ");
      }
    }
    else {
      dbg("TestBVR", "135 busy_sending was set!\n ");
    }
    
    dbg("TestBVR", "Timer1.fired ended\n");
  }

  command error_t StdControl.start() {  
    call RouterControl.start();
    call LBlinkControl.start();
    call LBlink.setRate(100);
    call LBlink.yellowBlink(3);
    call LBlink.greenBlink(2);
    call LBlink.redBlink(1);
		
    return SUCCESS;
  }
  
  command error_t StdControl.stop() {
    call RouterControl.stop();
    call LBlinkControl.stop();
    return SUCCESS;
  }

  task void sendAnother() {
    uint8_t beacon=6;
    if (busy_sending) {
#ifdef TOSSIM      
      sim_add_channel("BVR", stdout);
#endif      
      dbg("TestBVR","TestBVR %d sendAnother: mode:%d, dest_id=%d!!\n", call AMPacket.address(), mode, dest_id);  
      if (call Send.send(&send_buffer, 2,  dest_id, beacon) != SUCCESS) {
        dbg("TestBVR","sendAnother: send failed\n");
        busy_sending = FALSE;
      }
    } else 
      dbg("TestBVR","sendAnother ERROR: called without busy_sending set\n");
  }

  event error_t Send.sendDone(message_t* msg, error_t success) {
    //finished sending
    if (msg == &send_buffer) {
      busy_sending = FALSE;
    } else {
      dbg("TestBVR","App Send$sendDone: msg (%p)!=&send_buffer(%p)!\n",msg,&send_buffer);
    }
    return SUCCESS;
  }

  event message_t* Receive.receive(message_t* msg, void* payload, uint16_t payloadLen) {
    //final hop, received message
    d = *(uint16_t*)payload;
    dbg("TestBVR","ReceiveApp: %d; len=%d!!\n", d, payloadLen);  
    
    return msg; //we are done with the buffer
  }
	

  
  event void AMControl.stopDone(error_t err) {
  
  }
  
  event void AMControl.startDone(error_t err){
    if (err == SUCCESS) {
      dbg("BVR", "Radio started; now starting the rest");
      call RouterControl.start();
    
      call LBlinkControl.start();
    
    
      pAppMsg = (uint8_t*) call Send.getBuffer(&send_buffer,&payloadLength);    
      dbg("TestBVR"," init ended\n", mode);
        
      msg_id = call AMPacket.address();
      busy_sending = 0;
     
      mode = 0;
        
      
        
      return ;   
    }
  }
  
}
