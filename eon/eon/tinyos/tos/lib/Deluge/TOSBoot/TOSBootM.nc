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

/*
 * @author: Jonathan Hui <jwhui@cs.berkeley.edu>
 */

includes crc;
includes hardware;

module TOSBootM {
  uses {
    interface Exec;
    interface ExtFlash;
    interface Hardware;
    interface InternalFlash as IntFlash;
    interface Leds;
    interface ProgFlash;
    interface StdControl as SubControl;
    interface Voltage;
  }
}
implementation {

  enum {
    LEDS_LOWBATT = 1,
    LEDS_GESTURE = 7,
  };

  enum {
    R_SUCCESS,
    R_INVALID_IMAGE_ERROR,
    R_PROGRAMMING_ERROR,
  };


  void goRealCrazy(int num)
    {
      int i=0;
      TOSH_SET_RED_LED_PIN();
      
      for (i=0; i < num; i++)
	{
	  TOSH_CLR_RED_LED_PIN();
	  wait(0xffff);
	  TOSH_SET_RED_LED_PIN();
	  wait(0xffff);
	}
      
      TOSH_SET_RED_LED_PIN();
    }


  void goCrazy(int num)
    {
      int i=0;
      TOSH_SET_RED_LED_PIN();
      for (i=0; i < 20; i++)
	{
	  wait(0xffff);
	}
      for (i=0; i < num; i++)
	{
	  TOSH_CLR_RED_LED_PIN();
	  wait(0xffff);
	  wait(0xffff);
	  TOSH_SET_RED_LED_PIN();
	  wait(0xffff);
	  wait(0xffff);
	  wait(0xffff);
	  wait(0xffff);
	}
      TOSH_SET_RED_LED_PIN();
      for (i=0; i < 20; i++)
	{
	  wait(0xffff);
	}
      TOSH_CLR_RED_LED_PIN();
      wait(0xff00);
      TOSH_SET_RED_LED_PIN();
    }

  void startupLeds() {

    uint8_t  output = 0x7;
    uint8_t  i;

    for (i = 3; i; i--, output >>= 1 )
      call Leds.glow(output, output >> 1);

  }

  uint32_t extFlashRead32() {
    uint32_t result = 0;
    uint8_t  i;
    for ( i = 0; i < 4; i++ )
      result |= ((uint32_t)call ExtFlash.readByte() & 0xff) << (i*8);    
    return result;
  }

  bool findImage()
    {

      uint32_t _addr;
      uint8_t first, second;
      
      _addr = 0;
      
      for (_addr=0; _addr < 512000; _addr++)
	{
	  call ExtFlash.startRead(_addr);
	  first = call ExtFlash.readByte();
	  //second = call ExtFlash.readByte();
	  call ExtFlash.stopRead();

	  if ((_addr % 100000) == 0) goRealCrazy(5);

	  //if (first == 0x01 && second == 22)
	  if (first != 0xff && first != 0)
	    {
	      goRealCrazy(20);
	      goCrazy(_addr % 10);
	      goCrazy((_addr/10) % 10);
	      goCrazy((_addr/100)% 10);
	      goCrazy((_addr/1000)% 10);
	      goCrazy((_addr/10000)% 10);
	      goCrazy((_addr/100000)% 10);
	    }
	}
      return 1;
    }

  bool verifyImage(uint32_t startAddr) {

    uint16_t crcTarget = 0, crcTmp = 0;
    uint32_t addr, len;
    pgnum_t  numPgs;
    uint8_t  i;
    uint32_t val;

    //findImage();

    // read size of image
    call ExtFlash.startRead(startAddr + offsetof(DelugeImgDesc,numPgs));
    numPgs = call ExtFlash.readByte();
    call ExtFlash.stopRead();

    if (numPgs == 0 || numPgs == 0xff)
      {
	if (numPgs == 0xff) 
	  {
	    val = startAddr + offsetof(DelugeImgDesc,numPgs);
	    goRealCrazy(20);
	    /*goCrazy(val % 10);
	    goCrazy((val/10) % 10);
	    goCrazy((val/100)% 10);
	    goCrazy((val/1000)% 10);
	    goCrazy((val/10000)% 10);
	    goCrazy((val/100000)% 10);*/
	  }
	return FALSE;
      }

    startAddr += DELUGE_METADATA_SIZE;

    addr = DELUGE_CRC_BLOCK_SIZE;
    len = DELUGE_BYTES_PER_PAGE-DELUGE_CRC_BLOCK_SIZE;

    for ( i = 0; i < numPgs && crcTarget == crcTmp; i++ ) {

      // read crc
      call ExtFlash.startRead(startAddr + i*sizeof(uint16_t));
      crcTarget = (uint16_t)(call ExtFlash.readByte() & 0xff);
      crcTarget |= (uint16_t)(call ExtFlash.readByte() & 0xff) << 8;
      call ExtFlash.stopRead();

      // compute crc
      call ExtFlash.startRead(startAddr + addr);
      for ( crcTmp = 0; len; len-- )
			crcTmp = crcByte(crcTmp, call ExtFlash.readByte());
      call ExtFlash.stopRead();

      //addr = (uint16_t)(i+1)*DELUGE_BYTES_PER_PAGE;
	  addr = (uint32_t)(i+1)*DELUGE_BYTES_PER_PAGE;
      len = DELUGE_BYTES_PER_PAGE;
		
    }
	
	
	
    return (i == numPgs);

  }

  result_t programImage(uint32_t startAddr) {

    uint8_t  buf[TOSBOOT_INT_PAGE_SIZE];
    uint32_t pageAddr, newPageAddr;
    uint32_t intAddr;
    uint32_t secLength;

    if (!verifyImage(startAddr))
      {
	  	
		return R_INVALID_IMAGE_ERROR;
      }

    startAddr += DELUGE_METADATA_SIZE + DELUGE_CRC_BLOCK_SIZE + DELUGE_IDENT_SIZE;

    call ExtFlash.startRead(startAddr);

    intAddr = extFlashRead32();
    secLength = extFlashRead32();

    while ( secLength ) {
      
      pageAddr = newPageAddr = intAddr / TOSBOOT_INT_PAGE_SIZE;

      // fill in ram buffer for internal program flash sector
      do {

			// check if secLength is all ones
			if ( secLength == 0xffffffff )
		  		return FAIL;

			buf[(uint32_t)intAddr % TOSBOOT_INT_PAGE_SIZE] = call ExtFlash.readByte();
			intAddr++;
	
			if ( --secLength == 0 ) 
			{
	  			intAddr = extFlashRead32();
	  			secLength = extFlashRead32();
			}

			newPageAddr = intAddr / TOSBOOT_INT_PAGE_SIZE;

      } while ( pageAddr == newPageAddr && secLength );
      
      call Leds.set(pageAddr);

      // write out page
      if (call ProgFlash.write(pageAddr*TOSBOOT_INT_PAGE_SIZE, buf,
			       TOSBOOT_INT_PAGE_SIZE) == FAIL)
	return R_PROGRAMMING_ERROR;

    }

    call ExtFlash.stopRead();

    return R_SUCCESS;

  }

  void runApp() {
    call SubControl.stop();
    call Exec.exec();
  }

  void startupSequence() {

    tosboot_args_t args;

    // check voltage and make sure flash can be programmed
    //   if not, just run the app, can't check for gestures
    //   if we can't write to the internal flash anyway
    if ( !call Voltage.okToProgram() ) {
      // give user some time and count down LEDs
      call Leds.flash(LEDS_LOWBATT);
      startupLeds();
      runApp();
    }

    // get current value of counter
    call IntFlash.read((uint8_t*)TOSBOOT_ARGS_ADDR, &args, sizeof(args));

    // increment gesture counter, see if it exceeds threshold
    if ( ++args.gestureCount >= TOSBOOT_GESTURE_MAX_COUNT - 1 ) {
      // gesture has been detected, display receipt of gesture on LEDs
      call Leds.flash(LEDS_GESTURE);

      // load golden image from flash
      // if the golden image is invalid, forget about reprogramming
      // if an error happened during reprogramming, reboot and try again
      //   not much else we can do :-/
      if (programImage(TOSBOOT_GOLDEN_IMG_ADDR) == R_PROGRAMMING_ERROR)
	call Hardware.reboot();
    }
    else {
      // update gesture counter
      call IntFlash.write((uint8_t*)TOSBOOT_ARGS_ADDR, &args, sizeof(args));
      
      if ( !args.noReprogram ) {
	// if an error happened during reprogramming, reboot and try again
	//   after two tries, try programming the golden image
	if (programImage(args.imageAddr) == R_PROGRAMMING_ERROR)
	  call Hardware.reboot();
      }
    }

    // give user some time and count down LEDs
    startupLeds();

    // reset counter and reprogramming flag
    args.gestureCount = 0xff;
    args.noReprogram = TRUE;
    call IntFlash.write((uint8_t*)TOSBOOT_ARGS_ADDR, &args, sizeof(args));
    
    runApp();

  }

  int main() __attribute__ ((C, spontaneous)) {

    __nesc_disable_interrupt();

    TOSH_SET_PIN_DIRECTIONS();
    call Hardware.init();

    TOSH_MAKE_RED_LED_OUTPUT();

    call SubControl.init();
    call SubControl.start();

    startupSequence();

    return 0;

  }

}
