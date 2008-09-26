#include <pthread.h>
#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include <values.h>
#include <stdarg.h>
#include <string.h>

#include "simworld.h"

#define __USE_GNU
//#include "/usr/include/dlfcn.h"
#include <dlfcn.h>

void __attribute__ ((constructor)) myinit(void);

int (*old_pthread_create)() = 0;
void (*old_pthread_exit)() = 0;
int (*old_usleep)() = 0;
unsigned int (*old_sleep)() = 0;

typedef void *(*__threadfunc) (void *);

typedef struct thread_struct
{
	__threadfunc func;
	void *arg;
} thread_struct_t;


#define MAX_TDS 20
#define ENERGY_TIME 5
#define IDLE_POWER	1000 //uW
#define GPS_POWER   300000 //uW
#define FLASH_POWER   100000 //uW
#define RADIO_LST_POWER   1000 //uW
#define RADIO_RX_POWER   18000 //uW
#define RADIO_TX_POWER   270000 //uW

#define GPS_MIN_TIME	30 //seconds
#define GPS_MAX_TIME	200 //seconds

#define RADIO_RX_TIME  3000 //us
#define RADIO_TX_TIME  3000 //us


/********DEFINED ACTIONS*************************/

#define ACTION_SENSOR 11
#define ACTION_RADIORX 12
#define ACTION_RADIOTX 13
#define ACTION_RADIOLSTN 14
#define ACTION_ENERGYIN 15
#define ACTION_ENERGYOUT 16
#define ACTION_ENERGYBATT 17
#define ACTION_SETCALLBACK 18
#define ACTION_USER 10

/********END DEFINED ACTIONS*********************/
typedef struct td_entry
{
	int valid;
	pthread_t id;
	int asleep;
	unsigned int waketime;
	pthread_cond_t cond;
} td_entry;


pthread_mutex_t __td_mutex = PTHREAD_MUTEX_INITIALIZER;
pthread_mutex_t __log_mutex = PTHREAD_MUTEX_INITIALIZER;
td_entry __tds[MAX_TDS];
unsigned int __current_time;  //in hundredths of a second
unsigned int __scale_factor;


__energyfunc the_energyfunc = NULL;
pthread_t energy_tid;

//MESSAGING VARS
int __inbox_full=0;
int __inbox_value;

//LOG FILE
FILE* __log_file = NULL;
char __log_file_name[512];
int __uselog = 0;
int __log_sys_evts = 0;
int __log_level;


/**********************************
Energy accounting variables
***********************************/
unsigned int __battery_uJ;
unsigned int __capacity_uJ;

int __outuW;
int __inuW;

int __outuJ;
int __inuJ;

pthread_t maint_tid;

int lastgpstime = GPS_MIN_TIME;



/*************************************
API
Here are the functions the user can call

*************************************/


void log_output(int action, const char *template, ...)
{
	va_list ap;
	
	
	if (__log_sys_evts == 0 && action > __log_level)
	{
		//don't log system events
		return;
	}
	
	pthread_mutex_lock(&__log_mutex);
	va_start(ap,template);
	if (__uselog)
	{
		__log_file = fopen(__log_file_name, "a");
		fprintf(__log_file,"@@:%d:%u:",action, __current_time);
		vfprintf(__log_file, template, ap);
		fprintf(__log_file, "\n");
		fclose(__log_file);
	} else {
		printf("@@:%d:%u:",action, __current_time);
		vprintf(template, ap);
		printf("\n");
	}
	va_end(ap);
	pthread_mutex_unlock(&__log_mutex);
	
	return;
}

int set_energy_callback(__energyfunc func)
{
	log_output(ACTION_SETCALLBACK,"%d", (int)func);
	the_energyfunc = func;
	return 0;
}


int get_sensor_reading()
{
	static int __reading = 0;
	int sleeptime;
	
	if (__battery_uJ <= 0) return -1;
	
	pthread_mutex_lock(&__td_mutex);
	__outuW += GPS_POWER;
	pthread_mutex_unlock(&__td_mutex);
	__reading++;
	
	sleeptime = ((rand() >> 4) % (GPS_MAX_TIME - GPS_MIN_TIME)) + GPS_MIN_TIME;
	sleep(sleeptime);
	log_output(ACTION_SENSOR,"%d",__reading);
	
	pthread_mutex_lock(&__td_mutex);
	__outuW -= GPS_POWER;
	pthread_mutex_unlock(&__td_mutex);
	
	
	return __reading;
}

int recv_network_int(unsigned int to_seconds, int *timedout)
{
	unsigned int time_so_far = to_seconds;
	int rxval = -1;
	int rxed = 0;
	int limit = 0;
	
	if (__battery_uJ <= 0) 
	{
		if (timedout != NULL)
		{
			*timedout = 1;
		}
		return -1;
	}
	
	if (to_seconds > 0)
	{
		limit = to_seconds;
	}
	
	pthread_mutex_lock(&__td_mutex);
	__outuW += RADIO_LST_POWER;
	pthread_mutex_unlock(&__td_mutex);
	
	log_output(ACTION_RADIOLSTN,"%d:%u",to_seconds,(int)timedout);
	
	while (!limit || time_so_far > 0)
	{
		if (__inbox_full && __battery_uJ > 0)
		{
			rxval = __inbox_value;
			rxed = 1;
			pthread_mutex_lock(&__td_mutex);
			__outuW += RADIO_RX_POWER;
			pthread_mutex_unlock(&__td_mutex);
			
			usleep(RADIO_RX_TIME);
			log_output(ACTION_RADIORX,"%d",rxval);
			
			pthread_mutex_lock(&__td_mutex);
			__outuW -= RADIO_RX_POWER;
			pthread_mutex_unlock(&__td_mutex);
			break;
		}
		sleep(3);
		if (limit)
		{
			time_so_far -= 3;
		}
	}
	pthread_mutex_lock(&__td_mutex);
	__outuW -= RADIO_RX_POWER;
	__outuW -= RADIO_LST_POWER;
	pthread_mutex_unlock(&__td_mutex);
	if (!rxed && timedout != NULL)
	{
		*timedout = 1;
	}
	if (rxed && timedout != NULL)
	{
		*timedout = 0;
	}
	return rxval;
	
}

void send_network_int(int value)
{

	if (__battery_uJ <= 0) return;

	pthread_mutex_lock(&__td_mutex);
	__outuW += RADIO_RX_POWER;
	pthread_mutex_unlock(&__td_mutex);
	
	
	usleep(RADIO_TX_TIME);
	log_output(ACTION_RADIOTX, "%d",value);
	
	pthread_mutex_lock(&__td_mutex);
	__outuW -= RADIO_RX_POWER;
	pthread_mutex_unlock(&__td_mutex);
}


/****************************************
End API Calls
******************************************/


unsigned int consume_energy(unsigned int __uJ)
{
	printf("consume_energy(%u) -> (%u, %u)\n", __uJ, __outuJ, __battery_uJ);
	__outuJ += __uJ;	
	if (__uJ <= __battery_uJ)
	{
		__battery_uJ -= __uJ;
	} else {
		__battery_uJ = 0;
	}
	return __battery_uJ;
}

unsigned int harvest_energy(unsigned int __uJ)
{
	__inuJ += __uJ;
	__battery_uJ += __uJ;
	if (__battery_uJ > __capacity_uJ)
	{
		__battery_uJ = __capacity_uJ;
	} 
	return __battery_uJ;
	
}

int getnextentry(pthread_t tid)
{
	int i;
	int theindex = -1;
	
	pthread_mutex_lock(&__td_mutex);
	for (i=0; i < MAX_TDS; i++)
	{
		
		if (__tds[i].valid == 0 && theindex == -1)
		{
			__tds[i].valid = 1;
			__tds[i].id = tid;
			__tds[i].asleep = 0;
			__tds[i].waketime = 0;
			pthread_cond_init(&__tds[i].cond, NULL);
			theindex = i;
			break;
		}
	}
	
	pthread_mutex_unlock(&__td_mutex);
	return theindex;
	
	
}


void removeentry(pthread_t tid)
{
	
	int i;
	
	pthread_mutex_lock(&__td_mutex);
	for (i=0; i < MAX_TDS; i++)
	{
		
		if (__tds[i].valid == 1 && pthread_equal(__tds[i].id, tid) != 0)
		{
			__tds[i].valid = 0;
			pthread_cond_destroy(&__tds[i].cond);
		}
	}
	
	pthread_mutex_unlock(&__td_mutex);	
	
}


int lookupentry(pthread_t tid)
{
	int theindex = -1;
	int i;
	for (i=0; i < MAX_TDS; i++)
	{
		if (__tds[i].valid == 1 && pthread_equal(__tds[i].id, tid) != 0)
		{
			theindex = i;
			break;
		}
	}
	
	
	return theindex;
}

void clearentries()
{
	int i;
	pthread_mutex_lock(&__td_mutex);
	for (i=0; i < MAX_TDS; i++)
	{
		__tds[i].valid = 0;
	}
	pthread_mutex_unlock(&__td_mutex);
}

int sleepy()
{
	int imsleepy = 1;
	int i;
	
	pthread_mutex_lock(&__td_mutex);
	for (i=0; i < MAX_TDS; i++)
	{
		if (__tds[i].valid == 1 && __tds[i].asleep == 0)
		{
			imsleepy = 0;
		}
	}
	pthread_mutex_unlock(&__td_mutex);
	return imsleepy;
}

unsigned int getnexttime()
{
	int i;
	unsigned int ntime = UINT_MAX;
	

	pthread_mutex_lock(&__td_mutex);
	printf("getnexttime\n");
	for (i=0; i < MAX_TDS; i++)
	{
		if (__tds[i].valid == 1 && __tds[i].waketime < ntime && __tds[i].waketime >= __current_time)
		{
			
			ntime = __tds[i].waketime;
		}
	}
	pthread_mutex_unlock(&__td_mutex);
	return ntime;
}

int realsleep(unsigned int waketime)
{
	unsigned int delta;
	unsigned int realdelta;
	int i;
	
	delta = waketime - __current_time;
	//actual time to sleep
	realdelta = (delta * 100)/__scale_factor;
	printf("realdelta = %u\n",realdelta);
	
	pthread_mutex_lock(&__td_mutex);
	for (i=0; i < MAX_TDS; i++)
	{
		if (__tds[i].valid == 1 && __tds[i].waketime == waketime)
		{
			
			__tds[i].asleep = 0;
			pthread_cond_signal(&__tds[i].cond);
		}
	}
	consume_energy((__outuW * delta) / 100);
	
	
	if (realdelta < 1000)
	{
		//from hs to us
		old_usleep(realdelta * 10000);
	} else {
		old_sleep(realdelta / 100);
	}
	if (waketime == UINT_MAX)
	{
		__current_time =0;
	} else {
		__current_time = waketime;
	}
	
	pthread_mutex_unlock(&__td_mutex);
	return realdelta;
}
	
void *__m_thread_routine (void *arg)
{

	unsigned int nexttime;
	unsigned int delta;
	
	while (1)
	{
		//check to see if all threads are asleep
		if (sleepy())
		{
			printf("sleepy-pre(%u)\n",nexttime);
			nexttime = getnexttime();
			printf("sleepy-post(%u)\n",nexttime);
			
			delta = realsleep(nexttime);
			
		}
		
		old_usleep(10);
	}
	return NULL;
}


void *__energy_thread_routine (void *arg)
{

	
	
	printf("energy thread!\n");
	
	
	while (1)
	{
		printf("energy thread! sleeping!\n");
		sleep(ENERGY_TIME);
		
		//printf("__outuJ = %u (%u)\n", __outuJ, __battery_uJ);
		
		log_output(ACTION_ENERGYIN,"%d",__inuJ);
		log_output(ACTION_ENERGYOUT,"%d",__outuJ);
		log_output(ACTION_ENERGYBATT,"%u",__battery_uJ);
		if (the_energyfunc != NULL)
		{
			printf("calling func\n");
			//add noise
			int innoise;
			int outnoise;
			unsigned int battnoise;
			
			innoise = ((rand() >> 4) % 600) - 300; //+/- 60uW accuracy
			outnoise = ((rand() >> 4) % 600) - 300;
			battnoise = (rand() >> 4) & 0x0000000f;
			
			
			the_energyfunc(__inuJ+innoise, __outuJ+outnoise, (__battery_uJ & 0xFFFFFFF0) | battnoise);
		}
		__inuJ = 0;
		__outuJ = 0;
	}
	return NULL;
}


void myinit(void)
{

	pthread_t self = pthread_self();
	int entry;

	clearentries();
	entry = getnextentry(self);
	__current_time= 0;
	__outuW = IDLE_POWER;
	
	//READ IN ENVIRONMENT VARIABLES
	
	char *str_factor = getenv("SIM_TIME_FACTOR");
	if (str_factor == NULL)
	{
		__scale_factor = 100;
	} else {
		__scale_factor = atoi(str_factor);
	}	
	
	char *str_bsize = getenv("BATTERY_SIZE");
	if (str_bsize == NULL)
	{
		__capacity_uJ = 10000000L;
		
	} else {
		__capacity_uJ= atoi(str_bsize);
	}	
	__battery_uJ = __capacity_uJ / 2;
	
	char *str_fname = getenv("SIM_LOG_FILE");
	if (str_fname == NULL)
	{
		__log_file = NULL;
		printf("Logging to stdout\n");	
	} else {
		strncpy(__log_file_name, str_fname, 500);
		
		__log_file = fopen(str_fname,"w");
		if (__log_file != NULL)
		{
			__uselog = 1;
		}
		fclose(__log_file);
		printf("Logging to file:%s(%d)\n",__log_file_name, __uselog);	
	}
		
	
	char *str_ll = getenv("SIM_LOG_LEVEL");
	if (str_ll == NULL)
	{
		__log_level = ACTION_USER;
	} else {
		__log_level = atoi(str_ll);
	}
	printf("Log Level=%d\n", __log_level);	
	
	//END OF READING ENVINRONMENT VARIABLES
	
	old_pthread_create = (int (*)()) dlsym(RTLD_NEXT, "pthread_create");
	
	if (old_pthread_create == NULL)
	{
		fprintf(stderr, "dlsym: %s\n", dlerror());
	} else {
		int ret;
		
		ret = old_pthread_create(&maint_tid, NULL, __m_thread_routine, NULL);
		
	}
	
	
	old_pthread_exit = (void (*)()) dlsym(RTLD_NEXT, "pthread_exit");
	
	if (old_pthread_exit == NULL)
	{
		fprintf(stderr, "dlsym: %s\n", dlerror());
	}
	
	old_sleep = (unsigned int (*)()) dlsym(RTLD_NEXT, "sleep");
	
	if (old_sleep == NULL)
	{
		fprintf(stderr, "dlsym: %s\n", dlerror());
	}
	
	old_usleep = (int (*)()) dlsym(RTLD_NEXT, "usleep");
	
	if (old_usleep == NULL)
	{
		fprintf(stderr, "dlsym: %s\n", dlerror());
	}
	
	pthread_create(&energy_tid, NULL, __energy_thread_routine, NULL);
	
	printf("libsimworld init! (entry=%d, scale=%u)\n", entry, __scale_factor);
}

void *__thread_routine (void *arg)
{
	void *ret;
	thread_struct_t *tst = (thread_struct_t*)arg;
	
	if (getnextentry(pthread_self()) == -1)
	{
		//could not find a free slot
		printf("TOO MANY THREADS! Killing this one.\n");
		pthread_exit(NULL);
	}
	
	ret = tst->func(tst->arg);
	pthread_exit(ret);
}


int pthread_create (pthread_t *__restrict __threadp,
			   __const pthread_attr_t *__restrict __attr,
			   void *(*__start_routine) (void *),
			   void *__restrict __arg)
{
	int ret;
	thread_struct_t *tst = malloc(sizeof(thread_struct_t));
	
	//printf ("shim: called pthread_create()\n");
	
	tst->func = __start_routine;
	tst->arg = __arg;
	
	ret = old_pthread_create(__threadp, __attr, __thread_routine, (void*)tst);

	return ret;
}


void __attribute__((noreturn)) pthread_exit(void *value_ptr)
{
	//clean up monitoring data here
	//printf ("shim: called pthread_exit()\n");
	
	removeentry(pthread_self());	
	
	old_pthread_exit(value_ptr);
	
	//never reached, but necessary to convince GCC that it won't return;
	exit(1);
}


unsigned int sleep (unsigned int __seconds)
{
	unsigned int realdelta;
	int idx;
	
	printf ("shim: called sleep(%u)\n", __seconds);
	pthread_mutex_lock(&__td_mutex);
	
	realdelta = __seconds * 100;
	idx = lookupentry(pthread_self());
	
	if (idx == -1)
	{
		printf("AAAH.  I have no record of this thread...BUG!\n");
		exit(1);
	}
	__tds[idx].waketime = __current_time + realdelta;
	__tds[idx].asleep = 1;
	printf ("pre-wait\n");
	pthread_cond_wait(&__tds[idx].cond, &__td_mutex);
	printf ("post-wait\n");
	//printf ("shim: sleep returned(%u, %u)\n", __tds[idx].waketime, __current_time);
	
	pthread_mutex_unlock(&__td_mutex);
	
	return __seconds;
}

int usleep (__useconds_t __useconds)
{
	
	unsigned int realdelta;
	int idx;
	
	//printf ("shim: called usleep()\n");
	pthread_mutex_lock(&__td_mutex);
	
	realdelta = __useconds / 10000;
	idx = lookupentry(pthread_self());
	if (idx == -1)
	{
		printf("AAAH.  I have no record of this thread...BUG!\n");
		exit(1);
	}
	__tds[idx].waketime = __current_time + realdelta;
	__tds[idx].asleep = 1;
	pthread_cond_wait(&__tds[idx].cond, &__td_mutex);
	pthread_mutex_unlock(&__td_mutex);
	return 0;
}

