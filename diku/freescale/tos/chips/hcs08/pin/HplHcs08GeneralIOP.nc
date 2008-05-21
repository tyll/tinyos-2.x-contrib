
/* "Copyright (c) 2000-2005 The Regents of the University of California.  
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

/**
 * @author Joe Polastre
 * @author Tor Petterson <motor@diku.dk>
 */

generic module HplHcs08GeneralIOP(
				uint8_t port_data_addr,
				uint8_t port_dir_addr,
				uint8_t port_pullup_addr,
				uint8_t port_slewrate_addr,
				uint8_t pin
				)
{
  provides interface HplHcs08GeneralIO as IO;
}
implementation
{
  #define PORTxDATA (*(volatile uint8_t*)port_data_addr)
  #define PORTxDIR (*(volatile uint8_t*)port_dir_addr)
  #define PORTxPULLUP (*(volatile uint8_t*)port_pullup_addr)
  #define PORTxSLEWRATE (*(volatile uint8_t*)port_slewrate_addr)

  async command void IO.set() { atomic PORTxDATA |= (0x01 << pin); }
  async command void IO.clr() { atomic PORTxDATA &= ~(0x01 << pin); }
  async command void IO.toggle() { atomic PORTxDATA ^= (0x01 << pin); }
  async command uint8_t IO.getRaw() { return PORTxDATA & (0x01 << pin); }
  async command bool IO.get() { return (call IO.getRaw() != 0); }
  async command void IO.makeInput() { atomic PORTxDIR &= ~(0x01 << pin); }
  async command bool IO.isInput() { return (PORTxDIR & (0x01 << pin)) == 0; }
  async command void IO.makeOutput() { atomic PORTxDIR |= (0x01 << pin); }
  async command bool IO.isOutput() { return (PORTxDIR & (0x01 << pin)) != 0; }
  async command void IO.pullupOn() { atomic PORTxPULLUP |= (0x01 << pin); }
  async command void IO.pullupOff() { atomic PORTxPULLUP &= ~(0x01 << pin); }
  async command bool IO.isPullupOn() { return (PORTxPULLUP & (0x01 << pin)) != 0; }
  async command void IO.slewrateOn() { atomic PORTxPULLUP |= (0x01 << pin); }
  async command void IO.slewrateOff() { atomic PORTxPULLUP &= ~(0x01 << pin); }
  async command bool IO.isSlewrateOn() { return (PORTxPULLUP & (0x01 << pin)) != 0; }
}
