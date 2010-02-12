/**
* The driver for using the SHT75 temperature and humidity sensor
* 
* @author Charles Elliott
* @modified June 24, 2008
*/

module SHT75_P {
	provides {
		interface SHT75Interface;
	}
	uses {
		//interface Leds as DebugLeds;
		interface DIO;
	}
}
implementation {
	//----------------------------------------------------------------------------------
	// modul-var
	//----------------------------------------------------------------------------------
	
	#define TEMP 0
	#define HUMI 1
	
	#define	DATA   	0x3E
	#define	SCK   	0x01
	
	#define noACK 0
	#define ACK   1
								//adr  command  r/w
	#define STATUS_REG_W 0x06   //000   0011    0
	#define STATUS_REG_R 0x07   //000   0011    1
	#define MEASURE_TEMP 0x03   //000   0001    1
	#define MEASURE_HUMI 0x05   //000   0010    1
	#define RESET        0x1e   //000   1111    0
	
	
	
	//----------------------------------------------------------------------------------
	command char s_write_byte(unsigned char value)
	//----------------------------------------------------------------------------------
	// writes a byte on the Sensibus and checks the acknowledge 
	{ 
	  unsigned char i,error=0;  
	  for (i=0x80;i>0;i/=2)             //shift bit for masking
	  {	if (i & value) 
		{
			if(SUCESS!=(call DIO.set(DATA,0xFF)//masking value with i , write to SENSI-BUS
			{//try again
			}			
		}else 
		{
			if(SUCESS != (call DIO.set(DATA,0x00)))
			{//try again
			} 
		}	
		if(SUCESS != (call DIO.set(SCK, 0xFF))) //clk for SENSI-BUS
		{//try again
		}
		_nop_();_nop_();_nop_();        //pulswith approx. 5 us  	
		if(SUCESS != (call DIO.set(SCK, 0x00))) //clk for SENSI-BUS
		{//try again
		}
	  }
	  if(SUCESS != (call DIO.set(DATA & SCK, 0xFF))) //release DATA-line
														//clk #9 for ack
		{//try again
		}
	  if (call DigOutput.requestRead() != SUCCESS) {
	  //try again
	  }
	  
	  //wait for read ready
	  
	  error=(call DigOutput.read()) & DATA;           //check ack (DATA will be pulled down by SHT11)
	  if(SUCESS != (call DIO.set(SCK, 0x00))) 
		{//try again
		}        
	  return error;                     //error=1 in case of no acknowledge
	}
	
	//----------------------------------------------------------------------------------
	command char s_read_byte(unsigned char ack)
	//----------------------------------------------------------------------------------
	// reads a byte form the Sensibus and gives an acknowledge in case of "ack=1" 
	{ 
	  unsigned char i,val=0;
	  DATA=1;                           //release DATA-line
	  for (i=0x80;i>0;i/=2)             //shift bit for masking
	  { SCK=1;                          //clk for SENSI-BUS
		if (DATA) val=(val | i);        //read bit  
		SCK=0;  					 
	  }
	  DATA=!ack;                        //in case of "ack==1" pull down DATA-Line
	  SCK=1;                            //clk #9 for ack
	  _nop_();_nop_();_nop_();          //pulswith approx. 5 us 
	  SCK=0;						    
	  DATA=1;                           //release DATA-line
	  return val;
	}
	
	//----------------------------------------------------------------------------------
	command void s_transstart(void)
	//----------------------------------------------------------------------------------
	// generates a transmission start 
	//       _____         ________
	// DATA:      |_______|
	//           ___     ___
	// SCK : ___|   |___|   |______
	{  
	   DATA=1; SCK=0;                   //Initial state
	   _nop_();
	   SCK=1;
	   _nop_();
	   DATA=0;
	   _nop_();
	   SCK=0;  
	   _nop_();_nop_();_nop_();
	   SCK=1;
	   _nop_();
	   DATA=1;		   
	   _nop_();
	   SCK=0;		   
	}
	
	//----------------------------------------------------------------------------------
	command void s_connectionreset(void)
	//----------------------------------------------------------------------------------
	// communication reset: DATA-line=1 and at least 9 SCK cycles followed by transstart
	//       _____________________________________________________         ________
	// DATA:                                                      |_______|
	//          _    _    _    _    _    _    _    _    _        ___     ___
	// SCK : __| |__| |__| |__| |__| |__| |__| |__| |__| |______|   |___|   |______
	{  
	  unsigned char i; 
	  DATA=1; SCK=0;                    //Initial state
	  for(i=0;i<9;i++)                  //9 SCK cycles
	  { SCK=1;
		SCK=0;
	  }
	  s_transstart();                   //transmission start
	}
	
	//----------------------------------------------------------------------------------
	command char s_softreset(void)
	//----------------------------------------------------------------------------------
	// resets the sensor by a softreset 
	{ 
	  unsigned char error=0;  
	  s_connectionreset();              //reset communication
	  error+=s_write_byte(RESET);       //send RESET-command to sensor
	  return error;                     //error=1 in case of no response form the sensor
	}
	
	//----------------------------------------------------------------------------------
	command char s_read_statusreg(unsigned char *p_value, unsigned char *p_checksum)
	//----------------------------------------------------------------------------------
	// reads the status register with checksum (8-bit)
	{ 
	  unsigned char error=0;
	  s_transstart();                   //transmission start
	  error=s_write_byte(STATUS_REG_R); //send command to sensor
	  *p_value=s_read_byte(ACK);        //read status register (8-bit)
	  *p_checksum=s_read_byte(noACK);   //read checksum (8-bit)  
	  return error;                     //error=1 in case of no response form the sensor
	}
	
	//----------------------------------------------------------------------------------
	command char s_write_statusreg(unsigned char *p_value)
	//----------------------------------------------------------------------------------
	// writes the status register with checksum (8-bit)
	{ 
	  unsigned char error=0;
	  s_transstart();                   //transmission start
	  error+=s_write_byte(STATUS_REG_W);//send command to sensor
	  error+=s_write_byte(*p_value);    //send value of status register
	  return error;                     //error>=1 in case of no response form the sensor
	}
								   
	//----------------------------------------------------------------------------------
	command char s_measure(unsigned char *p_value, unsigned char *p_checksum, unsigned char mode)
	//----------------------------------------------------------------------------------
	// makes a measurement (humidity/temperature) with checksum
	{ 
	  unsigned error=0;
	  unsigned int i;
	
	  s_transstart();                   //transmission start
	  switch(mode){                     //send command to sensor
		case TEMP	: error+=s_write_byte(MEASURE_TEMP); break;
		case HUMI	: error+=s_write_byte(MEASURE_HUMI); break;
		default     : break;	 
	  }
	  for (i=0;i<65535;i++) if(DATA==0) break; //wait until sensor has finished the measurement
	  if(DATA) error+=1;                // or timeout (~2 sec.) is reached
	  *(p_value)  =s_read_byte(ACK);    //read the first byte (MSB)
	  *(p_value+1)=s_read_byte(ACK);    //read the second byte (LSB)
	  *p_checksum =s_read_byte(noACK);  //read checksum
	  return error;
	}
}