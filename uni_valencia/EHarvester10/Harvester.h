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

/* Copyright (c) 2011 Universitat de Valencia.
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
*  For additional information see http://www.uv.es/varimos/
* 
*/

/**
 * @author Manuel Delamo
 */


#ifndef HARVESTER_H
#define HARVESTER_H
#include <AM.h>

enum {
 
  AM_HARVESTERSENSOR = 0x93,

  INT_SENSOR = 30720UL, //muestras cada 30 segundos
  
  INT_RESET = 675840UL, //11 minutos

  NUM_MEDIDAS = 20, //10 minutos -> 20 medidas

  INT_SEND_ANTERIOR = 5120UL, //5 segundos

  INT_REINICIO_MOTA = 44298240UL, //12 horas y 1 minuto se reinicia la mota si o si 

};

typedef nx_struct harvesterSensor {
  nx_uint8_t dsn; /* serial number */
  nx_uint16_t id; /* Mote id of sending mote. */
  nx_uint32_t temperatura; /*	raw value of the on-board Sensirion temperature sensor */	 
  nx_uint32_t humedad; /*	raw value of the on-board Sensirion humidity sensor	 */
  nx_uint16_t voltaje; /*	voltage level	 */
  nx_uint8_t num_medidas;
  nx_uint8_t anterior; /* 0 = actual,  1 = anterior*/
  nx_am_addr_t padre; /* id of parent node (treerouting) */
  nx_uint16_t etx;	
} harvester_sensor_t;
#endif
