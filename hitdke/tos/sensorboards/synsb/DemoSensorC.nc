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
 * @date   Apr 13 2009
 */

#include "synsb.h"

generic configuration DemoSensorC()
{
  provides interface Read<uint16_t>;
}
implementation
{
  components new SyntheticSensorC(uint16_t, F_VOLTAGE) as Sensor;
  Read = Sensor;
}
