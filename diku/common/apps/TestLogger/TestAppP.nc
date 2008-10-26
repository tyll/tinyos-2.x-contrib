
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

module TestAppP
{
    provides interface Init;
    uses interface Boot;
    uses interface Timer<TMilli>;
    uses interface GeneralIO as Bit0;
    uses interface GeneralIO as Bit1;
    uses interface GeneralIO as Bit2;
    uses interface GeneralIO as Bit3;
    uses interface GeneralIO as Bit4;
    uses interface GeneralIO as Bit5;
    uses interface GeneralIO as Bit6;
    uses interface GeneralIO as Bit7;
    uses interface Leds;
    uses interface StdOut;
}

implementation
{
    bool timerOn = FALSE;

    command error_t Init.init() {
    
        call Bit0.makeOutput();
        call Bit1.makeOutput();
        call Bit2.makeOutput();
        call Bit3.makeOutput();
        call Bit4.makeOutput();
        call Bit5.makeOutput();
        call Bit6.makeOutput();
        call Bit7.makeOutput();

        call Bit0.clr();
        call Bit1.clr();
        call Bit2.clr();
        call Bit3.clr();
        call Bit4.clr();
        call Bit5.clr();
        call Bit6.clr();
        call Bit7.clr();

        return SUCCESS;
    }

    event void Boot.booted() {

        call Leds.led0On();
        call StdOut.print("Program initialized\n\r");

    }


    event void Timer.fired()
    {
        call StdOut.print("Timer fired\n\r");
//        call Bit0.toggle();
    }


    /**************************************************************************
    ** StdOut
    **************************************************************************/
    uint8_t buffer;
    task void echoTask();

    async event void StdOut.get( uint8_t byte ) {
        buffer = byte;

        call Leds.led1Toggle();
        
        post echoTask();
    }

    task void echoTask() {
        uint8_t tmp[2];

        atomic tmp[0] = buffer;
        tmp[1] = '\0';

        switch (tmp[0]) {

            case '0':
                call StdOut.print("0\n\r");
                call Bit0.toggle();
                break;

            case '1':
                call StdOut.print("1\n\r");
                call Bit1.toggle();
                break;

            case '2':
                call StdOut.print("2\n\r");
                call Bit2.toggle();
                break;

            case '3':
                call StdOut.print("3\n\r");
                call Bit3.toggle();
                break;

            case '4':
                call StdOut.print("4\n\r");
                call Bit4.toggle();
                break;

            case '5':
                call StdOut.print("5\n\r");
                call Bit5.toggle();
                break;

            case '6':
                call StdOut.print("6\n\r");
                call Bit6.toggle();
                break;

            case '7':
                call StdOut.print("7\n\r");
                call Bit7.toggle();
                break;
 
            case 's':
                if (timerOn) {
                    timerOn = FALSE;
                    call Timer.stop();
                } else {
                    timerOn = TRUE;
                    call Timer.startPeriodic(100);
                }

            case '\r':
                call StdOut.print("\n\r");
                break;

            default:
                call StdOut.print(tmp);
        }
    }

}

