
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
 * Log recording layer
 *
 * @author Marcus Chang <marcus@diku.dk>
 * @author Martin Leopold <leopold@diku.dk>
 */

configuration TestAppC {}
implementation {
    components MainC, TestAppP;

    MainC.SoftwareInit -> TestAppP.Init;
    MainC.Boot <- TestAppP;

    components new TimerMilliC() as TimerC;
    TestAppP.Timer -> TimerC;

/*
    components new PinC() as Bit0;
    components new PinC() as Bit1;
    components new PinC() as Bit2;
    components new PinC() as Bit3;
    components new PinC() as Bit4;
    components new PinC() as Bit5;
    components new PinC() as Bit6;
    components new PinC() as Bit7;
*/
    components LoggerPinsC;
    TestAppP.Bit0 -> LoggerPinsC.Mcu;
    TestAppP.Bit1 -> LoggerPinsC.GeneralIO[1];
    TestAppP.Bit2 -> LoggerPinsC.GeneralIO[2];
    TestAppP.Bit3 -> LoggerPinsC.GeneralIO[3];
    TestAppP.Bit4 -> LoggerPinsC.GeneralIO[4];
    TestAppP.Bit5 -> LoggerPinsC.GeneralIO[5];
    TestAppP.Bit6 -> LoggerPinsC.GeneralIO[6];
    TestAppP.Bit7 -> LoggerPinsC.Starter;

    TestAppP.Bit0 -> LoggerPinsC.Trigger;
    TestAppP.Bit1 -> LoggerPinsC.Trigger;
    TestAppP.Bit2 -> LoggerPinsC.Trigger;
    TestAppP.Bit3 -> LoggerPinsC.Trigger;
    TestAppP.Bit4 -> LoggerPinsC.Trigger;
    TestAppP.Bit5 -> LoggerPinsC.Trigger;
    TestAppP.Bit6 -> LoggerPinsC.Trigger;
    TestAppP.Bit7 -> LoggerPinsC.Trigger;
/*
    TestAppP.Bit0 -> Bit0;
    TestAppP.Bit1 -> Bit1;
    TestAppP.Bit2 -> Bit2;
    TestAppP.Bit3 -> Bit3;
    TestAppP.Bit4 -> Bit4;
    TestAppP.Bit5 -> Bit5;
    TestAppP.Bit6 -> Bit6;
    TestAppP.Bit7 -> Bit7;
*/
    components LedsC;
    TestAppP.Leds -> LedsC;

    components StdOutC;
    TestAppP.StdOut -> StdOutC;

}


