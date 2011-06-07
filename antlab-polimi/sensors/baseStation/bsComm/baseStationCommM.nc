/*
 * Author: Stefano Paniga
 * contact: stefano.paniga@mail.polimi.it
 */
#include "commConfig.h"

module baseStationCommM
{
  provides
  {
    interface baseStationComm;
  }

  uses
  {
    interface Boot;
    interface Packet as SerialPacket;
    interface SplitControl as SerialControl;
    interface AMSend as SerialSend;
  //  interface AMSend as VideoSerialSend;
    //interface Receive;
    interface Leds;
 
  }
}

implementation
{
  uint8_t *buffer;
  bigmsg_frame_request_t req;
  video_frame_request_t videoReq;
  uint32_t total_size;
  message_t tx_msg;
  uint8_t last_sent=0;
  uint8_t acked=0;
  uint8_t last_video_msg=0;

  event void Boot.booted()
  {
    buffer = 0;
    last_video_msg=0;
    call   SerialControl.start();
   
  }
  
  //START DONE

  event void SerialControl.startDone(error_t result) {}

  event void SerialControl.stopDone(error_t result) {}

   //SERIAL-process photo
  task void processFrame()
  {
    bigmsg_frame_part_t *msgData =
      (bigmsg_frame_part_t *)call SerialPacket.getPayload(&tx_msg, sizeof(bigmsg_frame_part_t));
    uint32_t buf_offset;
    uint8_t len;

    buf_offset = req.part_id<<BIGMSG_DATA_SHIFT;

    if (buf_offset >= total_size)
    {
      buffer = 0;
      signal baseStationComm.sendDone(FAIL);
      return;
    }
	
    len = (total_size - buf_offset < BIGMSG_DATA_LENGTH) ? total_size - buf_offset : BIGMSG_DATA_LENGTH;

    msgData->part_id = req.part_id;
    memcpy(msgData->buf,&(buffer[buf_offset]),len);

    len = BIGMSG_DATA_LENGTH;
    		call Leds.led1On();
    if (call SerialSend.send(AM_BROADCAST_ADDR, &tx_msg, len+BIGMSG_HEADER_LENGTH) !=SUCCESS)
      post processFrame();
  }
/*
  //SERIAL process video frame
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
      signal baseStationComm.sendVideoFrameDone(FAIL);
      return;
    }

    len = (total_size - buf_offset < VIDEO_DATA_LENGTH) ? total_size - buf_offset : VIDEO_DATA_LENGTH;
    msgData->frame_id=videoReq.frame_id;
    //set part_id of the last msg to 0
    if(total_size-len-buf_offset!=0)  msgData->part_id = videoReq.part_id;	
    else {
		msgData->part_id=0;
		last_video_msg=1;
	}
    memcpy(msgData->buf,&(buffer[buf_offset]),len);
	
    len = VIDEO_DATA_LENGTH;

  if (call VideoSerialSend.send(AM_BROADCAST_ADDR, &tx_msg, len+BIGMSG_HEADER_LENGTH) != SUCCESS)
	    post processVideoFrame();

	
  }
*/
  //SERIAL 
  command error_t baseStationComm.send(uint8_t *start_buf, uint32_t size)
  {
    if (size==0 )//|| busy==1)
    {
      signal baseStationComm.sendDone(SUCCESS);
      return FAIL;
    }

    buffer = start_buf;
    req.part_id = 0;
    req.send_next_n_parts = size/BIGMSG_DATA_LENGTH;//size>>BIGMSG_DATA_SHIFT;
    total_size = size;
    post processFrame();
    return SUCCESS;
  }
  
/*
   //SERIAL video send 
    command error_t baseStationComm.sendVideoFrame(uint8_t *start_buf, uint32_t size,uint8_t frame_num)
  {
    if (size==0 )
    {
      signal baseStationComm.sendVideoFrameDone(SUCCESS);
      return FAIL;
    }

    buffer = start_buf;
    videoReq.frame_id=frame_num;
    videoReq.part_id = 1;
    last_video_msg=0;
//    videoReq.send_next_n_parts = size/VIDEO_DATA_LENGTH;
    total_size = size;
    post processVideoFrame();
    return SUCCESS;
  }
*/
  //SERIAL RESEND
  command error_t baseStationComm.resend(uint8_t *start_buf, uint16_t from, uint16_t numFrames)
  {
    buffer = start_buf;
    req.part_id = from;
    req.send_next_n_parts = numFrames;
    total_size = numFrames<<BIGMSG_DATA_SHIFT;
    post processFrame();
    return SUCCESS;
  }


  	//SERIAL photo sendDone
  event void SerialSend.sendDone(message_t* bufPtr, error_t error)
  {
	
	
	    if (error==FAIL)
	    {
	      post processFrame();
	      return;
	    }
   	    if (req.send_next_n_parts)
	    {

	      req.part_id++;
	      req.send_next_n_parts--;
		post processFrame();

    	    }
	    else
	      signal baseStationComm.sendDone(SUCCESS);
   }
	//SERIAL video sendDone
/*
	event void VideoSerialSend.sendDone(message_t* bufPtr, error_t error)
  	{
	
		if (error!=SUCCESS)
	    {
	      post processVideoFrame();
	      return;
	    }
   	    if (!last_video_msg)
	    {
		if(videoReq.part_id==254) signal baseStationComm.sendVideoFrameDone(FAIL);
		else{
		      videoReq.part_id++;
		      //videoReq.send_next_n_parts--;
		      post processVideoFrame();
		}
    	    }
	    else{
				call Leds.led1Off();
	      signal baseStationComm.sendVideoFrameDone(SUCCESS);
	    }

	}
*/
 //DONE DECLARATION

  default event void baseStationComm.sendDone(error_t success)
  {
  }
 /* default event void baseStationComm.sendVideoFrameDone(error_t success)
  {
  }*/


}

