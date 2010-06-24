// $Id$

/*
 * Copyright (c) 2010 Data & Knowledge Engineering Research Center,
 *                    Harbin Institute of Technology, P. R. China.
 * All rights reserved.
 */

/**
 * Generic-type virtual Sensor component.
 * 
 * @param width_t type of return value
 * @param sensor_t type of sensor device to emulate
 * 
 * @author LIU Yu <pineapple.liu@gmail.com>
 * @date   June 24, 2010
 */

#include <sim_event_queue.h>    /* FOR: sim_{event,time}_t, sim_node() */
#include <sim_synsb.h>          /* FOR: sim_synsb_{init,query}DataSource */

generic module SyntheticSensorC(typedef width_t @integer(), 
    sensor_t sensorId)
{
    provides
    {
        interface Init;
        interface Read<width_t>;
        interface ReadNow<width_t>;
    }
    uses
    {
        interface SensorLatencyModel as LatencyModel;
        interface SensorEnergyModel as EnergyModel;
     }
}
implementation
{
    void handleReadEvent(sim_event_t* evt)
    {
        width_t val = 0;        /* (not-yet) obtained data */

        if (evt == NULL)
        {
            signal Read.readDone(EINVAL, val);
            return;
        }
        else
        {
            sim_time_t readTime = evt->time;
            int nodeId = evt->mote;
            SensorValue sv = sim_synsb_queryDataSource(readTime, nodeId, sensorId);
            
            /* TODO: examine some fields of sv to determine return status */
            
            val = (width_t)sv.data;
        }
        /* signal read done with obtained value */
        signal Read.readDone(SUCCESS, val);
        return;
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
    
    task void scheduleReadEvent()
    {
        /* allocate a new <tt>readEvent</tt> */
        sim_event_t * readEvent = allocateReadEvent();
        
        /* apply Sensor latency model to <tt>readEvent-&gt;time</tt> */
        readEvent->time = sim_time() + (call LatencyModel.getReadLatency());
        
        /* TODO: apply Sensor energy model if Power TOSSIM is detected */

        /* insert <tt>readEvent</tt> to TOSSIM's global event queue */
        sim_queue_insert(readEvent);
    }
    
    command error_t Read.read() 
    {
        char timeBuf[128];
        sim_print_time(timeBuf, 128, sim_time());
        dbg(SIM_SYNSB_CHANNEL, "mote %d sensor %d reads data at time %s\n", sim_node(), sensorId, timeBuf);
        return (post scheduleReadEvent());
    }
    
    async command error_t ReadNow.read()
    {
        return (call Read.read());
    }

    command error_t Init.init()
    {
        dbg(SIM_SYNSB_CHANNEL, "mote %d trying to initialize DataSource\n", sim_node());
        if (sim_synsb_initDataSource(FALSE) != 0)
        {
            return FAIL;
        }
        return SUCCESS;
    }
}

