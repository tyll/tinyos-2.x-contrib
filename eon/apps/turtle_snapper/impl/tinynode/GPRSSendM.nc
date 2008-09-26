includes structs;	


module GPRSSendM
{
	provides
	{
		interface StdControl;
		interface IGPRSSend;
	}
	uses
	{
		interface StdControl as ModemControl;
		interface GPRS;
		interface Timer;
		interface AckStore;
		interface ObjLog;
		interface SendMsg;
		interface IAccum;
	}
}
implementation
{
#include "fluxconst.h"
#define NUMMSG	100
#define NUMSEND	50
#define NUMCMDS	8
#define BUFSIZE 3800
#define RESPONSE_LENGTH 250
#define GPRS_RETRIES	5
	
	GPRSSend_in* node_in;
	GPRSSend_out* node_out;
	
	int msg_count;
	int record_count;
	int cmdidx;
	//int cmdc;
	int msgidx;
	int failure;
	bool sending;
	//norace bool endc = FALSE;
	int retries;
	TOS_Msg gmsg;
	

uint16_t turtles[NUMMSG];
uint16_t indices[NUMMSG];

char body[BUFSIZE];


chunk_t thechunk;

#define BODY_NUM 6
#define BS_INFO_NUM 5

uint32_t cmddelay [NUMCMDS]= {	20000L,		//wopen
				50000L,		//cgatt
				20000L,		//cgreg
				20000L,		//connectionstart
				20000L,		//putmail
				1000L,		//BS info
				1000L,		//special
				20000L};		//exit



char cmds[NUMCMDS][40] = {"AT+WOPEN=1\n",
							"AT+CGATT=1\n",
							"AT+CGREG=1\n",
							"AT#CONNECTIONSTART\n",
							"AT#PUTMAIL\n",
							"",
							"SPECIAL",
							"\r\n.\r\n",
							};
							

							
char cmdmatch[NUMCMDS][40] = {"OK",
							"OK",
							"OK",
							"Ok_Info",
							"Ok_Info",
							"",
							"",
							"OK",
							};
							
task void readerTask();
	
task void bsInfoTask();

	result_t addMsg(chunk_t *chunk, uint16_t *spaceleft);
							
	command result_t StdControl.init ()
	{
		call ModemControl.init();
		msg_count = 0;
		body[0]=0;
		cmdidx = 0;
		
		failure = 0;		
		msgidx = 0;
		record_count = 0;
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
	
	
	void Cleanup()
	{
		call ModemControl.stop();
		
	}
	
	void SignalSuccess()
	{
		int i;
		for (i=0; i < record_count; i++)
		{
			call AckStore.report_ack(turtles[i],indices[i],indices[i]);
		}
		record_count = 0;
		body[0] = 0;
		msg_count = 0;
		Cleanup();
		signal IGPRSSend.nodeDone(node_in, node_out, ERR_OK);
	}
	
	void SignalFailure()
	{
		failure++;
		Cleanup();
		signal IGPRSSend.nodeDone(node_in, node_out, ERR_OK);
	}

	task void SendCommand()
	{
		call Timer.start(TIMER_ONE_SHOT, 2000);
	}
	
	task void RealSendCommand()
	{

		char *cmdstr;
		
		if (cmdidx == BODY_NUM)
		{
			cmdstr = body;
		} else {
			cmdstr = cmds[cmdidx];
		}
		
		if (call GPRS.ATCmd(cmdstr, cmdmatch[cmdidx], cmddelay[cmdidx]) == FAIL)
		{
			SignalFailure();
		} else {
			/*int len = strlen(cmds[cmdidx])+1;
			memcpy(gmsg.data, cmds[cmdidx], len);
			call SendMsg.send(TOS_BCAST_ADDR, len, &gmsg);
			*/
		} 
	}
	
	
	event void GPRS.ready()
	{
		post SendCommand();
	}
	
	event result_t SendMsg.sendDone( TOS_MsgPtr msg, result_t success)
	{
		return SUCCESS;
	}
	
	event void GPRS.ATCmdDone(result_t result, char *response)
	{

		if (result == FAIL)
		{
			//SignalFailure();
			retries--;
			if (retries <= 0)
			{
				SignalFailure();
				return;
			}
			post SendCommand();
			
			
		} else {
			/*int len = strlen(response)+1;
			if (len > 60) len = 60;
			memcpy(gmsg.data, response, len);
			call SendMsg.send(TOS_BCAST_ADDR, len, &gmsg); */	
		
			cmdidx++;
			if (cmdidx >= NUMCMDS)
			{
				SignalSuccess();
			} else {
				post SendCommand();
			}
			
		} 
	}

	void BodyDone()
	{
		call ModemControl.start();
	}
	
	task void readerTask()
  	{
  		result_t res;
		bool eol;
	
		if ((BUFSIZE - msg_count) < 100)
		{
			BodyDone();
			return;
		}
  		res = call ObjLog.read(1,&eol);
		if (res == FAIL)
		{
			if (eol)
			{
				//no more packets in log 1
				BodyDone();
				return;
			}
			retries--;
			if (retries <= 0)
			{
				BodyDone();
			} else {
				post readerTask();
			}
			return;
		}
  	}
	
	
	event result_t ObjLog.readDone(int logid, uint8_t *buffer, uint16_t numbytes, result_t success)
  	{
		result_t res;
		uint16_t space;
  	
  		if (success == FAIL )
		{
			retries--;
			if (retries <= 0)
			{
				BodyDone();
			} else {
				post readerTask();
			}
			return SUCCESS;
		}
	
		retries = GPRS_RETRIES;

		
		memcpy(thechunk.data, buffer, numbytes);
		thechunk.length = numbytes;

		
		res = addMsg(&thechunk, &space);
		
		if (res == FAIL)
		{
			BodyDone();
		} else {
			if (space > 100)
			{
				post readerTask();
			} else {
				BodyDone();
			}
		}
  		return SUCCESS;
  	}
  
  event result_t ObjLog.appendDone(int logid, result_t success)
  {
  	
	return SUCCESS;
  }
	
	
	command result_t IGPRSSend.nodeCall (GPRSSend_in * in, GPRSSend_out * out)
	{
//PUT NODE IMPLEMENTATION HERE

		if (!g_active) 
		{
			return FAIL;
		}
		
		cmdidx = 0;
		retries = GPRS_RETRIES;
		post bsInfoTask();
		post readerTask();
		//call Timer.start(TIMER_ONE_SHOT, 10000L);
		return SUCCESS;
	}
	
	
	
	
	
	
	event result_t Timer.fired()
	{
		
		
		post RealSendCommand();
		
		return SUCCESS;
	}

	char inttohexdigit(int val)
	{
		
		if (val >= 0 && val <= 9) return ('0' + val);
		if (val >= 10 && val <= 15) return ('A' + (val-0x0A));
		return '*';
	}
	
	int decimal(char *dbuf, int32_t n) 
	{
		int32_t tmp = n;
		char digits[25];
		int numd = 0;
		
		int bufidx = 0;
		
		if (n == 0)
		{
			dbuf[bufidx] = '0';
			bufidx++;
			return bufidx;
		}
		if (n < 0)
		{
			dbuf[bufidx] = '-';
			bufidx++;
		}
		while (tmp != 0)
		{
			digits[numd] = '0' + (tmp % 10);
			tmp =tmp / 10;
			numd++;
		}
		numd--;
		while (numd >= 0)
		{
			dbuf[bufidx] = digits[numd];
			bufidx++;
			numd--;
		}
		
	
		return bufidx;
    }
	
	task void bsInfoTask()
	{
		char *buf = cmds[BS_INFO_NUM];
		//insert base station status information
		memset(cmds[BS_INFO_NUM], 0, sizeof(cmds[BS_INFO_NUM]));
		buf[0] = '@';
		buf++;
		
		buf = buf + decimal(buf, call IAccum.getVoltage());
		buf[0] = ',';
		buf++;
		buf = buf + decimal(buf, call IAccum.getInMicroJoules());
		buf[0] = ',';
		buf++;
 		buf = buf + decimal(buf, call IAccum.getOutMicroJoules());
		buf[0] = ',';
		buf++;
 		buf = buf + decimal(buf, call IAccum.getTemperature());
		buf[0] = ',';
		buf++;
 		buf = buf + decimal(buf, call IAccum.getTemperature2());
		buf[0] = '\n';
		buf++;
		
	}
	
	result_t addMsg(chunk_t *chunk, uint16_t *spaceleft)
	{
		uint16_t len;
		int i;
		uint8_t addr;
		uint16_t seq;

		len = chunk->length;
		if (record_count < NUMMSG-1)
		{
			addr = chunk->data[0];
			seq = chunk->data[2] + (chunk->data[3] << 8);
			
			//check to see if acked.
			if (call AckStore.check_packet(addr, seq) == TRUE)
			{
				return SUCCESS;
			}
			
			turtles[record_count] = addr;
			indices[record_count] = seq;
			//indices[record_count] = 0xbeef;
			record_count++;
		}
		
		*spaceleft = 0;
		
		if ((msg_count + (len*3)) > BUFSIZE-3) //leave space for ^Z and null char
		{
			return FAIL;
		}
		
		for (i=0; i < len; i++)
		{
			body[msg_count] = inttohexdigit((chunk->data[i] >> 4) & 0x0F);
			body[msg_count+1] = inttohexdigit(chunk->data[i] & 0x0F);
			body[msg_count+2] = ',';
			msg_count += 3;
		}
		body[msg_count] = '\n';
		msg_count++;
		body[msg_count] = 0;
		*spaceleft = (BUFSIZE-3 - msg_count);
		return SUCCESS;	
	}
  
	
	event void IAccum.update(int32_t inuJ, int32_t outuJ)
	{
	
	}
}
