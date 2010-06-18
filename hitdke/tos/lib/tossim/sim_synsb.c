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

#include <sim_synsb.h>          /* struct sim_event_t */

static SSB_DataSource theDS; /* global singleton data source object */

void 
sim_synsb_initDataSource(void)
{
    return;
}

SSB_DataSource * 
sim_synsb_getDataSource(void)
{
    return &theDS;
}

SSB_RecordSet * 
sim_synsb_queryDataSource(SSB_DataSource * pDS, sim_time_t readTime, int nodeId, int sensorId)
{
    return NULL;
}

int
sim_synsb_getFirstRecord(SSB_RecordSet * pRS)
{
    return 0;
}

