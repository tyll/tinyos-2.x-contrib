/*
 * Author: Stefano Paniga
 * contact: stefano.paniga@mail.polimi.it
 */

#include "config.h"


module radioInterM {
  uses {
    interface Leds;
    interface Boot;
    interface SplitControl as AMControl;
    interface Packet as RadioPacket;
    //radio
    interface PacketAcknowledgements as Ack;	
    interface Receive as ReceiveImgstat;
    interface Receive as ReceivePhoto;
    interface Receive as ReceiveVideo;
    interface Receive as ReceiveCmd;
#ifdef TEST_ENV
    interface Receive as ReceiveTimeTest;
    interface Receive as ReceivePktTest;
    interface Receive as ReceiveQueueTest;
    interface AMSend as SendTimeTest;
    interface AMSend as SendPktTest;
    interface AMSend as SendQueueTest;
    interface Timer<TMilli> as TimerTestTime;
    interface Timer<TMilli> as TimerTestPkt;    
    interface Timer<TMilli> as TimerQueue;
#endif

    interface AMSend as SendPhoto;
    interface AMSend as SendImgstat;
    interface AMSend as SendVideo;
    interface AMSend as SendCommand;
    interface Queue<message_t*> as Queue;
    interface Pool<message_t> as Pool;
    interface Timer<TMilli> as TimerTxPause;
    interface Timer<TMilli> as TimerCmd;
    interface Timer<TMilli> as TimerImgstat;


  
  }
}
implementation {


  message_t test_msg;
  message_t fwd_time_msg;
  message_t fwd_pkt_msg;
  message_t command_msg;
  message_t queue_msg;
  pkt_test_msg_t rcvPktData;

  photo_radio_part_t photoData;
  uint16_t photo_last_partid;
  uint8_t video_last_partid;
  uint8_t video_last_frameid;
  uint8_t busy=0;
  uint8_t busy_cmd=0;
  uint8_t busy_test=0;
  uint8_t rtx_count=0;
  uint32_t rcv_test_pkts;
  uint32_t rtx_test_count;
  uint32_t   last_test_id=0;
  uint8_t fwd_cmd=0; //to choose between queueStop task and fwdCmd task in sendDone
  uint8_t imgstat_sent=0;
   uint8_t test_msg_type=0;
  uint8_t video_on=0;
  uint8_t tx_pause=0;
  uint8_t send_queue=0;
  uint8_t stop_queueing=0;
  uint16_t QUEUE_STOP_THRESHOLD=150;
  uint16_t QUEUE_RESTART_THRESHOLD=50;
  uint16_t TX_PAUSE=100;
  uint16_t last_part_sent=255;
  uint16_t last_part_rcv=255;
  uint8_t pkttest_rcv=0;
  uint8_t imgstat_rcv=0;
  uint8_t timetest_rcv=0;
  uint8_t queuetest_rcv=0;
  uint8_t sending_photo=0;
  uint16_t last_part_queue;
  uint16_t part_queue;
  uint16_t sample_queue;
  uint8_t send_on=0;
  uint8_t cmd_sending=0;
  message_t imgstat_msg;
  cmd_msg_t *cmd_data;

  task void queueStopCmd();
  task void queueRestartCmd();
  task void forwardVideo();
  task void forwardImgstat();
  task void forwardPhoto();
  task void forwardCommand();
#ifdef TEST_ENV
  task void forwardTimeTestMsg();
  task void forwardPktTestMsg();
  task void sendQueueSize();
  task void fwdQueueSize();
#endif
  

  event void Boot.booted() {

    photo_last_partid=255;
    video_last_partid=0;
    video_last_frameid=255;
    rtx_count=0;
    rcv_test_pkts=0;
    rtx_test_count=0;
    fwd_cmd=0;
    busy=0;
    video_on=0;
    tx_pause=0;
    imgstat_sent=0;
    stop_queueing=0;
    cmd_sending=0;

    call AMControl.start(); 	   
  }

  event void AMControl.startDone(error_t err) {
    if (err == SUCCESS) {
    }
    else {
	 call AMControl.start(); 	
    }
  }

  event void AMControl.stopDone(error_t err) {
    // do nothing
  }

 
 
// IMGSTAT

  event void TimerImgstat.fired(){
	post forwardImgstat();
  }

  task void forwardImgstat(){

        
	if(busy==0){

		call Ack.requestAck(&imgstat_msg);
		if (call SendImgstat.send(DEST,&imgstat_msg,sizeof(img_stat_t)) != SUCCESS){
				post forwardImgstat();
		}
		else busy=1;
    	}	
	else {
		call TimerImgstat.startOneShot(300);
	      }
	
  }


  event message_t* ReceiveImgstat.receive(message_t* msg, 
				   void* payload, uint8_t len) {
 	
    if (len == sizeof(img_stat_t) && imgstat_rcv==0)
    {
		rcv_test_pkts++;
		memcpy(&imgstat_msg,msg,sizeof(message_t));
		imgstat_rcv=1;
		post forwardImgstat();
			
    }
    return msg;
  }




  event void SendImgstat.sendDone(message_t* msg, error_t error)
  {

	busy=0;
	if(error!=SUCCESS || !call Ack.wasAcked(msg)){
		
		post forwardImgstat();
	}
	else {
		imgstat_sent=1;
        }
                	
   }


// PHOTO

event void TimerTxPause.fired(){

	if(tx_pause==1){
		call TimerTxPause.startOneShot(TX_PAUSE);
	}
	else if(video_on==1) {
		tx_pause=0;
		post forwardVideo();
	}
	else {
		tx_pause=0;
		post forwardPhoto();
	}
		
	
}

 task void forwardPhoto(){

	message_t  *photo_msg;
	if(tx_pause==1 || imgstat_sent==0) {
			call TimerTxPause.startOneShot(TX_PAUSE);
			return;
	}
	if(call Queue.size()<= QUEUE_RESTART_THRESHOLD && stop_queueing==1) {
		call Leds.led1Off();
		post queueRestartCmd();
	}
	
	if(call Queue.empty()){
		 send_on=0;
		 return;
	}
	else send_on=1;


        photo_msg= call Queue.head();
			
	if(busy==0){
		
		call Ack.requestAck(photo_msg);
		if (call SendPhoto.send(DEST,photo_msg,PHOTO_HEADER_LENGTH+PHOTO_DATA_LENGTH) != SUCCESS){

				post forwardPhoto();
		}
		else	busy=1;
		
    	}	
	else call TimerTxPause.startOneShot(TX_PAUSE);
	  
	     
 }

  event message_t* ReceivePhoto.receive(message_t* msg, 
				   void* payload, uint8_t len) {
  photo_radio_part_t *rcvPhotoMsg;
	
    if(len == sizeof(photo_radio_part_t)){

		rcvPhotoMsg=(photo_radio_part_t*) payload;
		if(rcvPhotoMsg->part_id==photo_last_partid+1 || (rcvPhotoMsg->part_id==0 && rcvPhotoMsg->part_id!=photo_last_partid))
		{
			call Leds.led0On();
			 photo_last_partid=rcvPhotoMsg->part_id;
			rcv_test_pkts++;

			if(call Queue.size()>= QUEUE_STOP_THRESHOLD && stop_queueing==0){
				stop_queueing=1;
				call Leds.led1On();				
				post queueStopCmd();
			}
		
			if (!call Pool.empty() && call Queue.size() < call Queue.maxSize()) {
				message_t * tmp;
				tmp = call Pool.get();
	
				if(tmp==NULL){
					//call Leds.led1On();
					 return msg;
				}
	
			        if(call Queue.enqueue(msg)==SUCCESS) {

				if((rcvPhotoMsg->part_id!=last_part_rcv+1 && rcvPhotoMsg->part_id!=0) || (rcvPhotoMsg->part_id==0)) call Leds.led0On();
				else last_part_rcv=rcvPhotoMsg->part_id;
#ifdef TEST_ENV			    	     //TEST: send queue
				     if(rcvPhotoMsg->part_id%200==0 && TOS_NODE_ID==5) post sendQueueSize();

#endif
				     if(send_on==0) post forwardPhoto();
				      
				       return tmp;
				}
				else{
					//call Leds.led1On();
					call Pool.put(tmp);
					return msg;
				}
			}else call Leds.led0Toggle();
			
	     }
    }else call Leds.led2Toggle();		
    
    return msg;
}



event void SendPhoto.sendDone(message_t* msg, error_t error)
  {
	photo_radio_part_t *rcvMsg;
	busy=0;
	call Leds.led0Off();
	if(error!=SUCCESS || !call Ack.wasAcked(msg)){
		
		rtx_test_count++;
		sending_photo=0;
		post forwardPhoto();
	}
	else{
		
		rcvMsg=call RadioPacket.getPayload(msg,sizeof(photo_radio_part_t));
		last_part_sent=rcvMsg->part_id;
		call Pool.put(msg);
	   	call Queue.dequeue();
		if(call Queue.size()>0)	 post forwardPhoto();		
		else send_on=0;
		
        }
     	
   }


//VIDEO

 task void forwardVideo(){

	message_t *video_msg;
	
	if(tx_pause==1) {
			call TimerTxPause.startOneShot(100);
			return;
	}
	if(call Queue.size()<= QUEUE_RESTART_THRESHOLD && stop_queueing==1) {
		post queueRestartCmd();
	}
	
	if(call Queue.empty()){
		 send_on=0;
		 return;
	}
	else send_on=1;
	
	video_msg= (message_t *)call Queue.head();
	if(busy==0){
#ifdef NO_ACK         
		video_radio_part_t *msgData=(video_radio_part_t*)call RadioPacket.getPayload(video_msg,sizeof(video_radio_part_t));

        if(msgData->frame_id==0)
#endif
            call Ack.requestAck(video_msg);
        
		if (call SendVideo.send(DEST,video_msg,VIDEO_DATA_LENGTH+VIDEO_HEADER_LENGTH) != SUCCESS){
			post forwardVideo();
		}
		else busy=1;
	    	}	
	else call TimerTxPause.startOneShot(100);
	     

 }

 event message_t* ReceiveVideo.receive(message_t* msg, 
				   void* payload, uint8_t len) {
	video_radio_part_t* rcvVideoMsg;

	if(len == sizeof(video_radio_part_t)){

		rcvVideoMsg=(video_radio_part_t*) payload;
		
		if(rcvVideoMsg->part_id>video_last_partid || (rcvVideoMsg->part_id==0 && rcvVideoMsg->frame_id!=video_last_frameid)){
				call Leds.led0On();
			video_last_partid=rcvVideoMsg->part_id;
			//test
			rcv_test_pkts++;
		
			if(call Queue.size()>=QUEUE_STOP_THRESHOLD && stop_queueing==0)
			{				
				stop_queueing=1;
				call Leds.led1On();
				post queueStopCmd();
			}
			
			if (!call Pool.empty() && call Queue.size() < call Queue.maxSize()) {
				message_t * tmp;
				tmp = call Pool.get();
	
				if(tmp==NULL) return msg;
	
			if(call Queue.enqueue(msg)==SUCCESS) {
				
				if(rcvVideoMsg->part_id==0) {
					video_last_frameid=rcvVideoMsg->frame_id;
				}
#ifdef TEST_ENV
				if(rcv_test_pkts%300==0 && rcvVideoMsg->part_id==1 && rcvVideoMsg->frame_id!=0 && TOS_NODE_ID==5)
							 post sendQueueSize();
#endif

				if(send_on==0)	post forwardVideo();
						  
			        return tmp;
			}
			else{
				call Pool.put(tmp);
				return msg;
			}
			
		       }else {
		
			  call Leds.led0Toggle();
		     }
		}
	}

	return msg;

  }


event void SendVideo.sendDone(message_t* msg, error_t error)
  {

#ifdef NO_ACK     
    video_radio_part_t *msgData=(video_radio_part_t*)call RadioPacket.getPayload(msg,sizeof(video_radio_part_t));
#endif
      
    busy=0;
    call Leds.led0Off();
    
#ifdef NO_ACK 
    if((error!=SUCCESS || (msgData->frame_id==0 && !call Ack.wasAcked(msg))) && rtx_count<MAX_RTX) {
#else
	if((error!=SUCCESS || !call Ack.wasAcked(msg)) && rtx_count<MAX_RTX) {
#endif
		rtx_count++;
		//test
		rtx_test_count++;
		post forwardVideo();
	}
	else {
		rtx_count=0;
       	        call Queue.dequeue();
	        call Pool.put(msg);
		if(call Queue.size()>0){
			post forwardVideo();		
		}
		else send_on=0;
		
        }
          
		
   }

// COMMANDS

event void TimerCmd.fired(){
	if(fwd_cmd==0)	post forwardCommand();
	else if(fwd_cmd==1) post queueStopCmd();
	else if(fwd_cmd==2) post queueRestartCmd();
}

task void queueStopCmd(){

	cmd_msg_t *cmdStopData=(cmd_msg_t*)call RadioPacket.getPayload(&command_msg,sizeof(cmd_msg_t));
	cmdStopData->cmd=0x40;
	
	if(busy_cmd==0){
			fwd_cmd=1;
			call Ack.requestAck(&command_msg);
			if (call SendCommand.send(SRC,&command_msg,sizeof(cmd_msg_t)) != SUCCESS){
	
				post queueStopCmd();
	    		}
			else	 busy_cmd=1;
			
	}
	else call TimerCmd.startOneShot(100);
    	
}

task void queueRestartCmd(){

	cmd_msg_t *cmdRestartData=(cmd_msg_t*)call RadioPacket.getPayload(&command_msg,sizeof(cmd_msg_t));
	cmdRestartData->cmd=0x80;
	
	if(busy_cmd==0){
			fwd_cmd=2;
			call Ack.requestAck(&command_msg);
			if (call SendCommand.send(SRC,&command_msg,sizeof(cmd_msg_t)) != SUCCESS){
	
				post queueRestartCmd();
	    		}
			else busy_cmd=1;
	}
	else call TimerCmd.startOneShot(100);
    	
}

task void forwardCommand(){

	
	if(busy_cmd==0){
			fwd_cmd=0;
			call Ack.requestAck(&command_msg);
	   		if (call SendCommand.send(SRC,&command_msg,sizeof(cmd_msg_t)) != SUCCESS){
				
				post forwardCommand();
	    		}
			else busy_cmd=1;
	
    	}	
	else call TimerCmd.startOneShot(100);
		
	      

	

}

event message_t *ReceiveCmd.receive(message_t *msg, void *payload, uint8_t len) {

	if(len==sizeof(cmd_msg_t) && cmd_sending==0){

			cmd_data=(cmd_msg_t*) payload;
			if(cmd_data->cmd & 0x20){
				if(video_last_partid!=0) video_last_partid=0;
				if(video_last_frameid==0) video_last_frameid=255;
				else video_last_frameid--;
			}
			else if(cmd_data->cmd & 0x40){
				tx_pause=1;
				call Leds.led2On();
				return msg;
			}
			else if(cmd_data->cmd & 0x80){
				tx_pause=0;
				call Leds.led2Off();
				return msg;
			}
			else if(cmd_data->cmd & 0x08){
			    //test
			    rtx_test_count=0;
			    rcv_test_pkts=0;
			    pkttest_rcv=0;
			    last_test_id=0;
			    pkttest_rcv=0;
			    timetest_rcv=0;
			    
  			    video_on=1;
  			    video_last_partid=0;
			    video_last_frameid=255;
			    rtx_count=0;
			    tx_pause=0;
			    
			}
			else if(cmd_data->cmd < 0x08){
			    photo_last_partid=255;
			    video_on=0;
			    tx_pause=0;
			    imgstat_sent=0;
			    last_part_sent=255;
			    last_part_rcv=255;
			    imgstat_rcv=0;
			    timetest_rcv=0;
			    sending_photo=0;
			    send_on=0;	
			    //test
			    pkttest_rcv=0;
			    rtx_test_count=0;
			    rcv_test_pkts=0;
			    last_test_id=0;
			    stop_queueing=0;
		    	    
			}
			cmd_sending=0;
			memcpy(&command_msg,msg,sizeof(message_t));							
			post forwardCommand();			

	}

   return msg;
}

event void SendCommand.sendDone(message_t* msg, error_t error)
  {

	busy_cmd=0;
	
	if(error!=SUCCESS || !call Ack.wasAcked(msg)){
		if(fwd_cmd==0)post forwardCommand();
		else if(fwd_cmd==1) post queueStopCmd();
		else post queueRestartCmd();
	}
	else if(fwd_cmd==0) cmd_sending=0;
	else if(fwd_cmd==2){
		 call Leds.led1Off();
		 stop_queueing=0;
	}
	                	
   }


//TEST
#ifdef TEST_ENV

event void TimerTestTime.fired(){
  post forwardTimeTestMsg();
}

//Test pkts time forwarding
task void forwardTimeTestMsg(){

	
	if(busy_test==0){
		if(video_on==0) call Ack.requestAck(&fwd_time_msg);
		if(call SendTimeTest.send(DEST,&fwd_time_msg, sizeof(time_test_msg_t))!=SUCCESS){
			post forwardTimeTestMsg();
		}	
		else {
			busy_test=1;
		}
	}
	else call TimerTestTime.startOneShot(100);
	
}


event message_t *ReceiveTimeTest.receive(message_t *msg, void *payload, uint8_t len) {


	if(len==sizeof(time_test_msg_t) && timetest_rcv==0){

				timetest_rcv=1;
				memcpy(&fwd_time_msg,msg,sizeof(message_t));
				post forwardTimeTestMsg();
			
	}
	return msg;
}

  event void SendTimeTest.sendDone(message_t* msg, error_t error) {
	busy_test=0;
	if(error!=SUCCESS)  post forwardTimeTestMsg();
	else if(video_on==0 && !call Ack.wasAcked(msg)) post forwardTimeTestMsg();
	else timetest_rcv=0;
	
  }


// Test data pkts forwarding
event void TimerTestPkt.fired(){
  if(call Queue.size()>0){
	call TimerTestPkt.startOneShot(200);
  }
  else post forwardPktTestMsg();
}

task void forwardPktTestMsg(){
	
	pkt_test_msg_t *msgData;
	msgData=(pkt_test_msg_t *)call RadioPacket.getPayload(&fwd_pkt_msg, sizeof(pkt_test_msg_t));
	
		msgData->rcv_inter_pkts=rcvPktData.rcv_inter_pkts+rcv_test_pkts;
		msgData->rtx_inter_count=rcvPktData.rtx_inter_count+rtx_test_count;
		msgData->frame_num=rcvPktData.frame_num;
		msgData->rtx_camera_count=rcvPktData.rtx_camera_count;
		msgData->rcv_bs_pkts=0;

	if(busy_test==0){
		call Ack.requestAck(&fwd_pkt_msg);
		if(call SendPktTest.send(DEST,&fwd_pkt_msg, sizeof(pkt_test_msg_t))!=SUCCESS){
			post forwardPktTestMsg();
		}
		else busy_test=1;
	}else call TimerTestPkt.startOneShot(100);
}

event message_t *ReceivePktTest.receive(message_t *msg, void *payload, uint8_t len) {
	
	if(len==sizeof(pkt_test_msg_t) && pkttest_rcv==0){
				
				pkttest_rcv=1;
				memcpy(&rcvPktData,payload,len);
				call TimerTestPkt.startOneShot(1000);
	}
	return msg;
}


  event void SendPktTest.sendDone(message_t* msg, error_t error) {
	busy_test=0;
	if(error!=SUCCESS || !call Ack.wasAcked(msg)){
		post forwardPktTestMsg();

	}
	else pkttest_rcv=0;

  }

//queue status monitoring

event void TimerQueue.fired(){
	if(send_queue==1) post sendQueueSize();
	else post fwdQueueSize();
}

task void fwdQueueSize(){
      
	send_queue=0;
	if(busy_test==0){
		if(call SendQueueTest.send(DEST,&queue_msg, sizeof(queue_test_msg_t))!=SUCCESS){
			post fwdQueueSize();
		}	
		else {
			busy_test=1;
		}
	}
	else call TimerQueue.startOneShot(200);

}

event message_t *ReceiveQueueTest.receive(message_t *msg, void *payload, uint8_t len) {
	
	if(len==sizeof(queue_test_msg_t) && queuetest_rcv==0){

				queuetest_rcv=1;
				memcpy(&queue_msg,msg,sizeof(message_t));
				post fwdQueueSize();
	}
	return msg;
}


task void sendQueueSize(){
       queue_test_msg_t *msgData;
       msgData=(queue_test_msg_t *)call RadioPacket.getPayload(&queue_msg, sizeof(queue_test_msg_t));
	
	msgData->tx_pause= TX_PAUSE;
	msgData->queue_size= call Queue.size();
	msgData->queue_delta=0;
	
	if(busy_test==0){
		send_queue=1;
		//call Ack.requestAck(&queue_msg);
		if(call SendQueueTest.send(DEST,&queue_msg, sizeof(queue_test_msg_t))!=SUCCESS){
			post sendQueueSize();
		}	
		else 	busy_test=1;
		
			
	}
	else call TimerQueue.startOneShot(100);

}
  
 event void SendQueueTest.sendDone(message_t* msg, error_t error) {
	busy_test=0;
	if(error!=SUCCESS){
		if(send_queue==1){
			send_queue=0;
			post sendQueueSize();
		}
		else post fwdQueueSize();
	}
	else queuetest_rcv=0;
  } 
#endif  

}






