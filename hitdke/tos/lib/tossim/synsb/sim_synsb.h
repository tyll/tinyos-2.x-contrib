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


#ifndef SIM_SYNSB_CHANNEL
#define SIM_SYNSB_CHANNEL "TOSSIM.DB"
#endif /* SIM_SYNSB_CHANNEL */


#ifndef SIM_SYNSB_DSD
#error SIM_SYNSB_CHANNEL ": " "external data source SIM_SYNSB_DSD is not specified."
#endif /* SIM_SYNSB_DSD */


typedef struct
{
    int status;
    int data;
} SensorValue;


/**
 * Initialize the global DataSource object.
 * @param forceConnect
 * @return 0 on success
 */
int sim_synsb_initDataSource(bool forceConnect);

/**
 * Map sensor name string to the sensor id in configured DataSource.
 * @param sensorName
 * @return senorId
 */
int sim_synsb_mapSensorId(const char * sensorName);

/**
 * Query the global DataSource object.
 * @return a variant-type data.
 */
SensorValue sim_synsb_queryDataSource(sim_time_t readTime, int nodeId, int sensorId);


#ifdef __cplusplus
}
#endif

#endif /* __SIM_SYNSB_H__ */

