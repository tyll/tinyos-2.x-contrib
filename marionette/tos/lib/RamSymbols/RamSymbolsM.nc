//$Id$
/*									tab:4
 * "Copyright (c) 2000-2003 The Regents of the University of California.  
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
/**
 * @author Kamin Whitehouse
 */

includes Rpc;
includes RamSymbols;

module RamSymbolsM
{
  provides command unsigned int poke(ramSymbol_t *symbol) @rpc();
  provides command ramSymbol_t peek(unsigned int memAddress, uint8_t length, bool dereference) @rpc();
}

implementation
{
  ramSymbol_t symbol;

  command unsigned int poke(ramSymbol_t *p_symbol){
    if ( p_symbol->length <= MAX_RAM_SYMBOL_SIZE) {
      if (p_symbol->dereference == TRUE){
	memcpy(*(void**)p_symbol->memAddress, (void*)p_symbol->data, p_symbol->length);
      }
      else{
	memcpy((void*)p_symbol->memAddress, (void*)p_symbol->data, p_symbol->length);
      }
    }
    return p_symbol->memAddress;
  }

  command ramSymbol_t peek(unsigned int memAddress, uint8_t length, bool dereference){
    symbol.memAddress = memAddress;
    symbol.length = length;
    symbol.dereference = dereference;
    if ( symbol.length <= MAX_RAM_SYMBOL_SIZE) {
      if (symbol.dereference == TRUE){
	memmove((void*)symbol.data, *(void**)symbol.memAddress, symbol.length);
      }
      else{
	memmove((void*)symbol.data, (void*)symbol.memAddress, symbol.length);
      }
    }
    return symbol;
  }

}
