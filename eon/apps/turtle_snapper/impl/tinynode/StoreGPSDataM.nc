includes structs;

module StoreGPSDataM
{
	provides
	{
		interface StdControl;
		interface IStoreGPSData;
	}
	uses 
	{
		interface BitVec;
		command uint16_t getNextSeq();
	}
}
implementation
{
#include "fluxconst.h"
#include "mktime.c"

StoreGPSData_in *node_in;
StoreGPSData_out *node_out;

task void prepDateTime();
//task void prepFix();
uint8_t ctob(char*buf, int start, int num);

	command result_t StdControl.init ()
	{
		return SUCCESS;
	}
	
	command result_t StdControl.start ()
	{
		return SUCCESS;
	}
	
	command result_t StdControl.stop ()
	{
		return SUCCESS;
	}
	
	 /*
	IN:
		GpsData_t data - the gps reading that was taken
	OUT:
		chunkarr_t chunkarr - the two chunks to be added to the log
	 */
	
	command result_t IStoreGPSData.nodeCall (StoreGPSData_in * in,
											   StoreGPSData_out * out)
	{

		uint16_t year, mon, day, hr, min, sec;
		uint32_t utime;
	
		node_in = in;
		node_out = out;

		//update runtime clock
		if (node_in->data.timevalid)
		{
			day = ctob(node_in->data.date, 0, 2); //day
			mon = ctob(node_in->data.date, 2, 2); //month
			year = ctob(node_in->data.date, 4, 2); //year
			year += 2000;
			
			hr = node_in->data.fix.hr;
			min = node_in->data.fix.min;
			sec = node_in->data.fix.sec;
			
			g_yr = year;
			g_mo = mon;
			g_dy = day;
			g_hr = hr;
			g_min = min;
			g_sec = sec;
			
			utime = tl_mktime(year, mon, day, hr, min, sec);
			//utime = tl_mktime(2008, 6, 26, 11, 39, 54);
			if (utime != 0)
			{
				booted = FALSE;
				rt_clock = utime;
			}
		}
		
		if (post prepDateTime())
		{
			return SUCCESS;
		} else {
			return FAIL;
		}
	}
  
	bool isdigit(uint8_t val)
	{
		return (val >= '0' && val <= '9');
	}
	
	uint8_t todigit(uint8_t ch)
	{
		return (ch-'0');
	}
	
	uint8_t ctob(char*buf, int start, int num)
	{
		uint8_t ret = 0;
		int i;
		
		for (i=start; i < start+num; i++)
		{
			if (!isdigit(buf[i]))
			{
				return 0xff;
			} 
			ret = (ret * 10) + todigit(buf[i]);
		}
		return ret;	
	}
	
	uint8_t setValidBits(uint8_t valid, uint8_t ew, uint8_t ns)
	{
		uint8_t result = 0;
		
		result |= (valid & 0x01) << 7;
		result |= (ew == 'E' ? 0x01 : 0x00) << 1;
		result |= (ew == 'N' ? 0x01 : 0x00);
		
		return result;
	}
	
	task void prepDateTime()
	{
		uint8_t *__writebuf;
		
		uint16_t seq;
		
		
		
		
		seq = call getNextSeq();
		__writebuf = node_out->chunkarr.chunks[0].data;
				
		 //pack data into __writebuf
		 //header first
		 __writebuf[0] = TOS_LOCAL_ADDRESS;
		 __writebuf[1] = ((booted ? 1 : 0) << 7) | BTYPE_GPSFIRST;
		 memcpy(__writebuf+2, &seq, sizeof(seq));
		 //__writebuf[4] = 0;
		 //__writebuf[5] = 0;
		 memcpy(__writebuf+4, &rt_clock, sizeof(rt_clock));
		 
		//data
		
		__writebuf[8] = setValidBits(node_in->data.fix.valid, node_in->data.fix.ew, node_in->data.fix.ns);		//valid
		__writebuf[9] = (node_in->toofew << 7) | (node_in->toofew == 1 ? node_in->numsats : node_in->data.fix.sats);		//satelites
		__writebuf[10] = node_in->data.fix.hdilution;	//horizontal dilution
		memcpy(__writebuf+11, &(node_in->data.fix.lat_deg), 2);
		memcpy(__writebuf+13, &(node_in->data.fix.lat_min), 4);
		memcpy(__writebuf+17, &(node_in->data.fix.long_deg), 2);
		memcpy(__writebuf+19, &(node_in->data.fix.long_min), 4);
		memcpy(__writebuf+23, &(node_in->data.fix.altitude), 2);
		//memcpy(__writebuf+25, &(node_in->numsats), 2);
		
		node_out->chunkarr.chunks[0].length = 25; //must be less than 28
		node_out->chunkarr.num = 1;
		
		//post prepFix();
		signal IStoreGPSData.nodeDone(node_in, node_out, ERR_OK);
	}
  
	
	/*task void prepFix()
	{
		uint16_t seq;
		uint8_t *__writebuf;
		
		seq = call getNextSeq();
		__writebuf = node_out->chunkarr.chunks[1].data;
				
		 //pack data into __writebuf
		 //header first
		 __writebuf[0] = TOS_LOCAL_ADDRESS;
		 memcpy(__writebuf+1, &seq, sizeof(seq));
		 __writebuf[3] = ((booted ? 1 : 0) << 7) | BTYPE_GPSSECOND;
		 //__writebuf[4] = 0;
		 //__writebuf[5] = 0;
		 //call BitVec.set16((uint16_t*)(__writebuf+4), TOS_LOCAL_ADDRESS, TRUE);
		memcpy(__writebuf+4, &rt_clock, sizeof(rt_clock));
		
		//data
		memcpy(__writebuf+6, &(node_in->data.fix.lat_deg), 2);
		memcpy(__writebuf+8, &(node_in->data.fix.lat_min), 4);
		memcpy(__writebuf+12, &(node_in->data.fix.long_deg), 2);
		memcpy(__writebuf+14, &(node_in->data.fix.long_min), 4);
		//18 bytes
		
		node_out->chunkarr.chunks[1].length = 18; //better be less than 28
		node_out->chunkarr.num = 2;
		
		
		signal IStoreGPSData.nodeDone(node_in, node_out, ERR_OK);
		
	}*/
  
	
}
