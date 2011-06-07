/*
 * Author: Stefano Paniga
 * contact: stefano.paniga@mail.polimi.it
 */
#include "radio.h"


module RadioMsgM
{
  provides
  {
    interface RadioMsg;
  }

  uses
  {
    interface Boot;
    interface Packet as SerialPacket;
    interface AMSend as SerialImgstatSend;
    interface AMSend as SerialSend;
    interface AMSend as VideoSerialSend;
    interface cameraJpegTest;
    interface Leds;
    //RADIO
    interface SplitControl as AMControl;
    interface Packet as RadioPacket;
    interface AMSend as RadioPhotoSend;
    interface AMSend as RadioImgStatSend;
    interface AMSend as RadioVideoSend;
    interface Receive as ReceiveRadioCmd;
    interface PacketAcknowledgements as Ack;
    //TEST
    interface AMSend as RadioTimeTestSend;
    interface AMSend as RadioPktTestSend;
    interface Packet as TimerPacket;
    //SERIAL
    interface SplitControl as SerialControl;

    interface Timer<TMilli> as TimerWait;
    interface Timer<TMilli> as TimerVideoWait;	
    interface Timer<TMilli> as TimerPktData;
    interface Timer<TMilli> as TimerPhotoPause;

  }
}

implementation
{
  uint8_t *buffer;
  photo_frame_request_t photoReq;
  video_frame_request_t videoReq;
  imgstat_request_t imgStatReq;
  img_stat_t *img_data;
  uint32_t total_size;
  uint8_t last_photo_msg=0;
  uint8_t last_video_msg=0;
  message_t tx_msg;
  message_t stat_msg;
  message_t pkt_msg;
  message_t time_msg;
  uint8_t busy=0;
  uint8_t busy_test=0;
  uint8_t rtx_count=0;
  uint16_t PHOTO_PAUSE=50;
  uint8_t photo_pause=0;
   //test
  uint32_t rtx_test_count=0;
  uint32_t test_acquire=0;
  uint32_t test_process=0;
  uint32_t test_sending=0;
  uint32_t test_size=0;
  uint32_t test_id=0;
  uint32_t test_pause=0;
  uint32_t pause_time=0;
  uint32_t pause_time_temp=0;
  uint32_t acquire_period=0;
  uint8_t send_pkt_test=0;
  uint8_t VIDEO_ON=0;
  uint8_t sending_photo=0;

  


task void processPhotoRadio();
task void sendPktData();
task void sendTimeData();

  event void Boot.booted()
  {
    buffer = 0;
    busy=0;
    busy_test=0;
    rtx_test_count=0;
    VIDEO_ON=0;
    photo_pause=0;
    sending_photo=0;
    call   AMControl.start();
  }

  event void AMControl.startDone(error_t err){
	if(err!=SUCCESS) call AMControl.start();
	else call SerialControl.start();
  }
  event void AMControl.stopDone(error_t err){
  }

 event void SerialControl.startDone(error_t result) {
 }
 event void SerialControl.stopDone(error_t result) {}


/****************************************************************************
*
*	RADIO COMMUNICATION
*
*****************************************************************************/


/* ---------------- RADIO REMOTE COMMANDS -------------------*/
  event message_t *ReceiveRadioCmd.receive(message_t *msg, void *payload, uint8_t len) {

    cmd_msg_t *cmdMsg;


    if(len==sizeof(cmd_msg_t)){

    cmdMsg=(cmd_msg_t*)payload;

   //Stop video cmd 	
    if(cmdMsg->cmd == 0x10 && VIDEO_ON==1 && send_pkt_test==0){
	send_pkt_test=1;
	call TimerPktData.startOneShot(1000);
    }
    //pause tx
    if(cmdMsg->cmd==0x40){
	photo_pause=1;
    }
    //pause tx
    if(cmdMsg->cmd==0x80){
	photo_pause=0;
    }
   //get photo
    if(cmdMsg->cmd < 0x08 && sending_photo==0){
	VIDEO_ON=0;
	rtx_test_count=0;
	sending_photo=1;
	pause_time=0;
    }
   //start video
   if(cmdMsg->cmd == 0x08 && VIDEO_ON==0){
	VIDEO_ON=1; 
	pause_time=0;
	send_pkt_test=0;
	rtx_test_count=0;
    }
    call cameraJpegTest.radio_command_manager(cmdMsg);

   }// sizeof cmd_msg_t 
  
  return msg;
}



event void TimerPktData.fired(){
	post sendPktData();
}

event void TimerPhotoPause.fired(){
	if(photo_pause==1) {
		call TimerPhotoPause.startOneShot(PHOTO_PAUSE);
		return;
	}
	pause_time_temp+= call TimerPhotoPause.getNow();
	pause_time=pause_time+pause_time_temp;
	post processPhotoRadio();
}

//TEST

task void sendPktData(){

	pkt_test_msg_t *msgData =
      (pkt_test_msg_t *)call RadioPacket.getPayload(&pkt_msg, sizeof(pkt_test_msg_t));

	msgData->rtx_camera_count=rtx_test_count;
	msgData->frame_num=test_id;
	msgData->rcv_inter_pkts=0;
	msgData->rtx_inter_count=0;
	msgData->rcv_bs_pkts=0;
	
	if(busy_test==0){	
		 call Ack.requestAck(&pkt_msg);
 		 if (call RadioPktTestSend.send(DEST, &pkt_msg, sizeof(pkt_test_msg_t)) != SUCCESS){
		     post sendPktData(); 
		   }
		else busy_test=1;
	}
	else post sendPktData();
	
}

 task void sendTimeData(){

	time_test_msg_t *msgData =
      (time_test_msg_t *)call RadioPacket.getPayload(&time_msg, sizeof(time_test_msg_t));


	msgData->acquire= test_acquire;
	msgData->process= test_process;
	msgData->sending= test_sending;
	msgData->send_size= test_size;
	msgData->id= test_id;
	msgData->acq_period=acquire_period;
	msgData->pause_time=test_pause;

	if(busy_test==0){
		 call Ack.requestAck(&time_msg);
	 	    if (call RadioTimeTestSend.send(DEST, &time_msg, sizeof(time_test_msg_t)) != SUCCESS){
		     post sendTimeData(); 
		   }
		   else busy_test=1;
	}
	else {
			post sendTimeData();
	}
 }

event void RadioTimeTestSend.sendDone(message_t* bufPtr, error_t error){
	busy_test=0;
	if(error!=SUCCESS || !call Ack.wasAcked(bufPtr)) 
	{
		post sendTimeData();
	}
	else {
		signal RadioMsg.sendTimerDataRadioDone(SUCCESS);
	}
	
		
}
event void RadioPktTestSend.sendDone(message_t* bufPtr, error_t error){
	busy_test=0;

	if(error!=SUCCESS || !call Ack.wasAcked(bufPtr)){ 
		
		post sendPktData();
	}
	else VIDEO_ON=0;
}


 command error_t RadioMsg.sendTimerDataRadio(uint32_t acquire_time, uint32_t process_time, uint32_t sending_time,uint32_t send_size,uint32_t id,uint32_t period,uint32_t video_pause){
	
	test_acquire=acquire_time;
	test_process=process_time;
	test_sending=sending_time;
	test_size=send_size;
	test_id=id;
	acquire_period=period;
	if(VIDEO_ON==1)	test_pause=video_pause;
	else {
		test_pause=pause_time;
	}
	post sendTimeData();
	if(send_pkt_test==1){
		send_pkt_test=0;
		call TimerPktData.startOneShot(1000);
	}


  return SUCCESS;
 }


   //RADIO-Imgstat

   task void processImgStatRadio(){

	
    img_data = (img_stat_t *)call RadioPacket.getPayload(&stat_msg, sizeof(img_stat_t));


    img_data->data_size = imgStatReq.data_size;
    img_data->width=imgStatReq.width;
    img_data->height=imgStatReq.height;
 

	if(busy==0){
		call Ack.requestAck(&stat_msg);
     		if(call RadioImgStatSend.send(DEST, &stat_msg, sizeof(img_stat_t))!=SUCCESS){
			post processImgStatRadio();
		}else busy=1;
	}
	else{
		post processImgStatRadio();
	}
	
   }

  event void RadioImgStatSend.sendDone(message_t* bufPtr, error_t error)
  {
	busy=0;
	if(error!=SUCCESS || !call Ack.wasAcked(bufPtr)){
	     rtx_test_count++;
	      call RadioMsg.sendImgStatRadio(imgStatReq.width,imgStatReq.height,imgStatReq.data_size);
		return;
	}

	else {

		signal RadioMsg.sendImgStatRadioDone(SUCCESS);   	
	}

                  	
   }

 command error_t RadioMsg.sendImgStatRadio(uint16_t width, uint16_t height, uint32_t size)
  {
		
    if (size==0 )
    {
      signal RadioMsg.sendImgStatRadioDone(FAIL);
      return FAIL;
    }
    imgStatReq.data_size=size;
    imgStatReq.width=width;
    imgStatReq.height=height;
    rtx_test_count=0;
    post processImgStatRadio();
    return SUCCESS;
  }


  //RADIO-photo

  task void processPhotoRadio()
  {
    uint32_t buf_offset;
    uint8_t len;
    photo_frame_part_t *msgData =
      (photo_frame_part_t *)call RadioPacket.getPayload(&tx_msg, sizeof(photo_frame_part_t));
	
   
    buf_offset = photoReq.part_id*PHOTO_DATA_LENGTH;//<<BIGMSG_DATA_SHIFT;
 
    if (buf_offset >= total_size)
    {
      buffer = 0;
	
      signal RadioMsg.sendPhotoRadioDone(FAIL);
      return;
    }

    len = (total_size - buf_offset < PHOTO_DATA_LENGTH) ? total_size - buf_offset : PHOTO_DATA_LENGTH;
     //last packet
    if(total_size-buf_offset-len==0) last_photo_msg=1;
    msgData->part_id = photoReq.part_id;
    memcpy(msgData->buf,&(buffer[buf_offset]),len);
    len = PHOTO_DATA_LENGTH;
 
	if(busy==0){

		     call Ack.requestAck(&tx_msg);
	 	    if (call RadioPhotoSend.send(DEST, &tx_msg, len+PHOTO_HEADER_LENGTH) != SUCCESS){
		     post processPhotoRadio(); 

		   }else{
			 busy=1;
			}
	}
	else{
		      post processPhotoRadio(); 
	}
	
  }

  event void TimerWait.fired(){
  	post processPhotoRadio();
  }

  event void RadioPhotoSend.sendDone(message_t* bufPtr, error_t error)
  {
      photo_frame_part_t *msgData =
      (photo_frame_part_t *)call RadioPacket.getPayload(bufPtr, sizeof(photo_frame_part_t));
	busy=0;
	
	if(error==SUCCESS && call Ack.wasAcked(bufPtr)){ 

       		call Leds.led1Toggle();
		if (!last_photo_msg){
			photoReq.part_id++;
			if(photo_pause==1){
				pause_time_temp=- call TimerPhotoPause.getNow();
				call TimerPhotoPause.startOneShot(PHOTO_PAUSE);
			}
			else {
				call TimerWait.startOneShot(20);
				// post processPhotoRadio();
			}
		}   
	        else {
			//test
			send_pkt_test=1;
			sending_photo=0;
			signal RadioMsg.sendPhotoRadioDone(SUCCESS); 
		}
		
	}
	else { 
	      rtx_test_count++;
	      post processPhotoRadio();
	 
	}
     
   }

 command error_t RadioMsg.sendPhotoRadio(uint8_t *start_buf, uint32_t size)
  {
	
    if (size==0 )
    {
     signal RadioMsg.sendPhotoRadioDone(FAIL);
      return FAIL;
    }

    buffer = start_buf;
    photoReq.part_id = 0;
    last_photo_msg=0;
    total_size = size;
    post processPhotoRadio();
    return SUCCESS;
  }


   //RADIO-Video

  task void processVideoFrameRadio()
  {
    video_frame_part_t *msgData =
     (video_frame_part_t *)call RadioPacket.getPayload(&tx_msg, sizeof(video_frame_part_t));

    uint32_t buf_offset;
    uint8_t len;
    
    buf_offset = (videoReq.part_id-1)*VIDEO_DATA_LENGTH;

    if (buf_offset >= total_size)
    {

      buffer = 0;
      signal RadioMsg.sendVideoFrameRadioDone(FAIL);
      return;
    }

    len = (total_size - buf_offset < VIDEO_DATA_LENGTH) ? total_size - buf_offset : VIDEO_DATA_LENGTH;
    memcpy(msgData->buf,&(buffer[buf_offset]),len);

    if(total_size-buf_offset-len==0){
		last_video_msg=1;
		msgData->part_id=0;
    }
    else msgData->part_id = videoReq.part_id;	   

    msgData->frame_id=videoReq.frame_id;
    len = VIDEO_DATA_LENGTH;

	if(busy==0){
		busy=1;
		call Ack.requestAck(&tx_msg);
	 	if (call RadioVideoSend.send(DEST, &tx_msg, len+VIDEO_HEADER_LENGTH) != SUCCESS){
		 busy=0;		 
		   post processVideoFrameRadio();
		}
	}
	else{
		post processVideoFrameRadio();
	}
	
  }

   event void TimerVideoWait.fired(){
	post processVideoFrameRadio();	
   }


   command error_t RadioMsg.sendVideoFrameRadio(uint8_t *start_buf, uint32_t size,uint8_t frame_num)
   {
     if (size==0 )
    {
      signal RadioMsg.sendVideoFrameRadioDone(FAIL);
      return FAIL;
    }

    buffer = start_buf;
    videoReq.frame_id=frame_num;
    videoReq.part_id = 1;
    last_video_msg=0;
    rtx_count=0;
    total_size = size;

    post processVideoFrameRadio();
    return SUCCESS;
  }

  event void RadioVideoSend.sendDone(message_t* bufPtr, error_t error)
  {
	   
		busy=0;	
 	   if((error!=SUCCESS || !call Ack.wasAcked(bufPtr)) && rtx_count<MAX_RTX ) {
		rtx_count++;
		rtx_test_count++;
	        post processVideoFrameRadio();
	      return;
	    }
     		call Leds.led1Toggle();
	   if (!last_video_msg)
	    {
		rtx_count=0;
		videoReq.part_id++;
	        post processVideoFrameRadio();

    	    }
	    else
	      signal RadioMsg.sendVideoFrameRadioDone(SUCCESS);
  
  }


/****************************************************************************
*
*	SERIAL COMMUNICATION
*
*****************************************************************************/



  //SERIAL-Imgstat
   task void processImgStat(){
	
    img_data = (img_stat_t *)call RadioPacket.getPayload(&stat_msg, sizeof(img_stat_t));

    img_data->data_size = imgStatReq.data_size;
    img_data->width=imgStatReq.width;
    img_data->height=imgStatReq.height;
  

	if(busy==0){
	     if(call SerialImgstatSend.send(AM_BROADCAST_ADDR, &stat_msg, sizeof(img_stat_t))!=SUCCESS){
		post processImgStat();		
		}		
		else busy=1;
        }
        else{
		post processImgStat();
	}
	
   }


 event void SerialImgstatSend.sendDone(message_t* bufPtr, error_t error)
  {
	busy=0;
 	if (error!=SUCCESS)
	    {
	      post processImgStat();
	      return;
	    }
	else    signal RadioMsg.sendImgStatDone(SUCCESS);
  }

  command error_t RadioMsg.sendImgStat(uint16_t width, uint16_t height, uint32_t size)
  {
		
    /*if (size==0 )
    {
      signal RadioMsg.sendImgStatDone(FAIL);
      return FAIL;
    }*/
    imgStatReq.data_size=size;
    imgStatReq.width=width;
    imgStatReq.height=height;
    rtx_test_count=0;
    post processImgStat();
    return SUCCESS;
  }



  //SERIAL-Photo

  task void processPhoto()
  {
    photo_frame_part_t *msgData =
      (photo_frame_part_t *)call SerialPacket.getPayload(&tx_msg, sizeof(photo_frame_part_t));
    uint32_t buf_offset;
    uint8_t len;

    buf_offset = photoReq.part_id*PHOTO_DATA_LENGTH;

    if (buf_offset >= total_size)
    {
      buffer = 0;
      signal RadioMsg.sendPhotoDone(FAIL);
      return;
    }
	
    len = (total_size - buf_offset < PHOTO_DATA_LENGTH) ? total_size - buf_offset : PHOTO_DATA_LENGTH;

    if(total_size-buf_offset-len==0) last_photo_msg=1;
    msgData->part_id = photoReq.part_id;
    memcpy(msgData->buf,&(buffer[buf_offset]),len);

    len = PHOTO_DATA_LENGTH;

    if (call SerialSend.send(AM_BROADCAST_ADDR, &tx_msg, len+PHOTO_HEADER_LENGTH) != SUCCESS)
      post processPhoto();
  }

  command error_t RadioMsg.sendPhoto(uint8_t *start_buf, uint32_t size)
  {
    if (size==0 )
    {
      signal RadioMsg.sendPhotoDone(SUCCESS);
      return FAIL;
    }
	VIDEO_ON=0;
	rtx_test_count=0;
    	buffer = start_buf;
    	photoReq.part_id = 0;
    	last_photo_msg=0;
   	total_size = size;
    	post processPhoto();
    	return SUCCESS;
  }

  event void SerialSend.sendDone(message_t* bufPtr, error_t error)
  {
	
	
	    if (error!=SUCCESS)
	    {
	      post processPhoto();
	      return;
	    }
   	    if (!last_photo_msg)
	    {

	      photoReq.part_id++;
		post processPhoto();

    	    }
	    else
	      signal RadioMsg.sendPhotoDone(SUCCESS);
   }


  //SERIAL-Video
  task void processVideoFrame()
  {
    video_frame_part_t *msgData =
      (video_frame_part_t *)call SerialPacket.getPayload(&tx_msg, sizeof(video_frame_part_t));
    uint32_t buf_offset;
    uint8_t len;

    buf_offset = (videoReq.part_id-1)*VIDEO_DATA_LENGTH;
	
    if (buf_offset >= total_size)
    {
      buffer = 0;
      signal RadioMsg.sendVideoFrameDone(FAIL);
      return;

    }

    len = (total_size - buf_offset < VIDEO_DATA_LENGTH) ? total_size - buf_offset : VIDEO_DATA_LENGTH;
    msgData->frame_id=videoReq.frame_id;

    if(total_size-buf_offset-len==0){
		last_video_msg=1;
		msgData->part_id=0;
    }
    else msgData->part_id = videoReq.part_id;		

    memcpy(msgData->buf,&(buffer[buf_offset]),len);
	
    len = VIDEO_DATA_LENGTH;

    if (call VideoSerialSend.send(AM_BROADCAST_ADDR, &tx_msg, len+VIDEO_HEADER_LENGTH) != SUCCESS)
	    post processVideoFrame();

	
  }

  command error_t RadioMsg.sendVideoFrame(uint8_t *start_buf, uint32_t size,uint8_t frame_num)
  {
    if (size==0 )
    {
      signal RadioMsg.sendVideoFrameDone(SUCCESS);
      return FAIL;
    }
    buffer = start_buf;
    videoReq.frame_id=frame_num;
    videoReq.part_id = 1;
   last_video_msg=0;
   total_size = size;
    post processVideoFrame();
    return SUCCESS;
  }

  event void VideoSerialSend.sendDone(message_t* bufPtr, error_t error)
  {
	if (error!=SUCCESS)
	    {
	      post processVideoFrame();
	      return;
	    }
   	    if (!last_video_msg)
	    {
	      videoReq.part_id++;
	      post processVideoFrame();
    	    }
	    else  signal RadioMsg.sendVideoFrameDone(SUCCESS);

  }

 //Default events declarations

  default event void RadioMsg.sendPhotoDone(error_t success)
  {
  }
 default event void RadioMsg.sendVideoFrameDone(error_t success)
  {
  }
 default event void RadioMsg.sendPhotoRadioDone(error_t success)
  {
  }
 default event void RadioMsg.sendVideoFrameRadioDone(error_t success)
  {
  }
 default event void RadioMsg.sendImgStatRadioDone(error_t success)
  {
  }
 default event void RadioMsg.sendTimerDataRadioDone(error_t success)
  {
  }
 default event void RadioMsg.sendImgStatDone(error_t success)
  {
  }


}


