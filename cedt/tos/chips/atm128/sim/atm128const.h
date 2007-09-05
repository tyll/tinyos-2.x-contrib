/* $Id$
 * Copyright (c) 2005 Intel Corporation
 * All rights reserved.
 *
 * This file is distributed under the terms in the attached INTEL-LICENSE     
 * file. If you do not find these files, copies can be found by writing to
 * Intel Research Berkeley, 2150 Shattuck Avenue, Suite 1300, Berkeley, CA, 
 * 94704.  Attention:  Intel License Inquiry.
 */
/*
 * const_[u]int[8/16/32]_t types are used to declare single and array
 * constants that should live in ROM/FLASH. These constants must be read
 * via the corresponding read_[u]int[8/16/32]_t functions.
 * 
 * This file defines the ATmega128 version of these types and functions.
 * @author David Gay
 */

/*
 * "Copyright (c) 2007 CENTRE FOR ELECTRONICS AND DESIGN TECHNOLOGY,IISc.
 *  All rights reserved.
 *
 * Permission to use, copy, modify, and distribute this software and
 * its documentation for any purpose, without fee, and without written
 * agreement is hereby granted, provided that the above copyright
 * notice, the following two paragraphs and the author appear in all
 * copies of this software.
 *
 * IN NO EVENT SHALL CENTRE FOR ELECTRONICS AND DESIGN TECHNOLOGY,IISc BE LIABLE TO
 * ANY PARTY FOR DIRECT, INDIRECT, SPECIAL, INCIDENTAL, OR CONSEQUENTIAL DAMAGES
 * ARISING OUT OF THE USE OF THIS SOFTWARE AND ITS DOCUMENTATION, EVEN
 * IF CENTRE FOR ELECTRONICS AND DESIGN TECHNOLOGY,IISc HAS BEEN ADVISED OF THE
 * POSSIBILITY OF SUCH DAMAGE.
 *
 * CENTRE FOR ELECTRONICS AND DESIGN TECHNOLOGY,IISc SPECIFICALLY DISCLAIMS
 * ANY WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
 * MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.  THE SOFTWARE
 * PROVIDED HEREUNDER IS ON AN "AS IS" BASIS, AND CENTRE FOR ELECTRONICS
 * AND DESIGN TECHNOLOGY,IISc HAS NO OBLIGATION TO PROVIDE MAINTENANCE,
 * SUPPORT, UPDATES, ENHANCEMENTS, OR MODIFICATIONS."
 */
 
 /*
  * Added the pgm_read functionality
  *
  * @author Venkatesh S
  * @author Prabhakar T V
  */
#ifndef ATMEGA128CONST_H
#define ATMEGA128CONST_H

typedef uint8_t const_uint8_t PROGMEM;
typedef uint16_t const_uint16_t PROGMEM;
typedef uint32_t const_uint32_t PROGMEM;
typedef int8_t const_int8_t PROGMEM;
typedef int16_t const_int16_t PROGMEM;
typedef int32_t const_int32_t PROGMEM;

#define read_uint8_t(x) pgm_read_byte(x)
#define read_uint16_t(x) pgm_read_word(x)
#define read_uint32_t(x) pgm_read_dword(x)

#define read_int8_t(x) ((int8_t)pgm_read_byte(x))
#define read_int16_t(x) ((int16_t)pgm_read_word(x))
#define read_int32_t(x) ((int32_t)pgm_read_dword(x))


#define pgm_read_byte(x)  (*(x))
#define pgm_read_word(x)  (*(x))
#define pgm_read_dword(x) (*(x))

#endif
