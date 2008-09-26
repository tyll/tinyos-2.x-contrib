
module MyGpsPacket {
  provides {
    interface StdControl as GpsControl;
    interface GPSReceiveMsg as Receive;

  }
  uses 
    {
      interface HPLUART as UART;
      interface Leds;
    }

}

implementation
{

#include "gps.h"

  GPS_Msg buffer;
  uint16_t rxCount;
  bool valid, recving;
  //TOS_MsgPtr bufferPtr;
  GPS_MsgPtr bufferPtr;

  command result_t GpsControl.init()
    {
      atomic {
	valid = FALSE;
	rxCount = 0;
	buffer.length = 0;
	buffer.crc = 0;
	bufferPtr = &buffer;
	recving = FALSE;
      }
      call Leds.init();
      call UART.init();
      return SUCCESS;
    }

  command result_t GpsControl.start()
    {
      
      atomic {
	recving = FALSE;
	valid = FALSE;
	rxCount = 0;
      }
      return SUCCESS;
    }

  command result_t GpsControl.stop()
    {
      return SUCCESS;
    }

  task void recvTask()
    {
      GPS_MsgPtr tbuf;
      //call Leds.redToggle();
        tbuf = signal Receive.receive(bufferPtr);
	atomic {
	  bufferPtr = (GPS_MsgPtr)tbuf;
	  recving = FALSE;
	  valid = FALSE;
	}
    }

  event async result_t UART.get(uint8_t bdata)
    {
      //call UART.put(bdata);
      if (recving)
	{
	  return SUCCESS;
	}

      if (bdata == GPS_PACKET_START)
	{
	  
	  rxCount = 0;
	  bufferPtr->length = rxCount;
	  valid = TRUE;
	  return SUCCESS;
	}

      if (rxCount >= GPS_DATA_LENGTH-1)
	{
	  //too long for valid packet.
	  rxCount = 0;
	  valid = FALSE;
	  return SUCCESS;
	}

      if (valid)
	{
	  atomic {
	    bufferPtr->data[rxCount] = bdata;
	    rxCount++;
	    bufferPtr->length = rxCount;
	  
	    if (bdata == GPS_PACKET_END2)
	      {
		recving = TRUE;
		post recvTask();
	      }
	  }//atomic
	}// if valid
      return SUCCESS;
    }
  
 
  event async result_t UART.putDone() {
    
    return SUCCESS;
  }



}
    
