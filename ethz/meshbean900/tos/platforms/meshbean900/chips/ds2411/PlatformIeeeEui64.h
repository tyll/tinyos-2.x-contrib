#ifndef PLATFORM_IEEE_EUI64_H
#define PLATFORM_IEEE_EUI64_H

/*
 * Copyright (c) 2007, Vanderbilt University
 * All rights reserved.
 *
 * Permission to use, copy, modify, and distribute this software and its
 * documentation for any purpose, without fee, and without written agreement is
 * hereby granted, provided that the above copyright notice, the following
 * two paragraphs and the author appear in all copies of this software.
 *
 * IN NO EVENT SHALL THE VANDERBILT UNIVERSITY BE LIABLE TO ANY PARTY FOR
 * DIRECT, INDIRECT, SPECIAL, INCIDENTAL, OR CONSEQUENTIAL DAMAGES ARISING OUT
 * OF THE USE OF THIS SOFTWARE AND ITS DOCUMENTATION, EVEN IF THE VANDERBILT
 * UNIVERSITY HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 *
 * THE VANDERBILT UNIVERSITY SPECIFICALLY DISCLAIMS ANY WARRANTIES,
 * INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY
 * AND FITNESS FOR A PARTICULAR PURPOSE.  THE SOFTWARE PROVIDED HEREUNDER IS
 * ON AN "AS IS" BASIS, AND THE VANDERBILT UNIVERSITY HAS NO OBLIGATION TO
 * PROVIDE MAINTENANCE, SUPPORT, UPDATES, ENHANCEMENTS, OR MODIFICATIONS.
 *
 * Author: Janos Sallai
 */


/* For now, let us set the company ID to 'M' 'E' 'S' (MeshNetics), and the first two bytes
 * of the serial ID to 'M' 'B' (MeshBean900). The last three bytes of the serial ID are read
 * from the DS2411 chip.
 */
 
enum {
  IEEE_EUI64_COMPANY_ID_0 = 'M',
  IEEE_EUI64_COMPANY_ID_1 = 'E',
  IEEE_EUI64_COMPANY_ID_2 = 'S',
  IEEE_EUI64_SERIAL_ID_0 = 'M',
  IEEE_EUI64_SERIAL_ID_1 = 'B',
};



#endif /* PLATFORM_IEEE_EUI64_H */
