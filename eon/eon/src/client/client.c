//#include "../mImpl.h"
//#include "rt_intercomm.h"
#include "sfaccess/telossource.h"
#include "sfaccess/teloscomm.h"
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <netdb.h> 
#include <unistd.h>
#include <signal.h>
#include <stdio.h>
#include <time.h>


#define AM_REQUESTMSG 0x14
#define AM_REDIRECTMSG 0x15
#define AM_METAMSG 0x16
#define AM_DATAMSG 0x17
#define AM_DATAACK 0x18

#define MYADDR 2

int waitforfd(int fd, int seconds)
{
  fd_set rfds;
  struct timeval tv;
  int retval;
                                                                                
  /* Watch stdin (fd 0) to see when it has input. */
  FD_ZERO(&rfds);
  FD_SET(fd, &rfds);
  /* Wait up to five seconds. */
  tv.tv_sec = seconds;
  tv.tv_usec = 0;
                                                                                
  retval = select(fd+1, &rfds, NULL, NULL, &tv);
  return retval;
}

void dump_packet(telospacket *packet)
{
  int i=0;
  fprintf(stderr,"dumping packet...\n");
  fprintf(stderr,"\tlength=%i\n", packet->length);
  fprintf(stderr,"\taddr=%X\n", packet->addr);
  
  for (i=0; i < packet->length; i++)
    {
      fprintf(stderr,"%X ", packet->data[i]);
    }
  fprintf(stderr,"\ndump done.\n");
}

telospacket *getMyPacket(int fd, uint16_t src, uint16_t suid)
{
  telospacket *recvpacket;
  int mine = 0;
  uint16_t puid;
  
  while (!mine)
    {

      if (!waitforfd(fd, 3))
	{
	  fprintf(stderr,"Error! timeout\n");
	  exit(1);
	}

      recvpacket = read_telos_packet(fd); 
      if (recvpacket ==  NULL)
	{
	  fprintf(stderr,"Error! Read error.\n");
	  exit(1);	
	}

      ntoh_uint16(recvpacket->data+2, &puid);
      fprintf(stderr,"Got packet (suid=%X, puid=%X)\n", suid, puid);
      dump_packet(recvpacket);
      if (puid == suid)
	{
	  mine = 1;
	} else {
	  free_telos_packet(&recvpacket);
	}
      
    }
  return recvpacket;
}


int main(int argc, char **argv)
{
  int port;
  uint16_t rport;
  int moteaddr;
  char *url;
  char *ipaddr;
  int result;
  int connid;
  char redirect = 0;
  uint32_t datalength;
  int index;
  char data;
  int telosfd;
  uint16_t suid;
  uint8_t dsn=0;
  uint16_t srcaddr = MYADDR;
  int connectcount;
  int sockfd, n;
  struct sockaddr_in serv_addr;
  struct hostent *server;
  telospacket packet;
  telospacket *recvpacket;
  uint8_t buf[28]; //MSG_SIZE

  if (argc != 5)
    {
      fprintf(stderr,"Usage: client <sf port> <mote address> <ipaddr> <object>\n");	
      fprintf(stderr,"Example: client 9001 2 128.119.23.14 movies/film.mpg\n\n");
      exit(1);
    }
		
  port = atoi(argv[1]);
  moteaddr = atoi(argv[2]);
  ipaddr = argv[3];
  url = argv[4];
  	
  	

  
  telosfd = open_telos_source("localhost",port);
  if (telosfd < 0)
    {
      fprintf(stderr,"Error! Could not open telos connection on port:%i\n",port);
      exit(2);	
    }

  srand(time(NULL));
  suid = rand();
	
  packet.type = AM_REQUESTMSG;
  packet.addr = moteaddr;
  packet.length = 60;
  packet.data = buf;
  bzero(buf,sizeof(buf));
  hton_uint16(buf, srcaddr);
  hton_uint16(buf+2, suid);
  memcpy(buf+4, url, strlen(url));  
  
  fprintf(stderr, "Sending %s\n",url);
  result = write_telos_packet(telosfd, &packet);
  if (result < 0)
    {
      fprintf(stderr,"Error! Send get failed\n");
      exit(1);	
    }
 	
  
  recvpacket = getMyPacket(telosfd, srcaddr, suid);
  
  if (recvpacket->type == AM_METAMSG)
    {
      free_telos_packet(&recvpacket);
      close(telosfd);
      fprintf(stderr,"Error! File not found.\n");
      exit(1);
    }

  if (recvpacket->type == AM_REDIRECTMSG)
    {
      ntoh_uint16(recvpacket->data+4, &rport);
  
      free_telos_packet(&recvpacket);
      close(telosfd);
      //get on 802.11
      //read port
      
      printf("rport=%i\n",rport);
      //sleep(8);
 		
 		
      sockfd = socket(AF_INET, SOCK_STREAM, 0);
      if (sockfd < 0) 
	{
	  fprintf(stderr,"Error! Can't create socket.\n");
	  exit(1);
	}	
 		
      server = gethostbyname(argv[3]);
      if (server == NULL) {
	fprintf(stderr,"ERROR, no such host\n");
	exit(0);
      }
      printf("Host: %s\n",server->h_name);
      printf("Type: %i\n",server->h_addrtype);
      printf("length: %i\n",server->h_length);
      printf("h_addr: %s\n",server->h_addr_list[0]);

      bzero((char *) &serv_addr, sizeof(serv_addr));
      serv_addr.sin_family = AF_INET;
      bcopy((char *)server->h_addr, 
	    (char *)&serv_addr.sin_addr.s_addr,
	    server->h_length);
      serv_addr.sin_port = htons(rport);

      connectcount = 0;
      result = 0;
      while (connectcount < 20)
	{
	  usleep(500000);
	  result = connect(sockfd,&serv_addr,sizeof(serv_addr));
	  if (result == 0) 
	    {
	      break;
	    } else {
	      connectcount++;
	      printf(".");
	    }
	}
      if (result < 0)
	{
	  fprintf(stderr,"ERROR, connect failed(%X)\n", serv_addr.sin_addr.s_addr);
	  exit(1);
	}
 		
      n = 1;
      while (n > 0)
	{
	  n = read(sockfd,&data,1);
	  if (n < 0) 
	    {
	      fprintf(stderr,"ERROR, read error\n");
	      exit(1);
	    }
	  printf("%c",data);
	}
      close(sockfd);
      return 0;
    } //redirect
 	
  
 	
  return 0;
}
