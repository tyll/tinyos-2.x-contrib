// $Id$

/*
 * Copyright (c) 2010 Data & Knowledge Engineering Research Center,
 *                    Harbin Institute of Technology, P. R. China.
 * All rights reserved.
 */

/**
 * Generic-type virtual Sensor configuration.
 * 
 * @param  width_t type of return value
 * @param  sensorName name of the sensor device / data attribute type to emulate
 * 
 * @author LIU Yu <pineapple.liu@gmail.com>
 * @date   June 25, 2010
 */

generic configuration VirtualSensorC(typedef width_t @integer(), 
    char sensorName[])
{
    provides
    {
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
    components new VirtualSensorP(width_t, sensorName);
    components MainC;
    
    VirtualSensorP.LatencyModel = LatencyModel;
    VirtualSensorP.EnergyModel = EnergyModel;
    VirtualSensorP.Init <- MainC.SoftwareInit;
    
    Read = VirtualSensorP;
    ReadNow = VirtualSensorP;
}

