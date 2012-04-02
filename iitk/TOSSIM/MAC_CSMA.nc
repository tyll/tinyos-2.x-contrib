9891770008
// $Id$
/*
 * "Copyright (c) 2005 Stanford University. All rights reserved.
 *
 * Permission to use, copy, modify, and distribute this software and
 * its documentation for any purpose, without fee, and without written
 * agreement is hereby granted, provided that the above copyright
 * notice, the following two paragraphs and the author appear in all
 * copies of this software.
 * 
 * IN NO EVENT SHALL STANFORD UNIVERSITY BE LIABLE TO ANY PARTY FOR
 * DIRECT, INDIRECT, SPECIAL, INCIDENTAL, OR CONSEQUENTIAL DAMAGES
 * ARISING OUT OF THE USE OF THIS SOFTWARE AND ITS DOCUMENTATION, EVEN
 * IF STANFORD UNIVERSITY HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH
 * DAMAGE.
 * 
 * STANFORD UNIVERSITY SPECIFICALLY DISCLAIMS ANY WARRANTIES,
 * INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
 * MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.  THE SOFTWARE
 * PROVIDED HEREUNDER IS ON AN "AS IS" BASIS, AND STANFORD UNIVERSITY
 * HAS NO OBLIGATION TO PROVIDE MAINTENANCE, SUPPORT, UPDATES,
 * ENHANCEMENTS, OR MODIFICATIONS."
 */

/**
 *
 * This packet-level radio component implements a basic CSMA
 * algorithm. It derives its constants from sim_csma.c. The algorithm
 * is as follows:
 *
 * Transmit iff you measure a clear channel min_free_samples() in a row.
 * Sample up to max_iterations() times. If you do not detect a free
 * channel in this time, signal sendDone with an error of EBUSY.
 * If max_iterations() is zero, then sample indefinitely.
 *
 * On a send request, use an initial backoff in the range of
 * init_low() to init_high().
 * Subsequent backoffs are in the range
         <pre>(low, high) * exponent_base() ^ iterations</pre>
 *
 * The default exponent_base is 1 (constant backoff).
 *
 *
 * @author Philip Levis
 * @date Dec 16 2005
 *
 */

#include <TossimRadioMsg.h>
#include <sim_csma.h>

module MAC_CSMA { 
  provides {
    interface Init;
    interface SplitControl as Control;
    interface PacketAcknowledgements;
    interface TossimPacketModel as Packet;
  }
  uses interface GainRadioModel; 
//  uses interface SplitControl as Control;
  #if defined(POWERTOSSIMZ)
    uses interface PacketEnergyEstimator as Energy;
    uses interface AMPacket;
  #endif
  
}
implementation {
  #if defined(POWERTOSSIMZ)
    bool sweepMe = TRUE; 
  #endif
  bool initialized = FALSE;
  bool running = FALSE;
  uint8_t backoffCount;
  uint8_t neededFreeSamples;
  message_t* sending = NULL;
  bool transmitting = FALSE;
  uint8_t sendingLength = 0;
  int destNode;
  sim_event_t sendEvent;
  
  message_t receiveBuffer;
  
  tossim_metadata_t* getMetadata(message_t* msg) {
    return (tossim_metadata_t*)(&msg->metadata);
  }
  
  command error_t Init.init() {                                                             // starts the mac
    dbg("TossimPacketModelC", "TossimPacketModelC: Init.init() called\n");
    initialized = TRUE;
    // We need to cancel in case an event is still lying around in the queue from
    // before a reboot. Otherwise, the event will be executed normally (node is on),
    // but its memory has been zeroed out.
    sendEvent.cancelled = 1;
    return SUCCESS;
  }

  task void startDoneTask() {                                                              
    running = TRUE;
	#if defined(POWERTOSSIMZ)
	  if ( !sweepMe )
	#endif
    signal Control.startDone(SUCCESS);
  }

  task void stopDoneTask() {
    running = FALSE;
    signal Control.stopDone(SUCCESS);
  }
  
  command error_t Control.start() {
    if (!initialized) {
      dbgerror("TossimPacketModelC", "TossimPacketModelC: Control.start() called before initialization!\n");
      return FAIL;
    }
    post startDoneTask();
	
	#if defined(POWERTOSSIMZ)
	if ( sweepMe ) {
       call Energy.poweron_start(); 
       sweepMe = FALSE;
    } else 
	   sweepMe = TRUE;
	#endif
  
    return SUCCESS;
  }

  command error_t Control.stop() {
    if (!initialized) {
      dbgerror("TossimPacketModelC", "TossimPacketModelC: Control.stop() called before initialization!\n");
      return FAIL;
    }
    running = FALSE;
    dbg("TossimPacketModelC", "TossimPacketModelC: Control.stop() called.\n");
  
	#if defined(POWERTOSSIMZ)  
	  call Energy.poweroff_start();
	#endif
  
	post stopDoneTask();
    return SUCCESS;
  }

  
  
  async command error_t PacketAcknowledgements.requestAck(message_t* msg) {
    tossim_metadata_t* meta = getMetadata(msg);
    meta->ack = TRUE;
    return SUCCESS;
  }

//nahi samajh mein aya
  async command error_t PacketAcknowledgements.noAck(message_t* ack) {
    tossim_metadata_t* meta = getMetadata(ack);
    meta->ack = FALSE;
    return SUCCESS;
  }


//nahi samajh mein aya
  async command error_t PacketAcknowledgements.wasAcked(message_t* ack) {
    tossim_metadata_t* meta = getMetadata(ack);
    return meta->ack;
  }
      
      

  task void sendDoneTask() {
    message_t* msg = sending;
    tossim_metadata_t* meta = getMetadata(msg);
    meta->ack = 0;
    meta->strength = 0;
    meta->time = 0;
    sending = FALSE;
	
	#if defined(POWERTOSSIMZ)	  
	  //call Energy.send_done(destNode, sendingLength, SUCCESS);
	#endif
	
	signal Packet.sendDone(msg, running? SUCCESS:EOFF);
  }

  command error_t Packet.cancel(message_t* msg) {
    return FAIL;
  }

  void start_csma();

  command error_t Packet.send(int dest, message_t* msg, uint8_t len) {
      dbg("TossimPacketModelC", "TossimPacketModelC: have to send a packet To:%d  Time:%llu.\n", dest,sim_time());
    if (!initialized) {
      dbgerror("TossimPacketModelC", "TossimPacketModelC: Send.send() called, but not initialized!\n");
      return EOFF;
    }
    if (!running) {
      dbgerror("TossimPacketModelC", "TossimPacketModelC: Send.send() called, but not running!\n");
      return EOFF;
    }
    if (sending != NULL) {
	  #if defined(POWERTOSSIMZ)	  
  	    dbg("ENERGY_DEBUG", "Attempting to send a message while sending another one...\n");
	  #endif
	  return EBUSY;
    }
    sendingLength = len; 
    sending = msg;
    destNode = dest;
    backoffCount = 0;
    neededFreeSamples = sim_csma_min_free_samples();
    
    if(destNode == AM_BROADCAST_ADDR)
          dbg("TossimPacketModelC", "TossimPacketModelC: have to Broadcast to everyone To:%d  Time:%llu.\n", destNode,sim_time());
    
    start_csma();
	
	#if defined(POWERTOSSIMZ)	  
	  dbg("ENERGY_DEBUG", "ENERGY_DEBUG :: After CSMA time is %lld", sim_time()); 
	#endif	  
	
    return SUCCESS;
  }

  void send_backoff(sim_event_t* evt);
  void send_transmit(sim_event_t* evt);
  void send_transmit_done(sim_event_t* evt);
  
  void start_csma() {
    sim_time_t first_sample;
    
//     call Control.stop();
    
    // The backoff is in terms of symbols. So take a random number
    // in the range of backoff times, and multiply it by the
    // sim_time per symbol.
    sim_time_t backoff = sim_random();
    backoff %= (sim_csma_init_high() - sim_csma_init_low());
    backoff += sim_csma_init_low();
    backoff *= (sim_ticks_per_sec() / sim_csma_symbols_per_sec());

    dbg("TossimPacketModelC", "Starting CMSA with %lli.\n", backoff);
    first_sample = sim_time() + backoff-8000000;

    sendEvent.mote = sim_node();                                    //does sim_node stores dest node
    sendEvent.time = first_sample;
    sendEvent.force = 0;
    sendEvent.cancelled = 0;

    sendEvent.handle = send_backoff;
    sendEvent.cleanup = sim_queue_cleanup_none;
    sim_queue_insert(&sendEvent);
  }


  void send_backoff(sim_event_t* evt) {
    backoffCount++;
//    call Control.start();
    if (call GainRadioModel.clearChannel()) {
      neededFreeSamples--;
    }
    else {
      neededFreeSamples = sim_csma_min_free_samples();
    }
  //  call Control.stop();
    if (neededFreeSamples == 0) {
      sim_time_t delay;
      delay = sim_csma_rxtx_delay();
      delay *= (sim_ticks_per_sec() / sim_csma_symbols_per_sec());
      evt->time += delay;
      transmitting = TRUE;
      call GainRadioModel.setPendingTransmission();
      evt->handle = send_transmit;
      sim_queue_insert(evt);
    }
    
    else if (sim_csma_max_iterations() == 0 ||
	  backoffCount <= sim_csma_max_iterations()) {
      sim_time_t backoff = sim_random();
      sim_time_t modulo = sim_csma_high() - sim_csma_low();
      modulo *= pow(sim_csma_exponent_base(), backoffCount);
      backoff %= modulo;
									
      backoff += sim_csma_init_low();
      backoff *= (sim_ticks_per_sec() / sim_csma_symbols_per_sec());
      evt->time += backoff;
      sim_queue_insert(evt);
     
    }
    else {
      message_t* rval = sending;
      sending = NULL;
      dbg("TossimPacketModelC", "PACKET: Failed to send packet due to busy channel.\n");
	  
	  #if defined(POWERTOSSIMZ)	
	  call Energy.send_busy(destNode, sendingLength, EBUSY); 
	  #endif

	  signal Packet.sendDone(rval, EBUSY);
    }
  }

  int sim_packet_header_length() {
    return sizeof(tossim_header_t);
  }
  
  void send_transmit(sim_event_t* evt) {
    sim_time_t duration;
   // call Control.start();
    tossim_metadata_t* metadata = getMetadata(sending);

    duration = 8 * (sendingLength + sim_packet_header_length());
    duration /= sim_csma_bits_per_symbol();
    duration += sim_csma_preamble_length();
    
    if (metadata->ack) {
      duration += sim_csma_ack_time();
    }
    duration *= (sim_ticks_per_sec() / sim_csma_symbols_per_sec());

    evt->time += duration;
    evt->handle = send_transmit_done;

    dbg("TossimPacketModelC", "PACKET: Broadcasting packet to everyone.\n");
	
	#if defined(POWERTOSSIMZ)	
	  call Energy.send_start(destNode, sendingLength, metadata->strength); 
	#endif	
	
    call GainRadioModel.putOnAirTo(destNode, sending, metadata->ack, evt->time, 0.0, 0.0);
    metadata->ack = 0;

    evt->time += (sim_csma_rxtx_delay() *  (sim_ticks_per_sec() / sim_csma_symbols_per_sec()));

    dbg("TossimPacketModelC", "PACKET: Send done at %llu.\n", evt->time);
	
	#if defined(POWERTOSSIMZ)	
	  call Energy.send_done(destNode, sendingLength, duration);
	#endif
	
    sim_queue_insert(evt);                  //ab ye event kyun insert kiya hai??
  }

  void send_transmit_done(sim_event_t* evt) {
    message_t* rval = sending;
    sending = NULL;
    transmitting = FALSE;
    dbg("TossimPacketModelC", "PACKET: Signaling send done at %llu.\n", sim_time());
	#if defined(POWERTOSSIMZ)	
	  //call Energy.send_done(destNode, sendingLength, SUCCESS);            //this line was commented by original authors, ricardo 
	#endif	
    signal Packet.sendDone(rval, running? SUCCESS:EOFF);
    
    //call Control.stop();
  }
 
  event void GainRadioModel.receive(message_t* msg) {
    if (running && !transmitting) {
	  #if defined(POWERTOSSIMZ)	
	    call Energy.recv_done(call AMPacket.destination(msg));
      #endif
	  signal Packet.receive(msg);
    }
  }

  uint8_t error = 0;


//ack ka funda nahi samajh aya
  event void GainRadioModel.acked(message_t* msg) {
    if (running) {
      tossim_metadata_t* metadata = getMetadata(sending);
      metadata->ack = 1;
      if (msg != sending) {
	error = 1;
	dbg("TossimPacketModelC", "Requested ack for 0x%x, but outgoing packet is 0x%x.\n", msg, sending);
      }
    }
  }

  event bool GainRadioModel.shouldAck(message_t* msg) {
    if (running && !transmitting) {
      return signal Packet.shouldAck(msg);
    }
    else {
      return FALSE;
    }
  }
}

