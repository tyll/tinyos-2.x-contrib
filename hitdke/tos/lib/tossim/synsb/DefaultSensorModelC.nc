// $Id$

/*
 * Copyright (c) 2010 Data & Knowledge Engineering Research Center,
 *                    Harbin Institute of Technology, P. R. China.
 * All rights reserved.
 */

/**
 * Default Sensor latency and energy model implementation.
 *
 * @author LIU Yu <pineapple.liu@gmail.com>
 * @date   June 24, 2010
 */

module DefaultSensorModelC
{
    provides
    {
        interface SensorLatencyModel;
        interface SensorEnergyModel;
    }
}
implementation
{
    command uint8_t SensorLatencyModel.getReadLatency(void)
    {
        return 1;
    }

    command double SensorEnergyModel.getReadEnergy(void)
    {
        return 0.0;
    }
}

