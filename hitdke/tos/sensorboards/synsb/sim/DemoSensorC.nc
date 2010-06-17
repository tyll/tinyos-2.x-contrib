// $Id$

/*
 * Copyright (c) 2010 Data & Knowledge Engineering Research Center,
 *                    Harbin Institute of Technology, P. R. China.
 * All rights reserved.
 */

/**
 * Demo sensor for synthetic sensorboard.
 * 
 * @author LIU Yu <pineapple.liu@gmail.com>
 * @date   Jun 18, 2010
 */

#include "synsb.h"

generic configuration DemoSensorC()
{
  provides interface Read<uint16_t>;
}
implementation
{
  components new SyntheticSensorC(uint16_t, S_DEMO_SENSOR) as Sensor;
  Read = Sensor;
}
