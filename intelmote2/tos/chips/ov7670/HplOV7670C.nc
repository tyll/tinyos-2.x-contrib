/*
* Copyright (c) 2008 Stanford University. All rights reserved.
* This file may be distributed under the terms of the GNU General
* Public License, version 2.
*/
/**
 * @brief Driver module for the OmniVision OV7670 Camera, inspired by V4L2
 *        linux driver for OV7670.
 * @author Brano Kusy (branislav.kusy@gmail.com)
 */
#include "OV7670.h"
configuration HplOV7670C
{
  provides interface HplOV7670;
  provides interface HplOV7670Advanced;
}
implementation {
  components HplOV7670M,
    LedsC,
    HplSCCBC,
    // HplSCCBReliableC,
    GeneralIOC;

  // Interface wiring
  HplOV7670	= HplOV7670M;
  HplOV7670Advanced	= HplOV7670M;

  // Component wiring
  HplOV7670M.Leds -> LedsC.Leds;
  HplOV7670M.Sccb_OVWRITE -> HplSCCBC.HplSCCB[OV7670_I2C_ADDR];
  // HplOV7670M.Sccb_OVWRITE -> HplSCCBReliableC.HplSCCB[OV7670_I2C_ADDR];

  HplOV7670M.RESET -> GeneralIOC.GeneralIO[83];	//A40-5
  HplOV7670M.PWDN -> GeneralIOC.GeneralIO[82];	//A40-1
  HplOV7670M.LED -> GeneralIOC.GeneralIO[106];	//A40-29

  HplOV7670M.SIOD -> GeneralIOC.GeneralIO[56];	//A40-3
  HplOV7670M.SIOC -> GeneralIOC.GeneralIO[57];	//A40-4

}
