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

#include <tos.h>

#ifdef __cplusplus
extern "C"
{
#endif

typedef enum
{
    S_DEMO_SENSOR = 0,
} SSB_SensorType;

typedef enum
{
    ERR_BAD_DS = 0,
    ERR_BAD_RS = 1,
    ERR_NO_DATA = 2,
} SSB_Error;

typedef struct
{
    int __unused__;
} SSB_DataSource;

typedef struct
{
    unsigned int count;
    int __unused__;
} SSB_RecordSet;

void SSB_initDataSource(void);

SSB_DataSource * SSB_getDataSource(void);

SSB_RecordSet * SSB_queryDataSource(SSB_DataSource * pDS, sim_time_t readTime, int nodeId, int sensorId);

int SSB_getFirstRecord(SSB_RecordSet * pRS);

#ifdef __cplusplus
}
#endif

#endif /* __SIM_SYNSB_H__ */
