#include "../mImpl.h"
#include "rt_intercomm.h"
#include "sfaccess/telossource.h"
#include <sys/types.h>
#include <unistd.h>
#include <signal.h>

extern const uint8_t minPathState[NUMPATHS];

int curstate = STATE_BASE;
float curgrade = 0.0;
//#define LOCALDBG

enum
{
  AM_STATUS_MSG = 0xd1,
  AM_SLEEP_MSG = 0xd3,
};

#define STATUSMSGSIZE 3

int asfpid = 0;

int startasf()
{
	int err;
	printf("startasf...\n");
	pid_t pID = fork();
	printf("forked(%i)\n",pID);
	if (pID == 0)
	{
		//child process
		#ifdef LOCALDBG
			err = execlp("./sf","sf","9000","/dev/ttyUSB0","115200","telos",(char*) 0);
		#else
			err = execlp("/root/asf","asf","9000","/dev/tts/1","19200","mica2dot",(char*) 0);	
		#endif
		if (err)
		{
			printf("execlp failed!\n");
			exit(1);
		}
		printf("Hrmmm....should not have reached this point.\n");
	} 
	else if (pID < 0)
	{
		printf("fork failed\n");
		return pID;
	} 
	else
	{
		return pID;
	}
	return pID;
}

int stopasf()
{
	int err;
	err = kill(asfpid, SIGTERM);
	if (err)
	{
		printf("error: could not send SIGTERM to proc %i\n",asfpid);
	}
	err = waitpid(asfpid, NULL, 0);
	printf("asf stopped...\n");	
	if (err <= 0)
	{
		return err;
	}
	return 0;
}

int closedown()
{
	int err;
	
	err = stopasf();
	if (err)
	{
		printf("stopasf failed (err=%i)\n",err);
		return err;
	}
	
	err = intercomm_stop();
	if (err)
	{
		printf("intercomm_stop failed (err=%i)\n",err);
		return err;
	}
	
	printf("closedown done\n");
	//usleep(100000);	
	return err;	
}

int firststartup(const char* host, short port)
{
	int err=0;
	
	asfpid = startasf();
	if (asfpid <= 0)
	{
		printf("Error starting asf (err=%i)\n",err);
		return asfpid;
	}
	printf("asf started (err=%i)\n",err);
	usleep(500000); 
	
	return err;
}

int startup(const char* host, short port)
{
	int err=0;
	
	asfpid = startasf();
	if (asfpid <= 0)
	{
		printf("Error starting asf (err=%i)\n",err);
		return asfpid;
	}
	printf("asf started (err=%i)\n",err);
	usleep(300000); 
	
	err = intercomm_start(port);	
	if (err)
	{
		printf("Error in startup (err=%i)\n",err);
		return err;
	}
	printf("Startup succeeded...\n");
	
	return err;
}


int sendStatusPacket(int fd, bool sleepy, uint16_t load)
{
	telospacket packet;
	uint8_t data[STATUSMSGSIZE];
	int err;
	
  	packet.length = STATUSMSGSIZE;
  	packet.addr = TOS_BCAST_ADDR;
  	packet.type = AM_STATUS_MSG;
  	packet.data = data;
  	data[0] = sleepy;
  	hton_uint16(data+1, load);
  	
	err = write_telos_packet(fd, &packet);
    if (err)
    {
      printf("AAAH! Could not send status packet.\n");
      return -1;
    }
    return 0;
}

int sendSleepPacket(int fd)
{
	telospacket packet;
	uint8_t data[1];
	int err;
	
  	packet.length = 1;
  	packet.addr = TOS_BCAST_ADDR;
  	packet.type = AM_SLEEP_MSG;
  	packet.data = data;
  	data[0] = 1;
  	
	err = write_telos_packet(fd, &packet);
    if (err)
    {
      printf("AAAH! Could not send sleep packet.\n");
      return -1;
    }
    return 0;
}


/*int main(int argc, char **argv)
{
	int fd;
	int err;
	int sleepy = FALSE;
	telospacket *packet;
	
  	init(argc,argv);
  	
  	printf("Starting\n");
  	sleep(1);
#ifndef LOCALDBG
  	system("modprobe usbserial");
	system("modprobe ftdi_sio");
	sleep(1);
	firststartup("localhost",9000);
	sleep(1);
	fd = open_telos_source("localhost", 9000);
 	if (fd <= 0)
 	{
 		printf("o_t_s failed! (fd=%i)\n",fd);
 		return 1;
 	}
 	sendStatusPacket(fd, 1, 0);
 	sleep(1);
 	//usleep(100000);
 	//sendStatusPacket(fd, 1, 0);
 	//usleep(100000);
 	close(fd);
 	usleep(500000);
 	//sleep(1);
 	printf("...going to sleep.\n");
 	err = stopasf();
	if (err)
	{
		printf("stopasf failed (err=%i)\n",err);
		return err;
	}
 	usleep(10000);
  	system("modprobe -r ftdi_sio");
  	system("modprobe -r usbserial");
  	system("/sbin/sys_suspend");
  	
#endif
  	while(TRUE)
  	{
  		//wait for device to wake
 #ifndef LOCALDBG
 		//sleep(2);
 		system("modprobe usbserial");
  		system("modprobe ftdi_sio");
 #endif
 
  		sleep(1);
  		err = startup("localhost",9000);
  		if (err)
  		{
  			printf("Startup failed...\n");
  			return 1;
  		}
 		
 		fd = open_telos_source("localhost", 9000);
 		if (fd <= 0)
 		{
 			printf("o_t_s failed! (fd=%i)\n",fd);
 			return 1;
 		}
 		
 		printf("startup succeeded...\n");
 		//wait for sleep msg and send status
 		while (!sleepy)
 		{	
 			packet = read_telos_packet(fd);
 			if (packet && packet->type == AM_SLEEP_MSG)
 			{
 				sleepy = TRUE;	
 				printf("Sleep Msg!");
 				sleep(1);
 			} else {
 				printf(".");
 			}	
 			
 			
 			free_telos_packet(&packet);
 			packet = NULL;	

 			
 		}
 		sleepy = FALSE; 		
 		sleep(1);
 		//send I'm sleeping packet
 		sendStatusPacket(fd, 1, 0);
 		usleep(10000);
 		close(fd);
 		
 		err = closedown();
  		if (err)
  		{
  			printf("closedown failed...\n");
  		} else {
  			printf("Going to sleep\n");
#ifdef LOCALDBG
 			sleep(5);
#else
  			system("modprobe -r ftdi_sio");
  			system("modprobe -r usbserial");
  			system("/sbin/sys_suspend");
#endif
  		}
  		sleep(1);///hrmmm
  	}
  	return 0;
}*/


int main(int argc, char **argv)
{
	int fd;

	int err;
	int sleepy = FALSE;
	bool connection = FALSE;
	FILE *connfile;
	bool firsttime = TRUE;
	
	telospacket *packet;
	
  	init(argc,argv);
  	
  	printf("Starting Server\n");
  	sleep(1);

	

	sleep(1);
	firststartup("localhost",9000);
	fd = open_telos_source("localhost", 9000);
	
	err = start_sources(fd);

  	while(TRUE)
  	{
  		if (!firsttime)
  		{
  			printf("Waiting for packet\n");
	  		packet = read_telos_packet(fd);
  		} else {
  			printf("First time...don't wait.\n");
  			packet = NULL;
  			firsttime = FALSE;
  		}
  		
 		if (packet)
 		{
 			int igrade;
 			curstate = packet->data[0];
 			igrade = packet->data[1];
 			curgrade = igrade;
 			curgrade = curgrade / 100.0;
 			free_telos_packet(&packet);
 		} 
 			
 		packet = NULL;
  		sleep(9);
  		printf("Time to sleep...if not connected.\n");
  		do
  		{
  			system("./check_wlan");
  			connfile = fopen("./connected","r");
  			if (connfile == NULL)
  			{
  				printf("not connected\n");
  				connection = FALSE;	
  			} else {
  				fclose(connfile);
  				connection = TRUE;
  				sleep(1);
  				printf("connected\n");
  			}
  		} while(connection);
  		printf("Sending packet.\n");
  		sendSleepPacket(fd);
  		sleep(1);
  		printf("Zzzzzz.....\n");
  		system("echo 1>/proc/sys/pm/suspend");
  		sleep(1);
  	}
  	return 0;
}
