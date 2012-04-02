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
 * This packet-level radio component implements a basic MAC_DMAC
 * algorithm. It derives its constants from sim_csma.c. and architecture from TossimPacketModel.nc
 * @author Philip Levis (author of TossimPacketModel.nc)
 * @date Dec 16 2005
 *
 * @author Himanshu Singh (original)
 *         -- Implementation of MAC_DMAC
 *
 */

#include <Timer.h>
#include <TossimRadioMsg.h>
#include <sim_csma.h>

#define MAX_LEVELS 11
#define ORIG_CYCLE_PERIOD 1000
#define ORIG_TX_PERIOD 25
#define ORIG_RX_PERIOD 25
#define ORIG_U_PERIOD 25
#define ORIG_SYNCHRO_PERIOD 480
#define SYNBACKOFF_THRESH 20
#define ACKBACKOFF_THRESH 5
#define DATABACKOFF_THRESH 30
#define SYN_BACKOFF_FACTOR 10
#define ACK_WAIT_TIME 10
#define MAX_CYCLES 2
//#define DEPTH (10 - sim_node()%10)


module MAC_DMAC { 
  provides {
    interface Init;
    interface SplitControl as Control;
    interface PacketAcknowledgements;
    interface TossimPacketModel as Packet;
  }
  uses interface GainRadioModel; 


  uses interface Timer<TMilli> as du_Timer;
  uses interface Timer<TMilli> as SYNwaitTimer;
  uses interface Timer<TMilli> as cycleTimer;
  uses interface Timer<TMilli> as TX_Timer;
  uses interface Timer<TMilli> as RX_Timer;
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
  uint8_t synbackoffCount;
  uint8_t ackbackoffCount;
  uint8_t noSYN_rec=0;
  uint8_t no_SendTry=0;
  uint8_t neededFreeSamples;
  uint8_t globalvar_timediff =0;
  uint8_t no_sync = 0;
  message_t* sending = NULL;
  bool transmitting = FALSE;
  uint8_t sendingLength = 0;
  int node_depth = -1;
  int destNode;
  bool radio_locked = FALSE;
  bool syn_done = FALSE;
  bool syn_sentbyme = FALSE;
  bool radioOnbyTimer = TRUE;
  bool imborderNode = FALSE;
  bool alreadyTryingforSYNC = FALSE;
  bool perm_sleeping = FALSE;
  bool waiting_fordata = FALSE;
  bool data_received = FALSE;
  bool ack_received = FALSE;
  bool cancelSending_temp = FALSE;

  
//  uint16_t CYCLE_PERIOD= ORIG_U_PERIOD*(MAX_LEVELS+1) + SYNCHRO_PERIOD;       // in milliseconds
  uint16_t CYCLE_PERIOD= ORIG_CYCLE_PERIOD;
  uint16_t TX_PERIOD=ORIG_TX_PERIOD;      // in milliseconds
  uint16_t RX_PERIOD=ORIG_RX_PERIOD;      // in milliseconds
  uint16_t U_PERIOD=ORIG_U_PERIOD;
  uint16_t SYNCHRO_PERIOD=ORIG_SYNCHRO_PERIOD;
  uint8_t d;
  
  SYN_packet_t* syn=NULL;        
  SYN_packet_t* syn4=NULL;  


  ACK_packet_t* ackP;
  ACK_packet_t* ack_rec;

  data_packet_t* data_packet;
  
  data_packet_t* data_packet2;
   data_packet_t* data_rec2;                   
  
  bool isSynchroniser = FALSE;
  bool isFollower = FALSE;
  
  message_t synpacket;
  message_t ackpacket;
  message_t *buffer;  
 
  uint8_t i,j;

  sim_event_t sendEvent;
  sim_event_t SYNsendEvent;
    sim_event_t evt2;
    
  sim_time_t sample_time;       //sample_time
  sim_time_t backoff2;
  
  //Function declaration
  void send_data();
  void send_backoff(sim_event_t* evt);
  void send_transmit(sim_event_t* evt);
  void send_transmit_done(sim_event_t* evt);
  void send_transmit_done_waitingAck(sim_event_t* evt);

  void start_syn();
  void send_syn(sim_event_t* evt);
  void send_transmit_syn(sim_event_t* evt);
  void send_transmit_done_syn(sim_event_t* evt);

  void send_ack(sim_event_t* evt);
  void send_transmit_ack(sim_event_t* evt);
  void send_transmit_done_ack(sim_event_t* evt);
  
  void goingto_permsleep();
  
  tossim_metadata_t* getMetadata(message_t* msg) {
    return (tossim_metadata_t*)(&msg->metadata);
  }


  tossim_header_t* getHeaderdata(message_t* msg) {
    return (tossim_header_t*)(&msg->header);
  }

  int sim_packet_header_length() {
    return sizeof(tossim_header_t);
  }

  command error_t Init.init() {                                                             // starts the mac

    dbg("TossimPacketModelC", "TossimPacketModelC: Init.init() called\n");
    initialized = TRUE;
    // We need to cancel in case an event is still lying around in the queue from
    // before a reboot. Otherwise, the event will be executed normally (node is on),
    // but its memory has been zeroed out.
    sendEvent.cancelled = 1;
    
/*    
    if(sim_node() == 0)
        d = 0;
    else if(sim_node()%4 == 0)
        d = sim_node()/4;
    else
        d = sim_node()/4 + 1;
    
    d = 5 - d;      

*/    
        
//    d = 10 - sim_node();        // for linear topology    
//    call du_Timer.startOneShot(d*U_PERIOD);
//    dbg("TossimPacketModelC", "TossimPacketModelC: du_Timer started at %llu, will fire after %hhu sec, node number:%hhu\n", sim_time(),d*U_PERIOD, sim_node());
    call cycleTimer.startOneShot(CYCLE_PERIOD);
    
    
    data_rec2 = (data_packet_t*)malloc(sizeof(data_packet_t));

    
    return SUCCESS;
  }


                   

  event void cycleTimer.fired() {       

    dbg("TossimPacketModelC", "TossimPacketModelC: Cycle timer fired at time = %llu.\n",sim_time());
    dbg("TossimPacketModelC", "TossimPacketModelC: Going to turn Radio ON\n");
    call Control.start();
    
    
        isFollower = FALSE;
        noSYN_rec = 0;
//        node_depth = -1;
        syn_sentbyme = FALSE;
        imborderNode = FALSE;
        alreadyTryingforSYNC = FALSE;
    
    
    
    radioOnbyTimer = TRUE;
    syn_done = FALSE;
    perm_sleeping = FALSE;
    TX_PERIOD = ORIG_TX_PERIOD;
//    CYCLE_PERIOD= ORIG_U_PERIOD*(MAX_LEVELS+1) + SYNCHRO_PERIOD;
     CYCLE_PERIOD= ORIG_CYCLE_PERIOD;
    perm_sleeping = FALSE;
    if(CYCLE_PERIOD > ORIG_CYCLE_PERIOD)
            CYCLE_PERIOD = ORIG_CYCLE_PERIOD;
    call cycleTimer.startOneShot(CYCLE_PERIOD);
    
    if(no_sync >=5)
    {
        SYNCHRO_PERIOD = 5;
    }
    else
    {
        SYNCHRO_PERIOD = ORIG_SYNCHRO_PERIOD;
    }    
    call SYNwaitTimer.startOneShot(SYNCHRO_PERIOD);
    dbg("TossimPacketModelC", "TossimPacketModelC: SYNwaitTimer started, time = %llu\n",sim_time());
    

    if(running && sim_node()==0 && no_sync<5){                //only synchroniser is allowed to send SYNC packet

       node_depth = 0;        
       alreadyTryingforSYNC = TRUE;
       start_syn();               


    }
    
    no_sync++;

    globalvar_timediff = 0;    
  }
  
  
  void start_syn()
  {
    if(!radio_locked){                   //if node is in communication, u cannot off radio and cannot send syn packet
   
    dbg("TossimPacketModelC", "start_syn : here2\n");
        
        synbackoffCount = 0;    
        isSynchroniser = TRUE;

        syn = (SYN_packet_t*)call ConPacket.getPayload(&synpacket, 20);

        if (syn == NULL) {
        	return;
        }
               
        syn->packet_type = 1;        // 1 for syn, 2 for RTS, 3 for CTS, 0 for userdata
        syn->node_id = sim_node();
        syn->node_depth = node_depth;
        
        dbg("TossimPacketModelC", "start_syn : here2\n");

        //some backoff before sending sync
                       
        // The backoff is in terms of symbols. So take a random number
        // in the range of backoff times, and multiply it by the
        // sim_time per symbol.
        backoff2 = sim_random();
        backoff2 %= ((sim_csma_init_high() - sim_csma_init_low()));
        backoff2 += sim_csma_init_low();
        backoff2 *= (sim_ticks_per_sec() / sim_csma_symbols_per_sec());
        //dbg("TossimPacketModelC", "TossimPacketModelC: Backoff value: %llu\n",backoff2);
        sample_time = sim_time() + backoff2*10-8000000;
        //sample_time = sim_time() + backoff2*2;
//        sample_time = sim_time() + backoff2-8000000;
        
        SYNsendEvent.mote = sim_node();                 //sim_node() returns my node_id
        SYNsendEvent.time = sample_time;
        SYNsendEvent.force = 0;
        SYNsendEvent.cancelled = 0;
        SYNsendEvent.handle = send_syn;                 //handling function
        SYNsendEvent.cleanup = sim_queue_cleanup_none;
        sim_queue_insert(&SYNsendEvent);                 // cooment this line if you donnot want to send sync packet
        //send SYN
            dbg("TossimPacketModelC", "start_syn : here2\n");
    }       
    else{
            dbg("TossimPacketModelC", "TossimPacketModelC: Cannot send SYN packet. Radio locked\n");
    }
  }
  
  
  //these function names are self-explanatory from their names
  void send_syn(sim_event_t* evt)
  {
  
      dbg("TossimPacketModelC", "SYNPACKET: here3\n");
          if(running)
          { synbackoffCount++;
            dbg("TossimPacketModelC", "SYNPACKET: here5\n");
            if(call GainRadioModel.clearChannel())          //sense the channel to check if it clear
            {
//                 if((!isFollower || !syn_sentbyme) && !imborderNode){
                    sim_time_t delay;
                    delay = sim_csma_rxtx_delay();
                    delay *= (sim_ticks_per_sec() / sim_csma_symbols_per_sec());
                    evt->time += delay;

//                  transmitting = TRUE;
                  call GainRadioModel.setPendingTransmission();
                  evt->handle = send_transmit_syn;

                  sim_queue_insert(evt);
                       dbg("TossimPacketModelC", "SYNPACKET: here6\n");
                  
                  
//                }
            }
            else{     
                 //if not, then backoff slightly
                                                 
                 if (synbackoffCount <= SYNBACKOFF_THRESH) {
                    sim_time_t backoff = sim_random();
                    sim_time_t modulo = sim_csma_high() - sim_csma_low();
                    modulo *= pow(sim_csma_exponent_base(), backoffCount);
                    backoff %= modulo;
		
                    backoff += sim_csma_init_low();
                    backoff *= (sim_ticks_per_sec() / sim_csma_symbols_per_sec());
                    evt->time += backoff;
                    sim_queue_insert(evt);
                    
                                        dbg("TossimPacketModelC", "SYNPACKET: here7\n");

                 }
                       
                else {
             
                  	#if defined(POWERTOSSIMZ)	
                         call Energy.send_busy(AM_BROADCAST_ADDR, sizeof(synpacket), EBUSY);            //this line was commented by original authors, ricardo 
                	#endif	
            	      dbg("TossimPacketModelC", "SYNPACKET: Syn sending failed due to busy channel\n");
                  

                }
            }
          }
  
  
  }
  
  void send_transmit_syn(sim_event_t* evt)
  {

        sim_time_t duration;

        tossim_metadata_t* metadata = getMetadata(&synpacket);

        syn->next_sleep_time = CYCLE_PERIOD - ((call cycleTimer.getNow()) - (call cycleTimer.gett0()));
        dbg("TossimPacketModelC", "PACKET: Next Sleep time: %hu\n",syn->next_sleep_time);
        duration = 8 * (sizeof(synpacket) + sim_packet_header_length());
        duration /= sim_csma_bits_per_symbol();
        duration += sim_csma_preamble_length();
        
        dbg("TossimPacketModelC", "SYNPACKET: here4\n");

        metadata->ack = 0;
        if (metadata->ack) {
          duration += sim_csma_ack_time();
        }
        duration *= (sim_ticks_per_sec() / sim_csma_symbols_per_sec());
        
        syn->next_sleep_time = syn->next_sleep_time - ((float)duration)/100000000;
        evt->time += duration;
        evt->handle = send_transmit_done_syn;


//    if((call SYNwaitTimer.isRunning())){
        dbg("TossimPacketModelC", "PACKET: Broadcasting syn synpacket to everyone. Duration:%llu ,time: %llu\n",duration,sim_time());
        dbg("TossimPacketModelC", "PACKET: Next WakeUp time: %hu\n",syn->next_sleep_time);

        transmitting = TRUE;

	    #if defined(POWERTOSSIMZ)	
	      call Energy.send_start(AM_BROADCAST_ADDR, sizeof(synpacket), metadata->strength); 
	    #endif	
	
        call GainRadioModel.putOnAirTo(AM_BROADCAST_ADDR, &synpacket, metadata->ack, evt->time, 0.0, 0.0);
        metadata->ack = 0;

        evt->time += (sim_csma_rxtx_delay() *  (sim_ticks_per_sec() / sim_csma_symbols_per_sec()));

        dbg("TossimPacketModelC", "PACKET: syn Send done at %llu.\n", evt->time);
	
	    #if defined(POWERTOSSIMZ)	
	      call Energy.send_done(AM_BROADCAST_ADDR, sizeof(synpacket), duration);
	    #endif
	
        sim_queue_insert(evt);                  //ab ye event kyun insert kiya hai??  
//     }
  }
  
  void send_transmit_done_syn(sim_event_t* evt) {
    transmitting = FALSE;
    syn = NULL;    

    syn_sentbyme = TRUE;
    dbg("TossimPacketModelC", "PACKET: Signaling SYN send done at %llu.\n", sim_time());
	#if defined(POWERTOSSIMZ)	
	  //call Energy.send_done(destNode, sendingLength, SUCCESS);            //this line was commented by original authors, ricardo 
	#endif	
  }
   
  
  
    event void SYNwaitTimer.fired() {    
      syn_done = TRUE;
      call Control.stop();
      d = node_depth;
      d = 10 - d ;

      if(node_depth<0)
      {
        return;
      }
      
      transmitting = FALSE;
      
                dbg("TossimPacketModelC", "TossimPacketModelC: SynwaitTimer fired, Synchronised to wakeup after %hu ms\n",CYCLE_PERIOD);
      dbg("TossimPacketModelC", "TossimPacketModelC: SynWaitTimer fired, node_depth = %hu, time = %llu\n", node_depth,sim_time());
      if( d > 0)
          call du_Timer.startOneShot(d*U_PERIOD);
      else
          call du_Timer.startOneShot(2);
          
      dbg("TossimPacketModelC", "TossimPacketModelC: du_Timer started at %llu, will fire after %hhu sec\n", sim_time(),d*U_PERIOD);
      dbg("TossimPacketModelC", "TossimPacketModelC: du_Timer started at %llu\n", sim_time());
    }
    
    event void du_Timer.fired() {
          dbg("TossimPacketModelC", "du_Timer fired, now can receive packets %llu\n",sim_time());
          call Control.start();
          data_received = FALSE;
          cancelSending_temp = FALSE;
          if(d > 0)          
              call RX_Timer.startOneShot(RX_PERIOD);
          else
              call RX_Timer.startOneShot(RX_PERIOD);
    }
   
    event void RX_Timer.fired() {
        dbg("TossimPacketModelC", "du_Timer fired, now can do transmission %llu\n",sim_time());              


        no_SendTry = 0;        
        if(sending != NULL || data_received == TRUE)
        {
            call TX_Timer.startOneShot(TX_PERIOD);
            send_data();
        }
        else{
            if(data_received == FALSE)
            {    call Control.stop();
                 goingto_permsleep();
            }     
            
        }   
        
        ack_received = FALSE;
    }    


  event void TX_Timer.fired() {       
        
        call du_Timer.startOneShot(3*U_PERIOD);    
  
  }
  
  void goingto_permsleep()
  {
  
        uint16_t next_wakeup_time = CYCLE_PERIOD - (call cycleTimer.getNow() - call cycleTimer.gett0());
        sim_time_t t = sim_time()+next_wakeup_time*10000000;
                dbg("TossimPacketModelC", "TossimPacketModelC: TX_timer fired at time = %llu.\n",sim_time());
        dbg("TossimPacketModelC", "TossimPacketModelC: Cycle timer will fire after %hu millisec at time = %llu.\n",next_wakeup_time,t);

       if(call SYNwaitTimer.isRunning())
            return;
            
       perm_sleeping = TRUE;
        if(!radio_locked){                  //if node is in communication, u cannot off radio
            dbg("TossimPacketModelC", "TossimPacketModelC: Going to Turn Radio OFF\n");
            call Control.stop();
//            syn_done = FALSE;
//            syn_sentbyme = FALSE;
        }
        else{
            dbg("TossimPacketModelC", "TossimPacketModelC: Want to Turn Radio OFF, but Radio locked\n");
        }
        
        isFollower = FALSE;
        noSYN_rec = 0;
        
        syn_sentbyme = FALSE;
        imborderNode = FALSE;
        alreadyTryingforSYNC = FALSE;
   }     
   
   
  task void startDoneTask() {                                                              

	#if defined(POWERTOSSIMZ)
	  if ( !sweepMe ){}
	#endif

	/*
	#if defined(SMAC)
        signal Control.startDone(SUCCESS);
    #endif
    */
  	#if defined(TMAC)
        signal Control.startDone(SUCCESS);
    #endif

  }

  task void stopDoneTask() {
    running = FALSE;
    
    #if defined(TMAC)
        signal Control.stopDone(SUCCESS);
    #endif
  }
  
  command error_t Control.start() {
    if (!initialized) {
      dbgerror("TossimPacketModelC", "TossimPacketModelC: Control.start() called before initialization!\n");
      return FAIL;
    }
    dbg("TossimPacketModelC", "TossimPacketModelC: Control.start() called!\n");
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
    dbg("TossimPacketModelC", "TossimPacketModelC: Control.stop() called.\n");
  
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
	
	#if defined(TMAC)
    	signal Packet.sendDone(msg, running? SUCCESS:EOFF);
    #endif

  }

  command error_t Packet.cancel(message_t* msg) {
    return FAIL;
  }


    tossim_metadata_t* metadata2;
    sim_time_t duration2;
    RTS_packet_t* rts=NULL;
    
    
    //when application layer does AMSend.Send, then msg is passed to this function of MAC layer.
  command error_t Packet.send(int dest, message_t* msg, uint8_t len) {              

    uint8_t dataLen;
    uint8_t *payload;
    uint8_t *payload2;

              dbg("TossimPacketModelC", "TossimPacketModelC: have to send a packet to node %d,\n",dest);


    if (!initialized) {
      dbgerror("TossimPacketModelC", "TossimPacketModelC: Send.send() called, but not initialized!\n");
      return EOFF;
    }
    
    
      dataLen = call ConPacket.payloadLength(msg);

    payload = (uint8_t*)call ConPacket.getPayload(msg, call ConPacket.maxPayloadLength());

    payload2 = (uint8_t*)malloc(16*sizeof(uint8_t));
    memcpy(payload2, payload, dataLen);
    
//    syn4 = (SYN_packet_t*)call ConPacket.getPayload(msg, 20);
//    dbg("TossimPacketModelC", "TossimPacketModelC: have to send a packet of type 0,\n");

    
    /*
    if (!running) {
      dbg("TossimPacketModelC", "TossimPacketModelC: Send.send() called, but not running!\n");
      
      return EOFF;
    }
    */
  /*  if (sending != NULL) {
	  #if defined(POWERTOSSIMZ)	  
  	    dbg("ENERGY_DEBUG", "Attempting to send a message while sending another one...\n");
	  #endif
	  return EBUSY;
    }
    */

    data_packet = (data_packet_t*)call ConPacket.getPayload(msg, sizeof(data_packet_t));
    data_packet->packet_type = 0;
    memcpy(data_packet->payload, payload2,dataLen);    
    sendingLength = len; 
    
    sending = msg;
    destNode = dest;
    backoffCount = 0;
    
    data_packet2 = (data_packet_t*)call ConPacket.getPayload(sending, sizeof(data_packet_t));
  
    if(destNode == AM_BROADCAST_ADDR){
        dbg("TossimPacketModelC", "TossimPacketModelC: have to Broadcast a packet of type %hu  to node %d.\n", data_packet->packet_type,destNode);
        if(!(call SYNwaitTimer.isRunning())){
  //       dbg("TossimPacketModelC", "TossimPacketModelC: syn_done true\n");
           send_data();        
           
        }
        else{
            sim_time_t syn_sending_time;
            uint16_t time_left = (SYNCHRO_PERIOD - (call SYNwaitTimer.getNow() - call SYNwaitTimer.gett0()));
            syn_sending_time = time_left*10000000;            //if radio is currently off, then send on next wake up. Right now, no info of next wake up time, so took it 0.
          
            dbg("TossimPacketModelC", "TossimPacketModelC: Its my synchronisation time, so postponing. time=%hu \n",time_left);
            backoff2 = sim_random();
            backoff2 %= (sim_csma_init_high() - sim_csma_init_low());
            backoff2 += sim_csma_init_low();
            backoff2 *= (sim_ticks_per_sec() / sim_csma_symbols_per_sec());
            //first_sample = sim_time() + backoff2-8000000;
             
            sendEvent.mote = sim_node();                                    //does sim_node stores dest node
            sendEvent.time = sim_time() + syn_sending_time;
            sendEvent.force = 0;
            sendEvent.cancelled = 0;
            sendEvent.handle = send_backoff;
            sendEvent.cleanup = sim_queue_cleanup_none;
            sim_queue_insert(&sendEvent);


        }
    }
    else{
/*        totalRTSCount = 0;
        noRTSCount = 0;    
        start_rts();
*/        
    }
    	
/*	#if defined(POWERTOSSIMZ)	  
	//  dbg("ENERGY_DEBUG", "ENERGY_DEBUG :: After CSMA time is %lld\n", sim_time()); 
	#endif	  
*/
    

    free(payload2);

    return SUCCESS;
  }
  
  

  
  void send_data() {
    sim_time_t first_sample;
   // The backoff is in terms of symbols. So take a random number
    // in the range of backoff times, and multiply it by the
    // sim_time per symbol.
    sim_time_t backoff = sim_random();
    backoff %= (sim_csma_init_high() - sim_csma_init_low());
    backoff += sim_csma_init_low();
    backoff *= (sim_ticks_per_sec() / sim_csma_symbols_per_sec());
    first_sample = sim_time() + backoff - 6000000;
//    first_sample = sim_time();

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
  
//    dbg("TossimPacketModelC", "PACKET: here2 time = %llu\n",sim_time());
    if(sending!=NULL)
    if (call GainRadioModel.clearChannel()) {

      sim_time_t delay;
//          dbg("TossimPacketModelC", "PACKET: here2\n");
      delay = sim_csma_rxtx_delay();
      delay *= (sim_ticks_per_sec() / sim_csma_symbols_per_sec());
      evt->time += delay;
      transmitting = TRUE;

      call GainRadioModel.setPendingTransmission();
      evt->handle = send_transmit;
      sim_queue_insert(evt);


    }
    else {

        if (backoffCount <= DATABACKOFF_THRESH) {

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
	      radio_locked = FALSE;
	      #if defined(POWERTOSSIMZ)	
	      call Energy.send_busy(destNode, sendingLength, EBUSY); 
	      #endif

	      signal Packet.sendDone(rval, EBUSY);

        }
    }
  }



  
  void send_transmit(sim_event_t* evt) {
    sim_time_t duration;

    tossim_metadata_t* metadata = getMetadata(sending);

    
    duration = 8 * (sendingLength + sim_packet_header_length());
    duration /= sim_csma_bits_per_symbol();
    duration += sim_csma_preamble_length();
//          dbg("TossimPacketModelC", "PACKET: here7\n");    
//    if(sending == NULL)
//          dbg("TossimPacketModelC", "PACKET: here7\n");    
     metadata->ack = 0;
    if (metadata->ack) {
//                  dbg("TossimPacketModelC", "PACKET: here9\n");
      duration += sim_csma_ack_time();
    }
//              dbg("TossimPacketModelC", "PACKET: here8\n");
    duration *= (sim_ticks_per_sec() / sim_csma_symbols_per_sec());
//    dbg("TossimPacketModelC", "PACKET: here5\n");
    evt->time += duration;
    evt->handle = send_transmit_done;

    dbg("TossimPacketModelC", "PACKET: Broadcasting data packet to Node:%d. time: %llu\n",destNode,sim_time());
    
    if(!(call TX_Timer.isRunning()))
    {
                    dbg("TossimPacketModelC", "TossimPacketModelC: In GainRadioModel.receive, TX_Timer not running, return.\n");
        return ;
    }
    
    
    if(cancelSending_temp == TRUE)
    {
        dbg("TossimPacketModelC", "TossimPacketModelC: channel acquired by another one return.\n");
        return ;
    }
    
    ack_received = FALSE;
	#if defined(POWERTOSSIMZ)	
	  call Energy.send_start(destNode, sendingLength, metadata->strength); 
	#endif	
	
    call GainRadioModel.putOnAirTo(destNode, sending, metadata->ack, evt->time, 0.0, 0.0);
    metadata->ack = 0;
    ack_received = FALSE;

    evt->time += (sim_csma_rxtx_delay() *  (sim_ticks_per_sec() / sim_csma_symbols_per_sec())) ;

    dbg("TossimPacketModelC", "PACKET: Send done at %llu.\n", evt->time);
	
	#if defined(POWERTOSSIMZ)	
	  call Energy.send_done(destNode, sendingLength, duration);
	#endif
	
    sim_queue_insert(evt);                  //ab ye event kyun insert kiya hai??
  
    
  }

  void send_transmit_done(sim_event_t* evt) {
  
    transmitting = FALSE;
    evt->time +=  ACK_WAIT_TIME*10000000;
    evt->handle = send_transmit_done_waitingAck;
    sim_queue_insert(evt);
  }
  
  void send_transmit_done_waitingAck(sim_event_t* evt) {

    message_t* rval = sending;
    tossim_metadata_t* metadata = getMetadata(sending);
    no_SendTry++;    
    transmitting = FALSE;
    dbg("TossimPacketModelC", "PACKET: Sending done at %llu.\n", sim_time());
    if(ack_received || destNode == AM_BROADCAST_ADDR){
          dbg("TossimPacketModelC", "PACKET: Received ack at %llu.\n", sim_time());
          signal Packet.sendDone(rval, running? SUCCESS:EOFF);


    }
    else{
        if(no_SendTry<2 && sending!=NULL)
        {
            dbg("TossimPacketModelC", "PACKET: Didnot Received ack, sending again at %llu.\n", sim_time());


            send_data();
            
        }
        else{
            dbg("TossimPacketModelC", "PACKET: Didnot Received ack twice, Signaling Failed at %llu.\n", sim_time());
            signal Packet.sendDone(rval, EBUSY);


        }
    }        

    if(ack_received || no_SendTry>=2 || destNode == AM_BROADCAST_ADDR)
    {
        sending = NULL;
//        free(data_packet->payload);
//        transmitting = FALSE;
        ack_received = FALSE;
        radio_locked = FALSE;
//        fullbufferMode = FALSE;
        dbg("TossimPacketModelC", "PACKET: Signaling send done at %llu.\n", sim_time());
        #if defined(POWERTOSSIMZ)	
        //call Energy.send_done(destNode, sendingLength, SUCCESS);            //this line was commented by original authors, ricardo 
        #endif	
    }

  }


////////////////////////////////////////////////////////////////////////
   void send_ack(sim_event_t* evt)
  {
  
      dbg("TossimPacketModelC", "PACKET: yahan1 Time =  %llu.\n", sim_time());
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
/*
                backoff2 = sim_random();
                backoff2 %= (sim_csma_init_high() - sim_csma_init_low());
                backoff2 += sim_csma_init_low();
                backoff2 *= (sim_ticks_per_sec() / sim_csma_symbols_per_sec());

                evt->time += backoff2;
                sim_queue_insert(evt);
*/                

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

    dbg("TossimPacketModelC", "PACKET: Broadcasting ACK time: %llu\n",sim_time());
    
    duration = 8 * (sizeof(ackpacket) + sim_packet_header_length());
    duration /= sim_csma_bits_per_symbol();
    duration += sim_csma_preamble_length();
    duration *= (sim_ticks_per_sec() / sim_csma_symbols_per_sec());

    evt->time += duration;
    evt->handle = send_transmit_done_ack;

    dbg("TossimPacketModelC", "PACKET: Broadcasting ACK time: %llu\n",sim_time());


	#if defined(POWERTOSSIMZ)	
//	  call Energy.send_start(AM_BROADCAST_ADDR, sizeof(ackpacket), metadata->strength); 
	#endif	
	
    call GainRadioModel.putOnAirTo(AM_BROADCAST_ADDR, &ackpacket, 0, evt->time, 0.0, 0.0);

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
////////////////////////////////////////////////////////////////////////////////////////////////////////////// 
 
  RTS_packet_t* syn3;
  SYN_packet_t* syn_rec;
  data_packet_t* data_rec;                
 
  
  bool borderNode_process(){

    //get next sleep time
    //find time left in active timer 
    //check if same.
    int16_t time_diff =(syn_rec->next_sleep_time) - (CYCLE_PERIOD - (call cycleTimer.getNow() - call cycleTimer.gett0()  )  ) ;
    globalvar_timediff = 0;
    dbg("TossimPacketModelC", "TossimPacketModelC: In borderNode_process,  time_diff: %d\n",time_diff);
    if( time_diff < -2  || time_diff > 2){
        //if not follow both schedule.
        dbg("TossimPacketModelC", "TossimPacketModelC: In borderNode_process, I'll follow both schedules. time: %llu\n",sim_time());
        imborderNode = TRUE;
        if(time_diff < -2)
        {

            CYCLE_PERIOD = syn_rec->next_sleep_time;
//            SLEEP_PERIOD = SLEEP_PERIOD - time_diff;
             if(CYCLE_PERIOD > ORIG_CYCLE_PERIOD)
                CYCLE_PERIOD = ORIG_CYCLE_PERIOD;
   
            call cycleTimer.startOneShot(CYCLE_PERIOD);
            dbg("TossimPacketModelC", "TossimPacketModelC: In borderNode_process, shifting back active period by %d ms. CYCLE_PERIOD = %hu, time: %llu\n",time_diff,CYCLE_PERIOD,sim_time());            
//            globalvar_timediff = -time_diff;
            
        }

        return imborderNode;
    }
    else{
        CYCLE_PERIOD = syn_rec->next_sleep_time;
        if(CYCLE_PERIOD > ORIG_CYCLE_PERIOD)
            CYCLE_PERIOD = ORIG_CYCLE_PERIOD;
   
        call cycleTimer.startOneShot(CYCLE_PERIOD);
        imborderNode = FALSE;
        return imborderNode;
    }
 }
 
  //whenever MAC layer receives a packet, this event is called.  
  event void GainRadioModel.receive(message_t* msg) {
  
    dbg("TossimPacketModelC", "TossimPacketModelC: In GainRadioModel.receive, Received some packet \n");        
    if (running && !transmitting) 
    {
        
       #if defined(POWERTOSSIMZ)	
         call Energy.recv_done(call AMPacket.destination(msg));
       #endif


        syn3 = (RTS_packet_t*)call ConPacket.getPayload(msg, 25);           //syn3 is any general packet
        dbg("TossimPacketModelC", "TossimPacketModelC: In GainRadioModel.receive, Received packet of type %hu\n",syn3->packet_type);        
        if(syn3==NULL)
        {
        
             dbg("TossimPacketModelC", "TossimPacketModelC: syn3 was null\n");
             return;
        }
                dbg("TossimPacketModelC", "TossimPacketModelC: In GainRadioModel.receive, Received packet of type %hu\n",syn3->packet_type);        
      
        if(syn3->packet_type == 1)          //got a SYNC packet
        {
    

            syn_rec = (SYN_packet_t*)call ConPacket.getPayload(msg, 25);
            dbg("TossimPacketModelC", "TossimPacketModelC: In GainRadioModel.receive, Received a SYN packet from node %hu, time: %llu\n",syn_rec->node_id,sim_time());
            if(syn_rec->node_id != sim_node())
            {
                
                noSYN_rec++;
                
                if(node_depth == -1)
                {
                    node_depth = syn_rec->node_depth + 1;
                    dbg("TossimPacketModelC", "TossimPacketModelC: In GainRadioModel.receive, going to send sync time: %llu\n",sim_time());
                    start_syn();
                }    
                else
                {
                    if(node_depth >= syn_rec->node_depth)
                    {
                        node_depth = syn_rec->node_depth + 1;
                        dbg("TossimPacketModelC", "TossimPacketModelC: In GainRadioModel.receive, going to send sync time: %llu\n",sim_time());
                        start_syn();
                    }
                }
                    
           
            }
        }    
        
        
    	else if(syn3->packet_type == 2)              //got a ACK packet
        {
    

            ack_rec = (ACK_packet_t*)call ConPacket.getPayload(msg, sizeof(ACK_packet_t));
            dbg("TossimPacketModelC", "TossimPacketModelC: In GainRadioModel.receive, Received an ACK from %hu for %hu  time:%llu\n",ack_rec->src_id,ack_rec->dest_id,sim_time());            

            if(ack_rec->dest_id == sim_node())          //if ACK destined to me, then send data now
            {
            
               ack_received = TRUE;
            }    
            else		//if ACK not destined to node
            {		
                dbg("TossimPacketModelC", "TossimPacketModelC: In GainRadioModel.receive, not for me\n");
                if(!radio_locked)
                {

                    if(sending!=NULL)         //by himanshu
                    {
                       dbg("TossimPacketModelC", "TossimPacketModelC: In GainRadioModel.receive, have pending data\n");
                        cancelSending_temp = TRUE;
                        call Control.stop();
                    }
                    else
                    {              
//                        dbg("TossimPacketModelC", "TossimPacketModelC: In GainRadioModel.receive, ACK for node %hu was received, Going to stop radio. \n",ack_rec->dest_id);
//                        call Control.stop();                                

                    }
                    

                }
            }
        }
        else if(syn3->packet_type == 0)              //got a data packet
        {
        



            uint8_t dataLen;
            void* payload;
            

            tossim_header_t* header =(tossim_header_t*)getHeaderdata(msg);
                          dbg("TossimPacketModelC", "TossimPacketModelC: In GainRadioModel.receive, received data packet\n");
            if(header->dest != sim_node()){
                dbg("TossimPacketModelC", "TossimPacketModelC: In GainRadioModel.receive, received packet for %hu, discarding it.\n",header->dest);
                return;
            }

                        dbg("TossimPacketModelC", "TossimPacketModelC: In GainRadioModel.receive, received data packet\n");
            if(!call RX_Timer.isRunning())
            {    
                dbg("TossimPacketModelC", "TossimPacketModelC: In GainRadioModel.receive, RX_Timer not running, return.\n");
                return;
            }    
            
            data_received = TRUE;
            data_rec = (data_packet_t*)call ConPacket.getPayload(msg, sizeof(data_packet_t));                
            

            waiting_fordata = FALSE;                
            buffer = (message_t*)malloc(sizeof(message_t));
            memcpy(buffer, msg, sizeof(message_t));

            dataLen = call ConPacket.payloadLength(msg);


            if(data_rec2->payload[1] != (data_rec->payload[1])){
                data_rec2->payload[1] = (data_rec->payload[1]);
            }
            else{
                dbg("TossimPacketModelC", "TossimPacketModelC: In GainRadioModel.receive, Duplicate packet return.\n");
                return;
            }        




            payload = call ConPacket.getPayload(buffer, call ConPacket.maxPayloadLength());
            

            dbg("TossimPacketModelC", "TossimPacketModelC: In GainRadioModel.receive, received data packet\n");
           

            dbg("TossimPacketModelC", "TossimPacketModelC: In GainRadioModel.receive, rec_counter = %hu \n",data_rec->payload[1]);
            memcpy(payload,data_rec->payload,dataLen);


            dbg("TossimPacketModelC", "TossimPacketModelC: In GainRadioModel.receive, received data packet\n");

//           if(data_rec->payload[1]==1 || (pre_counter)!= (rec_counter)){
//           if(data_rec->payload[1]==1 || data_rec2->payload[1] != (data_rec->payload[1])){
            radio_locked = FALSE;
            dbg("TossimPacketModelC", "TossimPacketModelC: In GainRadioModel.receive, Received a data packet , data_rec2->payload[1]=%hu\n",data_rec2->payload[1]);

//        	 (pre_counter)=(rec_counter);

          	signal Packet.receive(buffer);         //pass this packet to app layer
          	free(buffer);   	

            //send the ack.
              ackP = (ACK_packet_t*)call ConPacket.getPayload(&ackpacket, sizeof(ACK_packet_t));
              ackP->packet_type = 2;
              ackP->src_id = sim_node();
              ackP->dest_id = header->src;

              evt2.handle = send_ack;     
              evt2.time = sim_time();

              evt2.mote = sim_node();                                    //does sim_node stores dest node
              evt2.force = 0;
              evt2.cancelled = 0;
              evt2.cleanup = sim_queue_cleanup_none;
                      
              sim_queue_insert(&evt2);

              dbg("TossimPacketModelC", "PACKET: Radio clear, sending ACK Time =  %llu. event at time = %llu\n", sim_time(), evt2.time);
        	
            
        }     
    }
   syn3 = NULL;
   syn_rec = NULL;



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

