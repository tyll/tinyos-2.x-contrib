
//a really simple replacement

#include <sim_radio.h>
//#include <sim_noise.h>
#include <randomlib.h>
//#include "../../sim_energy.h"
#include <sim_energy.h>

module CpmModelC {
  provides interface GainRadioModel as Model;
}

implementation {
  
//replace these with real values
#ifndef TRANSMIT_ENERGY
#define TRANSMIT_ENERGY 64 //uJ
#endif

#ifndef RECEIVE_ENERGY
#define RECEIVE_ENERGY 64 //uJ
#endif

  message_t* outgoing; // If I'm sending, this is my outgoing packet
  bool requestAck;
  bool receiving = 0;  // Whether or not I think I'm receiving a packet
  struct receive_message;
  typedef struct receive_message receive_message_t;

  struct receive_message {
    int source;
    sim_time_t start;
    sim_time_t end;
    double power;
    double reversePower;
    bool lost;
    bool ack;
    message_t* msg;
    receive_message_t* next;
  };

  receive_message_t* outstandingReceptionHead = NULL;

  receive_message_t* allocate_receive_message();
  void free_receive_message(receive_message_t* msg);
  sim_event_t* allocate_receive_event(sim_time_t t, receive_message_t* m);

  bool shouldReceive(double SNR);
  bool checkReceive(receive_message_t* msg);
  //double packetNoise(receive_message_t* msg);
  double checkPrr(receive_message_t* msg);
  
  double timeInMs()   {
    sim_time_t ftime = sim_time();
    int hours, minutes, seconds;
    sim_time_t secondBillionths;
    int temp_time;
    double ms_time;

    secondBillionths = (ftime % sim_ticks_per_sec());
    if (sim_ticks_per_sec() > (sim_time_t)1000000000) {
	secondBillionths /= (sim_ticks_per_sec() / (sim_time_t)1000000000);
    }
    else {
      secondBillionths *= ((sim_time_t)1000000000 / sim_ticks_per_sec());
    }
    temp_time = (int)(secondBillionths/10000);
    
    if (temp_time % 10 >= 5) {
	temp_time += (10-(temp_time%10));
    }
    else {
      temp_time -= (temp_time%10);
    }
    ms_time = (float)(temp_time/100.0);

    seconds = (int)(ftime / sim_ticks_per_sec());
    minutes = seconds / 60;
    hours = minutes / 60;
    seconds %= 60;
    minutes %= 60;
	
    ms_time += (hours*3600+minutes*60+seconds)*1000;

    return ms_time;
  }
	
  //Generate a CPM noise reading
/*  double noise_hash_generation()   {
    double CT = timeInMs(); 
    uint32_t quotient = ((sim_time_t)(CT*10))/10;
    uint8_t remain = (uint8_t)(((sim_time_t)(CT*10))%10);
    double noise_val;
    uint16_t node_id = sim_node();

    dbg("CpmModelC", "IN: noise_hash_generation()\n");
    if (5 <= remain && remain < 10) {
	noise_val = (double)sim_noise_generate(node_id, quotient+1);
      }
    else {
      noise_val = (double)sim_noise_generate(node_id, quotient);
    }
    dbg("CpmModelC,Tal", "%s: OUT: noise_hash_generation(): %lf\n", sim_time_string(), noise_val);

    return noise_val;
  }
*/

/*  double packetSnr(receive_message_t* msg) {
    double signalStr = msg->power;
    double noise = noise_hash_generation();
    return (signalStr - noise);
  }*/
  
/*  double arr_estimate_from_snr(double SNR) {
    double beta1 = 1.3687;
    double beta2 = 0.9187;
    double SNR_lin = pow(10.0, SNR/10.0);
    double X = fabs(SNR_lin-beta2);
    double PSE = 0.5*erfc(beta1*sqrt(X/2));
    double prr_hat = pow(1-PSE, 23*2);
    dbg("CpmModelC,SNRLoss", "SNR is %lf, ARR is %lf\n", SNR, prr_hat);
    if (prr_hat > 1)
      prr_hat = 1;
    else if (prr_hat < 0)
      prr_hat = 0;
	
    return prr_hat;
  }
  */
  
  int shouldAckReceive(double snr) {
    double prr =0.0; //arr_estimate_from_snr(snr);
    double coin = RandomUniform();
    if ( (prr != 0) && (prr != 1) ) {
      if (coin < prr)
	prr = 1.0;
      else
	prr = 0.0;
    }
    return (int)prr;
  }
  
  void sim_gain_ack_handle(sim_event_t* evt)  {
    // Four conditions must hold for an ack to be issued:
    // 1) Transmitter is still sending a packet (i.e., not cancelled)
    // 2) The packet requested an acknowledgment
    // 3) The transmitter is on
    // 4) The packet passes the SNR/ARR curve
    if (requestAck && // This 
		outgoing != NULL &&
		sim_mote_is_on(sim_node())) 
	{
      //receive_message_t* rcv = (receive_message_t*)evt->data;
      //double power = rcv->reversePower;
      //double noise = packetNoise(rcv);
      //double snr = power - noise;
      //if (shouldAckReceive(snr)) 
	  //{
	  	signal Model.acked(outgoing);
      //}
    }
    free_receive_message((receive_message_t*)evt->data);
  }

  sim_event_t receiveEvent;
  // This clear threshold comes from the CC2420 data sheet
  double clearThreshold = -72.0;
  bool collision = FALSE;
  message_t* incoming = NULL;
  int incomingSource;

  command void Model.setClearValue(double value) {
    clearThreshold = value;
    dbg("CpmModelC", "Setting clear threshold to %f\n", clearThreshold);
	
  }
  
  command bool Model.clearChannel() {
    //dbg("CpmModelC", "Checking clear channel @ %s: %f <= %f \n", sim_time_string(), (double)packetNoise(NULL), clearThreshold);
	dbg("CpmModelC", "Checking clear channel @ %s\n", sim_time_string());
    //return packetNoise(NULL) < clearThreshold;
	return TRUE;
  }

  void sim_gain_schedule_ack(int source, sim_time_t t, receive_message_t* r) {
    sim_event_t* ackEvent = (sim_event_t*)malloc(sizeof(sim_event_t));
    
    ackEvent->mote = source;
    ackEvent->force = 1;
    ackEvent->cancelled = 0;
    ackEvent->time = t;
    ackEvent->handle = sim_gain_ack_handle;
    ackEvent->cleanup = sim_queue_cleanup_event;
    ackEvent->data = r;
    
    sim_queue_insert(ackEvent);
  }

  double prr_estimate_from_snr(double SNR) {
    double beta1 = 1.3687;
    double beta2 = 0.9187;
    double SNR_lin = pow(10.0, SNR/10.0);
    double X = fabs(SNR_lin-beta2);
    double PSE = 0.5*erfc(beta1*sqrt(X/2));
    double prr_hat = pow(1-PSE, 23*2);
    dbg("CpmModelC,SNR", "SNR is %lf, PRR is %lf\n", SNR, prr_hat);
    if (prr_hat > 1)
      prr_hat = 1;
    else if (prr_hat < 0)
      prr_hat = 0;
	
    return prr_hat;
  }

  bool shouldReceive(double SNR) {
    double prr = prr_estimate_from_snr(SNR);
    double coin = RandomUniform();
    if ( (prr != 0) && (prr != 1) ) {
      if (coin < prr)
	prr = 1.0;
      else
	prr = 0.0;
    }
    return prr;
  }

  
  

  /* Handle a packet reception. If the packet is being acked,
     pass the corresponding receive_message_t* to the ack handler,
     otherwise free it. */
  void sim_gain_receive_handle(sim_event_t* evt) {
    receive_message_t* mine = (receive_message_t*)evt->data;
    	
    dbg("CpmModelC", "Handling reception event @ %s.\n", sim_time_string());
    
	if (!sim_consume_energy(sim_node(),RECEIVE_ENERGY))
	{
		dbg("CpmModelC","Receive failed.  No Energy\n");
		free_receive_message(mine);
		return;
	}
	
    dbg("CpmModelC,SNRLoss", "Packet from %i to %i\n", (int)mine->source, (int)sim_node());
    
    if (!mine->lost) {
      dbg_clear("CpmModelC,SNRLoss", "  -signaling reception\n");
      signal Model.receive(mine->msg);
      if (mine->ack) {
        dbg_clear("CpmModelC", " acknowledgment requested, ");
      }
      else {
        dbg_clear("CpmModelC", " no acknowledgment requested.\n");
      }
      // If we scheduled an ack, receiving = 0 when it completes
      if (mine->ack && signal Model.shouldAck(mine->msg)) 
	{
        dbg_clear("CpmModelC", " scheduling ack.\n");
		sim_gain_schedule_ack(mine->source, sim_time() + 1, mine);
      } else { // Otherwise free the receive_message_t*
		free_receive_message(mine);
      }
      // We're searching for new packets again
      receiving = 0;
    } // If the packet was lost, then we're searching for new packets again
    else {
      free_receive_message(mine);
      
      receiving = 0;
      dbg_clear("CpmModelC,SNRLoss", "  -packet was lost.\n");
    }
  }
   
  // Create a record that a node is receiving a packet,
  // enqueue a receive event to figure out what happens.
  void enqueue_receive_event(int source, sim_time_t endTime, message_t* msg, bool receive, double power, double reversePower) {
    sim_event_t* evt;
    receive_message_t* rcv = allocate_receive_message();
    
    rcv->source = source;
    rcv->start = sim_time();
    rcv->end = endTime;
    rcv->power = power;
    rcv->reversePower = reversePower;
    rcv->msg = msg;
    rcv->lost = 0;
    rcv->ack = receive;
    
    

    if (!sim_mote_is_on(sim_node())) { 
      dbg("CpmModelC", "Lost packet from %i due to %i being off\n", source, sim_node());
      rcv->lost = 1;
    } else if (receiving == 1) {
    	dbg("CpmModelC", "Lost packet from %i due to %i currently receiving\n", source, sim_node());
      	rcv->lost = 1;
    } else {
    	receiving = 1;
    }

    evt = allocate_receive_event(endTime, rcv);
    sim_queue_insert(evt);

  }
  
  void sim_gain_put(int dest, message_t* msg, sim_time_t endTime, bool receive, double power, double reversePower) {
    int prevNode = sim_node();
    dbg("CpmModelC", "Enqueing reception event for %i at %llu with power %lf.\n", dest, endTime, power);
    sim_set_node(dest);
    enqueue_receive_event(prevNode, endTime, msg, receive, power, reversePower);
    sim_set_node(prevNode);
  }

  command void Model.putOnAirTo(int dest, message_t* msg, bool ack, sim_time_t endTime, double power, double reversePower) {
    radio_entry_t* neighborEntry = sim_radio_first(sim_node());
    radio_entry_t* tmp_next = NULL;
    
    requestAck = ack;
    outgoing = msg;
    dbg("CpmModelC", "Node %i transmitting to %i, finishes at %llu.\n", sim_node(), dest, endTime);

    while (neighborEntry != NULL) 
    {
      	int other = neighborEntry->mote;
	if (other == dest || dest == 0xffff)
	{
		//have to get the next entry in case this one goes away during capacity check
		tmp_next = sim_radio_next(neighborEntry);
		if (sim_radio_consume_capacity(sim_node(),other,1))
		{
	
			if (!sim_consume_energy(sim_node(),TRANSMIT_ENERGY))
			{
				//ran out of energy
				return;
			}
		
      			sim_gain_put(other, msg, endTime, ack && (other == dest), power, reversePower);
			
			neighborEntry = sim_radio_next(neighborEntry);
		 } else {
		 	neighborEntry = tmp_next;
		
		
		}
	} else {
	  neighborEntry = sim_radio_next(neighborEntry);
	 }
    }
  }
    

  
  
 default event void Model.receive(message_t* msg) {}

 sim_event_t* allocate_receive_event(sim_time_t endTime, receive_message_t* msg) {
   sim_event_t* evt = (sim_event_t*)malloc(sizeof(sim_event_t));
   evt->mote = sim_node();
   evt->time = endTime;
   evt->handle = sim_gain_receive_handle;
   evt->cleanup = sim_queue_cleanup_event;
   evt->cancelled = 0;
   evt->force = 1; // Need to keep track of air even when node is off
   evt->data = msg;
   return evt;
 }

 receive_message_t* allocate_receive_message() {
   return (receive_message_t*)malloc(sizeof(receive_message_t));
 }

 void free_receive_message(receive_message_t* msg) {
   free(msg);
 }
}
