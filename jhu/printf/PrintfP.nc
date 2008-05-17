/*
 * "Copyright (c) 2006 Washington University in St. Louis.
 * All rights reserved.
 *
 * Permission to use, copy, modify, and distribute this software and its
 * documentation for any purpose, without fee, and without written agreement is
 * hereby granted, provided that the above copyright notice, the following
 * two paragraphs and the author appear in all copies of this software.
 *
 * IN NO EVENT SHALL WASHINGTON UNIVERSITY IN ST. LOUIS BE LIABLE TO ANY PARTY
 * FOR DIRECT, INDIRECT, SPECIAL, INCIDENTAL, OR CONSEQUENTIAL DAMAGES ARISING
 * OUT OF THE USE OF THIS SOFTWARE AND ITS DOCUMENTATION, EVEN IF WASHINGTON
 * UNIVERSITY IN ST. LOUIS HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 *
 * WASHINGTON UNIVERSITY IN ST. LOUIS SPECIFICALLY DISCLAIMS ANY WARRANTIES,
 * INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY
 * AND FITNESS FOR A PARTICULAR PURPOSE.  THE SOFTWARE PROVIDED HEREUNDER IS
 * ON AN "AS IS" BASIS, AND WASHINGTON UNIVERSITY IN ST. LOUIS HAS NO
 * OBLIGATION TO PROVIDE MAINTENANCE, SUPPORT, UPDATES, ENHANCEMENTS, OR
 * MODIFICATIONS."
 */

/**
 * The printf service is currently only available for msp430 based motes 
 * (i.e. telos, eyes) and atmega128 based motes (i.e. mica2, micaz).  On the
 * atmega platforms, avr-libc version 1.4 or above must be used.
 *
 * @author Kevin Klues (klueska@cs.wustl.edu)
 * @author Razvan Musaloiu-E. (razvanm@cs.jhu.edu)
 *
 * @version $Revision$
 * @date $Date$
 */

#include "printf.h"

#ifdef _H_atmega128hardware_H
static int uart_putchar(char c, FILE *stream);
static FILE atm128_stdout = FDEV_SETUP_STREAM(uart_putchar, NULL, _FDEV_SETUP_WRITE);
#endif

module PrintfP
{
  uses {
    interface Boot;
    interface SplitControl as SerialSplitControl;
    interface AMSend;
    interface Packet;
    interface Pool<message_t>;
    interface Queue<message_t*>;
    interface Leds;
  }
}

implementation {
  
  enum {
    S_ON,
    S_OFF,
  };

  norace nx_uint8_t* nextByte;
  message_t *writeMsg;
  message_t *sendMsg;
  uint8_t state;
  uint8_t bytesLeft;

  task void retrySend();

  void nextLine()
  {
    if (writeMsg != NULL) {
      if (sendMsg == NULL) {
	sendMsg = writeMsg;
	post retrySend();
      } else {
	call Queue.enqueue(writeMsg);
      }
    }
    writeMsg = call Pool.get();
    if (writeMsg != NULL) {
      nextByte = call AMSend.getPayload(writeMsg, sizeof(printf_msg_t));
      bytesLeft = sizeof(printf_msg_t);
    } else {
      call Leds.led0Toggle();
      // Buffer overflow
      nextByte = NULL;
    }
  }

  event void Boot.booted()
  {
#ifdef _H_atmega128hardware_H
    stdout = &atm128_stdout;
#endif
    nextLine();
    call SerialSplitControl.start();
  }
  
  event void SerialSplitControl.startDone(error_t error)
  {
    state = S_ON;

    if (sendMsg != NULL) {
      post retrySend();
    } else if (!call Queue.empty()) {
      sendMsg = call Queue.dequeue();
      post retrySend();
    }
  }

  event void SerialSplitControl.stopDone(error_t error)
  {
    state = S_OFF;
  }

  task void retrySend()
  {
    if (state == S_ON && 
	call AMSend.send(AM_BROADCAST_ADDR, sendMsg, call Packet.payloadLength(sendMsg)) != SUCCESS) {
      post retrySend();
    }
  }
  
  event void AMSend.sendDone(message_t* msg, error_t error)
  {
    if (error == SUCCESS) {
      if (writeMsg == NULL) {
	writeMsg = msg;
	nextByte = call AMSend.getPayload(writeMsg, sizeof(printf_msg_t));
	bytesLeft = sizeof(printf_msg_t);
      } else {
	call Pool.put(msg);
      }
      if (call Queue.empty()) {
	sendMsg = NULL;
	return;
      } else {
	sendMsg = call Queue.dequeue();
      }
    }
    post retrySend();
  }
 
#ifdef _H_msp430hardware_h
  int putchar(int c) __attribute__((noinline)) @C() @spontaneous() {
#endif
#ifdef _H_atmega128hardware_H
  int uart_putchar(char c, FILE *stream) __attribute__((noinline)) @C() @spontaneous() {
#endif
    atomic {
      if (nextByte != NULL) {
	*nextByte = c;
	nextByte++;
	bytesLeft--;
	if (c == '\n' || bytesLeft == 0) {
	  call Packet.setPayloadLength(writeMsg, sizeof(printf_msg_t) - bytesLeft);
	  nextLine();
	}
      }
      return 0;
    }
  }
}
