/**
* File: MotionSensorC.nc
* Version: 1.0
* Description:  Interface for motion sensor
* 
* Author: Laurynas Riliskis
* E-mail: Laurynas.Riliskis@ltu.se
* Date:   March 12, 2009
*
* Copyright notice
*
* Copyright (c) Communication Networks, Lulea University of Technology.
* All rights reserved.
*
* Redistribution and use in source and binary forms, with or without
* modification, are permitted provided that the following conditions
* are met:
* 1. Redistributions of source code must retain the above copyright
*    notice, this list of conditions and the following disclaimer.
* 2. Redistributions in binary form must reproduce the above copyright
*    notice, this list of conditions and the following disclaimer in the
*    documentation and/or other materials provided with the distribution.
* 3. All advertising materials mentioning features or use of this software
*    must display the following acknowledgement:
*	This product includes software developed by the Communication Networks
*   Group at Lulea University of Technology.
* 4. Neither the name of the University nor of the group may be used
*    to endorse or promote products derived from this software without
*    specific prior written permission.
*
* THIS SOFTWARE IS PROVIDED BY THE REGENTS AND CONTRIBUTORS ``AS IS'' AND
* ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
* IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
* ARE DISCLAIMED.  IN NO EVENT SHALL THE REGENTS OR CONTRIBUTORS BE LIABLE
* FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
* DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
* OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
* HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
* LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
* OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
* SUCH DAMAGE.
*/
/**
 * IR sensor detect motion. The component provides the interface MotionSensor and 
 * interface StdControl as MotionControl. Through filter, recgnise the motion of pepole. 
 * The IR sensor board has 3 LED. RED, GREEN, and BLUE. 
 *
 * @author Fan Zhang <fanzha@ltu.se>
 */
#include "hardware.h"

configuration MotionSensorC{

    provides {
        interface MotionSensor;
        interface SplitControl as MotionControl;
        interface Leds as MotionLeds;
        interface Init;
    }
    
}

implementation {
    components MainC, MotionSensorP as App, LedsC, IRsensorLedsC;
    components new TimerMilliC();
    components new IRsensorC();

    MotionLeds = IRsensorLedsC;
    MotionSensor = App;
    MotionControl = App;
    
    App.Init = Init;
    App.ReadNowResource -> IRsensorC;
    App.MotionReadNow -> IRsensorC;
    App.MilliTimer -> TimerMilliC;
    /***************************************/
    components HplM16c62pGeneralIOC as IOs,
             HplM16c62pInterruptC as Irqs,
             new M16c62pInterruptC() as Irq;
             
    
    App.PortIRQ -> IOs.PortP16;
    App.GIRQ -> Irq;  // HIL wire to HAL
    Irq -> Irqs.Int4; // HAL wire to HIL

    
}
