/* Copyright (c) 2007 ETH Zurich.
*  All rights reserved.
*
*  Redistribution and use in source and binary forms, with or without
*  modification, are permitted provided that the following conditions
*  are met:
*
*  1. Redistributions of source code must retain the above copyright
*     notice, this list of conditions and the following disclaimer.
*  2. Redistributions in binary form must reproduce the above copyright
*     notice, this list of conditions and the following disclaimer in the
*     documentation and/or other materials provided with the distribution.
*  3. Neither the name of the copyright holders nor the names of
*     contributors may be used to endorse or promote products derived
*     from this software without specific prior written permission.
*
*  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS `AS IS'
*  AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
*  IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
*  ARE DISCLAIMED.  IN NO EVENT SHALL THE COPYRIGHT HOLDERS OR CONTRIBUTORS
*  BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
*  CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, LOSS OF USE, DATA,
*  OR PROFITS) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
*  CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
*  ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF
*  THE POSSIBILITY OF SUCH DAMAGE.
*
*  For additional information see http://www.btnode.ethz.ch/
*
*  $Id$
* 
*/

/**
 * @author Roman Lim
 */

#ifndef HARVESTER_H
#define HARVESTER_H
#include <AM.h>

enum {
  /* Number of readings per message. If you increase this, you may have to
     increase the message_t size. */
  // NREADINGS = 1,
  /* Default sampling period. */
  AM_HARVESTERSENSOR = 0x93,
  INT_SENSOR = 30000,
  
  AM_HARVESTERTOPOLOGY = 0x94,
  INT_TOPOLOGY = 62000UL, // milliseconds
  
  AM_HARVESTERSTATUS = 0x95,
  INT_STATUS = 0,

  LPL_INT = 1000UL, // default lpl interval in milliseconds
};

typedef nx_struct harvesterSensor {
  nx_uint8_t dsn; /* serial number */
  nx_uint16_t id; /* Mote id of sending mote. */
  nx_uint16_t temp_internal; /*	raw value of the on-board Sensirion temperature sensor */	 
  nx_uint16_t temp_external; /*	raw value of the external Sensirion temperature sensor */ 
  nx_uint16_t hum_internal; /*	raw value of the on-board Sensirion humidity sensor	 */
  nx_uint16_t hum_external; /*	raw value of the external Sensirion humidity sensor	 */
  nx_uint16_t voltage; /*	voltage level	 */
  nx_uint16_t light1; /*	value from Hamatsu S1087 light sensor */ 	 
  nx_uint16_t light2; /*	value from Hamatsu S1087-01 light sensor */	
} harvester_sensor_t;

typedef nx_struct harvesterTopology {
  nx_uint8_t dsn; /* serial number */
  nx_uint16_t id; /* Mote id of sending mote. */
  nx_am_addr_t parent; /*	id of parent node (treerouting) */	 
  nx_uint16_t parent_etx; /*	estimated transmissions to parent */	 
  nx_am_addr_t neighbour_id[5]; /*	ids of 5 best neighbours */
} harvester_topology_t;

typedef nx_struct harvesterNodeStatus {
  nx_uint8_t dsn; /* serial number */
  nx_uint16_t id; /* Mote id of sending mote. */	 	 
  nx_uint32_t prog_version; /*	program version e.g. IDENT_TIMESTAMP */
}  harvester_status_t;
#endif
