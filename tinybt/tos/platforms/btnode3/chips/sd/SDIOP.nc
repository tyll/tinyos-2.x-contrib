// $Id$

/*
 * "Copyright (c) 2000-2003 The Regents of the University  of California.  
 * All rights reserved.
 *
 * Permission to use, copy, modify, and distribute this software and its
 * documentation for any purpose, without fee, and without written agreement is
 * hereby granted, provided that the above copyright notice, the following
 * two paragraphs and the author appear in all copies of this software.
 * 
 * IN NO EVENT SHALL THE UNIVERSITY OF CALIFORNIA BE LIABLE TO ANY PARTY FOR
 * DIRECT, INDIRECT, SPECIAL, INCIDENTAL, OR CONSEQUENTIAL DAMAGES ARISING OUT
 * OF THE USE OF THIS SOFTWARE AND ITS DOCUMENTATION, EVEN IF THE UNIVERSITY OF
 * CALIFORNIA HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 * 
 * THE UNIVERSITY OF CALIFORNIA SPECIFICALLY DISCLAIMS ANY WARRANTIES,
 * INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY
 * AND FITNESS FOR A PARTICULAR PURPOSE.  THE SOFTWARE PROVIDED HEREUNDER IS
 * ON AN "AS IS" BASIS, AND THE UNIVERSITY OF CALIFORNIA HAS NO OBLIGATION TO
 * PROVIDE MAINTENANCE, SUPPORT, UPDATES, ENHANCEMENTS, OR MODIFICATIONS."
 *
 * Copyright (c) 2002-2003 Intel Corporation
 * All rights reserved.
 *
 * This file is distributed under the terms in the attached INTEL-LICENSE     
 * file. If you do not find these files, copies can be found by writing to
 * Intel Research Berkeley, 2150 Shattuck Avenue, Suite 1300, Berkeley, CA, 
 * 94704.  Attention:  Intel License Inquiry.
 */
/**
 * Low level hardware access to the onboard AT45DB flash chip.
 * <p>
 * Note: This component includes optimised bit-banging SPI code with the
 * pins hardwired.  Don't copy it to some other platform without
 * understanding it (see txByte).
 *
 * @author Jason Hill
 * @author David Gay
 * @author Philip Levis
 */

#include "Timer.h"

module SDIOP {
  provides {
    interface Init;
    interface SpiByte;
    interface SpiPacket;
    interface SDByte;
  }
  uses {
    interface GeneralIO as Select;
    interface GeneralIO as Clk;
    interface GeneralIO as Out;
    interface GeneralIO as In;
    interface HplAtm128Interrupt as InInterrupt;
    interface BusyWait<TMicro, uint16_t>;
  }
}
implementation
{
  // We use SPI mode 0 (clock low at select time)
  uint16_t len;
  uint8_t* COUNT_NOK(len) txBuffer;
  uint8_t* COUNT_NOK(len) rxBuffer;
  uint16_t pos;
  
  enum {
    SPI_IDLE,
    SPI_BUSY,
    SPI_ATOMIC_SIZE = 10,
  };
  command error_t Init.init() {
    call Select.makeOutput();
    call Select.set();
    call Clk.clr();
    call Clk.makeOutput();
    call Out.set();
    call Out.makeOutput();
    //call In.clr();
    call In.makeInput();

    //call InInterrupt.disable();
    //call InInterrupt.edge(TRUE);

    return SUCCESS;
  }

//  command void SDByte.select() {
//    call Clk.clr(); // ensure SPI mode 0
//    call Select.clr();
//  }
//
//  command void SDByte.deselect() {
//    call Select.set();
//  }
  
#define BITINIT \
  uint8_t clrClkAndData = PORTD & ~0x28

#define BIT(n) \
	PORTD = clrClkAndData; \
	asm __volatile__ \
        (  "sbrc %2," #n "\n" \
	 "\tsbi 18,3\n" \
	 "\tsbi 18,5\n" \
	 "\tsbic 16,2\n" \
	 "\tori %0,1<<" #n "\n" \
	 : "=d" (spiIn) : "0" (spiIn), "r" (spiOut))

  async command uint8_t SpiByte.write(uint8_t spiOut) {
    uint8_t spiIn = 0;
    uint8_t i = 8;

    // This atomic ensures integrity at the hardware level...
    atomic
      {
//  Too fast for SD Card
//	BITINIT;
//
//	BIT(7);
//	BIT(6);
//	BIT(5);
//	BIT(4);
//	BIT(3);
//	BIT(2);
//	BIT(1);
//	BIT(0);
          //call Select.clr();
		  do {
		    i--;
	    	call Clk.clr();
	    	if (spiOut & 1 << i)
	    	call Out.set();
	    	else call Out.clr();
	    	call BusyWait.wait(4);
	    	call Clk.set();
	    	if (call In.get())
	    	spiIn |= 1 << i;
	    	call BusyWait.wait(4);
		  } while (i);
      }

    return spiIn;
  }

  task void avail() {
    signal SDByte.idle();
  }

  command void SDByte.wait() {
    // Setup interrupt on rising edge of flash in
    atomic
      {
	call InInterrupt.clear();
	call InInterrupt.enable();
	// We need to wait at least 2 cycles here (because of the signal
	// acquisition delay). It's also good to wait a few microseconds
	// to get the fast ("FAIL") exit from wait (reads are twice as fast
	// with a 2us delay...)
	call BusyWait.wait(2);
	if (call In.get())
	  signal InInterrupt.fired(); // already high
      }
  }

  async event void InInterrupt.fired() {
    call InInterrupt.disable();
    post avail();
  }

//  command bool SDByte.getCompareStatus() {
//    call Clk.set();
//    call Clk.clr();
//    // Wait for compare value to propagate
//    asm volatile("nop");
//    asm volatile("nop");
//    return !call In.get();
//  }
  /**
   * This component sends SPI packets in chunks of size SPI_ATOMIC_SIZE
   * (which is normally 5). The tradeoff is between SPI performance
   * (throughput) and how much the component limits concurrency in the
   * rest of the system. Handling an interrupt on each byte is
   * very expensive: the context saving/register spilling constrains
   * the rate at which one can write out bytes. A more efficient
   * approach is to write out a byte and wait for a few cycles until
   * the byte is written (a tiny spin loop). This leads to greater
   * throughput, but blocks the system and prevents it from doing
   * useful work.
   *
   * This component takes a middle ground. When asked to transmit X
   * bytes in a packet, it transmits those X bytes in 10-byte parts.
   * <tt>sendNextPart()</tt> is responsible for sending one such
   * part. It transmits bytes with the SpiByte interface, which
   * disables interrupts and spins on the SPI control register for
   * completion. On the last byte, however, <tt>sendNextPart</tt>
   * re-enables SPI interrupts and sends the byte through the
   * underlying split-phase SPI interface. When this component handles
   * the SPI transmit completion event (handles the SPI interrupt),
   * it calls sendNextPart() again. As the SPI interrupt does
   * not disable interrupts, this allows processing in the rest of the
   * system to continue.
   */
   
  error_t sendNextPart() {
    uint16_t end;
    uint16_t tmpPos;
    uint16_t myLen;
    uint8_t* COUNT_NOK(myLen) tx;
    uint8_t* COUNT_NOK(myLen) rx;
    
    atomic {
      myLen = len;
      tx = txBuffer;
      rx = rxBuffer;
      tmpPos = pos;
      end = pos + SPI_ATOMIC_SIZE;
      end = (end > len)? len:end;
    }

    for (;tmpPos < (end - 1) ; tmpPos++) {
      uint8_t val;
      if (tx != NULL) 
	val = call SpiByte.write( tx[tmpPos] );
      else
	val = call SpiByte.write( 0 );
    
      if (rx != NULL) {
	rx[tmpPos] = val;
      }
    }

    // For the last byte, we re-enable interrupts.

   //call Spi.enableInterrupt(TRUE);
   atomic {
     if (tx != NULL)
       call SpiByte.write(tx[tmpPos]);
     else
       call SpiByte.write(0);
     
     pos = tmpPos;
      // The final increment will be in the interrupt
      // handler.
    }
    return SUCCESS;
  }


  task void zeroTask() {
     uint16_t  myLen;
     uint8_t* COUNT_NOK(myLen) rx;
     uint8_t* COUNT_NOK(myLen) tx;

     atomic {
       myLen = len;
       rx = rxBuffer;
       tx = txBuffer;
       rxBuffer = NULL;
       txBuffer = NULL;
       len = 0;
       pos = 0;
       signal SpiPacket.sendDone(tx, rx, myLen, SUCCESS);
     }
  }
  /**
   * Send bufLen bytes in <tt>writeBuf</tt> and receive bufLen bytes
   * into <tt>readBuf</tt>. If <tt>readBuf</tt> is NULL, bytes will be
   * read out of the SPI, but they will be discarded. A byte is read
   * from the SPI before writing and discarded (to clear any buffered
   * bytes that might have been left around).
   *
   * This command only sets up the state variables and clears the SPI:
   * <tt>sendNextPart()</tt> does the real work.
   * 
   * If there's a send of zero bytes, short-circuit and just post
   * a task to signal the sendDone. This generally occurs due to an
   * error in the caler, but signaling an event will hopefully let
   * it recover better than returning FAIL.
   */

  
  async command error_t SpiPacket.send(uint8_t* writeBuf, 
				       uint8_t* readBuf, 
				       uint16_t  bufLen) {
    uint8_t discard;
    atomic {
      len = bufLen;
      txBuffer = writeBuf;
      rxBuffer = readBuf;
      pos = 0;
    }
    if (bufLen > 0) {
      discard = call SpiByte.write(SD_BLANK_BYTE);
      return sendNextPart();
    }
    else {
      post zeroTask();
      return SUCCESS;
    }
  }

 default async event void SpiPacket.sendDone
      (uint8_t* _txbuffer, uint8_t* _rxbuffer, 
       uint16_t _length, error_t _success) { }
//  async event void SpiPacket.dataReady(uint8_t data) {
//   bool again;
//   
//   atomic {
//     if (rxBuffer != NULL) {
//       rxBuffer[pos] = data;
//       // Increment position
//     }
//     pos++;
//   }
//   //call Spi.enableInterrupt(FALSE);
//   
//   atomic {
//     again = (pos < len);
//   }
//   
//   if (again) {
//     sendNextPart();
//   }
//   else {
//     uint8_t discard;
//     uint16_t  myLen;
//     uint8_t* COUNT_NOK(myLen) rx;
//     uint8_t* COUNT_NOK(myLen) tx;
//     
//     atomic {
//       myLen = len;
//       rx = rxBuffer;
//       tx = txBuffer;
//       rxBuffer = NULL;
//       txBuffer = NULL;
//       len = 0;
//       pos = 0;
//     }
//     discard = call SpiByte.write(SD_BLANK_BYTE);
//
//     signal SpiPacket.sendDone(tx, rx, myLen, SUCCESS);
//   }
// }
}