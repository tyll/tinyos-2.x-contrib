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

generic module SyntheticSensorC(typedef width_t @integer(), 
    sensor_type_t sensor_t)
{
    provides interface Read<width_t>;
}
implementation
{
    task void querySynSB()
    {
        // TODO post query to the REQ queue

        // TODO obtain value from data source

        width_t val = 0;

        // TODO signal read done with obtained value        
    	signal Read.readDone(SUCCESS, val);
        
    }
    
    command error_t Read.read() 
    {
        return post querySynSB();
    }
}
