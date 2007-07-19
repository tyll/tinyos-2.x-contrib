/*
 * Copyright (c) 2007, ETH Zuerich
 * All rights reserved.
 * Author: Min Guo
 */

//QUESTION: 1. SHOULD INIT OR NOT? 2. MAKE SURE PORT 21?

#include "hardware.h"

configuration PlatformPINC
{
  provides interface GeneralIO as Pin;
}
implementation
{
  components
    HplMsp430GeneralIOC as GeneralIOC
    , new Msp430GpioC() as PinImpl
    ;

  Pin = PinImpl;
  PinImpl -> GeneralIOC.Port62;

}

