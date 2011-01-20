/*
 * "Copyright (c) 2009 Stanford University. All rights reserved.
 *
 * Permission to use, copy, modify, and distribute this software and
 * its documentation for any purpose, without fee, and without written
 * agreement is hereby granted, provided that the above copyright
 * notice, the following two paragraphs and the author appear in all
 * copies of this software.
 *
 * IN NO EVENT SHALL STANFORD UNIVERSITY BE LIABLE TO ANY
 * PARTY FOR DIRECT, INDIRECT, SPECIAL, INCIDENTAL, OR CONSEQUENTIAL
 * DAMAGES ARISING OUT OF THE USE OF THIS SOFTWARE AND ITS
 * DOCUMENTATION, EVEN IF STANFORD UNIVERSITY HAS BEEN
 * ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 *
 * STANFORD UNIVERSITY SPECIFICALLY DISCLAIMS ANY WARRANTIES,
 * INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
 * MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.  THE SOFTWARE
 * PROVIDED HEREUNDER IS ON AN "AS IS" BASIS, AND THE UNIVERSITY OF
 * CALIFORNIA HAS NO OBLIGATION TO PROVIDE MAINTENANCE, SUPPORT,
 * UPDATES, ENHANCEMENTS, OR MODIFICATIONS."
 *
 */


/* Application using the powernet driver. Will allow us to read/write registers on the chip and send over the radio
* 
* @author Maria A. Kazanjieva, <mariakaz@cs.stanford.edu>
* @date Dec 2, 2008
*/ 


#include "PowerNetApp.h"

module PowerNetAppP {
  uses interface Boot;
  uses interface ADE7753;
  uses interface Timer<TMilli> as Timer;
  uses interface Timer<TMilli> as CtpTimer;
  uses interface Leds;
  uses interface Send;
  uses interface SplitControl as AMControl;
  uses interface Packet;
  uses interface Receive;
  uses interface CtpInstrumentation;
  // for CTP collection
  uses interface StdControl as RoutingControl;
  uses interface Random;
}

implementation {
  /****** variables ******/

  uint32_t energy = 0xFFFFFFFF;
  uint32_t time = 0xFFFFFFFF;
  uint32_t state = UNSET;
  message_t packet;
  message_t summary_packet;
  bool sendBusy = FALSE;
  meter_msg_t local_buf[NUMENTRIES];
  meter_msg_t temp_buf[NUMENTRIES];
  uint8_t buf_count = 0;
  
  /****** tasks *******/    
  
  /* set the gain register */
  task void setGain() {
	  uint8_t len = 2;
	  atomic state = SET_GAIN; 
	  call ADE7753.setReg(GAIN, len, ADE7753_GAIN_VAL);
  }


  /* get the gain register */
  task void getGain() {
	  uint8_t len = 2;
	  atomic state = GET_GAIN; 
	  call ADE7753.getReg(GAIN, len);
  }

  /* set MODE register to sample temperature */
  task void setMode() {
  	uint8_t len = 3;
	  atomic state = SET_TEMP_MODE;
	  call ADE7753.setReg(MODE, len, TEMP_MODE);
  }
 
  /* start timer */
  task void startTimers() {
    uint16_t rnd = call Random.rand16() % RANDOM_INTERVAL;
    call Timer.startPeriodic(SAMPLE_INTERVAL-0.5*RANDOM_INTERVAL+rnd);
    rnd = call Random.rand16() % RANDOM_INTERVAL;
   call CtpTimer.startPeriodic(CTP_INTERVAL-0.5*RANDOM_INTERVAL2+rnd);
  }

  /* led indicator for successful readin */
  task void successReading() {
	  call Leds.led1Toggle();
  }

         
  task void sendReadings() {
    readings_t* r = (readings_t*) call Send.getPayload(&packet,
sizeof(readings_t));
    memcpy(r->buffer, temp_buf, NUMENTRIES*sizeof(meter_msg_t)); 
	  if (call Send.send(&packet, sizeof(readings_t)) != SUCCESS) {
	 	  // sending failed
	  } else {
		  sendBusy = TRUE;
	  }
  }

  task void createMsg() {
    meter_msg_t m;
	  atomic m.energy = energy;
    if (buf_count < NUMENTRIES) {
      memcpy(local_buf + buf_count, &m, sizeof(meter_msg_t));
      buf_count++;
    }
    if (buf_count == NUMENTRIES) {
      memcpy(temp_buf, local_buf, NUMENTRIES*sizeof(meter_msg_t));
      buf_count = 0;
      post sendReadings();
    }
  }
    
    
  /****** events *******/

  /* Start radio when the node boots */
  event void Boot.booted() {
  	while (call AMControl.start() != SUCCESS);
  }

  /* SplitControl returns; check is radio started or failed */
  event void AMControl.startDone(error_t err) {
  	if (err == SUCCESS) {
	    while (call RoutingControl.start() != SUCCESS);
      // initiate the Ctp Intrumentation for collecting stats
      call CtpInstrumentation.init();
	    // set the GAIN register of the ADE
	    post setGain();
	  } else {
	    // try starting AMControl again
	    call AMControl.start();
	  }
  }

  /* Radio stopped; someone called AMControl.stop() */
  event void AMControl.stopDone(error_t err) {
  }

  /* CtpTimer has fired, time to send a CTP summary packet */
  event void CtpTimer.fired() {
    uint8_t msgsize;
    msgsize = call CtpInstrumentation.summary_size();
    call CtpInstrumentation.summary(call Send.getPayload(&summary_packet, msgsize));
    if (call Send.send(&summary_packet, msgsize) != SUCCESS) {
      //failed send
    } else {
      sendBusy = TRUE;
    }
  }

  /* Periodic timer has fired, time to read a register */
  event void Timer.fired() {
  	uint8_t len;
  	len = 4;
	  atomic state = GET_ENERGY;
	  call Leds.led2Toggle();
    call ADE7753.getReg(RAENERGY, len);
  }

  /* sending a packet was successful, increment sequence number */ 
  event void Send.sendDone(message_t* bufPtr, error_t err) {
	  sendBusy = FALSE;
    post successReading();
  }

  /* Reading register off of the ADE has completed */
  async event void ADE7753.getRegDone(error_t err, uint32_t value) {
	  if (err == SUCCESS) {
		  if (state == GET_ENERGY) {
		    energy = value;
        post createMsg();
		  } else if (state == GET_TEMP) {
		  }
	  }
  }

  /* Writing to an ADE register has completed */
  async event void ADE7753.setRegDone(error_t err, uint32_t value){
	  if (err == SUCCESS) {
      if (state == SET_GAIN) {
		    post setMode();
		  } else if (state == SET_TEMP_MODE) {	
        post startTimers();   
		  }
	  } 
  }

  /* received message on the radio */
  event message_t* Receive.receive(message_t* bufPtr, void* payload, uint8_t l) {
  	return bufPtr;
  }
}
