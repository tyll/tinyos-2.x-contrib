/*
 * Copyright (c) 2007, Vanderbilt University
 * All rights reserved.
 *
 * Permission to use, copy, modify, and distribute this software and its
 * documentation for any purpose, without fee, and without written agreement is
 * hereby granted, provided that the above copyright notice, the following
 * two paragraphs and the author appear in all copies of this software.
 * 
 * IN NO EVENT SHALL THE VANDERBILT UNIVERSITY BE LIABLE TO ANY PARTY FOR
 * DIRECT, INDIRECT, SPECIAL, INCIDENTAL, OR CONSEQUENTIAL DAMAGES ARISING OUT
 * OF THE USE OF THIS SOFTWARE AND ITS DOCUMENTATION, EVEN IF THE VANDERBILT
 * UNIVERSITY HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 * 
 * THE VANDERBILT UNIVERSITY SPECIFICALLY DISCLAIMS ANY WARRANTIES,
 * INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY
 * AND FITNESS FOR A PARTICULAR PURPOSE.  THE SOFTWARE PROVIDED HEREUNDER IS
 * ON AN "AS IS" BASIS, AND THE VANDERBILT UNIVERSITY HAS NO OBLIGATION TO
 * PROVIDE MAINTENANCE, SUPPORT, UPDATES, ENHANCEMENTS, OR MODIFICATIONS.
 *
 * Author: Miklos Maroti
 */

#include <RadioConfig.h>

configuration HplRF230C
{
    provides
    {
        interface GeneralIO as SELN;
        interface Resource as SpiResource;
        interface SpiByte;
        interface FastSpiByte;

        interface GeneralIO as SLP_TR;
        interface GeneralIO as RSTN;

        interface GpioCapture as IRQ;
        interface Alarm<TRadio, uint16_t> as Alarm;
        interface LocalTime<TRadio> as LocalTimeRadio;
 
    }

}

implementation
{


    components HplRF230P;
    IRQ = HplRF230P.IRQ;


    components new SoftSpiRF230C() as Spi;
    HplRF230P.Spi -> Spi;
    SpiResource = Spi;
    SpiByte = Spi;
    FastSpiByte = HplRF230P.FastSpiByte;

    components HplM16c62pGeneralIOC as IOs;
    HplRF230P.PortVCC -> IOs.PortP77;
    HplRF230P.PortIRQ -> IOs.PortP83;
    SLP_TR = IOs.PortP07;
    RSTN = IOs.PortP43;
    SELN = IOs.PortP35;

    components  HplM16c62pInterruptC as Irqs,
                new M16c62pInterruptC() as Irq;
    HplRF230P.GIRQ -> Irq;
    Irq -> Irqs.Int1;

    components
#ifdef ENABLE_STOP_MODE
        AlarmRF23016C as AlarmRF230;
#else
    AlarmMicro16C as AlarmRF230;
#endif

    HplRF230P.Alarm -> AlarmRF230;
    Alarm = AlarmRF230;

    components RealMainP;
    RealMainP.PlatformInit -> HplRF230P.PlatformInit;
    
   	components LocalTimeMicroC;
  	LocalTimeRadio = LocalTimeMicroC;

}
