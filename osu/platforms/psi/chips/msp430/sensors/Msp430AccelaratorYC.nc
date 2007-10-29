/**
 * Copyright (c) 2007 - The Ohio State University.
 * All rights reserved.
 *
 * Permission to use, copy, modify, and distribute this software and its
 * documentation for any purpose, without fee, and without written agreement is
 * hereby granted, provided that the above copyright notice, the following
 * two paragraphs, and the author attribution appear in all copies of this
 * software.
 *
 * IN NO EVENT SHALL THE OHIO STATE UNIVERSITY BE LIABLE TO ANY PARTY FOR
 * DIRECT, INDIRECT, SPECIAL, INCIDENTAL, OR CONSEQUENTIAL DAMAGES ARISING OUT
 * OF THE USE OF THIS SOFTWARE AND ITS DOCUMENTATION, EVEN IF THE OHIO STATE
 * UNIVERSITY HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 *
 * THE OHIO STATE UNIVERSITY SPECIFICALLY DISCLAIMS ANY WARRANTIES,
 * INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY
 * AND FITNESS FOR A PARTICULAR PURPOSE.  THE SOFTWARE PROVIDED HEREUNDER IS
 * ON AN "AS IS" BASIS, AND THE OHIO STATE UNIVERSITY HAS NO OBLIGATION TO
 * PROVIDE MAINTENANCE, SUPPORT, UPDATES, ENHANCEMENTS, OR MODIFICATIONS.

	@author 
	Lifeng Sang  <sangl@cse.ohio-state.edu>
	Anish Arora  <anish@cse.ohio-state.edu>	
	$Date$
	
	Porting TinyOS to Intel PSI motes
 */
 

generic configuration Msp430AccelaratorYC() {
  provides interface Read<uint16_t>;
  provides interface ReadStream<uint16_t>;
}
implementation {
  components new AdcReadClientC();
  Read = AdcReadClientC;

  components new AdcReadStreamClientC();
  ReadStream = AdcReadStreamClientC;

  components Msp430AccelaratorYP;
  AdcReadClientC.AdcConfigure -> Msp430AccelaratorYP;
  AdcReadStreamClientC.AdcConfigure -> Msp430AccelaratorYP;
}
