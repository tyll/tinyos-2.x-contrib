/*
 * Copyright (c) 2007, ETH Zuerich
 * All rights reserved.
 * Author: Min Guo
 */

#include "Timer.h"

generic configuration TimerT32khzC() {
  provides interface Timer<T32khz>;
}
implementation {
  components TimerT32khzP;
  Timer = TimerT32khzP.TimerT32khz[unique(UQ_TIMER_32KHZ)];
}


