
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
 * Log recording application
 *
 * @author Marcus Chang <marcus@diku.dk>
 * @author Martin Leopold <leopold@diku.dk>
 */

#include "io.h"

#define _BV(bit) (1 << (bit))

//  #define PORTxIN (*(volatile TYPE_PORT_IN*)port_in_addr)

module LogRecorderP
{
    provides interface Init;
    uses interface GeneralIO as Pin0;
    uses interface GeneralIO as Pin1;
    uses interface GeneralIO as Pin2;
    uses interface GeneralIO as Pin3;
    uses interface GeneralIO as Pin4;
    uses interface GeneralIO as Pin5;
    uses interface GeneralIO as Pin6;
    uses interface GeneralIO as Pin7;
    uses interface GpioCounterCapture<T32khz,uint32_t>;
    uses interface Boot;
    uses interface Leds;
    uses interface StdOut;
}

implementation
{

#define NO_STATES 256
  uint32_t counts[NO_STATES];

// define to disable event counting
#define NO_EVENT_CNT
uint32_t events[8]; // Should be log_2(NO_STATES)

// define to disable bucket counting
//#define NO_BUCKET_CNT

#define BUCKET_SHIFT 0
#define NO_BUCKETS 300
  uint32_t t_cpu_on;
  uint32_t buckets[NO_BUCKETS];
  /**
   * Each bucket contains intervals af 1<<BUCKET_SHIFT ticks
   * ex. BUCKET_SHIFT=2
   *   bucket 0 is  0- 3 
   *   bucket 1 is  4- 7 
   *   bucket 2 is  8-11
   *   bucket 3 is 12-15 (3<<BUCKET_SHIFT - 4<<BUCKET_SHIFT-1)
   *
   *  bucket[NO_BUCKETS-1] == all ticks > NO_BUCKETS-1<<BUCKET_SHIFT
   *     for 10 bucket 
   */

  /*    0
    1
   10
   11

  100
  101
  110
  111

 1000
 1001
 1010
 1011

 1100
  */

  bool debug_print = 0;

    command error_t Init.init() {

        call Pin0.makeInput();
        call Pin1.makeInput();
        call Pin2.makeInput();
        call Pin3.makeInput();
        call Pin4.makeInput();
        call Pin5.makeInput();
        call Pin6.makeInput();
        call Pin7.makeInput();

        call GpioCounterCapture.captureRisingEdge();
        call GpioCounterCapture.captureFallingEdge();
        
        return SUCCESS;
    }

    event void Boot.booted() {

        call Leds.led0On();
        call StdOut.print("Program initialized\n\r");
    }
  /*
    uint8_t getState() {
        uint8_t state;
    
        state =  (call Pin0.get()) ? 0x01 : 0x00;
        state |= (call Pin1.get()) ? 0x02 : 0x00;
        state |= (call Pin2.get()) ? 0x04 : 0x00;
        state |= (call Pin3.get()) ? 0x08 : 0x00;
        state |= (call Pin4.get()) ? 0x10 : 0x00;
        state |= (call Pin5.get()) ? 0x20 : 0x00;
        state |= (call Pin6.get()) ? 0x40 : 0x00;
        state |= (call Pin7.get()) ? 0x80 : 0x00;
        
        return state;
    }
*/
    inline uint8_t getState() {
        uint8_t state;
        state  = (P1IN & 0x4) << 4; // State bit 7 is read as port 2 bit 2 (3rd bit)
        state |= (P4IN & ~(1<<6));
      
    return state;
    }

    uint8_t skip_Non = 1;
    uint8_t old_state = 0;
    uint32_t old_time = 0;

    async event void GpioCounterCapture.captured(uint32_t time) {
      uint32_t diff;
      uint8_t new_state;

      // State bit 7 is read as port 2 bit 2 (3rd bit)
      new_state  = (P1IN & 0x4) << 4;
      new_state |= (P4IN & ~(1<<6));
      diff = time - old_time;
      counts[old_state] += diff;   
      
      if (debug_print) {
        call StdOut.print("state: ");
        call StdOut.printBase2(old_state);
        call StdOut.print(" (");
        call StdOut.printBase10uint8(old_state);
        call StdOut.print(") : ");
        call StdOut.printBase10uint32(diff);
        call StdOut.print("\n\r");
      }

#ifndef NO_EVENT_CNT
      /**
       * Record the total number of events by bit no
       */
      if (!skip_Non || (new_state & (1<<7)) ) {
        uint8_t i, mask;
        uint8_t changed = new_state ^ old_state;
        changed = new_state & changed; // Count only "up" flank

        mask=1;
        for (i=0 ; i<8 ; i ++) {
          if (mask & changed) {
            events[i]++;
          }
          mask = mask<<1;
        }
      }
#endif

#ifndef NO_BUCKET_CNT
      /**
       * Record the distribution of the CPU event length.
       *   This categorizes the length of CPU event in NO_BUCKETS 
       *   with 1<<BUCKET_SHIFT ticks in each
       */
      if ( (!skip_Non || (new_state & (1<<7))) && // Skip prior to "on"
           ((old_state | new_state) & 0x1) ) { // CPU pin change
        if (new_state & 0x1) { // CPU pin was raised
          t_cpu_on = time;
        } else {               // CPU pin dropped
          diff = time - t_cpu_on;
          diff = (diff >> BUCKET_SHIFT);

          if (diff < NO_BUCKETS) {
            buckets[diff]++;
          } else {
            buckets[NO_BUCKETS-1]++;
          }
        }
      }
#endif
      old_time  = time;
      old_state = new_state;
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
        uint16_t i;
        uint8_t tmp[2];
        bool empty = TRUE;

        atomic tmp[0] = buffer;
        tmp[1] = '\0';

        switch (tmp[0]) {
        case 'd':
            debug_print = debug_print==0 ? 1 : 0;
                call StdOut.print("Debug print ");
        if (debug_print) {
                 call StdOut.print("enabled\n\r");
            } else {
                 call StdOut.print("disabled\n\r");
                }
            break;
            case 'g':                
                call StdOut.print("state: ");
                call StdOut.printBase2(getState());
                call StdOut.print("\n\r");
                break;

#ifndef NO_EVENT_CNT
        case 'c':
          for (i = 0; i<8; i++) {
            call StdOut.printBase10uint8(i);
            call StdOut.print(",");
            call StdOut.printBase10uint32(events[i]);
            call StdOut.print("\n\r");
          }
          call StdOut.print("\n\r");
          break;
#endif

#ifndef NO_BUCKET_CNT
        case 'b':
          for (i = 0; i < NO_BUCKETS-1; i++) {
            uint16_t low = i<<BUCKET_SHIFT;
            uint16_t high = ((i+1)<<BUCKET_SHIFT) - 1;
            call StdOut.printBase10uint16(low);
            call StdOut.print(",");
            call StdOut.printBase10uint32(buckets[i]);
            call StdOut.print("\n\r");
          }
          // Last bucket contains remaining counts
          call StdOut.printBase10uint16((NO_BUCKETS-1)<<BUCKET_SHIFT);
          call StdOut.print(",");
          call StdOut.printBase10uint32(buckets[NO_BUCKETS-1]);
          call StdOut.print("\n\r");
          call StdOut.print("\n\r");
          break;
#endif

            case 'p':
                for (i = 0; i < NO_STATES; i++) {                
                  // Skip state prior to "on" signal
                  if( !skip_Non || (i & (1<<7)) ) {
                    call StdOut.printBase10uint16(i - 128*skip_Non);
                    call StdOut.print(",");
                    call StdOut.printBase10uint32(counts[i]);
                    call StdOut.print("\n\r");
                  }
                }
                break;

            case 'P':
              for (i = 0; i < NO_STATES; i++) {                
                // skip empty states, skip state prior to "on" signal
                if( counts[i]>0 && (!skip_Non || (i & (1<<7))) ) {
                  call StdOut.printBase10uint16(i - 128*skip_Non);
                  call StdOut.print(",");
                  call StdOut.printBase10uint32(counts[i]);
                  call StdOut.print("\n\r");
                    
                  empty = FALSE;
                }
              }
              
              if (empty) {
                call StdOut.print("No states logged\n\r");
              } else {
                call StdOut.print("\n\r");
              }

              break;
        case 's':
          skip_Non = skip_Non ? 0 : 1;
          if (skip_Non){
        call StdOut.print("Now skipping states prior to \"on\" signal\n\r");
          } else {
        call StdOut.print("Not skipping states\n\r");
          }
          break;

            case 'r':
                call StdOut.print("Reset\n\r");
                atomic {
                  for (i=0 ; i<8 ; i++) {
                    events[i] = 0;
                  }
                  for (i=0 ; i<NO_BUCKETS ; i++) {
                    buckets[i] = 0;
                  }
                  for (i = 0; i < 256; i++) {        
                    counts[i] = 0;
                  }

                    old_state = 0;
                    old_time = 0;
                }
                break;

            case '\r':
                call StdOut.print("\n\r");
                break;

            default:
                call StdOut.print(tmp);
        }
    }

}

