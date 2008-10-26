/*
 * Copyright (c) 2007 University of Copenhagen
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 * - Redistributions of source code must retain the above copyright
 *   notice, this list of conditions and the following disclaimer.
 * - Redistributions in binary form must reproduce the above copyright
 *   notice, this list of conditions and the following disclaimer in the
 *   documentation and/or other materials provided with the
 *   distribution.
 * - Neither the name of University of Copenhagen nor the names of
 *   its contributors may be used to endorse or promote products derived
 *   from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 * ``AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
 * FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL THE UNIVERSITY
 * OF COPENHAGEN OR ITS CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
 * INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
 * STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
 * OF THE POSSIBILITY OF SUCH DAMAGE.
 */

/**
 * 
 * @author Marcus Chang
 *
 */

configuration LoggerPinsC {

  provides interface GeneralIO as Starter;
  provides interface GeneralIO as Trigger;
  provides interface GeneralIO as Mcu;
  provides interface GeneralIO[uint8_t id];

}

implementation
{    
    components HplMsp430GeneralIOC as HplGeneralIOC;
  
    components new Msp430GpioC() as Bit1;
    components new Msp430GpioC() as Bit2;
    components new Msp430GpioC() as Bit3;
    components new Msp430GpioC() as Bit4;
    components new Msp430GpioC() as Bit5;
    components new Msp430GpioC() as Bit6;

    Bit1.HplGeneralIO -> HplGeneralIOC.Port41;
    Bit2.HplGeneralIO -> HplGeneralIOC.Port42;
    Bit3.HplGeneralIO -> HplGeneralIOC.Port43;
    Bit4.HplGeneralIO -> HplGeneralIOC.Port44;
    Bit5.HplGeneralIO -> HplGeneralIOC.Port45;
    Bit6.HplGeneralIO -> HplGeneralIOC.Port12;

    GeneralIO[1] = Bit1.GeneralIO;
    GeneralIO[2] = Bit2.GeneralIO;
    GeneralIO[3] = Bit3.GeneralIO;
    GeneralIO[4] = Bit4.GeneralIO;
    GeneralIO[5] = Bit5.GeneralIO;
    GeneralIO[6] = Bit6.GeneralIO;

    components new Msp430GpioC() as McuPin;
    McuPin.HplGeneralIO -> HplGeneralIOC.Port40;
    Mcu = McuPin;

    components new Msp430GpioC() as StarterPin;    
    StarterPin.HplGeneralIO -> HplGeneralIOC.Port47;
    Starter = StarterPin;

    components new Msp430GpioC() as TriggerPin;    
    TriggerPin.HplGeneralIO -> HplGeneralIOC.Port46;
    Trigger = TriggerPin;

    components new Msp430GpioC() as BackupPin;    
    BackupPin.HplGeneralIO -> HplGeneralIOC.Port57;
    Starter = BackupPin;
}
