/*
* Copyright (c) 2009 GTI/TC-1 Research Group.  Universidade de Vigo.
*                    Gradiant (www.gradiant.org)
* All rights reserved.
*
* Redistribution and use in source and binary forms, with or without
* modification, are permitted provided that the following conditions
* are met:
* - Redistributions of source code must retain the above copyright
*   notice, this list of conditions and the following disclaimer.
* - Redistributions in binary form must reproduce the above copyright
*   notice, this list of conditions and the following disclaimer in the
*   documentation and/or other materials provided with the
*   distribution.
* - Neither the name of Universidade de Vigo nor the names of its
*   contributors may be used to endorse or promote products derived
*   from this software without specific prior written permission.
*
* THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
* ``AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
* LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
* FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL STANFORD
* UNIVERSITY OR ITS CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
* INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
* (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
* SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
* HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
* STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
* ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
* OF THE POSSIBILITY OF SUCH DAMAGE.
*
* - Revision -------------------------------------------------------------
* $Revision$
* $Date$
* @author Daniel F. Piñeiro-Santos <danips@enigma.det.uvigo.es>
* @author Felipe Gil-Castiñeira <xil@det.uvigo.es>
* @author David Chaves-Diéguez <dchaves@gradiant.org>
* ========================================================================
*/

/**
 * NLME_ED_SCAN
 * Zigbee-2007
 * Sect. 3.2.2.9 and 3.2.2.10
 */
#include "Nwk.h"

interface NLME_ED_SCAN {
  /**
   * This primitive allows the next higher layer to request an energy scan to
   * evaluate channels in the local area.
   * @param ScanChannels The five most significant bits (b27,...,b31) are
   *                     reserved. The 27 least significant bits (b0,b1,...b26)
   *                     indicate which channels are to be scanned (1 = scan,
   *                     0 = do not scan) for each of the 27 valid channels.
   * @param ScanDuration A value used to calculate the time to spend scanning
   *                     each channel: The time spent scanning each channel is
   *                     (aBaseSuperframeDuration * (2^n + 1)) symbols, where n
   *                     is the value of the ScanDuration parameter.
   * @param EDListSize       The number of entries in the EDList.
   * @param EnergyDetectList An empty buffer (allocated by the caller) to store
   *                         the result of the energy measurements.
   */
  command void request(
		       uint32_t ScanChannels,
		       uint8_t ScanDuration,
		       uint8_t EDListSize,
		       int8_t* EnergyDetectList
		       );

  /**
   * This primitive provides the next higher layer results from an energy scan.
   * @param Status The status of the request.
   * @param UnscannedChannels The five most significant bits (b27,...,b31) are
   *                          reserved. The 27 least significant bits (b0,b1,
   *                          ...b26) indicate which channels were not scanned
   *                          (1 = scan, 0 = did not scan) for each of the 27
   *                          valid channels.
   * @param EDListSize        The number of valid entries in the EDList.
   * @param EnergyDetectList  The buffer list of energy measurements, one for
   *                          each channel searched during an ED scan.
   */
  event void confirm(
		     nwk_status_t Status,
		     uint32_t UnscannedChannels,
		     uint8_t EDListSize,
		     int8_t* EnergyDetectList
		     );
}