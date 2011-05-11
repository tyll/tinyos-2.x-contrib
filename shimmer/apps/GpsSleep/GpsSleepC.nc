/*
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
 * Copyright (c) 2002-2005 Intel Corporation
 * All rights reserved.
 *
 * This file is distributed under the terms in the attached INTEL-LICENSE     
 * file. If you do not find these files, copies can be found by writing to
 * Intel Research Berkeley, 2150 Shattuck Avenue, Suite 1300, Berkeley, CA, 
 * 94704.  Attention:  Intel License Inquiry.
 */

/**
 * Null is an empty skeleton application.  It is useful to test that the
 * build environment is functional in its most minimal sense, i.e., you
 * can correctly compile an application. It is also useful to test the
 * minimum power consumption of a node when it has absolutely no 
 * interrupts or resources active.
 *
 * @author Cory Sharp <cssharp@eecs.berkeley.edu>
 * @date February 4, 2006
 */

module GpsSleepC @safe()
{
  uses {
    interface Boot;
    interface Leds;

    interface HplMsp430I2C as HplI2C;
    interface I2CPacket<TI2CBasicAddr> as I2CPacket;
  }
}
implementation
{
  task void pacifyI2CBus(){
    msp430_i2c_union_config_t msp430_i2c_my_config = { 
      {
	rxdmaen : 0, 
	txdmaen : 0, 
	xa : 0, 
	listen : 0, 
	mst : 1,
	i2cword : 0, 
	i2crm : 1, 
	i2cssel : 0x2, 
	i2cpsc : 0, 
	i2csclh : 0x3, 
	i2cscll : 0x3,
	i2coa : 0,
      } 
    };
    TOSH_SET_ADC_1_PIN();   // this is a pull-up to enable the i2c bus

    TOSH_SET_ADC_2_PIN();   // module clear pin, logical false (basically reset)

    call HplI2C.setModeI2C(&msp430_i2c_my_config);

  }

  event void Boot.booted() {
    post pacifyI2CBus();
   // Do nothing.
  }

  async event void I2CPacket.writeDone(error_t _success, uint16_t _addr, uint8_t _length, uint8_t* _data) { }
  async event void I2CPacket.readDone(error_t _success, uint16_t _addr, uint8_t _length, uint8_t* _data) { }

}

