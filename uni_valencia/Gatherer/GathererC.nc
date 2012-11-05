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

#include <6lowpan.h>

configuration GathererC {

} 

implementation {
  components MainC, LedsC;
  components GathererP;

  GathererP.Boot -> MainC;
  GathererP.Leds -> LedsC;

  components new TimerMilliC() as TimerWatchDog,
  new TimerMilliC() as ReinicioMotaTimer,
  new TimerMilliC() as LedsTimer,
  new TimerMilliC() as TimerMedidas;

  GathererP.TimerWatchDog -> TimerWatchDog;
  GathererP.ReinicioMotaTimer -> ReinicioMotaTimer;
  GathererP.LedsTimer -> LedsTimer;
  GathererP.TimerMedidas -> TimerMedidas;

  components IPDispatchC;
  GathererP.RadioControl -> IPDispatchC;

  GathererP.RouteStats -> IPDispatchC.RouteStats;

  components new UdpSocketC() as ServerUDP;
  GathererP.ServerUDP -> ServerUDP;

  //Sensor externo
  //components new SensirionSht71C() as SensorExterno;

  components new SensirionSht11C() as SensorExterno;
  GathererP.Temperatura -> SensorExterno.Temperature;
  GathererP.Humedad -> SensorExterno.Humidity;

  components new VoltageC() as VoltajeInterno;
  GathererP.Voltaje -> VoltajeInterno;
}
