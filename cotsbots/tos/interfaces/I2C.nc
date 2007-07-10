/*									tab:4
 *
 *
 * "Copyright (c) 2000-2002 The Regents of the University  of California.  
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
 */
/*									tab:4
 *  IMPORTANT: READ BEFORE DOWNLOADING, COPYING, INSTALLING OR USING.  By
 *  downloading, copying, installing or using the software you agree to
 *  this license.  If you do not agree to this license, do not download,
 *  install, copy or use the software.
 *
 *  Intel Open Source License 
 *
 *  Copyright (c) 2002 Intel Corporation 
 *  All rights reserved. 
 *  Redistribution and use in source and binary forms, with or without
 *  modification, are permitted provided that the following conditions are
 *  met:
 * 
 *	Redistributions of source code must retain the above copyright
 *  notice, this list of conditions and the following disclaimer.
 *	Redistributions in binary form must reproduce the above copyright
 *  notice, this list of conditions and the following disclaimer in the
 *  documentation and/or other materials provided with the distribution.
 *      Neither the name of the Intel Corporation nor the names of its
 *  contributors may be used to endorse or promote products derived from
 *  this software without specific prior written permission.
 *  
 *  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 *  ``AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 *  LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A
 *  PARTICULAR PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL THE INTEL OR ITS
 *  CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
 *  EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
 *  PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
 *  PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
 *  LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
 *  NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 *  SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 * 
 * 
 */

/**
 * Byte and Command interface for using the I2C hardware bus
 */
interface I2C
{
  /**
   * Checks if the bus is free and sends a start condition
   *
   * @return SUCCESS if the start request is accepted, FAIL otherwise
   */
  async command result_t sendStart();

  /**
   * Sends a stop/end condition over the bus
   *
   * @return SUCCESS if the end request is accepted, FAIL otherwise
   */
  async command result_t sendEnd();

  /**
   * reads a single byte from the I2C bus from a slave device
   *
   * @return SUCCESS if the read request is accepted, FAIL otherwise
   */
  async command result_t read(bool ack);

  /**
   * writes a single byte to the I2C bus from master to slave
   *
   * @return SUCCESS if the write request is accepted, FAIL otherwise
   */
  async command result_t write(char data);
  
  /**
   * Notifies that the start condition has been established
   *
   * @return SUCCESS to continue using the bus, FAIL to release it
   */
  async event result_t sendStartDone();

  /**
   * Notifies that the end condition has been established
   *
   * @return Always return SUCCESS (you have released the bus)
   */
  async event result_t sendEndDone();

  /**
   * Returns the byte read from the I2C bus
   *
   * @return SUCCESS to continue using the bus, FAIL to release it
   */
  async event result_t readDone(result_t success, char data);

  /**
   * Notifies that the byte has been written to the I2C bus
   *
   * @param success SUCCESS if the slave acknowledged the byte, FAIL otherwise
   *
   * @return SUCCESS to continue using the bus, FAIL to release it
   */
  async event result_t writeDone(bool success);


  async event result_t gotReadRequest(bool success);

  async event result_t gotWriteRequest(bool success);

  async event result_t gotWriteData(bool success, uint8_t data);

  async event result_t sentReadData(bool success);

  async event result_t sentReadDone(bool success);

  async event result_t gotStop();

  // Error.  Reset it all.
  async event result_t gotError();
}
