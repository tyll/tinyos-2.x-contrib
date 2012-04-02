/**
 *
 * This packet-level radio component implements a basic SMAC
 * algorithm. It derives its constants from sim_csma.c. and architecture from TossimPacketModel.nc
 * @author Philip Levis (author of TossimPacketModel.nc)
 * @date Dec 16 2005
 *
 * @author Himanshu Singh (original)
 *         -- Implementation of SMAC
 *
 */
#include <Timer.h>
#include <TossimRadioMsg.h>
#include <sim_csma.h>

#define ORIG_SLEEP_PERIOD 600
#define ORIG_ACTIVE_PERIOD 400
#define SYNCHRO_PERIOD 100
#define RTS_WAIT_TIME 30
#define CTS_WAIT_TIME 30
#define SYNBACKOFF_THRESH 20
#define NO_RTS_REQ 2
#define RTSBACKOFF_THRESH 20
#define DATABACKOFF_THRESH 20
#define CTSBACKOFF_THRESH 20
#define SYN_BACKOFF_FACTOR 10
#define MAX_CYCLES 2


module MAC_SMAC { 
  provides {
    interface Init;
    interface SplitControl as Control;
    interface PacketAcknowledgements;
    interface TossimPacketModel as Packet;
  }
  uses interface GainRadioModel; 
//  uses interface Timer<TMilli> as RadioTimer;
  uses interface Timer<TMilli> as gotrts_sleepTimer;
  uses interface Timer<TMilli> as RTSwaitTimer;
  uses interface Timer<TMilli> as CTSwaitTimer;
  uses interface Timer<TMilli> as SYNwaitTimer;
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
  uint8_t synbackoffCount;
  uint8_t rtsbackoffCount;
  uint8_t ctsbackoffCount;
  uint8_t noRTSCount;
  uint8_t totalRTSCount=0;
  uint8_t noSYN_rec=0;
  uint8_t no_SendTry=0;
  uint8_t neededFreeSamples;
  message_t* sending = NULL;
  bool transmitting = FALSE;
  uint8_t sendingLength = 0;
  int destNode;
  bool radio_locked = FALSE;
  bool syn_done = FALSE;
  bool syn_sentbyme = FALSE;
  bool radioOnbyTimer = TRUE;
  bool imborderNode = FALSE;
  bool alreadyTryingforSYNC = FALSE;
  bool waiting_fordata = FALSE;

  message_t receiveBuffer;
  
  uint16_t SLEEP_PERIOD=ORIG_SLEEP_PERIOD;       // in milliseconds
  uint16_t ACTIVE_PERIOD=ORIG_ACTIVE_PERIOD;      // in milliseconds

  
  
  SYN_packet_t* syn=NULL;        
  SYN_packet_t* syn4=NULL;  
  RTS_packet_t* rts;  
  CTS_packet_t* cts;
  data_packet_t* data_packet;
  data_packet_t* data_packet2;
   data_packet_t* data_rec2;                   
  
  uint8_t syn_table[4][3];
  bool isSynchroniser = FALSE;
  bool isFollower = FALSE;
  message_t synpacket;
  message_t rtspacket;
  message_t ctspacket;
  uint8_t i,j;

  sim_event_t sendEvent;
  sim_event_t SYNsendEvent;
  sim_event_t RTSsendEvent;
  sim_event_t CTSsendEvent;
  sim_time_t sample_time;       //sample_time
  sim_time_t backoff2;
  
  //Function declaration
  void send_data();
  void send_backoff(sim_event_t* evt);
  void send_transmit(sim_event_t* evt);
  void send_transmit_done(sim_event_t* evt);

  void start_syn();
  void send_syn(sim_event_t* evt);
  void send_transmit_syn(sim_event_t* evt);
  void send_transmit_done_syn(sim_event_t* evt);

  void start_rts();
  void send_rts(sim_event_t* evt);
  void send_transmit_rts(sim_event_t* evt);
  void send_transmit_done_rts(sim_event_t* evt);

  void send_cts(sim_event_t* evt);
  void send_transmit_cts(sim_event_t* evt);
  void send_transmit_done_cts(sim_event_t* evt);
  
  
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


  event void activeTimer.fired() {       
      dbg("TossimPacketModelC", "TossimPacketModelC: Active timer fired at time = %llu.\n",sim_time());
            
       
    if(call SYNwaitTimer.isRunning())
        return;
        
        if(!radio_locked){                  //if node is in communication, u cannot off radio
            dbg("TossimPacketModelC", "TossimPacketModelC: Going to Turn Radio OFF\n");
            call Control.stop();
//            syn_done = FALSE;
//            syn_sentbyme = FALSE;
        }
        else{
            dbg("TossimPacketModelC", "TossimPacketModelC: Want to Turn Radio OFF, but Radio locked\n");
        }
        
        call sleepTimer.startOneShot(SLEEP_PERIOD);
        isFollower = FALSE;
        noSYN_rec = 0;

        syn_sentbyme = FALSE;
        imborderNode = FALSE;
  
  }
                   
 

  event void sleepTimer.fired() {       

    dbg("TossimPacketModelC", "TossimPacketModelC: Sleep timer fired at time = %llu.\n",sim_time());
    dbg("TossimPacketModelC", "TossimPacketModelC: Going to turn Radio ON\n");
    call Control.start();
    radioOnbyTimer = TRUE;
    syn_done = FALSE;
    
    isFollower = FALSE;
    noSYN_rec = 0;
    syn_sentbyme = FALSE;
    imborderNode = FALSE;



    ACTIVE_PERIOD = ORIG_ACTIVE_PERIOD;
    SLEEP_PERIOD = ORIG_SLEEP_PERIOD;
    call SYNwaitTimer.startOneShot(SYNCHRO_PERIOD);
    dbg("TossimPacketModelC", "TossimPacketModelC: SYNwaitTimer started\n");
    call activeTimer.startOneShot(ACTIVE_PERIOD);          



    if(!isFollower && running){                //only synchroniser is allowed to send SYNC packet

  
       alreadyTryingforSYNC = TRUE;
       start_syn();               
    }
    
    
    if(sending!=NULL && totalRTSCount != 0)
    {
        start_rts();
    }

  }
  
  
  void start_syn()
  {
    if(!radio_locked){                   //if node is in communication, u cannot off radio and cannot send syn packet
   
    dbg("TossimPacketModelC", "SYNPACKET: here2\n");
        
        synbackoffCount = 0;    
        syn_table[sim_node()][0]=150;
        syn_table[sim_node()][1]=200;
        syn_table[sim_node()][2]=1;
        isSynchroniser = TRUE;

        syn = (SYN_packet_t*)call ConPacket.getPayload(&synpacket, 20);

        if (syn == NULL) {
        	return;
        }
               
        syn->packet_type = 1;        // 1 for syn, 2 for RTS, 3 for CTS, 0 for userdata
        syn->node_id = sim_node();
        
        /*for(i=0;i<4;i++){            //copy the synchronisation table, have to correct it.
            for(j=0;j<3;j++){
                 syn->mat[i][j] = syn_table[i][j];
            }     
        }
        */

        //some backoff before sending sync
                       
        // The backoff is in terms of symbols. So take a random number
        // in the range of backoff times, and multiply it by the
        // sim_time per symbol.
        backoff2 = sim_random();
        backoff2 %= (sim_csma_init_high() - sim_csma_init_low());
        backoff2 += sim_csma_init_low();
        backoff2 *= (sim_ticks_per_sec() / sim_csma_symbols_per_sec());
        dbg("TossimPacketModelC", "TossimPacketModelC: Backoff value: %llu\n",backoff2);
        sample_time = sim_time() + backoff2*10-6000000;
//        sample_time = sim_time() + backoff2*2;
        
        SYNsendEvent.mote = sim_node();                 //sim_node() returns my node_id
        SYNsendEvent.time = sample_time;
        SYNsendEvent.force = 0;
        SYNsendEvent.cancelled = 0;
        SYNsendEvent.handle = send_syn;                 //handling function
        SYNsendEvent.cleanup = sim_queue_cleanup_none;
        sim_queue_insert(&SYNsendEvent);                 // cooment this line if you donnot want to send sync packet
        //send SYN
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
            if(call GainRadioModel.clearChannel())          //sense the channel to check if it clear
            {
                 if((!isFollower || !syn_sentbyme) && !imborderNode){
                    sim_time_t delay;
                    delay = sim_csma_rxtx_delay();
                    delay *= (sim_ticks_per_sec() / sim_csma_symbols_per_sec());
                    evt->time += delay;

//                  transmitting = TRUE;
                  call GainRadioModel.setPendingTransmission();
                  evt->handle = send_transmit_syn;

                  sim_queue_insert(evt);
                        dbg("TossimPacketModelC", "SYNPACKET: here3\n");
                  
                  
                }
            }
            else{     
                 //if not, then backoff slightly
                                                 
                 if (synbackoffCount <= SYNBACKOFF_THRESH) {
                    backoff2 = sim_random();
                    backoff2 %= (sim_csma_init_high() - sim_csma_init_low());
                    backoff2 += sim_csma_init_low();
                    backoff2 *= (sim_ticks_per_sec() / sim_csma_symbols_per_sec());

                    evt->time += backoff2*1000;
                    sim_queue_insert(evt);
                 }
                       
                else {
                  dbg("TossimPacketModelC", "PACKET: Failed to send SYN no %hu packet due to busy channel.\n",totalRTSCount);
                  	#if defined(POWERTOSSIMZ)	
                         call Energy.send_busy(AM_BROADCAST_ADDR, sizeof(synpacket), EBUSY);            //this line was commented by original authors, ricardo 
                	#endif	
                  

                }
            }
          }
  
  
  }
  
  void send_transmit_syn(sim_event_t* evt)
  {
    if(!syn_sentbyme){
        sim_time_t duration;

        tossim_metadata_t* metadata = getMetadata(&synpacket);

        syn->next_sleep_time = ACTIVE_PERIOD - ((call activeTimer.getNow()) - (call activeTimer.gett0()));
        dbg("TossimPacketModelC", "PACKET: Next Sleep time: %hu\n",syn->next_sleep_time);
        duration = 8 * (sizeof(synpacket) + sim_packet_header_length());
        duration /= sim_csma_bits_per_symbol();
        duration += sim_csma_preamble_length();

        transmitting = TRUE;
        metadata->ack = 0;
        if (metadata->ack) {
          duration += sim_csma_ack_time();
        }
        duration *= (sim_ticks_per_sec() / sim_csma_symbols_per_sec());
        
        syn->next_sleep_time = syn->next_sleep_time - ((float)duration)/100000000;
        syn->sleep_period = SLEEP_PERIOD;
        evt->time += duration;
        evt->handle = send_transmit_done_syn;

        if(!syn_sentbyme && imborderNode == FALSE && (call SYNwaitTimer.isRunning())){
            dbg("TossimPacketModelC", "PACKET: Broadcasting syn synpacket to everyone. Duration:%llu ,time: %llu\n",duration,sim_time());
            dbg("TossimPacketModelC", "PACKET: Next Sleep time: %hu\n",syn->next_sleep_time);


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
         }
      }
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
   
    event void gotrts_sleepTimer.fired() {         //timer should fire when communication between two other nodes is over

      if(call sleepTimer.isRunning())
      {
        dbg("TossimPacketModelC", "In gotrts_sleepTimer fired, Its My sleeping time, going to sleep time %llu\n",sim_time());
        call Control.stop();
      }
      else{
          dbg("TossimPacketModelC", "gotrts_sleepTimer fired, now waking up at time %llu\n",sim_time());                  
          call Control.start();
          if(sending!=NULL)
          {
              dbg("TossimPacketModelC", "In gotrts_sleepTimer fired, have a pending transmision, sending RTS %llu\n",sim_time());
              start_rts();
          }

      }
    
    }
  
  
    event void SYNwaitTimer.fired() {    
      dbg("TossimPacketModelC", "SYNwaitTimer fired, now can do transmission %llu\n",sim_time());
      syn_done = TRUE;
    }
    
    
    event void CTSwaitTimer.fired() {  
      radio_locked = FALSE;  
      dbg("TossimPacketModelC", "CTSwaitTimer fired, giving up waiting for data %llu\n",sim_time());
      waiting_fordata = FALSE;
    }
    event void RTSwaitTimer.fired() {    
      dbg("TossimPacketModelC", "RTSwaitTimer fired, Packet has been dropped. noRTSCount=%hu Time = %llu\n",noRTSCount,sim_time());

      if(sending!=NULL)
      {
        if(totalRTSCount == MAX_CYCLES*(NO_RTS_REQ+1))
        {
            totalRTSCount = 0;   
            #if defined(POWERTOSSIMZ)	
                call Energy.send_busy(AM_BROADCAST_ADDR, sendingLength, EBUSY); 
            #endif

            signal Packet.sendDone(sending, EBUSY);
            dbg("TossimPacketModelC", "In RTSwaitTimer fired. Making sending NULL Time = %llu\n",sim_time());
            
            sending = NULL;
    //        free(data_packet->payload);
            radio_locked = FALSE;
            dbg("TossimPacketModelC", "In RTSwaitTimer fired. Making sending NULL Time = %llu\n",sim_time());
            return;
        }
        if(noRTSCount>NO_RTS_REQ)
        {
           radio_locked = FALSE;
           noRTSCount = 0;
        }
        
       else{   

        dbg("TossimPacketModelC", "RTSwaitTimer fired, retransmitting the RTS. noRTSCount=%hu Time = %llu\n",noRTSCount,sim_time());
      //make an event for rts
        backoff2 = sim_random();
        backoff2 %= (sim_csma_init_high() - sim_csma_init_low());
        backoff2 += sim_csma_init_low();
        backoff2 *= (sim_ticks_per_sec() / sim_csma_symbols_per_sec());
        sample_time = sim_time() + backoff2-8000000;


        RTSsendEvent.mote = sim_node();                                    //does sim_node stores dest node
        RTSsendEvent.time = sample_time;
        RTSsendEvent.force = 0;
        RTSsendEvent.cancelled = 0;
        RTSsendEvent.handle = send_rts;
        RTSsendEvent.cleanup = sim_queue_cleanup_none;
        sim_queue_insert(&RTSsendEvent);

        dbg("TossimPacketModelC", "RTSwaitTimer fired, retransmitting the RTS. noRTSCount=%hu Time = %llu\n",noRTSCount,sim_time());
//      signal Packet.sendDone(sending, ECANCEL);
    //  radio_locked = FALSE;
       }
      }
    }


  task void startDoneTask() {                                                              
/*
	#if defined(POWERTOSSIMZ)
	  if ( !sweepMe )
	#endif
	*/
	#if defined(SMAC)
        signal Control.startDone(SUCCESS);
    #endif
  }

  task void stopDoneTask() {
    running = FALSE;
    
    #if defined(SMAC)
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
	
	#if defined(SMAC)
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

    if (!initialized) {
      dbgerror("TossimPacketModelC", "TossimPacketModelC: Send.send() called, but not initialized!\n");
      return EOFF;
    }
    dataLen = call ConPacket.payloadLength(msg);

    payload = (uint8_t*)call ConPacket.getPayload(msg, call ConPacket.maxPayloadLength());

    payload2 = (uint8_t*)malloc(16*sizeof(uint8_t));
    memcpy(payload2, payload, dataLen);
    dbg("TossimPacketModelC", "TossimPacketModelC: have to send a packet of type 0,\n");

    
    /*
    if (!running) {
      dbg("TossimPacketModelC", "TossimPacketModelC: Send.send() called, but not running!\n");
      
      return EOFF;
    }
    */
    if (sending != NULL) {
	  #if defined(POWERTOSSIMZ)	  
  	    dbg("ENERGY_DEBUG", "Attempting to send a message while sending another one...\n");
	  #endif
	  return EBUSY;
    }
  

    data_packet = (data_packet_t*)call ConPacket.getPayload(msg, sizeof(data_packet_t));
    data_packet->packet_type = 0;
    memcpy(data_packet->payload, payload2,dataLen);    
    sendingLength = len; 
    
    sending = msg;
    destNode = dest;
    backoffCount = 0;
  
    data_packet2 = (data_packet_t*)call ConPacket.getPayload(sending, sizeof(data_packet_t));
    dbg("TossimPacketModelC", "TossimPacketModelC: sending says type = %hu, payload = %hu to destNode=%d\n",data_packet2->packet_type,data_packet2->payload[1],destNode);
    
    data_packet2->packet_type = 0;
    
//    free(data_packet->payload);
    
    if(destNode == AM_BROADCAST_ADDR){
        dbg("TossimPacketModelC", "TossimPacketModelC: have to Broadcast a packet of type %hu  to node %d.\n", data_packet->packet_type,destNode);
  //      if(!(call SYNwaitTimer.isRunning())){
         dbg("TossimPacketModelC", "TossimPacketModelC: syn_done true\n");
           send_data();        
           
    /*    }
        else{
            sim_time_t syn_sending_time;
            uint16_t time_left = (SYNCHRO_PERIOD - (call SYNwaitTimer.getNow() - call SYNwaitTimer.gett0()));
            syn_sending_time = time_left*10000000;            //if radio is currently off, then send on next wake up. Right now, no info of next wake up time, so took it 0.
          
            dbg("TossimPacketModelC", "TossimPacketModelC: syn_done true time=%hu \n",time_left);
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


        }*/
    }
    else{
        totalRTSCount = 0;
        noRTSCount = 0;    
        start_rts();
    }
    	
/*	#if defined(POWERTOSSIMZ)	  
	//  dbg("ENERGY_DEBUG", "ENERGY_DEBUG :: After CSMA time is %lld\n", sim_time()); 
	#endif	  
*/
    

    free(payload2);

    return SUCCESS;
  }
  
  void start_rts()
  {
        backoffCount = 0;
        rtsbackoffCount = 0;
        ctsbackoffCount = 0;

        noRTSCount = 0;    
        

        //now first send RTS

    //    radio_locked = TRUE;

        metadata2 = getMetadata(sending);

        duration2 = 8 * (sendingLength + sim_packet_header_length());
        duration2 /= sim_csma_bits_per_symbol();
        duration2 += sim_csma_preamble_length();

        metadata2->ack = 1;        
        if (metadata2->ack) {
          duration2 += sim_csma_ack_time();
        }
        duration2 *= (sim_ticks_per_sec() / sim_csma_symbols_per_sec());
        
        //make rts packet
        rts = (RTS_packet_t*)call ConPacket.getPayload(&rtspacket, 20);
        rts->packet_type = 2;       //2 for rts
        rts->src_id = sim_node();
        rts->dest_id = destNode;
        rts->duration = duration2;
      
      //make an event for rts
        backoff2 = sim_random();
        backoff2 %= (sim_csma_init_high() - sim_csma_init_low());
        backoff2 += sim_csma_init_low();
        backoff2 *= (sim_ticks_per_sec() / sim_csma_symbols_per_sec());
        sample_time = sim_time() + backoff2-8000000;


        RTSsendEvent.mote = sim_node();                                    //does sim_node stores dest node
        RTSsendEvent.time = sample_time;
        RTSsendEvent.force = 0;
        RTSsendEvent.cancelled = 0;
        RTSsendEvent.handle = send_rts;
        RTSsendEvent.cleanup = sim_queue_cleanup_none;
        sim_queue_insert(&RTSsendEvent);

  
  }

  
   
  void send_rts(sim_event_t* evt)
  {
      
      if(syn_done)
      {
//          dbg("TossimPacketModelC", "syn sent = \n");
            dbg("TossimPacketModelC", "Trying to send RTS. noRTSCount=%hu Time = %llu\n",noRTSCount,sim_time());
          if(running)
          { rtsbackoffCount++;
            dbg("TossimPacketModelC", "Trying to send RTS. noRTSCount=%hu Time = %llu\n",noRTSCount,sim_time());
            if(call GainRadioModel.clearChannel())          //sense the channel to check if it clear
            {
                    sim_time_t delay;
                    delay = sim_csma_rxtx_delay();
                    delay *= (sim_ticks_per_sec() / sim_csma_symbols_per_sec());
                    evt->time += delay;

                  transmitting = TRUE;
                  call GainRadioModel.setPendingTransmission();
                  evt->handle = send_transmit_rts;
//                  evt->time = sim_time();
                  sim_queue_insert(evt);
            }
            else{     
                 //if not, then backoff slightly
                                                 
                 if (rtsbackoffCount <= RTSBACKOFF_THRESH) {
                    backoff2 = sim_random();
                    backoff2 %= (sim_csma_init_high() - sim_csma_init_low());
                    backoff2 += sim_csma_init_low();
                    backoff2 *= (sim_ticks_per_sec() / sim_csma_symbols_per_sec());

                    evt->time += backoff2;
                    sim_queue_insert(evt);
                 }
                       
                else {
                
                   if(sending!=NULL){
                      message_t* rval = sending;
                      sending = NULL;
                      dbg("TossimPacketModelC", "PACKET: Failed to send RTS no %hu packet due to busy channel.\n",totalRTSCount);
	                  radio_locked = FALSE;
	                  #if defined(POWERTOSSIMZ)	
	                  call Energy.send_busy(AM_BROADCAST_ADDR, sizeof(rtspacket), EBUSY); 
	                  #endif

	                  signal Packet.sendDone(rval, EBUSY);
	              }
                }
            }
          }
          else{
//                  sim_time_t next_wakeup_time=0;
                if(!call activeTimer.isRunning()){

/*                    
                    next_wakeup_time = (SLEEP_PERIOD - (call sleepTimer.getNow() - call sleepTimer.gett0()))*100000000;           //if radio is currently off, then send on next wake up. Right now, no info of next wake up time, so took it 0.

                    backoff2 = sim_random();
                    backoff2 %= (sim_csma_init_high() - sim_csma_init_low());
                    backoff2 += sim_csma_init_low();
                    backoff2 *= (sim_ticks_per_sec() / sim_csma_symbols_per_sec());
                  

                  evt->time += backoff2 + next_wakeup_time;
          
                  sim_queue_insert(evt);

                  dbg("TossimPacketModelC", "Postponed RTS to next wakeUp Time event will fire at time = %llu. Current Time = %llu\n",evt->time,sim_time());
*/


                  uint16_t next_wakeup_time = SLEEP_PERIOD - (call sleepTimer.getNow() - call sleepTimer.gett0());           //if radio is currently off, then send on next wake up. Right now, no info of next wake up time, so took it 0.
                  sim_time_t temp = next_wakeup_time;              
                  if(temp > SLEEP_PERIOD)
                    temp = SLEEP_PERIOD;    

                    dbg("TossimPacketModelC", "In send_rts(), radio sleeping.\n",totalRTSCount);
                    backoff2 = sim_random();
                    backoff2 %= (sim_csma_init_high() - sim_csma_init_low());
                    backoff2 += sim_csma_init_low();
                    backoff2 *= (sim_ticks_per_sec() / sim_csma_symbols_per_sec());


                  evt->time = sim_time() + backoff2 + temp*10000000;
                  sim_queue_insert(evt);
                    dbg("TossimPacketModelC", "Postponed RTS to next wakeUp Time event will fire at time = %llu. temp = %llu Current Time = %llu\n",evt->time,temp,sim_time());
                  
                }

          }
       }
       else{
/*          
            uint8_t time_left = SYNCHRO_PERIOD - (call SYNwaitTimer.getNow() - call SYNwaitTimer.gett0());
            sim_time_t syn_sending_time = time_left*100000000;            //if radio is currently off, then send on next wake up. Right now, no info of next wake up time, so took it 0.
          
            backoff2 = sim_random();
            backoff2 %= (sim_csma_init_high() - sim_csma_init_low());
            backoff2 += sim_csma_init_low();
            backoff2 *= (sim_ticks_per_sec() / sim_csma_symbols_per_sec());

            dbg("TossimPacketModelC", "Postponing RTS to after Synchro period. Time = %llu\n",sim_time());
          evt->time = sim_time()+backoff2 + syn_sending_time;
          sim_queue_insert(evt);
          dbg("TossimPacketModelC", "Postponing RTS to after Synchro period. time_left = %hu, syn_sending_time=%llu Time = %llu\n",time_left, syn_sending_time,sim_time());
          
*/


            uint16_t time_left = SYNCHRO_PERIOD - (call SYNwaitTimer.getNow() - call SYNwaitTimer.gett0());
            sim_time_t syn_sending_time = time_left;            //if radio is currently off, then send on next wake up. Right now, no info of next wake up time, so took it 0.
            if( syn_sending_time > SYNCHRO_PERIOD)
                syn_sending_time = SYNCHRO_PERIOD;

                              dbg("TossimPacketModelC", "Postponing RTS to after Synchro period. time_left = %hu, syn_sending_time=%llu Time = %llu\n",time_left, syn_sending_time,sim_time());
            backoff2 = sim_random();
            backoff2 %= (sim_csma_init_high() - sim_csma_init_low());
            backoff2 += sim_csma_init_low();
            backoff2 *= (sim_ticks_per_sec() / sim_csma_symbols_per_sec());


            evt->time = sim_time()+ backoff2 + syn_sending_time*10000000;
            dbg("TossimPacketModelC", "RTS will be sent at Time = %llu\n",evt->time);
            sim_queue_insert(evt);          
       }  
        
  }

  void send_transmit_rts(sim_event_t* evt)
  {

    sim_time_t duration;

    tossim_metadata_t* metadata = getMetadata(&rtspacket);
               dbg("TossimPacketModelC", "Trying to send RTS, in send_transmit_rts. noRTSCount=%hu Time = %llu\n",noRTSCount,sim_time());

    duration = 8 * (sizeof(rtspacket) + sim_packet_header_length());
    duration /= sim_csma_bits_per_symbol();
    duration += sim_csma_preamble_length();
    
    metadata->ack = 0;
    if (metadata->ack) {
      duration += sim_csma_ack_time();
    }
    duration *= (sim_ticks_per_sec() / sim_csma_symbols_per_sec());

    evt->time += duration;
    evt->handle = send_transmit_done_rts;

    dbg("TossimPacketModelC", "PACKET: Broadcasting rts rtspacket no %hu to everyone. time: %llu\n",totalRTSCount,sim_time());


	#if defined(POWERTOSSIMZ)	
	  call Energy.send_start(AM_BROADCAST_ADDR, sizeof(rtspacket), metadata->strength); 
	#endif	
	
    call GainRadioModel.putOnAirTo(AM_BROADCAST_ADDR, &rtspacket, metadata->ack, evt->time, 0.0, 0.0);
        dbg("TossimPacketModelC", "PACKET: Broadcasting rts rtspacket no %hu to everyone. time: %llu\n",totalRTSCount,sim_time());
    metadata->ack = 0;

    evt->time += (sim_csma_rxtx_delay() *  (sim_ticks_per_sec() / sim_csma_symbols_per_sec()));

    dbg("TossimPacketModelC", "PACKET: RTS no %hu Send done at %llu.\n", totalRTSCount, evt->time);
	
	#if defined(POWERTOSSIMZ)	
	  call Energy.send_done(AM_BROADCAST_ADDR, sizeof(rtspacket), duration);
	#endif
	
    sim_queue_insert(evt);                  //ab ye event kyun insert kiya hai??  
  }
  
  
  void send_transmit_done_rts(sim_event_t* evt) {
//    rts=NULL;
    if(sending != NULL){
        noRTSCount++;
        totalRTSCount++;
        transmitting = FALSE;
        radio_locked = TRUE;                    // i have sent a RTS and nobody can make me sleep now
        dbg("TossimPacketModelC", "PACKET: Signaling RTS no %hu send done at %llu.\n", totalRTSCount,sim_time());
        if(noRTSCount <= NO_RTS_REQ + 1)
            call RTSwaitTimer.startOneShot(RTS_WAIT_TIME);

	    #if defined(POWERTOSSIMZ)	
	      //call Energy.send_done(destNode, sendingLength, SUCCESS);            //this line was commented by original authors, ricardo 
	    #endif	
	}
  }
  
  
  
  void send_cts(sim_event_t* evt)
  {
  
//      dbg("TossimPacketModelC", "PACKET: yahan1 Time =  %llu.\n", sim_time());
      if(running)
      { ctsbackoffCount++;
  //          dbg("TossimPacketModelC", "PACKET: yahan2 Time =  %llu.\n", sim_time());
        if(call GainRadioModel.clearChannel())
        {
          sim_time_t delay;
//              dbg("TossimPacketModelC", "PACKET: Radio clear, sending CTS Time =  %llu.\n", sim_time());
              transmitting = TRUE;
              call GainRadioModel.setPendingTransmission();
              evt->handle = send_transmit_cts;     
              delay = sim_csma_rxtx_delay();
              delay *= (sim_ticks_per_sec() / sim_csma_symbols_per_sec());
              evt->time += delay;

              sim_queue_insert(evt);
        }
        else{

             if (ctsbackoffCount <= CTSBACKOFF_THRESH) {

                backoff2 = sim_random();
                backoff2 %= (sim_csma_init_high() - sim_csma_init_low());
                backoff2 += sim_csma_init_low();
                backoff2 *= (sim_ticks_per_sec() / sim_csma_symbols_per_sec());

                evt->time += backoff2;
                sim_queue_insert(evt);
             }
                   
            else {

              dbg("TossimPacketModelC", "PACKET: Failed to send CTS packet due to busy channel.\n");
	          radio_locked = FALSE;
	          #if defined(POWERTOSSIMZ)	
	             call Energy.send_busy(AM_BROADCAST_ADDR, sizeof(ctspacket), EBUSY); 
	          #endif


            }
            
        }
      }
      else{
          dbg("TossimPacketModelC", "PACKET: Radio sleeping while sending CTS, so backing off. Time =  %llu.\n", sim_time());
      }
        
  }
  
  
  void send_transmit_cts(sim_event_t* evt)
  {
    sim_time_t duration;

    tossim_metadata_t* metadata = getMetadata(&ctspacket);

    duration = 8 * (sizeof(ctspacket) + sim_packet_header_length());
    duration /= sim_csma_bits_per_symbol();
    duration += sim_csma_preamble_length();
    duration *= (sim_ticks_per_sec() / sim_csma_symbols_per_sec());

    evt->time += duration;
    evt->handle = send_transmit_done_cts;

    dbg("TossimPacketModelC", "PACKET: Broadcasting CTS packet to everyone. time: %llu\n",sim_time());


	#if defined(POWERTOSSIMZ)	
	  call Energy.send_start(AM_BROADCAST_ADDR, sizeof(ctspacket), metadata->strength); 
	#endif	
	
    call GainRadioModel.putOnAirTo(AM_BROADCAST_ADDR, &ctspacket, metadata->ack, evt->time, 0.0, 0.0);
    metadata->ack = 0;

    evt->time += (sim_csma_rxtx_delay() *  (sim_ticks_per_sec() / sim_csma_symbols_per_sec()));

    dbg("TossimPacketModelC", "PACKET: CTS Send done at %llu.\n", evt->time);
	
	#if defined(POWERTOSSIMZ)	
	  call Energy.send_done(AM_BROADCAST_ADDR, sizeof(ctspacket), duration);
	#endif
	
    sim_queue_insert(evt);                  //ab ye event kyun insert kiya hai??  
  
  }
  
  void send_transmit_done_cts(sim_event_t* evt) {
    cts=NULL;
    transmitting = FALSE;

    waiting_fordata = TRUE;
    dbg("TossimPacketModelC", "PACKET: Signaling CTS send done at %llu.\n", sim_time());
	#if defined(POWERTOSSIMZ)	
	  //call Energy.send_done(destNode, sendingLength, SUCCESS);            //this line was commented by original authors, ricardo 
	#endif	
		
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
//    first_sample = sim_time() + backoff-8000000;
    first_sample = sim_time();

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
  

    if(sending!=NULL)
    if (call GainRadioModel.clearChannel()) {

      sim_time_t delay;

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
                backoff2 = sim_random();
                backoff2 %= (sim_csma_init_high() - sim_csma_init_low());
                backoff2 += sim_csma_init_low();
                backoff2 *= (sim_ticks_per_sec() / sim_csma_symbols_per_sec());

            evt->time += backoff2;
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
     metadata->ack = 1;
    if (metadata->ack) {

      duration += sim_csma_ack_time();
    }

    duration *= (sim_ticks_per_sec() / sim_csma_symbols_per_sec());

    evt->time += duration;
    evt->handle = send_transmit_done;

    dbg("TossimPacketModelC", "PACKET: Broadcasting packet to everyone. time: %llu\n",sim_time());


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
            send_data();
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
        radio_locked = FALSE;
        dbg("TossimPacketModelC", "PACKET: Signaling send done at %llu.\n", sim_time());
        #if defined(POWERTOSSIMZ)	
        //call Energy.send_done(destNode, sendingLength, SUCCESS);            //this line was commented by original authors, ricardo 
        #endif	
      
        if(call sleepTimer.isRunning())
        {
            dbg("TossimPacketModelC", "In send_transmit_done, Its My sleeping time, going to sleep time %llu\n",sim_time());
            call Control.stop();
        }
    }

  }
 
 
  RTS_packet_t* syn3;
  SYN_packet_t* syn_rec;
  RTS_packet_t* rts_rec;
  CTS_packet_t* cts_rec;
  data_packet_t* data_rec;                
 
  
  bool borderNode_process(){

    //get next sleep time
    //find time left in active timer 
    //check if same.
    int16_t time_diff =(syn_rec->next_sleep_time) - (ACTIVE_PERIOD - (call activeTimer.getNow() - call activeTimer.gett0()  )  ) ;
    dbg("TossimPacketModelC", "TossimPacketModelC: In borderNode_process,  time_diff: %d\n",time_diff);
    if( time_diff < -4  || time_diff > 4){
        //if not follow both schedule.
        dbg("TossimPacketModelC", "TossimPacketModelC: In borderNode_process, I'll follow both schedules. time: %llu\n",sim_time());
        imborderNode = TRUE;
        if(time_diff > 4)
        {

            ACTIVE_PERIOD = syn_rec->next_sleep_time;
            
            SLEEP_PERIOD = SLEEP_PERIOD - time_diff;
            call activeTimer.startOneShot(ACTIVE_PERIOD);
            
            dbg("TossimPacketModelC", "TossimPacketModelC: In borderNode_process, extending active period and shortening sleep period. \nACTIVE PERIOD = %hu, SLEEP_PERIOD = %hu time: %llu\n",ACTIVE_PERIOD,SLEEP_PERIOD,sim_time());
            
        }
        else{

            if((SLEEP_PERIOD - (syn_rec->sleep_period + time_diff)) > 0)
            {
                 SLEEP_PERIOD = SLEEP_PERIOD + time_diff;        // note that time_diff is negative here, thats why +
                 dbg("TossimPacketModelC", "TossimPacketModelC: In borderNode_process, shortening sleep period. \nACTIVE PERIOD = %hu, SLEEP_PERIOD = %hu time: %llu\n",ACTIVE_PERIOD,SLEEP_PERIOD,sim_time());
            }    
            else
            {
                dbg("TossimPacketModelC", "TossimPacketModelC: In borderNode_process, no need to shorten sleep period. \nACTIVE PERIOD = %hu, SLEEP_PERIOD = %hu time: %llu\n",ACTIVE_PERIOD,SLEEP_PERIOD,sim_time());            
            }
        }    

        return imborderNode;
    }
    else{
        ACTIVE_PERIOD = syn_rec->next_sleep_time;
        call activeTimer.startOneShot(ACTIVE_PERIOD);
        imborderNode = FALSE;
        return imborderNode;
    }
 }
 
  //whenever MAC layer receives a packet, this event is called.  
  event void GainRadioModel.receive(message_t* msg) {

    if (running && !transmitting) {
        
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
        
      
        if(syn3->packet_type == 1)          //got a SYNC packet
        {
    
            syn_rec = (SYN_packet_t*)call ConPacket.getPayload(msg, 25);
            dbg("TossimPacketModelC", "TossimPacketModelC: In GainRadioModel.receive, Received a SYN packet from node %hu, time: %llu\n",syn_rec->node_id,sim_time());
            if(syn_rec->node_id != sim_node()){
                
                noSYN_rec++;
                if(syn_sentbyme){

                    imborderNode = borderNode_process();
                           
                }
                else{
                    isFollower = TRUE;
                    dbg("TossimPacketModelC", "TossimPacketModelC: In GainRadioModel.receive, following schedule, started active timer %hu\n",syn_rec->next_sleep_time);
                    if(alreadyTryingforSYNC){
                        
                        //check if diff schedules
                            // if yes, become border Node
                        if(noSYN_rec >= 2){
                            imborderNode = borderNode_process();
                        }
                        else{
                     
                            ACTIVE_PERIOD = syn_rec->next_sleep_time;
                            call activeTimer.startOneShot(ACTIVE_PERIOD);
                        }
                        
                        
                    }
                    else{
                         if(noSYN_rec >=2){
                             imborderNode = borderNode_process();
                             if(imborderNode == FALSE){
                                //rebroadcast
                                dbg("TossimPacketModelC", "TossimPacketModelC: After receiving SYNC, rebroadcasting. time: %llu\n",sim_time());
                                start_syn();
        //                        syn_sentbyme = TRUE;
                            }
                        }
                        else{
                            ACTIVE_PERIOD = syn_rec->next_sleep_time;
                            call activeTimer.startOneShot(ACTIVE_PERIOD);
                        }    
                   }     
                }
                
            }
        }
        else if(syn3->packet_type == 2)          //got a RTS packet
        {
            
            rts_rec = (RTS_packet_t*)call ConPacket.getPayload(msg, 25);
            if(rts_rec == NULL)
            {
                dbg("TossimPacketModelC", "TossimPacketModelC: In GainRadioModel.receive, rts_rec is NULL\n");
            }
            dbg("TossimPacketModelC", "TossimPacketModelC: In GainRadioModel.receive, Received a RTS packet of type %hu from: %hu for: %hu  time: %llu\n",rts_rec->packet_type,rts_rec->src_id,rts_rec->dest_id,sim_time());

            if(rts_rec->dest_id == sim_node())         //if RTS is destined to me, then send CTS
            {
                if(!waiting_fordata && !(call gotrts_sleepTimer.isRunning()))
                {
                    radio_locked = TRUE;                    //i got a RTS, nobody can make me sleep now
                             
                    cts = (CTS_packet_t*)call ConPacket.getPayload(&ctspacket, sizeof(CTS_packet_t));
                    cts->packet_type = 3;
                    cts->src_id = sim_node();
                    cts->dest_id = rts_rec->src_id;
                    cts->duration = rts_rec->duration;
                  
                  //make an event for rts
                    backoff2 = sim_random();
                    backoff2 %= (sim_csma_init_high() - sim_csma_init_low());
                    backoff2 += sim_csma_init_low();
                    backoff2 *= (sim_ticks_per_sec() / sim_csma_symbols_per_sec());
    //                sample_time = sim_time() + backoff2-8000000;
                    sample_time = sim_time();


                    CTSsendEvent.mote = sim_node();                                    //does sim_node stores dest node
                    CTSsendEvent.time = sample_time;
                    CTSsendEvent.force = 0;
                    CTSsendEvent.cancelled = 0;
                    CTSsendEvent.handle = send_cts;
                    CTSsendEvent.cleanup = sim_queue_cleanup_none;
                    sim_queue_insert(&CTSsendEvent);
                    dbg("TossimPacketModelC", "TossimPacketModelC: In GainRadioModel.receive, Sending a CTS packet to node %hu\n",cts->dest_id);
                    
                    call CTSwaitTimer.startOneShot(CTS_WAIT_TIME);

                }
             }
             else{      //if RTS is not destined to me, then sleep till their communication is going on (duration)
                
                if(!radio_locked){ 
                    dbg("TossimPacketModelC", "TossimPacketModelC: In GainRadioModel.receive, RTS for %hu was received, Going to stop radio. Duration = %llu \n", rts_rec->dest_id,rts_rec->duration);
                    call gotrts_sleepTimer.startOneShot((rts_rec->duration)/4500);
                    call Control.stop();
                }
             }
        }                
        
        else if(syn3->packet_type == 3)              //got a CTS packet
        {
            
            cts_rec = (CTS_packet_t*)call ConPacket.getPayload(msg, sizeof(CTS_packet_t));
            dbg("TossimPacketModelC", "TossimPacketModelC: In GainRadioModel.receive, Received a CTS packet from: %hu for: %hu  time:%llu\n",cts_rec->src_id,cts_rec->dest_id,sim_time());            

            if(cts_rec->dest_id == sim_node())          //if CTS destined to me, then send data now
            {
                if(!(call gotrts_sleepTimer.isRunning()))
                {

                    rts = NULL;
                    call RTSwaitTimer.stop();
                    totalRTSCount = 0;
                    dbg("TossimPacketModelC", "TossimPacketModelC: In GainRadioModel.receive, Sending data \n");
                    no_SendTry = 0;
                    if(sending!=NULL)
                        send_data();
                }
            }    
            else{
                if(!radio_locked){              //if CTS not destined to me, then sleep
                    dbg("TossimPacketModelC", "TossimPacketModelC: In GainRadioModel.receive, CTS for node %hu was received, Going to stop radio. \n",cts_rec->dest_id);
                    call gotrts_sleepTimer.startOneShot((cts_rec->duration)/5500);
                    call Control.stop();
                }
            }
        }
        
        else //if(syn3->packet_type == 0)              //got a data packet
        {
        
  
            message_t *buffer;
            uint8_t dataLen;
            void* payload;

            tossim_header_t* header =(tossim_header_t*)getHeaderdata(msg);
            
         
            if(header->dest != sim_node()){
                dbg("TossimPacketModelC", "TossimPacketModelC: In GainRadioModel.receive, received packet for %hu, discarding it.\n",header->dest);
                return;
            }
         
            data_rec = (data_packet_t*)call ConPacket.getPayload(msg, sizeof(data_packet_t));
            
            
      
            call CTSwaitTimer.stop();
            waiting_fordata = FALSE;                
            buffer = (message_t*)malloc(sizeof(message_t));
            memcpy(buffer, msg, sizeof(message_t));

            dataLen = call ConPacket.payloadLength(msg);            
            
/*
            if(data_rec2->payload[1] != (data_rec->payload[1])){
                data_rec2->payload[1] = (data_rec->payload[1]);
            }
            else{
                return;
            }        
*/

            payload = call ConPacket.getPayload(buffer, call ConPacket.maxPayloadLength());
            


            dbg("TossimPacketModelC", "TossimPacketModelC: In GainRadioModel.receive, rec_counter = %hu \n",data_rec->payload[1]);
            memcpy(payload,data_rec->payload,dataLen);

 
           //if(data_rec->payload[1]==1 || (pre_counter)!= (rec_counter)){
//           if(data_rec->payload[1]==1 || data_rec2->payload[1] != (data_rec->payload[1])){
//
            radio_locked = FALSE;
            dbg("TossimPacketModelC", "TossimPacketModelC: In GainRadioModel.receive, Received a data packet , data_rec2->payload[1]=%hu\n",data_rec2->payload[1]);
        	signal Packet.receive(buffer);         //pass this packet to app layer
//        	 (pre_counter)=(rec_counter);

            

        	
        	free(buffer);
            
        }     
    }
   syn3 = NULL;
   rts_rec = NULL;
   cts_rec = NULL;
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

