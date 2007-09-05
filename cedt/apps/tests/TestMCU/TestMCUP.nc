/*
 * "Copyright (c) 2007 CENTRE FOR ELECTRONICS AND DESIGN TECHNOLOGY,IISc.
 *  All rights reserved.
 *
 * Permission to use, copy, modify, and distribute this software and
 * its documentation for any purpose, without fee, and without written
 * agreement is hereby granted, provided that the above copyright
 * notice, the following two paragraphs and the author appear in all
 * copies of this software.
 *
 * IN NO EVENT SHALL CENTRE FOR ELECTRONICS AND DESIGN TECHNOLOGY,IISc BE LIABLE TO
 * ANY PARTY FOR DIRECT, INDIRECT, SPECIAL, INCIDENTAL, OR CONSEQUENTIAL DAMAGES
 * ARISING OUT OF THE USE OF THIS SOFTWARE AND ITS DOCUMENTATION, EVEN
 * IF CENTRE FOR ELECTRONICS AND DESIGN TECHNOLOGY,IISc HAS BEEN ADVISED OF THE
 * POSSIBILITY OF SUCH DAMAGE.
 *
 * CENTRE FOR ELECTRONICS AND DESIGN TECHNOLOGY,IISc SPECIFICALLY DISCLAIMS
 * ANY WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
 * MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.  THE SOFTWARE
 * PROVIDED HEREUNDER IS ON AN "AS IS" BASIS, AND CENTRE FOR ELECTRONICS
 * AND DESIGN TECHNOLOGY,IISc HAS NO OBLIGATION TO PROVIDE MAINTENANCE,
 * SUPPORT, UPDATES, ENHANCEMENTS, OR MODIFICATIONS."
 */

module TestMCUP {
  uses {
    interface Timer<TMilli> as RunningTimer;
    interface Timer<TMilli> as SleepTimer;
    interface McuSleep;
    interface Boot;
    interface Leds;
    interface Read<uint16_t>;
    interface SplitControl as RadioControl;
  }
}

implementation {

  event void Boot.booted() {
    call RunningTimer.startPeriodic(1024*5);
    call RadioControl.stop();
  }
  
  event void RunningTimer.fired() {
    call SleepTimer.startOneShot(1024*8);
    call Leds.led0Toggle();
    call RunningTimer.stop();
    call RadioControl.stop();
  }
  
  event void SleepTimer.fired() {
    call RunningTimer.startPeriodic(1024*5);
    call Leds.led1Toggle();
    call Read.read();
  }
  
  event void Read.readDone(error_t err, uint16_t data) {
    if(err == SUCCESS) {
      call RadioControl.start();
    }
  }
  
  event void RadioControl.startDone(error_t err) {
  
  }
  
  event void RadioControl.stopDone(error_t err) { }
}
