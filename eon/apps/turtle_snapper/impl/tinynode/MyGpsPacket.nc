
module MyGpsPacket {
  provides {
    interface StdControl as GpsControl;
    interface GPSReceiveMsg as Receive;

  }
  uses 
    {
      interface HPLUART as UART;
	  //interface Leds;
    }

}

implementation
{

#include "gps.h"
#define NUMBUFS 2
  GPS_Msg buffer[NUMBUFS];
  norace GPS_MsgPtr writebuf, readbuf;
  
  norace uint16_t rxCount;
  norace bool valid, recving;
  
  uint8_t chksum = 0;
  uint8_t chkstar = 0;
  uint8_t readsum = 0;
  norace uint8_t readstar = 0;
  

  command result_t GpsControl.init()
    {
		
		readbuf = &buffer[0];
		writebuf = &buffer[1];
		//call Leds.init();
      
		valid = FALSE;
		rxCount = 0;
		writebuf->length = 0;
		writebuf->crc = 0;
		recving = FALSE;
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

  int xtoi (char c)
  {
  	if (isdigit(c))
  	{
  		return (c-'0');
  	} else {
  		return (0x0A + (c-'A'));
  	}
  }

  task void recvTask()
    {
	  uint16_t csum;
	
	//tomic  
	{
		if (readstar > 0 && readstar < GPS_DATA_LENGTH - 3)
		{
			
			csum = (xtoi(readbuf->data[readstar+1]) * 16) + xtoi(readbuf->data[readstar+2]);
			
			if (readbuf->data[readstar] != '*' || csum != readbuf->crc)
			{
				recving = FALSE;
				return;
			}
		}	
    	signal Receive.receive(readbuf);
		recving = FALSE;
		
	}
	return;
    }

  event async result_t UART.get(uint8_t bdata)
    {
		GPS_MsgPtr tmp;	
	

    if (bdata == GPS_PACKET_START)
	{
	  //call Leds.redToggle();
	  rxCount = 0;
	  writebuf->length = rxCount;
	  chksum = 0;
	  valid = TRUE;
	  return SUCCESS;
	}
	
	if (bdata == '*')
	{
		writebuf->crc = chksum;
		chksum = 0;
		chkstar = rxCount;
	} else {
		chksum = chksum ^ bdata;
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
	    writebuf->data[rxCount] = bdata;
	    rxCount++;
	    writebuf->length = rxCount;
	  
	    if (bdata == GPS_PACKET_END2)
	    {
			if (recving)
			{
				rxCount = 0;
				writebuf = 0;
				valid = FALSE;
				writebuf->length = 0;
				return SUCCESS;
			}
			
			//tomic
			{
				tmp = readbuf;
				readbuf = writebuf;
				writebuf = tmp;
				writebuf->length = 0;
				writebuf->crc = 0;
				valid = FALSE;
				readstar = chkstar;
				recving = TRUE;
				post recvTask();
			}
	    }
	  
	}// if valid
      return SUCCESS;
    }
  
 
  event async result_t UART.putDone() {
    
    return SUCCESS;
  }



}
    
