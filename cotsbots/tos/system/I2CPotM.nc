// $Id$

/*									tab:4
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
/*
 *
 * Authors:		Alec Woo
 * Date last modified:  7/23/02
 *
 */

/**
 * @author Alec Woo
 */


module I2CPotM
{
  provides {
    interface StdControl;
    interface I2CPot;
  }
  uses {
    interface I2C;
    interface Leds;
	interface StdControl as I2CControl;
  }
}

implementation
{

  /* state of the i2c request */
  enum {IDLE=0,
	READ_POT_START=11,
	READ_COMMAND = 13,
	READ_COMMAND_2 = 14,
	READ_COMMAND_3 = 15,
	READ_COMMAND_4 = 16,
	READ_COMMAND_5 = 17,
	READ_POT_READING_DATA = 18,
        READ_FAIL = 19,
	WRITE_POT_START = 30,
	WRITE_COMMAND = 31,
	WRITE_COMMAND_2 = 32,
	WRITING_TO_POT = 33,
	WRITE_POT_STOP = 40,
        WRITE_FAIL = 49,
	READ_POT_STOP = 41
	};	

  // Frame variables
  char data;	/* data to be written */
  char state;   /* state of this module */
  char addr;    /* addr to be read/written */
  char pot;     /* pot select */

  command result_t StdControl.init() {
    call I2CControl.init();
    atomic {
      state = IDLE;
    }
    return SUCCESS;
  }

  command result_t StdControl.start() {
    return SUCCESS;
  }

  command result_t StdControl.stop() {
    return SUCCESS;
  }

  /* writes the new pot setting over the I2C bus */
  command result_t I2CPot.writePot(char line_addr, 
	char pot_addr, char in_data){	
    char s;
    atomic {
      s = state;
    }
    if (s == IDLE)
    {
      atomic {
	/*  reset variables  */
	addr = line_addr;
	pot = pot_addr;
	data = in_data;
	state = WRITE_POT_START;
      }
      if (call I2C.sendStart()){
	return SUCCESS;
      }else{
	atomic {
	  state = IDLE;
	}
	return FAIL;
      }
    } else {
      return FAIL;
    }
  }
  
  command result_t I2CPot.readPot(char line_addr, char pot_addr){
    char s;
    if (state == IDLE)
    {
      addr = line_addr;
      pot = pot_addr;
      state = READ_POT_START;
      if (call I2C.sendStart()){
	return SUCCESS;
      }else{
	state = IDLE;
	return FAIL;
      }
    }
    else {
      return FAIL;
    }
  }


  /* notification that the start symbol was sent */
  async event result_t I2C.sendStartDone() {
    char ret;
    char s, a;
    atomic {
      s = state;
      a = addr;
    }
    if(s == WRITE_POT_START){
      atomic {
	state = WRITE_COMMAND;
      }
      ret = call I2C.write(0x58 | ((a << 1) & 0x06));
    }
    else if (s == READ_POT_START){
      atomic {
	state = READ_COMMAND;
      }
      call I2C.write(0x59 | ((a << 1) & 0x06));
    }
    return SUCCESS;
  }

  task void sendDoneSignals() {
    char s, d;
    atomic {
      s = state;
      d = data;
    }
    if (s == WRITE_POT_STOP){
      atomic {
	state = IDLE;
      }
      signal I2CPot.writePotDone(SUCCESS);
    }
    else if (s == READ_POT_STOP) {
      atomic {
	state = IDLE;
      }
      signal I2CPot.readPotDone(d, SUCCESS);
    }
    else if ( s == READ_FAIL ){
      atomic {
	state = IDLE ;
      }
      signal I2CPot.readPotDone(d, FAIL);
    }
    else if ( s == WRITE_FAIL ) {
      atomic {
	state = IDLE ;
      }
      signal I2CPot.writePotDone(FAIL);
    }
  }

  /* notification that the stop symbol was sent */
  async event result_t I2C.sendEndDone() {
    post sendDoneSignals();
    return SUCCESS;
  }

  /* notification of a byte sucessfully written to the bus */
  async event result_t I2C.writeDone(bool result) {
    char s, p, d;
    atomic {
      s = state;
      p = pot;
      d = data;
    }

    if (result == FAIL){
      atomic {
	state = WRITE_FAIL;
      }
      call I2C.sendEnd();
      return FAIL ;
    }
    if (s == WRITING_TO_POT) {
      atomic {
	state = WRITE_POT_STOP;
      }
      call I2C.sendEnd();
      return 0;
    } else if (s == WRITE_COMMAND) {
      atomic {
	state = WRITE_COMMAND_2;
      }
      call I2C.write(0 | ((p << 7) & 0x80));
    } else if (s ==WRITE_COMMAND_2){
      atomic {
	state = WRITING_TO_POT;
      }
      call I2C.write(d);
    } else if (s ==READ_COMMAND) {
      atomic {
	state = READ_POT_READING_DATA;
      }
      call I2C.read(0 | ((p << 7) & 0x80));
    }

    return SUCCESS;
  }

  /* read a byte off the bus and add it to the packet */
  async event result_t I2C.readDone(bool success, char in_data) {
    char s;
    atomic {
      s = state;
    }
    if (s == IDLE){
      atomic {
	data = 0;
      }
      return FAIL;
    }
    if (s == READ_POT_READING_DATA){
      atomic {
	state = READ_POT_STOP;
	data = in_data;
      }
      call I2C.sendEnd();
      return FAIL; 
    }
    return SUCCESS;
  }

  async event result_t I2C.gotReadRequest(bool success) {
    return success;
  }

  async event result_t I2C.gotWriteRequest(bool success) {
    return success;
  }

  async event result_t I2C.gotWriteData(bool success, uint8_t byte) {
    return success;
  }

  async event result_t I2C.sentReadData(bool success) {
    return success;
  }

  async event result_t I2C.sentReadDone(bool success) {
    return success;
  }

  async event result_t I2C.gotStop() {
    return SUCCESS;
  }

  async event result_t I2C.gotError() {
    return SUCCESS;
  }

  default event result_t I2CPot.readPotDone(char in_data, bool result) {
    return SUCCESS;
  }

  default event result_t I2CPot.writePotDone(bool result) {
    return SUCCESS;
  }

}










