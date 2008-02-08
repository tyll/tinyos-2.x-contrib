//$Id$

/* "Copyright (c) 2000-2003 The Regents of the University of California.  
 * All rights reserved.
 *
 * Permission to use, copy, modify, and distribute this software and its
 * documentation for any purpose, without fee, and without written agreement
 * is hereby granted, provided that the above copyright notice, the following
 * two paragraphs and the author appear in all copies of this software.
 * 
 * IN NO EVENT SHALL THE UNIVERSITY OF CALIFORNIA BE LIABLE TO ANY PARTY FOR
 * DIRECT, INDIRECT, SPECIAL, INCIDENTAL, OR CONSEQUENTIAL DAMAGES ARISING OUT
 * OF THE USE OF THIS SOFTWARE AND ITS DOCUMENTATION, EVEN IF THE UNIVERSITY
 * OF CALIFORNIA HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 * 
 * THE UNIVERSITY OF CALIFORNIA SPECIFICALLY DISCLAIMS ANY WARRANTIES,
 * INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY
 * AND FITNESS FOR A PARTICULAR PURPOSE.  THE SOFTWARE PROVIDED HEREUNDER IS
 * ON AN "AS IS" BASIS, AND THE UNIVERSITY OF CALIFORNIA HAS NO OBLIGATION TO
 * PROVIDE MAINTENANCE, SUPPORT, UPDATES, ENHANCEMENTS, OR MODIFICATIONS."
 */

//@author Fred Jiang <fxjiang@eecs.berkeley.edu>

interface FM3116
{
  command error_t init();
  event void initDone();
  // Take a snapshot of the counters
  command error_t takeSnapshot();
  event void snapshotDone();
  // Return counter value from earlier snapshot
  command error_t readCounter_Only();
  event void readOnly_Done(uint32_t cnt); 
  // To get counter value
  // Differs from readCounter_Only in that
  // readCounter will RE-TAKE SNAPSHOT
  command error_t readCounter();
  event void readDone(uint32_t cnt); 
  command error_t CAL();
  event void calDone();
  command error_t writeReg(uint8_t addr, uint8_t val);
  event void writeReg_Done();
  command error_t readReg(uint8_t addr);
  event void readReg_Done(uint8_t val);
}

