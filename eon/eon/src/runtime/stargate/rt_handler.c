

#include "rt_handler.h"
#include "sfaccess/telossource.h"

#define PATHDONEMSGSIZE 3

extern int curstate;
extern float curgrade;

enum
{
  AM_PATHDONE_MSG = 0xd2
};



int sendPathDonePacket(rt_data _pdata);

bool isFunctionalState(int8_t state)
{
	return (curstate >= state);	
}

void reportError(uint16_t nodeid, uint8_t error, rt_data _pdata)
{
	printf("ERROR: %i:%i\n",nodeid, _pdata.weight);
	reportExit(_pdata);
}

void reportExit(rt_data _pdata)
{
	int result;
	printf("Flow done: %i\n",_pdata.weight);
	result = sendPathDonePacket(_pdata);
	if (result)
	{
		printf("ERROR sending path done packet\n");
	}
}

int sendPathStartPacket(int id)
{
	telospacket packet;
	uint8_t data[PATHDONEMSGSIZE];
	int err, fd;
	
  	packet.length = PATHDONEMSGSIZE;
  	packet.addr = TOS_BCAST_ADDR;
  	packet.type = AM_PATHDONE_MSG;
  	packet.data = data;
  	packet.data[0] = 1;
  	packet.data[1] = id;
  	packet.data[2] = 0;
  	
  	fd = open_telos_source("localhost", 9000);
 	if (fd <= 0)
 	{
 		printf("sendPathDonePacket: o_t_s failed! (fd=%i)\n",fd);
 		return 1;
 	}
  	
	err = write_telos_packet(fd, &packet);
    if (err)
    {
      printf("AAAH! Could not send status packet.\n");
      return -1;
    }
    
    close(fd);
    
    return 0;
		
}

int sendPathDonePacket(rt_data _pdata)
{
	telospacket packet;
	uint8_t data[PATHDONEMSGSIZE];
	int err, fd;
	
  	packet.length = PATHDONEMSGSIZE;
  	packet.addr = TOS_BCAST_ADDR;
  	packet.type = AM_PATHDONE_MSG;
  	packet.data = data;
  	packet.data[0] = 0;
  	packet.data[1] = _pdata.sessionID;
  	packet.data[2] = _pdata.weight;
  	
  	fd = open_telos_source("localhost", 9000);
 	if (fd <= 0)
 	{
 		printf("sendPathDonePacket: o_t_s failed! (fd=%i)\n",fd);
 		return 1;
 	}
  	
	err = write_telos_packet(fd, &packet);
    if (err)
    {
      printf("AAAH! Could not send status packet.\n");
      return -1;
    }
    
    close(fd);
    
    return 0;
}

int getNextSession()
{
	static int session= 0;
		
	session++;
	return session;
}

