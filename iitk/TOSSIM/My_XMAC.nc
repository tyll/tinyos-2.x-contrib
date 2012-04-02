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
 * This packet-level radio component implements a basic XMAC
 * algorithm. It derives its constants from sim_csma.c. and architecture from TossimPacketModel.nc
 * @author Philip Levis (author of TossimPacketModel.nc)
 * @date Dec 16 2005
 *
 * @author Himanshu Singh (original)
 *         -- Implementation of XMAC
 *
 */



#include <Timer.h>
#include <TossimRadioMsg.h>
#include <sim_csma.h>

#define ACTIVE_PERIOD 30
#define SLEEP_PERIOD 100
#define P_BACKOFF_THRESH 10
#define ACKBACKOFF_THRESH 10
#define NO_PREAMBLES 18         // by himanshu, I donot know why it is not working with 16 preambles


module MAC_XMAC2 { 
  provides {
    interface Init;
    interface SplitControl as Control;
    interface PacketAcknowledgements;
    interface TossimPacketModel as Packet;
  }
  uses interface GainRadioModel; 
  uses interface Timer<TMilli> as activeTimer;
  uses interface Timer<TMilli> as sleepTimer;
  uses interface AMSend as MacAMSend;
  uses interface Packet as ConPacket;
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
  uint8_t p_backoffCount;
  uint8_t neededFreeSamples;
  message_t* sending = NULL;
  bool transmitting = FALSE;
  uint8_t sendingLength = 0;
  uint8_t noTry = 0;        // by himanshu
  int destNode;

  sim_event_t sendEvent;
  sim_event_t PsendEvent;
  sim_event_t ACKsendEvent;

  bool radio_locked = FALSE;
  uint8_t no_SendTry = 0;
  bool PendingData=FALSE;
  bool receiveP=FALSE;
  bool receivedACK=FALSE;
  bool sendingFailed = FALSE;
  uint8_t ackbackoffCount;

  int16_t seq_no = 0;  
  message_t receiveBuffer;
  message_t preamble;
  message_t ackpacket;

  sim_time_t backoff2;
  //sim_time_t duration;
  sim_time_t duration1;
  sim_time_t duration2;

  preamble_packet_t* preamble_rec;
  preamble_packet_t* preamble_trans;

  ACK_packet_t* ackP;
  ACK_packet_t* ack_rec;

  data_packet_t* data_packet;
  data_packet_t* data_rec;
  data_packet_t* data_rec2;

//function declaration.
  void start_csma();
  void send_data();
  void send_backoff(sim_event_t* evt);
  void send_transmit(sim_event_t* evt);
  void send_transmit_done(sim_event_t* evt);

  void start_preamble();
  void send_preamble(sim_event_t* evt);
  void send_transmit_preamble(sim_event_t* evt);
  void send_transmit_done_preamble(sim_event_t* evt);

  void send_ack(sim_event_t* evt);
  void send_transmit_ack(sim_event_t* evt);
  void send_transmit_done_ack(sim_event_t* evt);
  
  tossim_metadata_t* getMetadata(message_t* msg) {
    return (tossim_metadata_t*)(&msg->metadata);
  }
  
tossim_header_t* getHeaderdata(message_t* msg) {
    return (tossim_header_t*)(&msg->header);
  }

  int sim_packet_header_length() {
    return sizeof(tossim_header_t);
  }

  command error_t Init.init() {
	call activeTimer.startOneShot(ACTIVE_PERIOD);
    dbg("TossimPacketModelC", "TossimPacketModelC: Init.init() called\n");
    initialized = TRUE;
    // We need to cancel in case an event is still lying around in the queue from
    // before a reboot. Otherwise, the event will be executed normally (node is on),
    // but its memory has been zeroed out.
    sendEvent.cancelled = 1;
    data_rec2 = (data_packet_t*)malloc(sizeof(data_packet_t));
    data_rec2->payload[1] = 0;
    return SUCCESS;
  }

/////////////////////////////////////////////////////////////////////////////////////////////////

event void activeTimer.fired() {       
      dbg("TossimPacketModelC", "TossimPacketModelC: Active timer fired at time = %llu.\n",sim_time());
            
       
        if(!radio_locked){          //if node is not in communication,then only u cannot off radio
//          dbg("TossimPacketModelC", "TossimPacketModelC: Going to Turn Radio OFF\n");
            call Control.stop();
	    call sleepTimer.startOneShot(SLEEP_PERIOD); 
        }
        else{
//            dbg("TossimPacketModelC", "TossimPacketModelC: Want to Turn Radio OFF, but Radio locked\n");
        }
        
        if(sendingFailed)       // by himanshu
        {
            
            signal Packet.sendDone(sending, EBUSY);
            sendingFailed = FALSE;
            

            sending = NULL;
               
            //        free(data_packet->payload);
            transmitting = FALSE;
            noTry  = 0;         // by himanshu
            no_SendTry = 0;
            radio_locked = FALSE;
            receivedACK = FALSE;
            dbg("TossimPacketModelC", "PACKET: Signaling send done at %llu.\n", sim_time());
            #if defined(POWERTOSSIMZ)	
            //call Energy.send_done(destNode, sendingLength, SUCCESS);            //this line was commented by original authors, ricardo 
            #endif	
        }         
        
  }

////////////////////////////////////////////////////////////////////////////////////////////////

event void sleepTimer.fired() {       
    dbg("TossimPacketModelC", "TossimPacketModelC: Sleep timer fired at time = %llu.\n",sim_time());
//    dbg("TossimPacketModelC", "TossimPacketModelC: Going to turn Radio ON\n");
    call Control.start();
    call activeTimer.startOneShot(ACTIVE_PERIOD);  
    if(sending!= NULL)
    { 	
	if(PendingData)
	{
	  PendingData=FALSE;
	  start_csma();
	}
	else
	{
        seq_no = NO_PREAMBLES;
	receiveP=FALSE;
    receivedACK=FALSE;      //by himanshu
	start_preamble();
	}     
     } 
  }

//////////////////////////////////////////////////////////////////////////////////////////////////

  task void startDoneTask() {
   
	#if defined(POWERTOSSIMZ)
	  if ( !sweepMe ){}
	#endif
	
	#if defined(CSMA)
        signal Control.startDone(SUCCESS);
    #endif
  }

  task void stopDoneTask() {
     #if defined(CSMA)
        running = FALSE;
        signal Control.stopDone(SUCCESS);
     #endif
  }
  
  command error_t Control.start() {
    if (!initialized) {
      dbgerror("TossimPacketModelC", "TossimPacketModelC: Control.start() called before initialization!\n");
      return FAIL;
    }
//    dbg("TossimPacketModelC", "TossimPacketModelC: Control.start() called.\n");
    post startDoneTask();
    running = TRUE;
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
//    dbg("TossimPacketModelC", "TossimPacketModelC: Control.stop() called.\n");
  
	#if defined(POWERTOSSIMZ)  
	  call Energy.poweroff_start();
	#endif
  
	post stopDoneTask();
    return SUCCESS;
  }

  
  event void MacAMSend.sendDone(message_t *msg, error_t error) {
  }
  
  async command error_t PacketAcknowledgements.requestAck(message_t* msg) {
    tossim_metadata_t* meta = getMetadata(msg);
    meta->ack = TRUE;
    return SUCCESS;
  }

  async command error_t PacketAcknowledgements.noAck(message_t* ack) {
    tossim_metadata_t* meta = getMetadata(ack);
    meta->ack = FALSE;
    return SUCCESS;
  }

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
	
	#if defined(CSMA)	
		signal Packet.sendDone(msg, running? SUCCESS:EOFF);
	#endif
  }

  command error_t Packet.cancel(message_t* msg) {
    return FAIL;
  }

void start_csma();

	command error_t Packet.send(int dest, message_t* msg, uint8_t len) {
	uint8_t dataLen;
	uint8_t *payload;
        uint8_t *payload2;

    if (sending != NULL) {
//	  #if defined(POWERTOSSIMZ)	  
  	    dbg("TossimPacketModelC", "Attempting to send a message while sending another one...\n");
//	  #endif
	  return EBUSY;
    }

    
    if (!initialized) {
      dbgerror("TossimPacketModelC", "TossimPacketModelC: Send.send() called, but not initialized!\n");
      return EOFF;
    }

    call Control.start();
    radio_locked = TRUE;
    
/*    if (!running) {
      dbgerror("TossimPacketModelC", "TossimPacketModelC: Send.send() called, but not running!\n");
      return EOFF;

    }
*/
    dataLen = call ConPacket.payloadLength(msg);

    payload = (uint8_t*)call ConPacket.getPayload(msg, call ConPacket.maxPayloadLength());

    payload2 = (uint8_t*)malloc(16*sizeof(uint8_t));
    memcpy(payload2, payload, dataLen);
    
    data_packet = (data_packet_t*)call ConPacket.getPayload(msg, sizeof(data_packet_t));
    data_packet->packet_type = 0;
    memcpy(data_packet->payload, payload2,dataLen);    
     
    destNode = dest;
	
    seq_no = NO_PREAMBLES;
    receiveP=FALSE;
    receivedACK = FALSE;        //by himanshu
    noTry++;
    start_preamble();

    sendingLength = len; 
    sending = msg;
    destNode = dest;
    backoffCount = 0;
    neededFreeSamples = sim_csma_min_free_samples();

//    start_csma();
	
	#if defined(POWERTOSSIMZ)	  
	  dbg("ENERGY_DEBUG", "After CSMA time is %lld", sim_time()); 
	#endif	  
	
    return SUCCESS;
  }


void start_preamble()
{
 p_backoffCount=0;
 ackbackoffCount = 0;
dbg("TossimPacketModelC", "%hu, at Time=%llu \n",receiveP, sim_time());
 if(!receiveP)
  {
    sim_time_t backoff;
    call activeTimer.stop();
    call sleepTimer.stop();
    seq_no--;
    dbg("TossimPacketModelC", "PACKET: Starting preamble packet with seq_no = %hu, at Time=%llu \n",seq_no, sim_time());
    preamble_trans = (preamble_packet_t*)call ConPacket.getPayload(&preamble,15);
 
    preamble_trans->packet_type = 1;
    preamble_trans->dest_id = destNode;
    preamble_trans->src_id = sim_node();
    preamble_trans->seq_no = seq_no;

	backoff = sim_random();
        backoff %= (sim_csma_init_high() - sim_csma_init_low());
        backoff += sim_csma_init_low();
        backoff *= (sim_ticks_per_sec() / sim_csma_symbols_per_sec());

    	PsendEvent.mote = sim_node();
    	PsendEvent.time = sim_time() + 5*10000000;//10000000=1ms to wait for ACK
  //  	PsendEvent.time = sim_time();
    	PsendEvent.force = 0;
    	PsendEvent.cancelled = 0;

    	PsendEvent.handle = send_preamble;
    	PsendEvent.cleanup = sim_queue_cleanup_none;
    	sim_queue_insert(&PsendEvent);
    
  }	
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////


void send_preamble(sim_event_t* evt) {
    p_backoffCount++;
dbg("TossimPacketModelC", "In send_preamble preamble packet at Time=%llu \n",sim_time());
    if(running){
	    if (call GainRadioModel.clearChannel()) {
	      
	      sim_time_t delay;
	      delay = sim_csma_rxtx_delay();
	      delay *= (sim_ticks_per_sec() / sim_csma_symbols_per_sec());
	      evt->time += delay;
	      transmitting = TRUE;
	      call GainRadioModel.setPendingTransmission();
	      evt->handle = send_transmit_preamble;
	      sim_queue_insert(evt);
	    }
	    else 
	      if(p_backoffCount <= P_BACKOFF_THRESH) {
		    sim_time_t backoff = sim_random();
		    backoff %= (sim_csma_init_high() - sim_csma_init_low());
		    backoff += sim_csma_init_low();
		    backoff *= (sim_ticks_per_sec() / sim_csma_symbols_per_sec());
		    
		      evt->time += backoff;
		      sim_queue_insert(evt);
	      }
	      else {
	      
		  dbg("TossimPacketModelC", "PACKET: Failed to send preamble due to busy channel.\n");
		  if(seq_no>0){
		  start_preamble();
		  }
		else
		  {
		   dbg("TossimPacketModelC", "PACKET: Failed to communicate going to sleep.\n");
		   call Control.stop();
	  	   call sleepTimer.startOneShot(SLEEP_PERIOD);
		  }
		  #if defined(POWERTOSSIMZ)	
		  call Energy.send_busy(destNode, sendingLength, EBUSY); 
		  #endif
	      
		 
	      }
      }
  }
////////////////////////////////////////////////////////////////////////

 
  void send_transmit_preamble(sim_event_t* evt) {
    sim_time_t duration;
    tossim_metadata_t* metadata = getMetadata(&preamble);
    
    if(receivedACK == FALSE)
    	    dbg("TossimPacketModelC", "PACKET: receivedACK is false at Time=%llu \n",sim_time());
    	    
    if(preamble_trans!=NULL && receivedACK == FALSE && receiveP == FALSE){      // by himanshu
	    duration = 8 * (sizeof(preamble) + sim_packet_header_length());
	    duration /= sim_csma_bits_per_symbol();
	    duration += sim_csma_preamble_length();
	    duration *= (sim_ticks_per_sec() / sim_csma_symbols_per_sec());
	    metadata->ack = 0;
	    evt->time += duration;
	    evt->handle = send_transmit_done_preamble;

	    dbg("TossimPacketModelC", "PACKET: Broadcasting preamble packet at Time=%llu \n",sim_time());
	
		#if defined(POWERTOSSIMZ)	
		  call Energy.send_start(AM_BROADCAST_ADDR, sizeof(preamble), metadata->strength); 
		#endif	
	
	    call GainRadioModel.putOnAirTo(AM_BROADCAST_ADDR,&preamble, metadata->ack, evt->time, 0.0, 0.0);
	    metadata->ack = 0;

	    evt->time += (sim_csma_rxtx_delay() *  (sim_ticks_per_sec() / sim_csma_symbols_per_sec()));

	    dbg("TossimPacketModelC", "PACKET: Send done at %llu.\n", evt->time);
	
		#if defined(POWERTOSSIMZ)	
		  call Energy.send_done(AM_BROADCAST_ADDR, sizeof(preamble), duration);
		#endif
	
	    sim_queue_insert(evt);
     }
     else{                                          // by himanshu, node has received the ack so cancel the preamble which is already in queue, if any.
        transmitting = FALSE;
        receivedACK = FALSE;
     }
        
  }

/////////////////////////////////////////////////////////////////////

void send_transmit_done_preamble(sim_event_t* evt) {
    preamble_trans = NULL;
    transmitting = FALSE;
    dbg("TossimPacketModelC", "PACKET: Signaling preamble send done at %llu.\n", sim_time());
	
    
     if(seq_no!=0)
     {
    	start_preamble();
      
     }
     else{                                  // by himanshu
        if(noTry < 1)                      // if one set of preamble fails, we can go for another set of preambles. Currently, going for only one set.
        {
            noTry++;
            seq_no = NO_PREAMBLES;
            start_preamble();
        }
        else{                                // by himanshu, this is necessary, because if channel is very noisy, node will ultimately fail and has to signal "EBUSY"
            

            call activeTimer.startOneShot(ACTIVE_PERIOD);
            
            sendingFailed = TRUE;           // by himanshu, done because want to give some time to receive ack for seq_no = 0, rather than declaring failed immediately after sending seq_no = 0
            
        }    
        receivedACK = FALSE;
     }   
     


  }

////////////////////////////////////////////////////////////////////////
 void send_ack(sim_event_t* evt)
  {
  
//      dbg("TossimPacketModelC", "PACKET: yahan1 Time =  %llu.\n", sim_time());
      if(running)
      { ackbackoffCount++;
  //          dbg("TossimPacketModelC", "PACKET: yahan2 Time =  %llu.\n", sim_time());
        if(call GainRadioModel.clearChannel())
        {
          sim_time_t delay;
             dbg("TossimPacketModelC", "PACKET: Radio clear, sending ACK for preamble Time =  %llu.\n", sim_time());
              transmitting = TRUE;
              call GainRadioModel.setPendingTransmission();
              evt->handle = send_transmit_ack;     
              delay = sim_csma_rxtx_delay();
              delay *= (sim_ticks_per_sec() / sim_csma_symbols_per_sec());
              evt->time += delay;

              sim_queue_insert(evt);
        }
        else{

             if (ackbackoffCount <= ACKBACKOFF_THRESH) {

                backoff2 = sim_random();
                backoff2 %= (sim_csma_init_high() - sim_csma_init_low());
                backoff2 += sim_csma_init_low();
                backoff2 *= (sim_ticks_per_sec() / sim_csma_symbols_per_sec());

                evt->time += backoff2;
                sim_queue_insert(evt);
             }
                   
            else {

              dbg("TossimPacketModelC", "PACKET: Failed to send ACK for preamble due to busy channel.\n");
	          radio_locked = FALSE;
	          #if defined(POWERTOSSIMZ)	
	             call Energy.send_busy(AM_BROADCAST_ADDR, sizeof(ackpacket), EBUSY); 
	          #endif


            }
            
        }
      }
      else{
          dbg("TossimPacketModelC", "PACKET: Radio sleeping while sending ACK, so backing off. Time =  %llu.\n", sim_time());
      }
        
  }
  
  
  void send_transmit_ack(sim_event_t* evt)
  {
    sim_time_t duration;

    tossim_metadata_t* metadata = getMetadata(&ackpacket);

    duration = 8 * (sizeof(ackpacket) + sim_packet_header_length());
    duration /= sim_csma_bits_per_symbol();
    duration += sim_csma_preamble_length();
    duration *= (sim_ticks_per_sec() / sim_csma_symbols_per_sec());

    evt->time += duration;
    evt->handle = send_transmit_done_ack;

    dbg("TossimPacketModelC", "PACKET: Broadcasting ACK time: %llu\n",sim_time());


	#if defined(POWERTOSSIMZ)	
	  call Energy.send_start(AM_BROADCAST_ADDR, sizeof(ackpacket), metadata->strength); 
	#endif	
	
    call GainRadioModel.putOnAirTo(AM_BROADCAST_ADDR, &ackpacket, metadata->ack, evt->time, 0.0, 0.0);
    metadata->ack = 0;

    evt->time += (sim_csma_rxtx_delay() *  (sim_ticks_per_sec() / sim_csma_symbols_per_sec()));

    dbg("TossimPacketModelC", "PACKET: ACK Send done at %llu.\n", evt->time);
	
	#if defined(POWERTOSSIMZ)	
	  call Energy.send_done(AM_BROADCAST_ADDR, sizeof(ackpacket), duration);
	#endif
	
    sim_queue_insert(evt);                  //ab ye event kyun insert kiya hai??  
  
  }
  
  void send_transmit_done_ack(sim_event_t* evt) {
    ackP=NULL;
    transmitting = FALSE;

    //waiting_fordata = TRUE;
    dbg("TossimPacketModelC", "PACKET: Signaling ACK for preamble send done at %llu.\n", sim_time());
	#if defined(POWERTOSSIMZ)	
	  //call Energy.send_done(destNode, sendingLength, SUCCESS);            //this line was commented by original authors, ricardo 
	#endif	
		
  }
  
////////////////////////////////////////////////////////////////////////

  void send_backoff(sim_event_t* evt);
  void send_transmit(sim_event_t* evt);
  void send_transmit_done(sim_event_t* evt);
  
  void start_csma() {
    sim_time_t first_sample;
    dbg("TossimPacketModelC", "Starting CMSA.\n");
    first_sample = sim_time() ;

    sendEvent.mote = sim_node();
    sendEvent.time = first_sample;
    sendEvent.force = 0;
    sendEvent.cancelled = 0;

    sendEvent.handle = send_backoff;
    sendEvent.cleanup = sim_queue_cleanup_none;
    sim_queue_insert(&sendEvent);
  }


  void send_backoff(sim_event_t* evt) {
    backoffCount++;
    if (call GainRadioModel.clearChannel()) {
      neededFreeSamples--;
    }
    else {
      neededFreeSamples = sim_csma_min_free_samples();
    }
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

  void send_transmit(sim_event_t* evt) {
    sim_time_t duration;
    tossim_metadata_t* metadata = getMetadata(sending);

    duration = 8 * (sendingLength + sim_packet_header_length());
    duration /= sim_csma_bits_per_symbol();
    duration += sim_csma_preamble_length();
    
    metadata->ack = 1;
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
	
    sim_queue_insert(evt);
  }

  void send_transmit_done(sim_event_t* evt) {

    message_t* rval = sending;
    tossim_metadata_t* metadata = getMetadata(sending);
    no_SendTry++;    
    if(metadata->ack || destNode == AM_BROADCAST_ADDR){
          dbg("TossimPacketModelC", "PACKET: Received ack at %llu.\n", sim_time());
          signal Packet.sendDone(rval, running? SUCCESS:EOFF);
          
    }
    else{
        if(no_SendTry<2 && sending!=NULL)
        {
            dbg("TossimPacketModelC", "PACKET: Didnot Received ack, sending again at %llu.\n", sim_time());
            start_csma();
        }
        else{
            dbg("TossimPacketModelC", "PACKET: Didnot Received ack twice, Signaling Failed at %llu.\n", sim_time());
            signal Packet.sendDone(rval, EBUSY);
        }
    }        
    
    if(metadata->ack==1 || no_SendTry>=2 || destNode == AM_BROADCAST_ADDR)
    {
        sending = NULL;
               
//        free(data_packet->payload);
        transmitting = FALSE;
        noTry  = 0;         // by himanshu
	no_SendTry = 0;
        radio_locked = FALSE;
        dbg("TossimPacketModelC", "PACKET: Signaling send done at %llu.\n", sim_time());
        #if defined(POWERTOSSIMZ)	
        //call Energy.send_done(destNode, sendingLength, SUCCESS);            //this line was commented by original authors, ricardo 
        #endif	

        call activeTimer.startOneShot(ACTIVE_PERIOD);
      
       
    }
  }
 /////////////////////////////////////////////////////////////////////////////////
  event void GainRadioModel.receive(message_t* msg) {
  tossim_metadata_t* metadata2;
	sim_time_t duration;
	
//		dbg("TossimPacketModelC", "Receive Function: Reaceived a packet, checking if running\n");
		
    if (running && !transmitting) 
     {

        #if defined(POWERTOSSIMZ)	
	    call Energy.recv_done(call AMPacket.destination(msg));
	#endif
	preamble_rec = (preamble_packet_t*)call ConPacket.getPayload(msg, 25);   
	
	dbg("TossimPacketModelC", "Receive Function: Reaceived a packet of type %hu with seq_no %hu %llu.\n", preamble_rec->packet_type ,preamble_rec->seq_no ,sim_time());
	if(preamble_rec->packet_type == 1)
	  {
          	tossim_metadata_t* metadata = getMetadata(&preamble);
	  	duration = 8 * (sizeof(preamble) + sim_packet_header_length());
          	duration /= sim_csma_bits_per_symbol();
          	duration += sim_csma_preamble_length();

	  	metadata->ack = 0;

	  	if (metadata->ack) 
	  	{
  	  	   duration += sim_csma_ack_time();
	  	}

	  	duration *= (sim_ticks_per_sec() / sim_csma_symbols_per_sec());
	  	duration*=preamble_rec->seq_no;

		if(preamble_rec->dest_id == sim_node())
		{
//		    if(sending==NULL)       //by himanshu, I was trying to implement Full Buffer Priority as given in TMAC, but no appreciable increase is obtained.
//		    {  receiveP=TRUE;
		      radio_locked = TRUE;
		      call activeTimer.stop();
		      call sleepTimer.stop();
		      ackP = (ACK_packet_t*)call ConPacket.getPayload(&ackpacket, sizeof(ACK_packet_t));
                      ackP->packet_type = 2;
                      ackP->src_id = sim_node();
                      ackP->dest_id = preamble_rec->src_id;

                      ACKsendEvent.mote = sim_node();                                    //does sim_node stores dest node
                      ACKsendEvent.time = sim_time();
                      ACKsendEvent.force = 0;
                      ACKsendEvent.cancelled = 0;
                      ACKsendEvent.handle = send_ack;
                      ACKsendEvent.cleanup = sim_queue_cleanup_none;
                      sim_queue_insert(&ACKsendEvent);
		      
                      dbg("TossimPacketModelC", "TossimPacketModelC: In GainRadioModel.receive, Sending a ACK to node %hu\n",ackP->dest_id);
//             }         
		}

		else
		{
		  if(sending!= NULL)
		  {
		    radio_locked=FALSE;
		    call Control.stop();
		    call sleepTimer.startOneShot(SLEEP_PERIOD); 
                  }
		}
	  }
	
	else if(preamble_rec->packet_type == 2)              //got a ACK packet
        {
    

            ack_rec = (ACK_packet_t*)call ConPacket.getPayload(msg, sizeof(ACK_packet_t));
            dbg("TossimPacketModelC", "TossimPacketModelC: In GainRadioModel.receive, Received an ACK from %hu for %hu  time:%llu\n",ack_rec->src_id,ack_rec->dest_id,sim_time());            

            if(ack_rec->dest_id == sim_node())          //if ACK destined to me, then send data now
            {
               /* if(!(call gotrts_sleepTimer.isRunning()))
                {

                    rts = NULL;
                    call RTSwaitTimer.stop();
                    totalRTSCount = 0;
		*/
                    dbg("TossimPacketModelC", "TossimPacketModelC: In GainRadioModel.receive, Sending data \n");
                    receivedACK = TRUE;         //by himanshu        
                    sendingFailed = FALSE;      // by himanshu
                    no_SendTry = 0;
		   
		    //seq_no=0;  //stop sending preambles
                    start_csma();
                //}
            }    
            else		//if ACK not destined to node
		{		
				                		dbg("TossimPacketModelC", "TossimPacketModelC: In GainRadioModel.receive, not for me\n");
                if(!radio_locked)
		{
            dbg("TossimPacketModelC", "TossimPacketModelC: In GainRadioModel.receive, radio open\n");
            if(sending!=NULL )         //by himanshu
            {   dbg("TossimPacketModelC", "TossimPacketModelC: In GainRadioModel.receive, have pending data\n");

                if(destNode == ack_rec->src_id){             // by himanshu, its ack_rec and not ackP                
                    PendingData = TRUE;
               }                                               
                    dbg("TossimPacketModelC", "TossimPacketModelC: In GainRadioModel.receive, have pending data\n");
                    metadata2 = getMetadata(sending);
                    dbg("TossimPacketModelC", "TossimPacketModelC: In GainRadioModel.receive, have pending data\n");
                    duration2 = 8 * (sendingLength + sim_packet_header_length());
                    duration2 /= sim_csma_bits_per_symbol();
                    duration2 += sim_csma_preamble_length();

                    metadata2->ack = 1;        
                    if (metadata2->ack) {
                    duration2 += sim_csma_ack_time();
                    }
                    duration2 *= (sim_ticks_per_sec() / sim_csma_symbols_per_sec());

                    backoff2 = sim_random();
                    backoff2 %= (sim_csma_init_high() - sim_csma_init_low());
                    backoff2 += sim_csma_init_low();
                    backoff2 *= (sim_ticks_per_sec() / sim_csma_symbols_per_sec());

                    dbg("TossimPacketModelC", "TossimPacketModelC: In GainRadioModel.receive, have pending data");

                    duration1=duration2+backoff2;
                    call activeTimer.stop();
                    call Control.stop();
                    call sleepTimer.startOneShot(duration1/10000000);
                //}


            }
		else
		    {              
        		dbg("TossimPacketModelC", "TossimPacketModelC: In GainRadioModel.receive, ACK for node %hu was received, Going to stop radio. \n",ack_rec->dest_id);
			call Control.stop();                    
			call sleepTimer.startOneShot(SLEEP_PERIOD);
                    }
                }
                }
        }
	else //if(preamble_rec->packet_type == 0)
	{


            message_t *buffer;
            uint8_t dataLen;
            void* payload;

            buffer = (message_t*)malloc(sizeof(message_t));
            memcpy(buffer, msg, sizeof(message_t));

            dataLen = call ConPacket.payloadLength(msg);

            payload = call ConPacket.getPayload(buffer, call ConPacket.maxPayloadLength());
            
            data_rec = (data_packet_t*)call ConPacket.getPayload(msg, sizeof(data_packet_t));

		//To enable MAC to remove duplicate packets, uncomment following lines
	
           
            // by himanshu, comments removed to check duplicate packets            
            if(data_rec2->payload[1] != (data_rec->payload[1])){
                data_rec2->payload[1] = (data_rec->payload[1]);
            }
            else{
                return;
            }        


            memcpy(payload,data_rec->payload,dataLen);

		dbg("TossimPacketModelC", "Receive Function: Reaceived a data packet of type %hu %llu.\n", preamble_rec->packet_type ,sim_time());
	  
	  signal Packet.receive(buffer);
	  call activeTimer.startOneShot(ACTIVE_PERIOD);
		radio_locked = FALSE;
	}
    }
  }

uint8_t error = 0;
  
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

