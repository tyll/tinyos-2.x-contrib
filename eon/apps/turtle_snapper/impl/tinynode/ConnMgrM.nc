includes structs;
#include "beacon.h"
includes XE1205Const;

module ConnMgrM
{
  provides
  {
    interface StdControl;
    interface ConnMgr;
	interface ConnEnd;
	interface BeaconSig;
  }
  uses
  {
  	interface Timer as SampleTimer;
	interface Timer as DayTimer;
	
	interface Timer as RadioTimer; //Cycles the radio to "undo" any latent radio bugs.
	
	interface XE1205LPL;
	interface XE1205Control;
	interface StdControl as RadioControl;
	interface ObjLog;
	interface CSMAControl;
	interface Leds;
  }
}
implementation
{
#include "fluxconst.h"

#define CONN_SAMPLE_IVAL (60L * 1024L)
#define CONN_DAY_IVAL (12L * 60L * 60L * 1024L)
//#define TXTIMER_IVAL (1000L)
#define CYCLE_IVAL	(60L * 1000L * 25L)  //cycle the radio every 25 minutes
#define CYCLE_DELAY	(1000L)

typedef struct connection_t
{
	uint16_t duration;
	uint16_t beacons;
	uint16_t delay;
	uint16_t meeting_delay;
	uint16_t history;
	uint8_t ttl;
	uint16_t tx;
	uint16_t rx;
	bool active;
} connection_t;


connection_t conns[NUM_TURTLES];
bool locked;
bool cycling;

uint16_t tx_rate, tx_rate_cnt;
int8_t radio_hilo;
int8_t radio_onoff;

enum
{
	CONN_MAX_DURATION = 60,
	CONNECTION_EVENT_TIMEOUT = 25, //minutes -- you missed at least two beacons
	CONNECTION_TIMEOUT = 40 * 1024L, //seconds
	DELAY_INF = 0xFFFF,
};


  command result_t StdControl.init ()
  {

  	int i;
	call Leds.init();
	
	cycling = FALSE;
	tx_rate = 5;
	tx_rate_cnt = 0;
	locked = FALSE;
	radio_hilo = 0; //lo ( lo <= 0 < hi )
	radio_onoff = 0;//on ( off < 0 <= on )
	//reset all records
	for (i=0; i < NUM_TURTLES; i++)
	{
		conns[i].active = FALSE;
		conns[i].history = 0; //we have never seen anybody
		conns[i].meeting_delay = DELAY_INF;
		if (i == 0)
		{
			conns[i].delay = 0; //this is the base
		} else {
			conns[i].delay = DELAY_INF;
		}
		conns[i].tx = 0;
		conns[i].rx = 0;
	}
  	//call RadioControl.init();
    return SUCCESS;
  }

  void __radioLo()
  {
  	
	call XE1205LPL.SetListeningMode(XE1205_LPL_STATES-1);
	call XE1205LPL.SetTransmitMode(XE1205_LPL_STATES-1);
	//call XE1205LPL.SetListeningMode(0);
	//call XE1205LPL.SetTransmitMode(0);
  }
  
  void __radioHi()
  {
	call XE1205LPL.SetListeningMode(0);
	call XE1205LPL.SetTransmitMode(0);
  }
  
  
  
  void setRF()
  {
	call XE1205Control.SetBitrate(40000L);
	call XE1205Control.SetRFPower(3);//15 dBm Tx power
	call CSMAControl.enableCCA();
	call CSMAControl.enableAck();
	call ConnMgr.radioLo();
  }
  
  task void SetRF()
  {
  	setRF();
	
  }
  
  
  command result_t StdControl.start ()
  {
  	cycling = FALSE;
  	//call RadioControl.start();
  	call SampleTimer.start(TIMER_REPEAT, CONN_SAMPLE_IVAL);
	call DayTimer.start(TIMER_REPEAT, CONN_DAY_IVAL);
	call RadioTimer.start(TIMER_ONE_SHOT, CYCLE_IVAL);
	//initialize radio parameters
 	post SetRF();
    return SUCCESS;
  }

  command result_t StdControl.stop ()
  {
  	//call RadioControl.stop();
	
	
    return SUCCESS;
  }

  
  
  
  
  
  
  command result_t ConnMgr.sentPacket(uint16_t toaddr)
  {
  	if (toaddr < NUM_TURTLES)
	{
		tx_rate_cnt++;
		conns[toaddr].tx++;
	}
  	return SUCCESS;
  }
  
  command result_t ConnMgr.recvedPacket(uint16_t fromaddr)
  {
  	if (fromaddr < NUM_TURTLES)
	{
		conns[fromaddr].rx++;
	}
  	return SUCCESS;
  }
  
  
  
  
  
  
  
  
  	command result_t ConnMgr.beacon(uint16_t addr, uint16_t delay)
  	{
		if (addr < NUM_TURTLES)
		{
			signal BeaconSig.beaconRecved(addr);
			if (conns[addr].active == FALSE)
			{
				conns[addr].active = TRUE;
				conns[addr].duration = 0;
				conns[addr].beacons = 0;
				conns[addr].tx = 0;
				conns[addr].rx = 0;
			}
			conns[addr].beacons++;
			if (addr == 0)
			{
				conns[addr].delay = 0;
			} else {
				conns[addr].delay = delay; //this is what this turtle thinks its delay to the base station is.
			}
			
			conns[addr].ttl = CONNECTION_EVENT_TIMEOUT;
			conns[addr].history |= 0x0001;
			if (conns[addr].history == 0x0001)
			{
				//HACK! this is to jump start the node so
				//we don't have to wait 12 hours before sending them any data
				conns[addr].meeting_delay = 16;
			}
			return SUCCESS;
			
		} 
		
		return FAIL;
	}

  	command uint16_t ConnMgr.getDelayToBase(bool shortcircuit)
	{
		int i;
		uint16_t tmp;
		uint16_t min_delay = DELAY_INF;
		uint16_t buffer_delay;
		uint16_t pkts_in_log;
		
		
		if (TOS_LOCAL_ADDRESS == 0)
		{
			//I am the base
			return 0;
		}
		
		pkts_in_log = (call ObjLog.getNumPages(1)+1) * 12; //approximation
		buffer_delay = pkts_in_log / (tx_rate+1);
		
		
		for (i=0; i < NUM_TURTLES; i++)
		{
			if (i != TOS_LOCAL_ADDRESS)
			{
				tmp = call ConnMgr.getDelayToBaseThroughAddr(i, shortcircuit);
				if (tmp < min_delay)
				{
					min_delay = tmp;
				}
			}
		}
		if (shortcircuit)
		{
			return (min_delay);
		} else {
			if (min_delay == DELAY_INF ||
				buffer_delay == DELAY_INF)
			{
				return DELAY_INF;
			} else {
				return (buffer_delay + min_delay);
			}
		}
	}
	
  	command uint16_t ConnMgr.getDelayToBaseThroughAddr(uint16_t addr, bool shortcircuit)
	{
		uint16_t actual_meet_delay;
		
		if (TOS_LOCAL_ADDRESS == 0)
		{
			//I am the base
			return 0;
		}
		
		if (addr >= NUM_TURTLES)
		{
			return DELAY_INF;
		}
		
		
		
		
		
		if (conns[addr].active && shortcircuit)
		{
			actual_meet_delay = 0;
		} else {
			
			actual_meet_delay = conns[addr].meeting_delay;
			
		}
		if (actual_meet_delay != DELAY_INF &&
			conns[addr].delay != DELAY_INF)
		{
				return actual_meet_delay + conns[addr].delay;
		} 
		return DELAY_INF;
	}
  
	command result_t ConnMgr.lock()
	{
		atomic
		{
			if (locked) return FAIL;
			
			locked = TRUE;
			return SUCCESS;
		}
	}
	
	command result_t ConnMgr.unlock()
	{
		atomic
		{
			if (!locked) return FAIL;
			
			locked = FALSE;
			return SUCCESS;
		}
	}
	
	command result_t ConnMgr.radioHi()
	{
		/*atomic
		{
			radio_hilo++;
			if (radio_hilo > 0) RadioHi();
		}*/
		__radioHi();
		call Leds.redOff();
		call Leds.greenOn();
		return SUCCESS;
	}
	
	command result_t ConnMgr.radioLo()
	{
		/*atomic
		{
			radio_hilo--;
			if (radio_hilo <= 0) RadioLo();
		}*/
		__radioLo();
		call Leds.redOn();
		call Leds.greenOff();
		return SUCCESS;
	}
	
	
	
	command result_t ConnMgr.radioOff()
	{
		
		return call RadioControl.stop();
	}
	
	command result_t ConnMgr.radioOn()
	{
		atomic
		{
			if (cycling)
			{
				return SUCCESS;
			}
		}
		//call RadioControl.init();
		call RadioControl.start();
		setRF();
		call ConnMgr.radioLo();
		
		return SUCCESS;
	}
	
  	command uint8_t ConnMgr.getConnectionRank(uint16_t addr, uint16_t* delay)
	{
		uint16_t thedelay, tmpdelay;
		int count = 0;
		int i;

		if (addr == 0)
		{
			if (delay != NULL) *delay = 0;
			return 0;
		}
		
		
		thedelay = call ConnMgr.getDelayToBaseThroughAddr(addr, TRUE);
		
		if (thedelay == DELAY_INF)
		{
			return NUM_TURTLES;
		}
		
		for (i=0; i < NUM_TURTLES; i++)
		{
			if (i != addr)
			{
				tmpdelay = call ConnMgr.getDelayToBaseThroughAddr(i, TRUE);
				if (tmpdelay < thedelay)
				{
					count++;
				}
			}
		}
		if (delay != NULL) *delay = thedelay;
		return count;
	}
  
	default event void BeaconSig.beaconRecved(uint16_t addr)
   {
   
   }
	
   default event void ConnEnd.connectionEnded(uint16_t addr, uint16_t duration, uint8_t quality, 
   											uint16_t rx, uint16_t tx)
   {
   
   }
  event result_t RadioTimer.fired()
  {
  	if (cycling)
	{
		atomic cycling = FALSE;
		call RadioTimer.start(TIMER_ONE_SHOT, CYCLE_IVAL);
		call RadioControl.start();
		setRF();
		call ConnMgr.radioLo();
	} else {
  		atomic cycling = TRUE;
		call RadioControl.stop();
		call RadioTimer.start(TIMER_ONE_SHOT, CYCLE_DELAY);
	}
	return SUCCESS;
  }
   
  event result_t SampleTimer.fired()
  {
  	int i;
	
	
	for (i=0; i < NUM_TURTLES; i++)
	{
		if (conns[i].active)
		{
			atomic {
				conns[i].duration++;
				conns[i].ttl--;
				if (conns[i].ttl == 0 || conns[i].duration > CONN_MAX_DURATION)
				{
					conns[i].active = FALSE;
					signal ConnEnd.connectionEnded(i, conns[i].duration, conns[i].beacons, conns[i].rx, conns[i].tx);
					return SUCCESS;
				}
			} //atomic
		}
	}
  	return SUCCESS;
  }
  
  event result_t DayTimer.fired()
  {
  	int i, j, bit;
	uint16_t tmp;
	uint16_t cumwaits, nextwt, numwts;
	
	//estimate how many packets we send for each one time this timer fires
	//used to predict queuing delay in the flash
	tx_rate = (((tx_rate * 6) + (tx_rate_cnt * 4))/10) + 1;
	tx_rate_cnt = 0;
	
  	for (i=0; i < NUM_TURTLES; i++)
	{
		tmp = conns[i].history;
		conns[i].history = (conns[i].history << 1) & (0xFFFE);
		
		//compute meeting delay
		if (tmp == 0x0000)
		{
			//no contact in the last 16 time periods ("days")
			conns[i].meeting_delay = DELAY_INF;
			
		} else {
			cumwaits = 0;
			nextwt = 0;
			numwts = 0;
			for (j=0; j < 16; j++)
			{
				bit = tmp & 0x0001;
				if (bit == 0)
				{
					nextwt++;
				} else {
					if (nextwt > 0)
					{
						cumwaits += nextwt;
						numwts++;	
					} 
					nextwt = 0;
					
				}
				
				tmp = tmp >> 1;
			}
			if (numwts > 0)
			{
				conns[i].meeting_delay = (cumwaits / numwts) + 1;	
			} else {
				conns[i].meeting_delay = 1;
			}
		}
	}
	return SUCCESS;
  }

  event result_t ObjLog.readDone(int logid, uint8_t *buffer, uint16_t numbytes, result_t success)
  {
  	return SUCCESS;
  }
  
  event result_t ObjLog.appendDone(int logid, result_t success)
  {
  	return SUCCESS;
  }
}
