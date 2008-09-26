
#ifndef _SIM_ENERGY_H_
#define _SIM_ENERGY_H_

#ifdef __cplusplus
extern "C" {
#endif



typedef struct sim_battery_t {
	double in_mJ;  
	double out_mJ;  
	double size;
	double energy;
	double waste;  
} sim_battery_t;

void sim_energy_init_all();
void sim_energy_init(int nodeId);

double sim_node_energy(int nodeId);
double sim_node_energy_in(int nodeId);
double sim_node_energy_out(int nodeId);
double sim_node_batt_size(int nodeId);
double sim_node_waste(int nodeId);

void set_sim_node_energy(int nodeId, double mJ);
void sim_harvest_energy(int nodeId, double mJ);
bool sim_consume_energy(int nodeId, double mJ);
bool sim_consume_profile(int nodeId, int path);
void set_sim_node_batt_size(int nodeId, double mJ);

#ifdef __cplusplus
}
#endif

#endif
