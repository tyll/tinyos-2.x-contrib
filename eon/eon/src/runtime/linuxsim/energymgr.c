#include <pthread.h>
#include "simworld.h"
#include "energymgr.h"
#include "../mNodes.h"
#include <stdint.h>

#define MAX_PATHS  10

typedef struct p_ent
{
	int valid;
	unsigned int session;
	unsigned int pathid;
	unsigned int energy; //uJ
	int done;
} p_ent;

int pcount = 0;
int idle_uW=0;

p_ent __paths[MAX_PATHS];

int64_t __battery_energy=0;
int64_t __battery_capacity=0;

unsigned int __path_costs[NUMPATHS];
unsigned int __path_count[NUMPATHS];
unsigned int __path_pred_count[NUMPATHS][NUMSTATES];

pthread_mutex_t __p_mutex = PTHREAD_MUTEX_INITIALIZER;

int count_since_eval=0;

void plock()
{
	pthread_mutex_lock(&__p_mutex);
}

void punlock()
{
	pthread_mutex_unlock(&__p_mutex);
}

int doewma(int oldv, int newv, int num, int den)
{
	int retval;
	
	retval = ((oldv * (den-num)) + (newv * num))/den;
	return retval;
}


int doeval()
{
	energy_evaluation_struct_t * eval;
	plock();
	
	eval = reevaluate_energy_level(__battery_energy,__battery_capacity);
	
	curstate = eval->energy_state;
	curgrade = eval->state_grade;
	free(eval);
	
	punlock();
}


void energy_callback(int uJin, int uJout, unsigned int battery)
{
	int idle_share;
	int p_share;
	int p_ind;
	int i;

	plock();
	__battery_energy = battery;
	
	if (pcount == 0)
	{
		//idle all
		idle_share =uJout;
		
	} else {
		idle_share = idle_uW*ENERGY_TIME;
		if (idle_share > uJout)
		{
			idle_share = uJout;
			p_share = 0;
		} else {
			p_share = uJout - idle_share;
		}
	}
	p_ind = (p_share / pcount)+1;
	idle_uW = doewma(idle_uW, idle_share/ENERGY_TIME, 3,10);
		
	
	for (i=0; i < MAX_PATHS; i++)
	{
		if (__paths[i].valid)
		{
			__paths[i].energy += p_ind;
			if (__paths[i].done)
			{
				//factor path cost
				__path_costs[__paths[i].pathid] = doewma(__path_costs[__paths[i].pathid], __paths[i].energy, 3,10); 
				__paths[i].valid = 0;
			}
		}
	}	
	
	count_since_eval++;
	punlock();

	if (count_since_eval > EVAL_COUNT)
	{
		//signal eval.
		doeval();
	}
	
}


void start_path(unsigned int session)
{
	int i;
	
	plock();
	
	for (i=0; i < MAX_PATHS; i++)
	{
		if (__paths[i].valid==0)
		{
			__paths[i].valid = 1;
			__paths[i].session = session;
			__paths[i].energy=0;
			__paths[i].done = 0;
			__paths[i].pathid=0;
			break;
		}
	}
	
	punlock();
}

void end_path(unsigned int session, unsigned int pathid)
{
	int i;
	
	plock();
	
	__path_count[pathid]++;
	
	for (i=0; i < MAX_PATHS; i++)
	{
		if (__paths[i].valid==1 && __paths[i].session==session)
		{
			__paths[i].done = 1;
			__paths[i].pathid=pathid;
			
			
			break;
		}
	}
	
	punlock();
}

void start_energy_mgr()
{
	set_energy_callback(energy_callback);
	__battery_capacity = get_battery_size();
}
