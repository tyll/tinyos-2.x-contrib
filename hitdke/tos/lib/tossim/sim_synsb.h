// $Id$

/*
 * Copyright (c) 2010 Data & Knowledge Engineering Research Center,
 *                    Harbin Institute of Technology, P. R. China.
 * All rights reserved.
 */

/**
 * Local wrappers for the Synthetic DataSource (SDS) library routines.
 *
 * @author LIU Yu <pineapple.liu@gmail.com>
 * @date   June 24, 2010
 */

#ifndef __SIM_SYNSB_H__
#define __SIM_SYNSB_H__

#include <sim_tossim.h>         /* FOR: sim_time_t */
#include <sds.h>                /* FOR: Synthetic DataSource (SDS) API's */

#ifdef __cplusplus
extern "C"
{
#endif

typedef enum
{
    S_DEMO_SENSOR = 0,
} SensorType;

typedef struct
{
    int status;
    int data;
} SensorValue;

/**
 * Initialize the global DataSource object.
 * @param force 
 * @return 0 on success, positive otherwise
 */
int sim_synsb_initDataSource(bool force);

/**
 * Query the global DataSource object.
 * @return a variant-type data.
 */
SensorValue sim_synsb_queryDataSource(sim_time_t readTime, int nodeId, int sensorId);


#ifdef __cplusplus
}
#endif

#endif /* __SIM_SYNSB_H__ */

