#include "../mImpl.h"
#include <sys/types.h>
#include <unistd.h>
#include <signal.h>

extern uint8_t minPathState[NUMPATHS];

//int curstate = STATE_BASE;
//float curgrade = 0.0;




int main(int argc, char **argv)
{
	int fd;
	int err;
	
  	init(argc,argv);
  	printf("starting sources...\n");
  	err = start_sources(fd);

  	while(TRUE)
  	{
  		sim_sleep(10);
  	}
  	return 0;
}
