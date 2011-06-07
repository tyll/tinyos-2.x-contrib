/*
 * Author: Stefano Paniga
 * contact: stefano.paniga@mail.polimi.it
 */
 
#include "commConfig.h"

configuration baseStationCommC
{
	provides
	{
		interface baseStationComm;
	}
}

implementation
{
	components MainC, baseStationCommM,LedsC;

	baseStationComm = baseStationCommM.baseStationComm;
	baseStationCommM.Boot -> MainC;
	baseStationCommM.Leds -> LedsC;
	components SerialActiveMessageC as Serial;
	baseStationCommM.SerialControl -> Serial;
	baseStationCommM.SerialPacket -> Serial;
	baseStationCommM.SerialSend -> Serial.AMSend[AM_BIGMSG_FRAME_PART];
	//baseStationCommM.VideoSerialSend -> Serial.AMSend[AM_VIDEO_FRAME_PART];



  	


}
