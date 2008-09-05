/*
 * Copyright (c) 2008, Arizona Board of Regents
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without 
 * modification, are permitted provided that the following conditions are met:
 * - Redistributions of source code must retain the above copyright notice, 
 *   this list of conditions and the following disclaimer.
 * - Redistributions in binary form must reproduce the above copyright notice, 
 *   this list of conditions and the following disclaimer in the documentation 
 *   and/or other materials provided with the distribution.
 * - Neither the name of Arizona State University nor the names of its 
 *   contributors may be used to endorse or promote products derived from this 
 *   software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" 
 * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE 
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE 
 * ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE 
 * LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR 
 * CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF 
 * SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS 
 * INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN 
 * CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) 
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE 
 * POSSIBILITY OF SUCH DAMAGE.
 */

/** 
 * Configuration for an ECH2O-TE soil sensor running on a Telos class mote.
 *
 * Requires UART interfaces for data and resource arbitration, and a 
 * GeneralIO interface for probe excitation. Also the client must wire the
 * provided Msp430UartConfigure interface to its UART component. Below is
 * an example wiring for a hypothetical MoteC component, which uses UART0 and
 * ADC0.
 *
 *  components EchoTETelosC;
 *  components new Msp430Uart0C()   as UartC;
 *  components HplMsp430GeneralIOC;
 *  components new Msp430GpioC();
 *  
 *  MoteC.SoilProbeReader     -> EchoTETelosC.Read;
 *  UartC.Msp430UartConfigure -> EchoTETelosC.Msp430UartConfigure;
 *  EchoTETelosC.UartStream   -> UartC;
 *  EchoTETelosC.UartResource -> UartC;
 *  Msp430GpioC.HplGeneralIO  -> HplMsp430GeneralIOC.ADC0;
 *  EchoTETelosC.TriggerPin   -> Msp430GpioC;
 */ 
configuration EchoTETelosC {
    provides {
        interface Read<soil_reading_t>;
        interface Msp430UartConfigure;
    }
    uses {
        interface UartStream;
        interface Resource    as UartResource;
        interface GeneralIO   as TriggerPin;
    }
}
implementation {
    components EchoTETelosP;
    components new TimerMilliC() as Timer0;
    //components LedsFlasherC;
    
    Read                = EchoTETelosP;
    Msp430UartConfigure = EchoTETelosP;
    
    EchoTETelosP.UartStream   = UartStream;
    EchoTETelosP.UartResource = UartResource;
    EchoTETelosP.TriggerPin   = TriggerPin;
    
    EchoTETelosP.TimeoutTimer -> Timer0;
    //EchoTETelosP.LedsFlasher -> LedsFlasherC;
}
