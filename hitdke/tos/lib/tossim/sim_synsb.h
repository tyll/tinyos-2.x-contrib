// $Id$

/*
 * Copyright (c) 2010 Data & Knowledge Engineering Research Center,
 *                    Harbin Institute of Technology, P. R. China.
 * All rights reserved.
 */

/**
 * C library for accessing synthetic data.
 *
 * @author LIU Yu <pineapple.liu@gmail.com>
 * @date   Jun 17 2008
 */

#ifndef __SIM_SYNSB_H__
#define __SIM_SYNSB_H__

#include <sim_tossim.h>         /* FOR: sim_time_t */
#include <sds.h>                /* FOR: HITDKE Synthetic DataSource API's */

#ifdef __cplusplus
extern "C"
{
#endif

typedef enum
{
    S_DEMO_SENSOR = 0,
} SensorType;

typedef enum
{
    ERR_BAD_DS = 0,
    ERR_BAD_RS = 1,
    ERR_NO_DATA = 2,
    ERR_BAD_PTR = 3,
} Error;

void sim_synsb_initDataSource(void);

DataSource * sim_synsb_getDataSource(void);

RecordSet * sim_synsb_queryDataSource(DataSource * pDS, sim_time_t readTime, 
    int nodeId, int sensorId);

int sim_synsb_getFirstRecord(RecordSet * pRS);

#ifdef __cplusplus
}
#endif

#endif /* __SIM_SYNSB_H__ */

