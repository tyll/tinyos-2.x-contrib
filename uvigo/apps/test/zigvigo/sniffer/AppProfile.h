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

#ifndef APPPROFILE_H
#define APPPROFILE_H

enum {
  NWK_PROFILE_nwkcCoordinatorCapable   = 0x01,
  NWK_PROFILE_nwkcDefaultSecurityLevel = 0x00,
  NWK_PROFILE_nwkPassiveAckTimeout     = 0x03,
  NWK_PROFILE_nwkMaxChildren           = 0x04,
  NWK_PROFILE_nwkMaxDepth              = 0x03,
  NWK_PROFILE_nwkMaxRouters            = 0x04,
  NWK_PROFILE_nwkStackProfile          = 0x00,

  NWK_NEIGHBOR_TABLE_SIZE              = 0x03,
  NWK_ROUTE_TABLE_SIZE                 = 0x03,
  NWK_BROADCAST_TRANSACTION_TABLE_SIZE = 0x02,
  NWK_GROUP_ID_TABLE_SIZE              = 0x02,
  NWK_ROUTE_RECORD_TABLE_SIZE          = 0x02,
  NWK_ADDRESS_MAP_SIZE                 = 0x02,
  
  NWK_ROUTE_TABLE_PATH_SIZE            = 0x04,

  NWK_MAX_PAN_DESCRIPTORS              = 0x02,

  NWK_ACCEPTABLE_ENERGY_LEVEL          = -20,//Max energy in a suitable channel
};

#endif

/*
  Experimental energy readings
  One mote running tinyos-2.x/apps/tests/cc2420/TxThroughput in channel 26
  and the other doing Energy Detection scans with ScanDuration = 6.

  Distance: 19m
    Ch11 -96
    Ch12 -96
    Ch13 -96
    Ch14 -96
    Ch15 -96
    Ch16 -96
    Ch17 -96
    Ch18 -95
    Ch19 -96
    Ch20 -96
    Ch21 -96
    Ch22 -96
    Ch23 -96
    Ch24 -96
    Ch25 -95
    Ch26 -96

  Distance: 15m
    Ch11 -96
    Ch12 -96
    Ch13 -96
    Ch14 -96
    Ch15 -96
    Ch16 -96
    Ch17 -96
    Ch18 -95
    Ch19 -96
    Ch20 -96
    Ch21 -96
    Ch22 -95
    Ch23 -96
    Ch24 -96
    Ch25 -96
    Ch26 -94

  Distance: 10m
    Ch11 -96
    Ch12 -96
    Ch13 -96
    Ch14 -96
    Ch15 -96
    Ch16 -96
    Ch17 -96
    Ch18 -95
    Ch19 -96
    Ch20 -96
    Ch21 -96
    Ch22 -96
    Ch23 -96
    Ch24 -96
    Ch25 -96
    Ch26 -82

  Distance: 5m
    Ch11 -96
    Ch12 -96
    Ch13 -96
    Ch14 -96
    Ch15 -96
    Ch16 -96
    Ch17 -96
    Ch18 -95
    Ch19 -96
    Ch20 -96
    Ch21 -96
    Ch22 -95
    Ch23 -96
    Ch24 -96
    Ch25 -96
    Ch26 -82

  Distance: 3m
    Ch11 -96
    Ch12 -96
    Ch13 -96
    Ch14 -96
    Ch15 -96
    Ch16 -96
    Ch17 -96
    Ch18 -95
    Ch19 -96
    Ch20 -96
    Ch21 -96
    Ch22 -95
    Ch23 -96
    Ch24 -96
    Ch25 -96
    Ch26 -81

  Distance: 2m
    Ch11 -96
    Ch12 -96
    Ch13 -96
    Ch14 -96
    Ch15 -96
    Ch16 -96
    Ch17 -96
    Ch18 -95
    Ch19 -96
    Ch20 -96
    Ch21 -96
    Ch22 -95
    Ch23 -96
    Ch24 -96
    Ch25 -96
    Ch26 -74

  Distance: 1m
    Ch11 -96
    Ch12 -96
    Ch13 -96
    Ch14 -96
    Ch15 -96
    Ch16 -96
    Ch17 -96
    Ch18 -95
    Ch19 -96
    Ch20 -96
    Ch21 -96
    Ch22 -96
    Ch23 -96
    Ch24 -96
    Ch25 -95
    Ch26 -69

  Distance: 0m
    Ch11 -92
    Ch12 -85
    Ch13 -74
    Ch14 -91
    Ch15 -81
    Ch16 -86
    Ch17 -93
    Ch18 -80
    Ch19 -92
    Ch20 -89
    Ch21 -85
    Ch22 -90
    Ch23 -87
    Ch24 -88
    Ch25 -67
    Ch26 -28

  We use -20dBm as max acceptable energy level, it is impossible to receive it
  from another MicaZ, no matter how close it is.

 */
