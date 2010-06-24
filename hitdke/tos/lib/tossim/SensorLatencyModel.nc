// $Id$

/*
 * Copyright (c) 2010 Data & Knowledge Engineering Research Center,
 *                    Harbin Institute of Technology, P. R. China.
 * All rights reserved.
 */

/**
 * Sensor devices latency model.
 *
 * @author LIU Yu <pineapple.liu@gmail.com>
 * @date   June 24, 2010
 */

interface SensorLatencyModel
{
    command uint8_t getUnitLatency(void);
}

