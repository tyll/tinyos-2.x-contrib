// $Id$

/*
 * Copyright (c) 2010 Data & Knowledge Engineering Research Center,
 *                    Harbin Institute of Technology, P. R. China.
 * All rights reserved.
 */

/**
 * Configuration for the generic-type virtual Sensor component.
 * 
 * @author LIU Yu <pineapple.liu@gmail.com>
 * @date   June 24, 2010
 */

generic configuration SyntheticSensorP(typedef width_t @integer(), 
    sensor_t sensorId)
{
    provides interface Read<width_t>;
}
implementation
{
    components new SyntheticSensorC(width_t, sensorId);
    components MainC;
    MainC.SoftwareInit -> SyntheticSensorC;
    Read = SyntheticSensorC;
}

