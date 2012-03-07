
/*
 * Copyright (c) 2012 Martin Cerveny
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
 * - Neither the name of INSERT_AFFILIATION_NAME_HERE nor the names of
 *   its contributors may be used to endorse or promote products derived
 *   from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 * ``AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
 * FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL STANFORD
 * UNIVERSITY OR ITS CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
 * INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
 * STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
 * OF THE POSSIBILITY OF SUCH DAMAGE.
 */

/**
 * Implementation for BlinkRaven application.  Toggle the red LED when a
 * Timer fires and send some infos to LCD.
 *
 * @author: Martin Cerveny
 **/

#include "Timer.h"

module BlinkRavenC @safe()
{
  uses interface Timer<TMilli> as Timer0;
  uses interface Timer<TMilli> as Timer1;
  uses interface Timer<TMilli> as Timer2;
  uses interface Leds;
  uses interface Boot;
  uses interface Raven;
  uses interface LocalIeeeEui64 as Eui64;
}
implementation
{
  task void waitforeui() {
    ieee_eui64_t eui;
    eui = call Eui64.getId();

    if (eui.data[0] | eui.data[1] | eui.data[2] | eui.data[3] | eui.data[4] | eui.data[5] | eui.data[6]) 
      call Raven.hex(eui.data[7]+(eui.data[6] << 8), SIPC_HEXALL);
    else post waitforeui();
  }

  event void Boot.booted()
  {
    call Timer0.startPeriodic( 250 );
    call Timer1.startPeriodic( 500 );
    call Timer2.startPeriodic( 1000 );

    call Raven.msg("Hello World");
    call Raven.cmd(SIPC_CMD_ID_LCD_SYMB_RAVEN_ON);
    call Raven.cmd(SIPC_CMD_ID_LED_ON);

    post waitforeui(); // eui is prepared during Boot.booted() due to disabled interrupt in SofwareInit()
  }

  event void Timer0.fired()
  {
    call Leds.led0Toggle();
  }
  
  event void Timer1.fired()
  {
    call Leds.led1Toggle();
  }
  
  event void Timer2.fired()
  {
    call Leds.led2Toggle();
  }

  event void Raven.battery(uint16_t voltage) {
  }

  event void Raven.temperature(int16_t celsius) {
  }

}

