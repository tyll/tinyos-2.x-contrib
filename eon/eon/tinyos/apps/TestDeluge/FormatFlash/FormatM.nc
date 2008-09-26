// $Id$

/*									tab:2
 * "Copyright (c) 2000-2005 The Regents of the University  of California.  
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
 */

/**
 * @author: Jonathan Hui <jwhui@cs.berkeley.edu>
 */

module FormatM {
  provides {
    interface StdControl;
  }
  uses {
    interface FlashWP;
    interface FormatStorage;
    interface Leds;
  }
}

implementation {

  enum {
    //VOLUME_SIZE = 65536,
	VOLUME_SIZE = 131072L
  };

  command result_t StdControl.init() {
    call Leds.init();
    return SUCCESS;
  }

  command result_t StdControl.start() {

    if ( call FlashWP.clrWP() == FAIL )
      call Leds.set(1);
    
    return SUCCESS;

  }

  command result_t StdControl.stop() {
    return SUCCESS;
  }

  event void FlashWP.clrWPDone() {

    result_t result;
    int i;

    call Leds.set(4);

    result = call FormatStorage.init();

    result = rcombine(call FormatStorage.allocateFixed(0xDF, TOSBOOT_GOLDEN_IMG_ADDR, 
						       VOLUME_SIZE), result);
    //for ( i = 0xd0; i < 0xd7; i++ )
	for ( i = 0xd0; i < 0xd1; i++ )
      result = rcombine(call FormatStorage.allocate(i, VOLUME_SIZE), result);
    result = rcombine(call FormatStorage.commit(), result);
    
    if (result != SUCCESS)
      call Leds.set(1);
    
  }

  event void FormatStorage.commitDone(storage_result_t result) {
    if (result != STORAGE_OK || call FlashWP.setWP() == FAIL )
      call Leds.set(1);
  }

  event void FlashWP.setWPDone() {
    //call Leds.set(2);
	call Leds.redOn();
  }



}
