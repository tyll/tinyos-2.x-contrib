
#include <errno.h>
#include <ctype.h>
#include <math.h>
//#include <float.h>
#include <stdlib.h>

module GpsM {

	provides 
	{
		interface StdControl as Control;
		interface GpsFix;
	}
	uses
	{
		interface StdControl as SubControl;
		interface GPSReceiveMsg as GpsReceive;
		interface Leds;
	}
}

implementation
{
#include "gps.h"
#define NUM_SATS	12
#define SATS_PER_BATCH	4
#define MAX_POWS 8	

	char send_arr[20];
	char nmea_fields[NMEA_FIELDS][NMEA_CHARS_PER_FIELD]; // = {{0}};
	GPS_Msg buffer;
	
	bool processing = FALSE;
	//TOS_Msg m_msg;
	uint8_t sat_snr[NUM_SATS];
	
	
	//this is ugly, but speeds things up considerably
	uint32_t pows_of_ten[MAX_POWS] = {1, 10, 100, 1000, 10000L, 100000L, 1000000L, 10000000L}; 
	
/*  strtod def (~5 ms!!!) */
/*
double strtod(const char *str, char **endptr)
{
  double number;
  char *p = (char *) str;
  int i;
  int num_digits;
  int num_decimals;

  // Skip leading whitespace
  while (isspace(*p)) p++;

  number = 0.;
  num_digits = 0;
  num_decimals = 0;

  // Process string of digits
  while (isdigit(*p))
  {
    number = number * 10. + (*p - '0');
    p++;
    num_digits++;
  }

  // Process decimal part
  if (*p == '.') 
  {
    p++;

    while (isdigit(*p))
    {
      number = number * 10. + (*p - '0');
      p++;
      num_digits++;
      num_decimals++;
    }

    for (i=0; i < num_decimals; i++)
    {
    	number = number / 10.0;
    }
  }

  return number;
}*/

//faster version of strtod for motes w/o FP unit (~1.1ms)
/*double strtod(const char *str, char **endptr)
{
  double number;
  char *p = (char *) str;
  int i;
  int num_digits;
  int num_decimals;
  int32_t first, last;
  

  first = 0;
  last = 0;
  
  // Skip leading whitespace
  while (isspace(*p)) p++;

  number = 0.;
  num_digits = 0;
  num_decimals = 0;

  // Process string of digits
  while (isdigit(*p))
  {
    first = first * 10 + (*p - '0');
    p++;
    num_digits++;
  }

  // Process decimal part
  if (*p == '.') 
  {
    p++;

    while (isdigit(*p))
    {
      first = first * 10 + (*p - '0');
      p++;
      num_digits++;
      num_decimals++;
    }

	number = first;
	
    for (i=0; i < num_decimals; i++)
    {
		
    	number = number / 10.0;
    }
  }

  return number;
}
*/
	
//faster parsing avoiding doubles altogether. (~200us)
uint32_t strtoid(const char *str, int *decs)
{
  
  char *p = (char *) str;
//  int i;
  int num_digits;
  int num_decimals;
  uint32_t number;
  
  
  // Skip leading whitespace
  while (isspace(*p)) p++;

  number = 0;
  num_digits = 0;
  num_decimals = 0;

  // Process string of digits
  while (isdigit(*p))
  {
    number = number * 10 + (*p - '0');
    p++;
  }

  // Process decimal part
  if (*p == '.') 
  {
    p++;

    while (isdigit(*p) && num_decimals < 5)
    {
      number = number * 10 + (*p - '0');
      p++;
      
      num_decimals++;
    }

	*decs = num_decimals;
	return number;
	
  }

  return number;
}

	
	command result_t Control.init()
	{
		call Leds.init();
		TOSH_MAKE_P40_OUTPUT();
		TOSH_CLR_P40_PIN();
		return call SubControl.init();
	}

	command result_t Control.start()
	{
		TOSH_SET_P40_PIN();
		return call SubControl.start();
	}

	command result_t Control.stop()
	{
		TOSH_CLR_P40_PIN();
		return call SubControl.stop();
	}


/******************************************************************************
	* GGA Packet received from GPS - ASCII msg
	* 1st byte in pkt is number of ascii bytes
	* async used only for testing
	GGA - Global Positioning System Fix Data
     
	GGA,123519,4807.038,N,01131.324,E,1,08,0.9,545.4,M,46.9,M, , *42
	123519       Fix taken at 12:35:19 UTC
	4807.038,N   Latitude 48 deg 07.038' N
	01131.324,E  Longitude 11 deg 31.324' E
	1            Fix quality: 0 = invalid
	1 = GPS fix
	2 = DGPS fix
	08           Number of satellites being tracked
	0.9          Horizontal dilution of position
	545.4,M      Altitude, Metres, above mean sea level
	46.9,M       Height of geoid (mean sea level) above WGS84
	ellipsoid
	(empty field) time in seconds since last DGPS update
	(empty field) DGPS station ID number
 *****************************************************************************/
	int32_t digit(char dig)
	{
		return (int32_t)(dig-'0');
	}

	void GGARecv(GPS_MsgPtr data)
	{
		GpsFixData fix;
		char *pdata;
		uint32_t ivalue, itmp;
		unsigned int decs;
      
 
		
		fix.valid = (nmea_fields[6][0] - '0');
		
      		//can stop here if not valid--add later
	  	if (fix.valid > 0 && fix.valid < 3)
	  	{
	  		fix.valid = 1;
	  	}
		

		pdata = nmea_fields[1];
		fix.hr = (10 * digit(pdata[0])) + digit(pdata[1]);
      
		fix.min = (10* digit(pdata[2])) + digit(pdata[3]);
		/*fix.sec = (uint32_t)(10000* digit(pdata[4]) + 1000*digit(pdata[5]) + 
				100*(pdata[7]) + 10*digit(pdata[8]) + digit(pdata[9]));*/
		fix.sec = (uint32_t)(10* digit(pdata[4])) + digit(pdata[5]);

      //latitude
		pdata = nmea_fields[2];
		ivalue = strtoid(pdata, &decs);
		itmp = (ivalue / pows_of_ten[decs+2]);
		
		fix.lat_deg = (uint16_t)itmp;
		fix.lat_min = ivalue - (itmp * pows_of_ten[decs+2]);
		fix.ns = nmea_fields[3][0]; 	// Is is North (N) or South (S)

      //longitude
		pdata = nmea_fields[4];
		ivalue = strtoid(pdata,&decs);
		itmp = (ivalue / pows_of_ten[decs+2]);
		
		fix.long_deg = (uint16_t)itmp;
		fix.long_min = ivalue - (itmp * pows_of_ten[decs+2]);
		fix.ew = nmea_fields[5][0];		// Is it East (E) or West (W)

      //num satelites
		fix.sats = ((nmea_fields[7][0]-'0')*10)+(nmea_fields[7][1]-'0');
      
		pdata = nmea_fields[8];
		ivalue = strtoid(pdata,&decs);
		fix.hdilution = (uint8_t)ivalue;
		
		pdata = nmea_fields[9];
		ivalue = strtoid(pdata,&decs);
		fix.altitude = (uint16_t)ivalue;
      
		signal GpsFix.gotFix((GpsFixPtr) &fix);
    
      
	}
  
    
//     $GPRMC,hhmmss.ss,A,llll.ll,a,yyyyy.yy,a,x.x,x.x,ddmmyy,x.x,a*hh
	// 
// RMC  = Recommended Minimum Specific GPS/TRANSIT Data
	// 
// 1    = UTC of position fix
// 2    = Data status (V=navigation receiver warning)
// 3    = Latitude of fix
// 4    = N or S
// 5    = Longitude of fix
// 6    = E or W
// 7    = Speed over ground in knots
// 8    = Track made good in degrees True
// 9    = UT date
// 10   = Magnetic variation degrees (Easterly var. subtracts from true course)
// 11   = E or W
// 12   = Checksum
    
	void RMCRecv(GPS_MsgPtr data)
	{
		bool valid;
		
		valid = (nmea_fields[2][0] == 'A');
		signal GpsFix.gotDateTime(valid, nmea_fields[9], nmea_fields[1]);
    
      
	}
	//GPGSV,3,2,09,11,41,165,46,28,26,291,22,03,26,057,30,29,08,325,24*77
	/*$GPGSV,2,1,08,01,40,083,46,02,17,308,41,12,07,344,39,14,22,228,45*75

Where:
      GSV          Satellites in view
      2            Number of sentences for full data
      1            sentence 1 of 2
      08           Number of satellites in view

      01           Satellite PRN number
      40           Elevation, degrees
      083          Azimuth, degrees
      46           SNR - higher is better
           for up to 4 satellites per sentence
      *75          the checksum data, always begins with *
	  */
	void GSVRecv(GPS_MsgPtr data)
	{
		int offset,i,idx,decs;
		char *pdata;
		
		pdata = nmea_fields[2]; //batch
		offset = digit(pdata[0]);
		
		for (i = 0; i < SATS_PER_BATCH; i++)
		{
			//what is the index into the sat_snr array
			idx = ((offset-1) * SATS_PER_BATCH) + i;
			pdata = nmea_fields[7 + (i*4)];
			sat_snr[idx] = strtoid(pdata,&decs);
		}  
	}

	void recvTask(GPS_MsgPtr gps_data)
	{
		
		int i, k,j,m, length;
		bool end_of_field;
			 
	
		
		//{
			//zero out field entries
			memset(&nmea_fields, 0, sizeof(nmea_fields));
			
			//parse comma delimited data
			end_of_field = FALSE;
			i=0;
			k=0;
			length = gps_data->length;
			while (i < NMEA_FIELDS) 
			{
				// assemble NMEA_fields array
				end_of_field = FALSE;
				j = 0;
				while ((!end_of_field) && 		// the last character reached was NOT a comma
						(k < length) && 		// we have't exceeded the length of the message
						(j < NMEA_CHARS_PER_FIELD)) 	// we haven't exceeded the allowable characters per field
				{
					if (gps_data->data[k] == GPS_DELIMITER) {
						end_of_field = TRUE;
					} 
					else {
						nmea_fields[i][j] = gps_data->data[k];
					}
					j++;
					k++;
				}
				// two commas (,,) indicate empty field
				// if field is empty, set it equal to 0
				if (j <= 1) {
					for (m=0; m< NMEA_CHARS_PER_FIELD; m++) nmea_fields[i][m] = '0';
				}
				i++;
			}//while i < ...

	
		
		
		
		
		if ((nmea_fields[0][0] == 'G') &&
				(nmea_fields[0][1] == 'P') &&
				(nmea_fields[0][2] == 'G') &&
				(nmea_fields[0][3] == 'G') &&
				(nmea_fields[0][4] == 'A'))
		{
			GGARecv(gps_data);
		}
		
		if ((nmea_fields[0][0] == 'G') &&
				(nmea_fields[0][1] == 'P') &&
				(nmea_fields[0][2] == 'R') &&
				(nmea_fields[0][3] == 'M') &&
				(nmea_fields[0][4] == 'C'))
		{
			//call Leds.redToggle();
			RMCRecv(gps_data);
		}
		
		if ((nmea_fields[0][0] == 'G') &&
				(nmea_fields[0][1] == 'P') &&
				(nmea_fields[0][2] == 'G') &&
				(nmea_fields[0][3] == 'S') &&
				(nmea_fields[0][4] == 'V'))
		{
			GSVRecv(gps_data);
		}
		processing = FALSE;
	}


  event GPS_MsgPtr GpsReceive.receive(GPS_MsgPtr data) 
{ 
	//GPS_MsgPtr tmp;
	
	if (processing)
	{
		return data;
	}
	processing = TRUE;
	//memcpy(&buffer, data, sizeof(GPS_Msg));
    recvTask(data);
    processing = FALSE;  
      
	return data;
}  

command uint8_t GpsFix.numSNRHigh(uint8_t threshold)
{
	uint8_t i;
	uint8_t count=0;
	
	for (i=0; i < NUM_SATS; i++)
	{
		if (sat_snr[i] > threshold) count++;
	}
	return count;
}
  
     
}
