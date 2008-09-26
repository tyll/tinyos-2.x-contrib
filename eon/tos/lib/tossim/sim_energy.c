

#include <stdio.h>
#include <tos.h>
#include <sim_energy.h>

int g_init = 0;
sim_battery_t node_battery[TOSSIM_MAX_NODES];

void sim_energy_init_all()
{

  int i;

  //printf("Initializing node_power variables to zero\n");

  for (i=0; i< TOSSIM_MAX_NODES; i++) {
    sim_energy_init(i);
  }
}

void sim_energy_init(int nodeId)
{
	if (g_init == 0)
	{
		g_init = 1;
		sim_energy_init_all();
	}
	node_battery[nodeId].in_mJ=0.0;
    	node_battery[nodeId].out_mJ=0.0;
    	node_battery[nodeId].size=0.0;
    	node_battery[nodeId].energy=0.0;
    	node_battery[nodeId].waste=0.0;
}



double sim_node_energy(int nodeId)
{
	return node_battery[nodeId].energy; 
}

double sim_node_energy_in(int nodeId)
{
	return node_battery[nodeId].in_mJ; 
}

double sim_node_energy_out(int nodeId)
{
	return node_battery[nodeId].out_mJ; 
}

double sim_node_batt_size(int nodeId)
{
	return node_battery[nodeId].size; 
}

double sim_node_waste(int nodeId)
{
	return node_battery[nodeId].waste; 
}

void set_sim_node_energy(int nodeId, double mJ)
{
	node_battery[nodeId].energy = mJ; 
}

void sim_harvest_energy(int nodeId, double mJ)
{
	node_battery[nodeId].in_mJ += mJ;
	node_battery[nodeId].energy += mJ;
	if (node_battery[nodeId].energy > node_battery[nodeId].size)
	{
		node_battery[nodeId].waste += node_battery[nodeId].energy - node_battery[nodeId].size;
		node_battery[nodeId].energy= node_battery[nodeId].size;
	}
}

bool sim_consume_energy(int nodeId, double mJ)
{
	node_battery[nodeId].out_mJ += mJ;
	node_battery[nodeId].energy -= mJ;
	if (node_battery[nodeId].energy < 0)
	{
		node_battery[nodeId].energy= 0;
		//maybe do some signalling cuz we're dead
		return FALSE;
	} 
	return TRUE;
}

bool sim_consume_profile(int nodeId, int path)
{
	//TODO:  need to add code for this. 
	return TRUE;
}


void set_sim_node_batt_size(int nodeId, double mJ)
{
	node_battery[nodeId].size = mJ; 
}

