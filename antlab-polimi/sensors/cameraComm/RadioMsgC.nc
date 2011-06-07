/*
 * Author: Stefano Paniga
 * contact: stefano.paniga@mail.polimi.it
 */ 
#include "config.h"


configuration RadioMsgC
{
	provides
	{
		interface RadioMsg;
	}
}

implementation
{
	components MainC, RadioMsgM, LedsC,cameraModuleC;
	components SerialActiveMessageC as Serial;
	components ActiveMessageC as RadioAMC;
	components new AMSenderC(AM_RADIO_IMGSTAT) as ImgStatSender; 
	components new AMSenderC(AM_RADIO_PHOTO) as PhotoSender; 
	components new AMSenderC(AM_RADIO_VIDEO) as VideoSender; 
	components new AMReceiverC(AM_RADIO_CMD) as CmdReceiver;
	//boot
	RadioMsg = RadioMsgM.RadioMsg;
	RadioMsgM.cameraModule -> cameraModuleC;
	RadioMsgM.Boot -> MainC;
	RadioMsgM.Leds -> LedsC;
	//serial	
	RadioMsgM.SerialPacket -> Serial;
	RadioMsgM.SerialControl -> Serial;
	RadioMsgM.SerialSend -> Serial.AMSend[AM_PHOTO];
	RadioMsgM.SerialImgstatSend -> Serial.AMSend[AM_IMGSTAT];
	RadioMsgM.VideoSerialSend -> Serial.AMSend[AM_VIDEO_FRAME_PART];
	//RADIO
	RadioMsgM.RadioImgStatSend->ImgStatSender;
	RadioMsgM.RadioPhotoSend-> PhotoSender;
	RadioMsgM.RadioVideoSend-> VideoSender;
	RadioMsgM.ReceiveRadioCmd-> CmdReceiver;
	RadioMsgM.RadioPacket-> RadioAMC;
	RadioMsgM.AMControl -> RadioAMC;
	//ack
	RadioMsgM.Ack -> RadioAMC;
	
	
	//TIMERS
	components new TimerMilliC() as TimerWait;
  	RadioMsgM.TimerWait -> TimerWait;
	components new TimerMilliC() as TimerPhotoPause;
	RadioMsgM.TimerPhotoPause -> TimerPhotoPause;
  	
  	


}

