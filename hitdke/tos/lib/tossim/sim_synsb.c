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
 * @date   Jun 17 2010
 */

#include "sim_synsb.h"          /* struct sim_event_t */

static SSB_DataSource theDS; /* global singleton data source object */

extern "C" unsigned int unique(const char *);
extern "C" void assert(void *);

void 
SSB_initDataSource(void)
{
    return;
}

SSB_DataSource * 
SSB_getDataSource(void)
{
    return &theDS;
}

SSB_RecordSet * 
SSB_queryDataSource(SSB_DataSource * pDS, sim_time_t readTime, int nodeId, int sensorId)
{
   /* print debug info. */
    char timeBuf[128];
    sim_print_time(timeBuf, 128, readTime);
    dbg("sim_synsb", "mote %i(%i) read data at time %d.\n", nodeId, sensorId, timeBuf);

    return NULL;
}

int
SSB_getFirstRecord(SSB_RecordSet * pRS)
{
    return 0;
}

