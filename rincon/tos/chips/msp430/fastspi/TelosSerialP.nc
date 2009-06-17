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
 
module TelosSerialP {
  provides interface StdControl;
  provides interface Msp430UartConfigure;
  uses interface Resource;
}
implementation {
  
  msp430_uart_union_config_t msp430_uart_telos_config = {
    {
#ifdef FAST_SMCLK
      ubr:    0x0024,
      umctl:  0x29,
#else
      ubr:    UBR_1MHZ_115200,
      umctl:  UMCTL_1MHZ_115200,
#endif
      ssel:   0x02,
      pena:   0,
      pev:    0,
      spb:    0,
      clen:   1,
      listen: 0,
      mm:     0,
      ckpl:   0,
      urxse:  0,
      urxeie: 1,
      urxwie: 0,
      utxe:   1,
      urxe:   1
    }
  };

  command error_t StdControl.start(){
    return call Resource.immediateRequest();
  }
  command error_t StdControl.stop(){
    call Resource.release();
    return SUCCESS;
  }
  event void Resource.granted(){}

  async command msp430_uart_union_config_t* Msp430UartConfigure.getConfig() {
    return &msp430_uart_telos_config;
  }
  
}
