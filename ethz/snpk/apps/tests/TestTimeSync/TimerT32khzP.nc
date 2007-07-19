/*
 * Copyright (c) 2007, ETH Zuerich
 * All rights reserved.
 * Author: Min Guo
 */

#include "Timer.h"

configuration TimerT32khzP {
  provides interface Timer<T32khz> as TimerT32khz[uint8_t id];
}
implementation {
  components HilTimerT32khzC, MainC;
  MainC.SoftwareInit -> HilTimerT32khzC;
  TimerT32khz = HilTimerT32khzC;
}

