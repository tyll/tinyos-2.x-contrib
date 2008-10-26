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
 * Authors:		Jason Hill, David Gay, Philip Levis
 * Date last modified:  6/25/02
 *
 *
 */

/**
 * The byte-level interface to the UART, which can send and receive
 * simultaneously.
 *
 * <p> This interface, as it directly abstracts hardware, follows the
 * hardware interface convention of not maintaining state. Therefore,
 * some conditions that could be understood by a higher layer to be
 * errors execute properly; for example, one can call
 * <code>txBit</code> when in receive mode. A higher level interface
 * must provide the checks for conditions such as this.
 *
 * @author Jason Hill
 * @author David Gay
 * @author Philip Levis
 */

interface HPLUART {

  /**
   * Initialize the UART.
   *
   * @return SUCCESS always.
   */
  
  async command bool init();

  /**
   * Turn off the UART
   *
   * @return SUCCESS always
   */

  async command bool stop();

  //async command bool setRate(uint8_t rate);

  /**
   * Send one byte of data. There should only one outstanding send at
   * any time; one must wait for the <code>putDone</code> event before
   * calling <code>put</code> or <code>put2</code> again.
   *
   * @return SUCCESS always.
   */
  async command bool put(uint8_t data);

  /**
   * Send more than one byte of data. ...
   */
  async command bool put_long(uint16_t no);
  async command bool put2(uint8_t *start);

  /**
   * A byte of data has been received.
   *
   * @return SUCCESS always.
   */
  
  async event bool get(uint8_t data);

  /**
   * The previous call to <code>put</code> has completed; another byte
   * may now be sent.
   *
   * @return SUCCESS always.
   */
  async event bool putDone();
}
