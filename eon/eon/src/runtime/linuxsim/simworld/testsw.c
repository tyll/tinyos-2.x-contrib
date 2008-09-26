#include "simworld.h"
//#include <pthread.h>



void energy_cb(int uJin, int uJout, unsigned int uJbatt)
{
	log_output(ACTION_USER,"%d,%d,%u",uJin, uJout, uJbatt);
}


void * recv_thread(void *arg)
{
	while(1)
	{
		int to, val;
		val = recv_network_int(0, &to);
		//sim_sleep(10);
		if (!to)
		{
			send_network_int(val);
		}
	}
}


void *hello(void *arg)
{
	int i;
	
	printf("Hello! I'm a thread!\n");
	
	while(1)
	{
		get_sensor_reading();
		sim_sleep(5000);
	}
	
	return NULL;
}

int main(int argc, char **argv)
{
	int rc, t;
	pthread_t pt, rt;
	int self = pthread_self();
	
	printf("main self=%d\n", self);
	
	set_energy_callback(energy_cb);
	
	rc = sim_pthread_create(&pt, NULL, hello, NULL);
	
	if (rc)
	{
		printf("pthread_create: FAILED\n");
		exit(-1);
	}
	
	rc = sim_pthread_create(&rt, NULL, recv_thread, NULL);
	
	//pthread_join(pt, NULL);
	while (1)
	{
		sim_sleep(50);
	}
}

