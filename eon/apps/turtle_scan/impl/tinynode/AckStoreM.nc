

module AckStoreM
{
  provides
  {
    interface StdControl;
    interface AckStore;
  }
  uses
  {
  	interface Leds;
#ifdef ACK_DEBUG
	interface Console;
#endif
	interface Timer;
  }

}
implementation
{
#include "fluxconst.h"

//#define REDUCE_IVAL		600000L
#define REDUCE_IVAL		40000L
#define MAX_SPAN 800L
#define MAX_AGE	20000L

typedef struct ack_entry_t
{
	bool valid;
	uint8_t addr;
	uint16_t minid;
	uint16_t maxid;
	uint16_t age;
} ack_entry_t;

ack_entry_t acks[NUM_TURTLES];
int curack;


#ifdef ACK_DEBUG
event void Console.input (char *str)
{

}
#endif

  command result_t StdControl.init ()
  {

  	int i;
	curack = 0;
#ifdef ACK_DEBUG
	call Console.init();
#endif
	//reset all records
	for (i=0; i < NUM_TURTLES; i++)
	{
		acks[i].valid = FALSE;
	}
  
    return SUCCESS;
  }

  command result_t StdControl.start ()
  {
  	call Timer.start(TIMER_REPEAT, REDUCE_IVAL);
    return SUCCESS;
  }

  command result_t StdControl.stop ()
  {
    return SUCCESS;
  }

 bool isAdjAck(int idx, uint8_t addr, uint16_t id)
  {
  	if (acks[idx].valid == FALSE)
	{
		
		return FALSE;
	}
	
	
	if (acks[idx].addr != addr)
	{
	 	return FALSE;
	}
	
	if ((id <  (acks[idx].minid - 1)) && acks[idx].minid != 0)
	{
		
	 	return FALSE;
	}
		
	if ((id > (acks[idx].maxid + 1)) && acks[idx].maxid != 0xffff)
	{
		
		return FALSE;
	} 
	
	
	return TRUE;
  }
  
  
  bool isInAck(int idx, uint8_t addr, uint16_t id)
  {
  	if (acks[idx].valid == FALSE)
	{
		return FALSE;
	}
	
	if (acks[idx].addr == addr &&
		acks[idx].minid <= id &&
		acks[idx].maxid >= id)
		{
			return TRUE;
		} else {
			return FALSE;
		}
  }
  
  command bool AckStore.get_numbered_ack(int idx, bool *valid, uint16_t *addr, uint16_t* minid, uint16_t* maxid)
  {
  	if (addr == NULL || minid == NULL || maxid == NULL || valid == NULL)
	{
		
		return FALSE;
	}
	
	if (idx >= NUM_TURTLES)
	{
		
		return FALSE;
	}
	
	*valid = acks[idx].valid;
	if (acks[idx].valid)
	{
		
		
		*addr = acks[idx].addr;
		*minid = acks[idx].minid;
		*maxid = acks[idx].maxid;	
	} 
		
	
	return TRUE;
	
  }
  
  
  command bool AckStore.get_random_ack(uint8_t *addr, uint16_t* minid, uint16_t* maxid)
  {
  	static int last_ack= 0;
	int idx;
	
  	if (addr == NULL || minid == NULL || maxid == NULL)
	{
		return FALSE;
	}
	
	idx = (last_ack + 1) % NUM_TURTLES;
	while (idx != last_ack)
	{
		if (acks[idx].valid)
		{
			*addr = acks[idx].addr;
			*minid = acks[idx].minid;
			*maxid = acks[idx].maxid;
			last_ack = idx;
			return TRUE;
		}
		idx = (idx + 1) % NUM_TURTLES;
	}
	return FALSE;
	
	
  }
  
  command bool AckStore.check_packet_entry(uint8_t addr, uint16_t id, uint16_t* minid, uint16_t* maxid)
  {
  	int i;
  	
	//tomic
	{
		for (i=0; i < NUM_TURTLES; i++)
		{
			if (acks[i].valid && acks[i].age > 0)
			{
				acks[i].age--;
			}
		}
		for (i=0; i < NUM_TURTLES; i++)
		{
			if (isInAck(i,addr,id))
			{
				if (minid != NULL)
				{
					*minid = acks[i].minid;
				}
				if (maxid != NULL)
				{
					*maxid = acks[i].maxid;
				}
				acks[i].age = MAX_AGE;
				return TRUE;
			}
		}
	}
	
	return FALSE;
	}
  
  command bool AckStore.check_packet(uint8_t addr, uint16_t id)
  {
  	 return call AckStore.check_packet_entry(addr,id, NULL, NULL);
  }
  
  
  result_t mergeAcks(int i,uint8_t addr, uint16_t minid, uint16_t maxid)
  {
  	//uint16_t amax, amin;
	
	if (acks[i].valid == FALSE || 
		acks[i].addr != addr)
	{
		return FAIL;
	}
	if (acks[i].minid > acks[i].maxid)
	{
		acks[i].valid = FALSE;
		return FAIL;
	}
	
	if (acks[i].minid > minid)
	{
		acks[i].minid = minid;
	}
	if (acks[i].maxid < maxid)
	{
		acks[i].maxid = maxid;
	}
	if ((acks[i].maxid - acks[i].minid) > MAX_SPAN)
	{
		acks[i].minid = acks[i].maxid - MAX_SPAN;
	}
	
	return SUCCESS;
  }
  
  
  task void ReduceTask()
  {
  	static int idx = 0;
  	int i, j, newidx = -1;
	result_t res;
	
	
	for (i=1; i < NUM_TURTLES; i++)
	{
		j = (idx + i) % NUM_TURTLES;
#ifdef ACK_DEBUG
		call Console.decimal(j);
		call Console.newline();
#endif
		if (acks[j].valid)
		{
#ifdef ACK_DEBUG
			call Console.string("valid");
#endif
		
			newidx = j;
			idx = newidx;
			break;
		}
	}
	
#ifdef ACK_DEBUG	
	call Console.string("reduce-");
	call Console.decimal(idx);
	call Console.newline();
#endif
	

	
	if (acks[idx].valid == FALSE || newidx == -1)
	{
	#ifdef ACK_DEBUG	
		call Console.string("inv!");
		call Console.newline();
	#endif

		return;
	}	
	
	for (i=0; i < NUM_TURTLES; i++)
	{

		if (i != idx && acks[i].valid &&
			(isAdjAck(idx,acks[i].addr, acks[i].minid) || 
			isAdjAck(idx,acks[i].addr, acks[i].maxid)))
		{
#ifdef ACK_DEBUG	
			call Console.string("m(");
			call Console.decimal(i);
			call Console.string(",");
			call Console.decimal(acks[i].addr);
			call Console.string(",");
			call Console.decimal(acks[i].minid);
			call Console.string(",");
			call Console.decimal(acks[i].maxid);
			call Console.string(")");
			call Console.newline();
#endif		
		
			res = mergeAcks(idx, acks[i].addr, acks[i].minid, acks[i].maxid);
			if (res == SUCCESS)
			{
			#ifdef ACK_DEBUG	
				call Console.string("m!.");
			#endif

				acks[i].valid = FALSE;
			} else {
			#ifdef ACK_DEBUG	
				call Console.string("m failed.");
			#endif
			}
		}
	}
  }
  
  event result_t Timer.fired()
  {
  	post ReduceTask();
	return SUCCESS;
  }
  
  
  command result_t AckStore.report_ack(uint8_t addr, uint16_t minid, uint16_t maxid)
  {
  	int i;
	int spareidx = -1;
  	int oldestidx = -1;
	
	if (minid > maxid)
	{
		
		return FAIL;
	}
	
	//tomic
	{
		for (i=0; i < NUM_TURTLES; i++)
		{
			if (acks[i].valid && acks[i].age > 0)
			{
				acks[i].age--;
			}
		}
		for (i=0; i < NUM_TURTLES; i++)
		{
			if (isAdjAck(i,addr,minid) || isAdjAck(i,addr,maxid))
			{
				//need to merge the acks;
				mergeAcks(i,addr,minid,maxid);
				curack = i;
				return SUCCESS;
			}
			if (acks[i].valid == FALSE && spareidx == -1)
			{
				spareidx = i;
			}
			if (acks[i].valid == TRUE)
			{
				if (oldestidx == -1)
				{
					oldestidx = i;
				} else {
					if (acks[oldestidx].age < acks[i].age)
					{
						oldestidx = i;
					}
				}
			}
		}
		if (spareidx != -1)
		{
			oldestidx = spareidx;
		}
		if (oldestidx != -1)
		{
			//evict the least recently used one
			acks[oldestidx].valid = TRUE;
			acks[oldestidx].addr = addr;
			acks[oldestidx].minid = minid;
			acks[oldestidx].maxid = maxid;
			acks[oldestidx].age = MAX_AGE;
			curack = oldestidx;
			return SUCCESS;
		}	
	
	} 
	
	return FAIL;
  }
  
  

}
