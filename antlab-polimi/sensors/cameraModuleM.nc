/*
* Copyright (c) 2006 Stanford University.
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
* - Neither the name of the Stanford University nor the names of
*   its contributors may be used to endorse or promote products derived
*   from this software without specific prior written permission
*
* THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
* ``AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
* LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
* FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL STANFORD
* UNIVERSITY OR ITS CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
* INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
* (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
* SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
* HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
* STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
* ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
* OF THE POSSIBILITY OF SUCH DAMAGE.
*/ 
/**
 * @author Brano Kusy (branislav.kusy@gmail.com)
 */

/*
  Modified by RMK, Crossbow Technology
*/
/*
 * Modified by: Stefano Paniga
 * contact: stefano.paniga@mail.polimi.it
 */

#include "xbowCam.h"
#include "cameraModule.h"
#include "sdram.h"
#include "jpeghdr.h"
#include "OV7670.h"


module cameraModuleM {

  provides
  {
    interface cameraModule;
  }

  uses {
    interface Boot;
    interface Leds;
    interface RadioMsg;
    interface Jpeg;
    interface Dpcm;
    interface Timer<TMilli> as TimerPause;
    interface Timer<TMilli> as TimerAcquire;
    interface Timer<TMilli> as TimerVideoSend;
    interface XbowCam;
    interface Init as CameraInit;
    interface Packet;
    interface Receive as CmdReceive;

  }
}

implementation {

  uint32_t mse;

  frame_t* frame;
  frame_t* frame1;
  frame_t* frame2;
  uint8_t DPCM_SEQ=20;
  uint8_t JPEG_QUALITY=9;
  uint8_t DPCM_QUALITY=6; // 1 (50%) 2 (25%) 5 (10%) 10 (5%)
  img_stat_t img_stat;
  uint8_t dpcm_counter=0;
  norace uint8_t acquire_counter=0;
  uint8_t frame_num=0;
  uint8_t frame_numA=0;
  uint8_t frame_numB=0;
  uint8_t *dpcm_buffer = (uint8_t *)BUF3_FRAME_ADDRESS;
  uint8_t img_size=0;
  uint16_t time_totalProc=0;
  uint8_t FULL_FRAME_PERIOD=240;
  uint8_t command_type=0;
  uint8_t video_pause=0;
  task void fixAcqBuffer();
  task void codeFrame();
  task void acquireTask();
  uint16_t VIDEO_PAUSE=400;
  uint32_t pause_time_temp=0;
  uint32_t pause_time=0;
  uint8_t buf1_busy=0;
  uint8_t buf2_busy=0;
  uint8_t dpcm1_ready=0;
  uint8_t dpcm2_ready=0;
  uint8_t  dpcm_send_num=0;
  uint8_t  send_busy=0;
  uint8_t sending_photo=0;
  uint8_t send_pause=0;


	//----------------------------------------------------------------------------
	// StdControl Interface Implementation
	//----------------------------------------------------------------------------  
	event void Boot.booted() {

          img_stat.width = 0;
	  img_stat.height = 0;
	  command_type = 0;
	  //init counters
	  dpcm_counter=0;
	  acquire_counter=0; 
	  video_pause=0;
  	  sending_photo=0;
	  call CameraInit.init();
	  call Jpeg.init();
   
	}


  void *sendAddr;
  uint32_t sendSize;
  void *dpcmAddrA;
  uint32_t dpcmSizeA;
  void *dpcmAddrB;
  uint32_t dpcmSizeB;


 // Serial Imgstat
 event void RadioMsg.sendImgStatDone(error_t success){

	if(success!=SUCCESS) {
		call Leds.led0On();
		return;
	}
#ifdef PSNR_ENV
	//simulation of the frame sending. To unlock the  acquire/send buffer checks
    if(dpcm_send_num==0){
        dpcm_send_num++;
        buf1_busy=0;        
    }
    else {
        buf2_busy=0;
        dpcm_send_num=0;
    }
#else
	call RadioMsg.sendPhoto(sendAddr,sendSize);
#endif

 }

 // Radio Imgstat
 event void RadioMsg.sendImgStatRadioDone(error_t success){

	if(success!=SUCCESS) {
		call Leds.led0On();		
		return;
	}
	
	call RadioMsg.sendPhotoRadio(sendAddr,sendSize);
 }

 // Serial Photo
 event void RadioMsg.sendPhotoDone(error_t error) {
	if(error != SUCCESS) call Leds.led0On();
	else call Leds.led1Toggle();
	sending_photo=0;
 }

 // Radio Photo 
  event void RadioMsg.sendPhotoRadioDone(error_t error) {

	if(error!=SUCCESS) call Leds.led0On();
	call Leds.led2Off();
	sending_photo=0;
  }

  // Serial Video
  event void RadioMsg.sendVideoFrameDone(error_t error) {
	if(error!=SUCCESS) {
		call Leds.led0On();
		return;
	}
	
	// free the used buffer
	if(dpcm_send_num==0){
		dpcm_send_num++;
		buf1_busy=0;		
	}
	else {
		buf2_busy=0;
		dpcm_send_num=0;
	}
	
	if ((command_type & VIDEO_STOP)){
		command_type &= ~VIDEO_ON;
	}
	else if(video_pause==1){
		call TimerPause.startOneShot(VIDEO_PAUSE);
	}
	else send_busy=0; 
	
  }

  // Radio Video
  event void RadioMsg.sendVideoFrameRadioDone(error_t error) {
	
		if(error!=SUCCESS) {
				call Leds.led0On();
				return;
		}
	
		// free the used buffer
		if(dpcm_send_num==0){
			dpcm_send_num++;
			buf1_busy=0;		
		}
	        else {
			buf2_busy=0;
			dpcm_send_num=0;
		}
		
		if ((command_type & VIDEO_STOP)){
			command_type &= ~VIDEO_ON;
		}
		else if(video_pause==1){
			call TimerPause.startOneShot(VIDEO_PAUSE);
		}
		else send_busy=0; 
		
  }


  task void startCompression() {
	void *addrJpeg = (void *)JPEG_FRAME_ADDRESS; 
	uint16_t jpegMaxSize = 65000;
    
    call Leds.led2On();

    if (command_type & IMG_COL) {
      // by this time, buffer should be fixed and contain 3 bytes per pixel (r,g,b)

      jpegMaxSize = call Jpeg.encodeColJpeg(frame->buf, addrJpeg, jpegMaxSize, img_stat.width, img_stat.height, JPEG_QUALITY, 3);
    } else {
      // buffer reading tweak: only every 2nd byte is read
      jpegMaxSize = call Jpeg.encodeJpeg(&frame->buf[1], addrJpeg, jpegMaxSize, img_stat.width, img_stat.height, JPEG_QUALITY, 2, 0);

    }  
    img_stat.tmp1 = jpegMaxSize;
    img_stat.tmp2 = CODE_HEADER_SIZE;

    sendAddr = addrJpeg;
    sendSize = jpegMaxSize;


    call Leds.led2Off();
    
#ifdef SERIAL_MODE
    	call RadioMsg.sendImgStat(img_stat.width,img_stat.height,sendSize);
#else
	call RadioMsg.sendImgStatRadio(img_stat.width,img_stat.height,sendSize);
#endif

  }

  task void startProcessing() {

    sendAddr = frame->buf;
    sendSize = frame->header->size;
     
#ifdef SERIAL_MODE
	call RadioMsg.sendImgStat(img_stat.width,img_stat.height,sendSize);
#else
	call RadioMsg.sendImgStatRadio(img_stat.width,img_stat.height,sendSize);
#endif
  }

  /*
  * Compress the frame and send it
  *
  */

  task void codeFrame() {

	void *addrFrame;
	uint16_t frameMaxSize = 25000;

	
	if(dpcm_counter==0) {
		addrFrame=(void*)DPCM1_FRAME_ADDRESS;
		frame=frame1;
	}
	else {
		addrFrame=(void*)DPCM2_FRAME_ADDRESS;
		frame=frame2;
	}

	if(frame_num==FULL_FRAME_PERIOD || (command_type & RESET_DPCM)){
		 frame_num=0;
	         command_type &= ~RESET_DPCM;	
	}

// dpcm_encode modified to compute the mse value
#ifdef PSNR_ENV
	frameMaxSize = call Dpcm.dpcm_encode(frame->buf,addrFrame,img_stat.width,img_stat.height,DPCM_QUALITY,frame_num%DPCM_SEQ,frameMaxSize,dpcm_buffer,&mse);
#else
	frameMaxSize = call Dpcm.dpcm_encode(frame->buf,addrFrame,img_stat.width,img_stat.height,DPCM_QUALITY,frame_num%DPCM_SEQ,frameMaxSize,dpcm_buffer);
#endif



	if(dpcm_counter==0) {
		dpcmAddrA  = addrFrame;
	    	dpcmSizeA  = frameMaxSize;
		frame_numA = frame_num;
		frame_num++;
		dpcm1_ready=1;
		dpcm_counter++;
	}
	else {
		dpcmAddrB  = addrFrame;
	    	dpcmSizeB  = frameMaxSize;
		frame_numB = frame_num;
		frame_num++;
		dpcm2_ready=1;
		dpcm_counter=0;
	}

// Mse-test msg
#ifdef PSNR_ENV
	 call RadioMsg.sendImgStat(img_stat.width,img_stat.height,mse);
#endif

  }

 event void TimerVideoSend.fired(){
	if(send_busy==1 || send_pause==1) return;
	else if(dpcm1_ready==1 && dpcm_send_num==0){
		 dpcm1_ready=0;
		 send_busy=1;
#ifdef SERIAL_MODE		 
		 call RadioMsg.sendVideoFrame(dpcmAddrA,dpcmSizeA,frame_numA);
#else
		call RadioMsg.sendVideoFrameRadio(dpcmAddrA,dpcmSizeA,frame_numA);
#endif

	}
	else if(dpcm2_ready==1 && dpcm_send_num==1){
		 dpcm2_ready=0;
		 send_busy=1;

#ifdef SERIAL_MODE		 
	call RadioMsg.sendVideoFrame(dpcmAddrB,dpcmSizeB,frame_numB);  
#else
	call RadioMsg.sendVideoFrameRadio(dpcmAddrB,dpcmSizeB,frame_numB);
#endif
	

		 
	}
 }


	
  task void fixAcqBuffer() {
   	
    int32_t i;
    // reset the camera to avoid progressive whitening of the pictures 
    call CameraInit.init();
    
    if(command_type & VIDEO_ON){
        post codeFrame();
	return;	
    }
    else {

    	if (!(command_type & IMG_COL)) {
      		// BW JPG encoder can read every second byte, no fix required
      		if (!(command_type & IMG_JPG)) {
			for (i = 0; i < frame->header->size / 2; i++) {
			  frame->buf[i] = frame->buf[2 * i + 1];
			}
			frame->header->size = frame->header->size / 2;
			/*
			  for (i = 0; i < frame->header->size / 2; i++)
			    frame->buf[i] = frame->buf[2 * i];
			  frame->header->size = frame->header->size / 2;
			*/	
		}
    	} 
	else {
      		if (command_type & IMG_JPG) {
 			// COL non-JPG images don't need fix, it's more efficient to xmit 2 bytes than 3
			for (i = (frame->header->size / 2 - 1); i >= 0; i--) {
	  		uint8_t b1 = frame->buf[2 * i];
		  	uint8_t b2 = frame->buf[2 * i + 1];

	  		frame->buf[3 * i] = b2 & 0xF8; // red
	  		frame->buf[3 * i + 1] = ((b2 & 0x07) << 5) | ((b1 & 0xE0) >> 3); // green
	  		frame->buf[3 * i + 2] = (b1 & 0x1F) << 3; // blue
			}
		frame->header->size = frame->header->size / 2 * 3;
      		}
        }	

    	if (command_type & IMG_JPG)  post startCompression();
    	else post startProcessing();
    }

  }



  async event void XbowCam.acquireDone() {

	
	if(acquire_counter==0)	acquire_counter++;
	else acquire_counter=0;
	
	post fixAcqBuffer();
  }


  task void acquireTask() {

    void* acquire_frame;


    if ((command_type & VIDEO_ON)) {

    	if(acquire_counter==0) {
		buf1_busy=1;
		acquire_frame=(void*)BASE1_FRAME_ADDRESS;
		frame1= call XbowCam.acquire(COLOR_UYVY,acquire_frame,img_size, 0);
	}
	else {
		buf2_busy=1;
		acquire_frame=(void*)BASE2_FRAME_ADDRESS;
		frame2= call XbowCam.acquire(COLOR_UYVY,acquire_frame,img_size, 0);

	}

    } 
    else if (!(command_type & IMG_COL)) {
	
		frame= call XbowCam.acquire(COLOR_UYVY,(void*)BASE_FRAME_ADDRESS,img_size, 0);
    } 
    else {

      		frame = call XbowCam.acquire(COLOR_RGB565, (void*)BASE_FRAME_ADDRESS, img_size, 0); //subSamp, 0);
    }
	
  }

event void TimerAcquire.fired(){
	if(buf1_busy==0 || buf2_busy==0) post acquireTask();
}

  
// get a frame after a pause
event void TimerPause.fired() {
		if(video_pause==1) {
			send_pause=1;
			call TimerPause.startOneShot(VIDEO_PAUSE);
			return;
		}
		else send_pause=0;
		
  }


// RADIO comm: command manager
command error_t cameraModule.radio_command_manager(cmd_msg_t *cmdMsg){

	img_stat.type= 0;
	
	
    if((command_type & VIDEO_ON)){
	if((cmdMsg->cmd & 0x10) == 0x10){
		command_type |= VIDEO_STOP;
		call TimerAcquire.stop();
		call TimerVideoSend.stop();
     	}
    	else if((cmdMsg->cmd & 0x20) == 0x20){
		command_type |= RESET_DPCM;
    	}
	else if((cmdMsg->cmd & 0x40) == 0x40){
		video_pause=1;
	}
	else if((cmdMsg->cmd & 0x80) == 0x80){
		video_pause=0;
	}
   } 
   else if(cmdMsg->cmd <= 0x08 && sending_photo==0){
   
    	command_type=0;
    	if ((cmdMsg->cmd & 0x01) == 0x01 && !(command_type & VIDEO_ON)) { // color
      		command_type |= IMG_COL;
      		img_stat.type |= IMG_COL;
    	} 
    
   	if ((cmdMsg->cmd & 0x02) == 0x02 && !(command_type & VIDEO_ON)) { // size
		  img_size = SIZE_VGA;
	          img_stat.width = VGA_WIDTH;
		          img_stat.height = VGA_HEIGHT;
		  img_stat.type |= SIZE_VGA;

	} 
	else {
      		  img_size = SIZE_QVGA;
		  img_stat.type |= SIZE_QVGA;
		  img_stat.width = QVGA_WIDTH;
		  img_stat.height = QVGA_HEIGHT;
	}
      
    	if ((cmdMsg->cmd & 0x04) == 0x04 && !(command_type & VIDEO_ON)) { // compression
	      command_type |= IMG_JPG;
	      img_stat.type |= IMG_JPG;
	}

	if ((cmdMsg->cmd & 0x08) == 0x08 && !(command_type & VIDEO_ON)) { // start video
  	        command_type |= VIDEO_ON;
 		img_stat.type |= VIDEO_ON;
		img_size = SIZE_QVGA;
	  	img_stat.type |= SIZE_QVGA;
	  	img_stat.width = QVGA_WIDTH;
		img_stat.height = QVGA_HEIGHT;
		
	        acquire_counter=0; // choose between the 2 acquire buffers
		dpcm_counter=0; // choose between the 2 DPCM buffer to stre dpcm_encode output
		frame_num=0; 
		pause_time=0;  
		buf1_busy=0;
		buf2_busy=0;
		dpcm1_ready=0;     //Variables to control the operations on the sending buffers
		dpcm2_ready=0;
                dpcm_send_num=0;
		send_busy=0;   
		call TimerAcquire.startPeriodic(200); // start the timer that controls the acquire operations
		call TimerVideoSend.startPeriodic(100); // start the timer that controls the sending operations
    	}else{
		sending_photo=1;
		post acquireTask();
	}
   }	    
	return SUCCESS;
}


  /* ---------------- SERIAL DEBUG/REMOTE COMMANDS -------------------*/

  event message_t *CmdReceive.receive(message_t *msg, void *payload, uint8_t len) {

    cmd_msg_t *cmdMsg = (cmd_msg_t *)payload;
	
    img_stat.type=0;
    if((command_type & VIDEO_ON) && cmdMsg->cmd > 0x08){
	if((cmdMsg->cmd & 0x10) == 0x10){
		command_type |= VIDEO_STOP;
		call TimerAcquire.stop();
		call TimerVideoSend.stop();
     	}
    	else if((cmdMsg->cmd & 0x20) == 0x20){
		// force dpcm reset
		command_type |= RESET_DPCM;
    	}
	else if((cmdMsg->cmd & 0x40) == 0x40){
		video_pause=1;
	}
    }
    else if(cmdMsg->cmd <= 0x08 && sending_photo==0){
    //reset command type    
    command_type=0;
    if ((cmdMsg->cmd & 0x01) == 0x01 && !(command_type & VIDEO_ON)) { // color
      command_type |= IMG_COL;
      img_stat.type |= IMG_COL;
    } 
   
   if ((cmdMsg->cmd & 0x02) == 0x02 && !(command_type & VIDEO_ON)) { // size
	  img_size = SIZE_VGA;
          img_stat.width = VGA_WIDTH;
          img_stat.height = VGA_HEIGHT;
	  img_stat.type |= SIZE_VGA;

    } 
   else {
      	  img_size = SIZE_QVGA;
	  img_stat.type |= SIZE_QVGA;
	  img_stat.width = QVGA_WIDTH;
	  img_stat.height = QVGA_HEIGHT;
    }
      
    if ((cmdMsg->cmd & 0x04) == 0x04 && !(command_type & VIDEO_ON)) { // compression
      command_type |= IMG_JPG;
    img_stat.type |= IMG_JPG;
    }

    if ((cmdMsg->cmd & 0x08) == 0x08 && !(command_type & VIDEO_ON)) { // start video
	   	command_type |= VIDEO_ON;
		command_type &= ~VIDEO_STOP;
 		img_stat.type |= VIDEO_ON;
  		img_size = SIZE_QVGA;
	  	img_stat.type |= SIZE_QVGA;
	  	img_stat.width = QVGA_WIDTH;
		img_stat.height = QVGA_HEIGHT;
		
	        acquire_counter=0;
		dpcm_counter=0;
		frame_num=0; 
		pause_time=0;
		buf1_busy=0;
		buf2_busy=0;
		dpcm1_ready=0;
		dpcm2_ready=0;
                dpcm_send_num=0;
		send_busy=0;
		send_pause=0;
		call TimerAcquire.startPeriodic(200);
#ifndef PSNR_ENV
		call TimerVideoSend.startPeriodic(100); 
#endif	
		post acquireTask();
	   }else {

		sending_photo=1;
		post acquireTask();
	}    
    } 	
    
	return msg;
}

	
}

