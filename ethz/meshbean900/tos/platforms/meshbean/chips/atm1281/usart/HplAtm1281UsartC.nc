/// $Id$

/*
 * Copyright (c) 2004-2005 Crossbow Technology, Inc.  All rights reserved.
 *
 * Permission to use, copy, modify, and distribute this software and its
 * documentation for any purpose, without fee, and without written agreement is
 * hereby granted, provided that the above copyright notice, the following
 * two paragraphs and the author appear in all copies of this software.
 * 
 * IN NO EVENT SHALL CROSSBOW TECHNOLOGY OR ANY OF ITS LICENSORS BE LIABLE TO 
 * ANY PARTY FOR DIRECT, INDIRECT, SPECIAL, INCIDENTAL, OR CONSEQUENTIAL 
 * DAMAGES ARISING OUT OF THE USE OF THIS SOFTWARE AND ITS DOCUMENTATION, EVEN
 * IF CROSSBOW OR ITS LICENSOR HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH 
 * DAMAGE. 
 *
 * CROSSBOW TECHNOLOGY AND ITS LICENSORS SPECIFICALLY DISCLAIM ALL WARRANTIES,
 * INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY 
 * AND FITNESS FOR A PARTICULAR PURPOSE. THE SOFTWARE PROVIDED HEREUNDER IS 
 * ON AN "AS IS" BASIS, AND NEITHER CROSSBOW NOR ANY LICENSOR HAS ANY 
 * OBLIGATION TO PROVIDE MAINTENANCE, SUPPORT, UPDATES, ENHANCEMENTS, OR 
 * MODIFICATIONS.
 */



#include <Atm1281Usart.h>

/**
 * HPL for the Atmega 1281 USART.
 *
 * @author Martin Turon <mturon@xbow.com>
 * @author David Gay
 * @author Philipp Sommer <sommer@tik.ee.ethz.ch> (Atmega1281 port)
 */
configuration HplAtm1281UsartC
{
  provides {
    interface StdControl as Usart0TxControl;
    interface StdControl as Usart0RxControl;
    interface HplAtm1281Usart as HplUsart0;
    
    interface StdControl as Usart1TxControl;
    interface StdControl as Usart1RxControl;
    interface HplAtm1281Usart as HplUsart1;
  }
}
implementation
{
  components HplAtm1281UsartP, PlatformC, McuSleepC;
  
  Usart0TxControl = HplAtm1281UsartP.Usart0TxControl;
  Usart0RxControl = HplAtm1281UsartP.Usart0RxControl;
  HplUsart0 = HplAtm1281UsartP.HplUsart0;
  
  Usart1TxControl = HplAtm1281UsartP.Usart1TxControl;
  Usart1RxControl = HplAtm1281UsartP.Usart1RxControl;
  HplUsart1 = HplAtm1281UsartP.HplUsart1;
  
  HplAtm1281UsartP.Atm128Calibrate -> PlatformC;
  HplAtm1281UsartP.McuPowerState -> McuSleepC;
  
  components MainC;
  MainC.SoftwareInit -> HplAtm1281UsartP.Usart0Init;
  MainC.SoftwareInit -> HplAtm1281UsartP.Usart1Init;
  
}
