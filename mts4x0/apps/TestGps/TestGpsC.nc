
/***********************************************************************/
/* This program is free software; you can redistribute it and/or       */
/* modify it under the terms of the GNU General Public License as      */
/* published by the Free Software Foundation; either version 2 of the  */
/* License, or (at your option) any later version.                     */
/*                                                                     */
/* This program is distributed in the hope that it will be useful, but */
/* WITHOUT ANY WARRANTY; without even the implied warranty of          */
/* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU   */
/* General Public License for more details.                            */
/*                                                                     */
/* Written and (c) by INRIA, Christophe Braillon                       */
/*                           Aurélien Francillon                       */
/* Contact <aurelien.francillon@inrialpes.fr> for comment, bug reports */
/* and possible alternative licensing of this program                  */
/***********************************************************************/
/**
 * @file   TestGpsC.nc
 * @author Christophe Braillon
 * @author Aurelien Francillon
 * @date   Fri May  9 01:50:04 2008
 *
 * @brief test application for the gps driver sends raw GGA frames to
 *  the serial port
 *
 */

module TestGpsC
{
  uses
  {
		interface Boot;
		interface Leds;
		interface Init as GPSInit;
		interface SplitControl as GPSControl;
		interface MTS400Sensor as GPS;

		// Serial
		interface Packet as SerialPacket;
		interface AMPacket as SerialAMPacket;
		interface AMSend as SerialAMSend;
		interface SplitControl as SerialAMControl;

    interface Timer<TMilli> as FlushTimer;
		interface SplitControl as PrintfControl;
    interface PrintfFlush;

	}
}

implementation
{
	message_t serialPkt;
	bool serialBusy = FALSE;

	#define MAX_LEN 30

	typedef nx_struct TextMsg
	{
		nx_uint8_t length;
		nx_uint8_t data[MAX_LEN];
	} TextMsg;

	event void Boot.booted()
	{
		call SerialAMControl.start();
    call FlushTimer.startPeriodic(500);
    call GPSInit.init();
      //call GPSInit.
	}

	event void FlushTimer.fired(){
    call PrintfFlush.flush();
	}

  event void PrintfControl.startDone(error_t error){}
  event void PrintfControl.stopDone(error_t error){}
  event void PrintfFlush.flushDone(error_t error){}

	event void GPSControl.startDone(error_t error)
	{
		call Leds.led1On();
	}

	event void GPS.dataReady(uint8_t *buf, uint16_t length)
	{
		uint8_t i;

		call Leds.led2Toggle();

		if(!serialBusy)
		{
			TextMsg *pkt = (TextMsg*)(call SerialPacket.getPayload(&serialPkt, sizeof(TextMsg)));

			pkt->length = length>MAX_LEN?MAX_LEN:length;
			for(i = 0; i < pkt->length; i++)
			{
				pkt->data[i] = buf[i];
			}

			if(call SerialAMSend.send(AM_BROADCAST_ADDR, &serialPkt, sizeof(TextMsg)) == SUCCESS)
			{
				serialBusy = TRUE;
			}
		}
	}

	event void SerialAMControl.startDone(error_t err)
	{
		if (err == SUCCESS)
		{
      //			call GPSInit.init();
			call GPSControl.start();
		}
		else
		{
			call SerialAMControl.start();
		}
	}

	event void SerialAMSend.sendDone(message_t* msg, error_t err)
	{
		if (&serialPkt == msg)
		{
			serialBusy = FALSE;
		}
	}

	// Unused events
	event void SerialAMControl.stopDone(error_t err) {}
	event void GPSControl.stopDone(error_t error) {}
}
