#ifndef __ENERGY_MGR_H
#define __ENERGY_MGR_H

#include "simworld.h"
#include <stdint.h>

#define EVAL_COUNT (3600 / ENERGY_TIME)

typedef struct
{
	int energy_state;
	double state_grade;
	int64_t cost_of_reevaluation;
} energy_evaluation_struct_t;

void start_energy_mgr();

energy_evaluation_struct_t *reevaluate_energy_level(int64_t battery_state, int64_t battery_capacity);

void start_path(unsigned int session);

void end_path(unsigned int session, unsigned int pathid);
#endif
