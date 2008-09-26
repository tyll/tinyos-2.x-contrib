#include "tinyrely.h"
#include "telossource.h"
#include <pthread.h>
#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>

#include <string.h>



uint8_t suid=0;
int relyfd = 0;
uint8_t ackdsn = 0;
ConnStr connections[RELY_MAX_CONNECTIONS];
pthread_t recvthread;
bool done = FALSE;
pthread_mutex_t conn_mutex = {0, 0, 0, PTHREAD_MUTEX_RECURSIVE_NP, __LOCK_INITIALIZER};
  

//prototypes
int getNewConnection();
uint8_t getNextUID();
int handle_connect(telospacket *packet);
int handle_msg(telospacket *packet);
int handle_ack(telospacket *packet);
int getIndexByUID(uint8_t whatsuid);
bool isValidConnectionID(int connid);
bool isValidConnection(int connid);




//recv routine
void *recv_routine(void *arg)
{
  telospacket *packet;
  dbg(TRELY,"Receive Thread Started\n");
  while (!done)
    {
      packet = read_telos_packet(relyfd);
      if (packet == NULL)
		{
	 		dbg(TRELY,"NULL packet: We're done\n");
	 		done = TRUE;
	 		break;
		}
      dbg(TRELY,"Incoming packet...(t=%i,a=%i,d=%i,l=%i,g=%i)\n", 
      									packet->type, packet->addr,
      									packet->dsn, packet->length,
      									packet->group);
      
      if (packet->type == AM_TINYRELYCONNECT)
		{
			dbg(TRELY,"connect...\n");
	  		handle_connect(packet);
	  		free_telos_packet(&packet);
		}
      else if (packet->type == AM_TINYRELYMSG)
		{
			dbg(TRELY,"data...\n");
	  		handle_msg(packet);
	  		free_telos_packet(&packet);
		}
      else if (packet->type == AM_TINYRELYACK)
		{
			dbg(TRELY,"ack...\n");
	  		handle_ack(packet);
	  		free_telos_packet(&packet);
		}
      else
		{
	  		dbg(TRELY,"not mine...\n");
	  		//sleep(1);  
	  		free_telos_packet(&packet);
		}
    }
  dbg(TRELY,"Receive Thread Done\n");
  return NULL;
}


int tinyrely_init(const char* host, int port)
{

  int i;

  done = FALSE;
  if (relyfd != 0)
    {
      //called twice.  Not good
      return -1;
    }
  for (i=0; i < RELY_MAX_CONNECTIONS; i++)
    {
      connections[i].valid = FALSE;
      connections[i].callback = NULL;
      pthread_mutex_init(&connections[i].mutex, NULL);
    }

  relyfd = open_telos_source(host, port);
  if (relyfd < 0) return -1;
  //spawn recv thread.
  if(pthread_create(&recvthread, NULL, recv_routine, NULL))
    return -1;

 
  return 0;
}

int tinyrely_destroy()
{
  	done = TRUE; //tell recvthread to stop
 	
  	pthread_join(recvthread, NULL);
  	dbg(TRELY,"TinyRely recv thread joined\n");

	close(relyfd);
	dbg(TRELY,"TinyRely fd closed.\n");
  	relyfd = 0;
  	//reset connections
  
  	return 0;
}

int tinyrely_send(int id, const uint8_t *data, int length)
{
	bool failed = FALSE;
	int left = length;
	int err, counter = 0;
	telospacket packet;
	uint8_t buf[RELYMSGSIZE];
	
	
	dbg(TRELY,"tinyrely_send(%i, %i)\n",id, length);	
	if (length <= 0 || !isValidConnection(id))
	{
		dbg(TRELY,"failed...\n");
		return -1;
	}

	pthread_mutex_lock(&connections[id].mutex);
	
	while (left > 0)
	{
		uint8_t chunksize;
		if (left <= RELY_PAYLOAD_LENGTH)
		{
			chunksize = left;
		}
		else
		{
			chunksize = RELY_PAYLOAD_LENGTH;	
		}
		//send a chunk
		packet.length = CONNMSGSIZE;
  		packet.addr = TOS_BCAST_ADDR;
  		packet.type = AM_TINYRELYMSG;
  		packet.data = buf;
  		hton_uint16(buf, TOS_UART_ADDR);
  		buf[2] = connections[id].suid;
  		buf[3] = connections[id].duid;
  		buf[4] = connections[id].txseq;
  		buf[5] = chunksize;
  		memcpy(buf+6, data+(length-left), chunksize);
  		
  		
  		left -= chunksize;
  		connections[id].txseq++;
  		connections[id].sending = TRUE;
  		
  		counter = 0;
  		while (connections[id].sending)
  		{
  			if (counter % RELY_RESEND_TIMEOUT == 0)
  			{
  				err = write_telos_packet(relyfd, &packet);
  				dbg(TRELY,"write err=%i\n",err);
  				if (err)
    			{
      				connections[id].valid = FALSE;
      				connections[id].pending = FALSE;
      				break;
      			} //if err
  			}//if retry
  		
  			
  			usleep(RELY_ACKTIMER * 1000);
  			counter++;
  			
  			if (counter > RELY_SEND_TIMEOUT)
  			{
  				break;
  			}
  		} //while
		
		if (connections[id].sending)
		{
			//no go
			failed = TRUE;
			break;
		}
		
	}//while
	
	if (failed || left > 0)
	{
		connections[id].valid = FALSE;
	}
	
	pthread_mutex_unlock(&connections[id].mutex);
	
	if (connections[id].valid == FALSE)
	{
		return -1;
	}
	return 0;
}

int tinyrely_connect(recv_callback_t callback)
{
  int idx;
  telospacket packet;
  uint8_t data[CONNMSGSIZE];
  int err;
  int counter = 0;


  idx = getNewConnection();
  dbg(TRELY,"New Connection...%i\n",idx);
  if (idx == RELY_IDX_INVALID)
    {
      return RELY_IDX_INVALID;
    }


	pthread_mutex_lock(&connections[idx].mutex);
	connections[idx].callback = callback;
 	dbg(TRELY,"locked mutex...\n");
  	connections[idx].pending = TRUE;
  //send connection request
  packet.length = CONNMSGSIZE;
  packet.addr = TOS_BCAST_ADDR;
  packet.type = AM_TINYRELYCONNECT;
  packet.data = data;
  hton_uint16(data, TOS_UART_ADDR);
  dbg(TRELY,"getNextUID...");
  data[2] = getNextUID();
  dbg(TRELY,"DONE\n");
  data[3] = 0;
  data[4] = CONN_TYPE_REQUEST;
  data[5] = RELY_OK;
  
  connections[idx].suid = data[2];
  
  err = write_telos_packet(relyfd, &packet);
  dbg(TRELY,"err=%i\n",err);
  if (err)
    {
      connections[idx].valid = FALSE;
      connections[idx].pending = FALSE;
      pthread_mutex_unlock(&connections[idx].mutex);
      return RELY_IDX_INVALID;
    }
  

  while (connections[idx].pending &&
  		counter < RELY_TIMEOUT_COUNT)
    {
    	counter++;
    	usleep(RELY_GRANULARITY * 1000);
    	/*err = write_telos_packet(relyfd, &packet);
  		dbg(TRELY,"err=%i\n",err);
  		if (err)
    	{
    	  connections[idx].valid = FALSE;
    	  connections[idx].pending = FALSE;
    	  pthread_mutex_unlock(&connections[idx].mutex);
    	  return RELY_IDX_INVALID;
    	}*/
    }
    
	if (connections[idx].pending)
	{
		dbg(TRELY,"Connection request timed out.\n");
		connections[idx].valid = FALSE;
	}
  
  if (connections[idx].valid)
    {
      pthread_mutex_unlock(&connections[idx].mutex);
      return idx;
    }
     
 pthread_mutex_unlock(&connections[idx].mutex);
 return RELY_IDX_INVALID;
	}
	

int tinyrely_close(int id)
{
  	telospacket packet;
  	uint8_t data[CONNMSGSIZE];
  	int err;
  	int counter = 0;


  
  	dbg(TRELY,"Close Connection...%i\n",id);
  	if (!isValidConnection(id))
    {
      	return -1;
    }


	pthread_mutex_lock(&connections[id].mutex);
 	dbg(TRELY,"locked mutex...\n");
  	connections[id].closing = TRUE;
  	//send connection close request
  	packet.length = CONNMSGSIZE;
  	packet.addr = TOS_BCAST_ADDR;
  	packet.type = AM_TINYRELYCONNECT;
  	packet.data = data;
  	//form close msg
  	hton_uint16(data, TOS_UART_ADDR);
  	data[2] = connections[id].suid;
  	data[3] = connections[id].duid;
  	data[4] = CONN_TYPE_CLOSE;
  	data[5] = RELY_OK;
  
  
  
  	err = write_telos_packet(relyfd, &packet);
  	
  	if (err)
    {
    	dbg(TRELY,"err=%i\n",err);
    	connections[id].valid = FALSE;
    	connections[id].pending = FALSE;
    	pthread_mutex_unlock(&connections[id].mutex);
    	return -1;
    }
     
    connections[id].valid = FALSE;
    connections[id].pending = FALSE;
    pthread_mutex_unlock(&connections[id].mutex);
      
 	return 0;
	}
	
	
	//aux calls
	
	/* Tries to find an available slot for the connection.  Returns a -1 if one is not
	   found.  Returns the slot index otherwise.
	*/
int getNewConnection()
	    {
	      int connid = -1;
	      int i=0;
	      
	      pthread_mutex_lock(&conn_mutex);

      for (i=0; i < RELY_MAX_CONNECTIONS; i++)
	{
	  if (connections[i].valid == FALSE)
	    {
	      //found a free slot
	      connections[i].valid = TRUE;
	      connid = i;
	      break;
	    }
	}//for

      pthread_mutex_unlock(&conn_mutex);
      
      return connid;
    }

/* Increments the global SUID and returns the next one.  Should
     never return a value of zero.  This would be an error.
  */
  uint8_t getNextUID()
    {
      bool isunique = FALSE;
      int i=0;


      pthread_mutex_lock(&conn_mutex);
	while (!isunique)
	  {
	    isunique = TRUE;

	    //get next UID
	    suid = (suid + 1) % 255;
	    if (suid == 0)
	      suid++;

	    //check for uniqueness
	    for (i=0; i < RELY_MAX_CONNECTIONS; i++)
	      {
		if (connections[i].valid && connections[i].suid == suid)
		  {
		    isunique = FALSE;
		    break;
		  }
	      } //for
	  }//while

      pthread_mutex_unlock(&conn_mutex);
      return suid;
    }

 


int handle_connect(telospacket *packet)
{
	uint16_t src;
	uint8_t suid;
	uint8_t duid;
	uint8_t type;
	uint8_t ok;
	int idx;
	
	ntoh_uint16(packet->data, &src);
	suid = packet->data[2];
	duid = packet->data[3];
	type = packet->data[4];
	ok = packet->data[5];
	dbg(TRELY,"h_c src=%i\n",src);
	dbg(TRELY,"h_c suid=%i\n",suid);
	dbg(TRELY,"h_c duid=%i\n",duid);
	dbg(TRELY,"h_c type=%i\n",type);
	dbg(TRELY,"h_c ok=%i\n",ok);
	
	if (type == CONN_TYPE_REQUEST)
	{
		dbg(TRELY,"conntype = conn_request(%i)\n",CONN_TYPE_REQUEST);
		//currently do nothing
	}
	else if (type == CONN_TYPE_ACK)
	{
		
		//Someone is ack-ing our request
		dbg(TRELY,"Connection ACK!\n");

	 	pthread_mutex_lock(&conn_mutex);
	 
	   	idx = getIndexByUID(duid);
	   	dbg(TRELY,"DUID: %d -> INDEX: %d\n",duid,idx);


	   	if (idx != RELY_IDX_INVALID && 
	   		connections[idx].pending == TRUE)
	    { 
	       	dbg(TRELY,"Valid Connection (%d,%d)\n",idx,connections[idx].pending);
	       	connections[idx].duid = suid;
	       	connections[idx].txseq = 0;
	       	connections[idx].rxseq = 0;
	       	connections[idx].full = TRUE;
	       	connections[idx].count = 0;
	       	connections[idx].pending = FALSE;
		} else {
	       	dbg(TRELY,"Invalid Connection (%d,%d)\n",idx,connections[idx].pending);
	    }
	 
	 pthread_mutex_unlock(&conn_mutex);
	 
	}
	else if (type == CONN_TYPE_CLOSE)
	{
		dbg(TRELY,"conntype = conn_close(%i)\n",CONN_TYPE_CLOSE);
	}
	else 
	{
		dbg(TRELY,"ERROR: unknown type = %i\n",type);
		return -1;	
	}
  	return 0;
}

int handle_msg(telospacket *packet)
{
	uint16_t src;
	uint8_t suid;
	uint8_t duid;
	uint8_t seq;
	uint8_t length;
	uint8_t * data;
	uint8_t * ackdata;
	int idx;
	telospacket ackpkt;
	
	ntoh_uint16(packet->data, &src);
	suid = packet->data[2];
	duid = packet->data[3];
	seq = packet->data[4];
	length = packet->data[5];
	
	pthread_mutex_lock(&conn_mutex);
	 
	idx = getIndexByUID(duid);
	
	if (!isValidConnection(idx) || length > RELY_PAYLOAD_LENGTH)
	{
		pthread_mutex_unlock(&conn_mutex);
		return -1;
	}
	
	if (connections[idx].rxseq == seq)
	{
		data = malloc(length);
		memcpy(data, packet->data+6, length);
		connections[idx].callback(idx, data, length);
		free(data);
		data = NULL;
		connections[idx].rxseq++;
	}
	
	//send ack
	ackpkt.addr = TOS_BCAST_ADDR;
	ackpkt.type = AM_TINYRELYACK;
	ackpkt.dsn = ackdsn++;
	ackpkt.length = ACKMSGSIZE;
	ackdata = malloc(ACKMSGSIZE);
	
	ackpkt.data = ackdata;
	//fill in ack data here 
	hton_int16(ackdata, connections[idx].addr);
	ackdata[2] = connections[idx].suid;
	ackdata[3] = connections[idx].duid;
	ackdata[4] = connections[idx].rxseq;
	ackdata[5] = RELY_OK;
	//send the ack
	if (write_telos_packet(relyfd, &ackpkt))
	{
		dbg(TRELY,"Error sending ack!\n");
	}
	pthread_mutex_unlock(&conn_mutex);
  return 0;
}

int handle_ack(telospacket *packet)
{
	uint16_t src;
	uint8_t suid;
	uint8_t duid;
	uint8_t seq;
	uint8_t ok;
	int idx;
	
	ntoh_uint16(packet->data, &src);
	suid = packet->data[2];
	duid = packet->data[3];
	seq = packet->data[4];
	ok = packet->data[5];
	
	pthread_mutex_lock(&conn_mutex);
	 
	idx = getIndexByUID(duid);
	
	if (!isValidConnection(idx))
	{
		pthread_mutex_unlock(&conn_mutex);
		return -1;
	}
	
	if (connections[idx].txseq != seq || 
		connections[idx].sending == FALSE)
	{
		pthread_mutex_unlock(&conn_mutex);
		return -1;
	}
	
	if (ok != RELY_OK)
	{
		connections[idx].valid = FALSE;
		connections[idx].sending = FALSE;
		pthread_mutex_unlock(&conn_mutex);
		return -1;
	}
	
	connections[idx].sending = FALSE;
	pthread_mutex_unlock(&conn_mutex);
  return 0;
}

int getIndexByUID(uint8_t whatsuid)
{
	int idx = RELY_IDX_INVALID;
	int i;

	pthread_mutex_lock(&conn_mutex);
	
	for (i=0; i < RELY_MAX_CONNECTIONS; i++)
	{
	  	if (connections[i].valid && connections[i].suid == whatsuid)
	    {
	      	idx = i;
	      	break;
	    }
	} //for
      
    pthread_mutex_unlock(&conn_mutex);

    return idx;
}

bool isValidConnectionID(int connid)
{
	return (connid > RELY_IDX_INVALID && connid < RELY_MAX_CONNECTIONS);
}
  
bool isValidConnection(int connid)
{
	return (isValidConnectionID(connid) && connections[connid].valid);
}
