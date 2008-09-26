

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
		//interface BareSendMsg as Send;
	}
}

implementation
{
#include "gps.h"
	
	char send_arr[20];
	char nmea_fields[NMEA_FIELDS][NMEA_CHARS_PER_FIELD]; // = {{0}};
	GPS_Msg buffer;
	GPS_MsgPtr bufferPtr;
	
	TOS_Msg m_msg;
	
	
	command result_t Control.init()
	{
		TOSH_MAKE_PW0_OUTPUT();
		TOSH_MAKE_PW1_OUTPUT();
		TOSH_CLR_PW0_PIN();
		TOSH_CLR_PW1_PIN();
		bufferPtr = &buffer;
		return call SubControl.init();
	}

	command result_t Control.start()
	{
		TOSH_SET_PW0_PIN();
		TOSH_SET_PW1_PIN();
		return call SubControl.start();
	}

	command result_t Control.stop()
	{
		TOSH_CLR_PW0_PIN();
		TOSH_CLR_PW1_PIN();
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
		double dvalue;
		double dtmp;
      
 
		
		fix.valid = (nmea_fields[6][0] - '0');
		
		/*
		send_arr[0] = 'v';
		send_arr[1] = 'a';
		send_arr[2] = 'l';
		send_arr[3] = nmea_fields[6][0];
		send_arr[4] = nmea_fields[6][1];
		send_arr[5] = 'v';
		
		
		if (fix.valid)
		{
			memcpy(m_msg.data, send_arr, 20*sizeof(char));
			call SendMsg.send(TOS_BCAST_ADDR, 20*sizeof(char), &m_msg);
		}
		*/
		/*
		memcpy(m_msg.data, nmea_fields, 90*sizeof(char));
		call SendMsg.send(TOS_BCAST_ADDR, 90*sizeof(char), &m_msg);
		*/
		/*
		memcpy(m_msg.data, (char *)(nmea_fields, 70*sizeof(char));
		call SendMsg.send(TOS_BCAST_ADDR, 70*sizeof(char), &m_msg);
		*/
		

      //can stop here if not valid--add later
	  if (fix.valid == 0)
	  {
	  	return;
	  }

		pdata = nmea_fields[1];
		fix.hr = 10 * digit(pdata[0]) + digit(pdata[1]);
      
		fix.min = 10* digit(pdata[2]) + digit(pdata[3]);
		fix.sec = (uint32_t)(10000* digit(pdata[4]) + 1000*digit(pdata[5]) + 
				100*(pdata[7]) + 10*digit(pdata[8]) + digit(pdata[9]));

      //latitude
		pdata = nmea_fields[2];
		dvalue = strtod(pdata,NULL); // convert the latitude reading to a double
		dtmp = dvalue/100.0;
		fix.lat_deg = (uint16_t)floor(dtmp);

		fix.lat_min = (uint32_t)(10000.0 * (dvalue-(floor(dtmp)*100)));

		fix.ns = nmea_fields[3][0]; 	// Is is North (N) or South (S)

      //longitude
		pdata = nmea_fields[4];
		dvalue = strtod(pdata,NULL);
		dtmp = dvalue/100.0;
		fix.long_deg = (uint16_t)floor(dtmp);

		fix.long_min = (uint32_t)(10000.0 * (dvalue-(floor(dtmp)*100)));
           
		fix.ew = nmea_fields[5][0];		// Is it East (E) or West (W)

      //num satelites
		fix.sats = ((nmea_fields[7][0]-'0')*10)+(nmea_fields[7][1]-'0');
      
		pdata = nmea_fields[8];
		dvalue = strtod(pdata,NULL);
		dtmp = dvalue*10;
		fix.hdilution = (uint8_t)floor(dtmp);
		
		pdata = nmea_fields[9];
		dvalue = strtod(pdata,NULL);
		dtmp = dvalue;
		fix.altitude = (uint16_t)floor(dtmp);
      
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
      
      
      
		signal GpsFix.gotDateTime(nmea_fields[9], nmea_fields[1]);
    
      
	}

	task void recvTask()
	{
		
		int i, k,j,m, length;
		bool end_of_field;
		GPS_MsgPtr gps_data;
		//bool found = FALSE;
		
		//change to GPS packet!!
		gps_data = bufferPtr;
		
	#ifdef	_GPS_DEBUG_	
		//copy data into msg;
		//memcpy(m_msg.data, gps_data->data, gps_data->length);
		//call SendMsg.send(TOS_BCAST_ADDR, gps_data->length, &m_msg);
		
	#endif
	
		atomic 
		{
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
		} //end atomic
	
		
		//send_arr[0] = nmea_fields[0][0];
		//send_arr[1] = nmea_fields[0][1];
		//send_arr[2] = nmea_fields[0][2];
		//send_arr[3] = nmea_fields[0][3];
		//send_arr[4] = nmea_fields[0][4];
		//send_arr[5] = 'Z';
		//memcpy(m_msg.data, send_arr, 20*sizeof(char));
		//call SendMsg.send(TOS_BCAST_ADDR, 20*sizeof(char), &m_msg);
		
		
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
			RMCRecv(gps_data);
		}
	}


  event GPS_MsgPtr GpsReceive.receive(GPS_MsgPtr data) 
{ 
	GPS_MsgPtr tmp;
	atomic{
		tmp = bufferPtr;
		bufferPtr = data;
		post recvTask();
	}
      
      
	return tmp;
}  

  
     
}
