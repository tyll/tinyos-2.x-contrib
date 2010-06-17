// $Id$

/*
 * Copyright (c) 2010 Data & Knowledge Engineering Research Center,
 *                    Harbin Institute of Technology, P. R. China.
 * All rights reserved.
 */

/**
 * Sensor emulator that outputs sensor readings from a data source. 
 * 
 * @author LIU Yu <pineapple.liu@gmail.com>
 * @date   Jan 14, 2010
 */

#include "synsb.h"

#include <sim_event_queue.h>
#include <sim_synsb.h>          /* sim_synsb_{get,query}DataSource */

generic module SyntheticSensorC(typedef width_t @integer(), 
    sensor_t sensorId)
{
    provides interface Read<width_t>;
}
implementation
{
    void handleReadEvent(sim_event_t* evt)
    {
        width_t val;            /* default (undefined) read data */

        if (evt == NULL)
        {
            signal Read.readDone(FAIL, ERR_BAD_PTR);
            return;
        }
        else
        {
            sim_time_t readTime = evt->time;
            int nodeId = evt->mote;

            SSB_DataSource * pDS = SSB_getDataSource();
            SSB_RecordSet * pRS = NULL;

            if (pDS == NULL)
            {
                signal Read.readDone(FAIL, ERR_BAD_DS);
                return;
            }

            pRS = SSB_queryDataSource(pDS, readTime, nodeId, sensorId);
            if (pRS == NULL)
            {
                signal Read.readDone(FAIL, ERR_BAD_RS);
                return;
            }

            if (pRS->count <= 0)
            {
                signal Read.readDone(FAIL, ERR_NO_DATA);
                return;
            }

            val = (width_t)SSB_getFirstRecord(pRS);
        }

        // signal read done with obtained value
        signal Read.readDone(SUCCESS, val);
    }

    void cleanupReadEvent(sim_event_t* evt)
    {
        return sim_queue_cleanup_event(evt);
    } 

    sim_event_t* allocateReadEvent(void)
    {
        sim_event_t* evt = sim_queue_allocate_event();

        evt->time = sim_time();     // current time
        evt->mote = sim_node();     // current mote id
        evt->data = NULL;
        evt->cancelled = FALSE;
        evt->force = TRUE;          // always keep track of the event (even when node is off)
        evt->handle = handleReadEvent;
        evt->cleanup = cleanupReadEvent;

        return evt;
    }

    task void queryDataSource()
    {
        // insert a read event into the global event queue
        sim_event_t * readEvent = allocateReadEvent();
        sim_queue_insert(readEvent);
    }    
    
    command error_t Read.read() 
    {
        return post queryDataSource();
    }
}

