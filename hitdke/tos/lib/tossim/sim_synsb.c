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

static DataSource theDS;    /* global singleton data source object */

void 
sim_synsb_initDataSource(void)
{
    return;
}

DataSource * 
sim_synsb_getDataSource(void)
{
    return &theDS;
}

RecordSet * 
sim_synsb_queryDataSource(DataSource * pDS, sim_time_t readTime, int nodeId, int sensorId)
{
    return NULL;
}

int
sim_synsb_getFirstRecord(RecordSet * pRS)
{
    return 0;
}

