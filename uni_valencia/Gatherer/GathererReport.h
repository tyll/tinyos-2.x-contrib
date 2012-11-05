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

#ifndef _GATHERERREPORT_H
#define _GATHERERREPORT_H

enum{

   INTERVALO_TIEMPO_MEDIDAS = 30720UL,

   NUM_MEDIDAS = 20, //20

   TAM_BUFFER = 72, //12 horas de datos

   RESET = 44298240UL, //12 horas y 1 minuto

};

typedef nx_struct gatherer_report {
  nx_uint32_t temperatura;
  nx_uint32_t humedad;
  nx_uint16_t voltaje;
  nx_uint8_t total_medidas;
  nx_uint8_t num_sec;
} gatherer_report;

typedef nx_struct gatherer_packet{
  nx_uint16_t id_nodo;
  nx_uint8_t anterior;
  nx_uint8_t num_medias;
  nx_uint16_t parent;
  nx_uint16_t etx;
  nx_struct gatherer_report payload[6];
} gatherer_packet;

#endif
