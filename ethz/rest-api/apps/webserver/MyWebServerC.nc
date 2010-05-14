/* Copyright (c) 2009, Distributed Computing Group (DCG), ETH Zurich.
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
*  @author Lars Schor <lschor@ee.ethz.ch>
* 
*/

configuration MyWebServerC{
}
implementation{
	
	/*********** General Components **************/
	components new RestC() as Rest;
	components MainC, RandomC;
	components DeviceC; 
	DeviceC.Boot -> MainC;
	
	
	/*********** Leds ****************************/
/*	components mgmLedsP, LedsC;
  	mgmLedsP.Rest -> Rest.Rest[unique("REST_CLIENT")]; 
  	mgmLedsP.Json -> Rest;
  	mgmLedsP.Boot -> MainC.Boot; 
  	mgmLedsP.Leds -> LedsC; 
*/  	
  	/*********** Led List ************************/
	components mgmLedListP, LedsC;
  	mgmLedListP.Rest -> Rest.Rest[unique("REST_CLIENT")]; 
  	mgmLedListP.Json -> Rest;
  	mgmLedListP.Boot -> MainC.Boot; 
  	mgmLedListP.Leds -> LedsC;
	
  	/*********** Temperature *********************/
#if defined(PLATFORM_MESHBEAN900)
	components sensorTemperatureP, new TemperatureC() as Temperatur, new TimerMilliC() as TemperaturTimer;
  	sensorTemperatureP.Rest -> Rest.Rest[unique("REST_CLIENT")]; 
  	sensorTemperatureP.Json -> Rest;
  	sensorTemperatureP.Boot -> MainC.Boot; 
  	sensorTemperatureP.SensingTimer -> TemperaturTimer; 
  	sensorTemperatureP.Sensor -> Temperatur;
#endif
  	
  	/*********** LightSensor *********************/
#if defined(PLATFORM_MESHBEAN900)
	components sensorLightP, new LightC() as Light, new TimerMilliC() as LightTimer;
  	sensorLightP.Rest -> Rest.Rest[unique("REST_CLIENT")]; 
  	sensorLightP.Json -> Rest;
  	sensorLightP.Boot -> MainC.Boot; 
  	sensorLightP.SensingTimer -> LightTimer; 
  	sensorLightP.LightChannel1 -> Light.LightChannel0;
  	sensorLightP.LightChannel2 -> Light.LightChannel1;
#endif

	/*********** LightSensor *********************/
#if defined(MOISTURE)
	components sensorMoistureP, new MoistureSensorC() as Moisture, new TimerMilliC() as MoistureTimer;
  	sensorMoistureP.Rest -> Rest.Rest[unique("REST_CLIENT")]; 
  	sensorMoistureP.Json -> Rest;
  	sensorMoistureP.Boot -> MainC.Boot; 
  	sensorMoistureP.SensingTimer -> MoistureTimer; 
  	sensorMoistureP.MoistureChannel -> Moisture;
#endif
 
 	
  	/*********** Blip Information ****************/

	components reportBlipP, IPDispatchC;   	 
	reportBlipP.Rest -> Rest.Rest[unique("REST_CLIENT")]; 
  	reportBlipP.Json -> Rest;
  	reportBlipP.Boot -> MainC.Boot;  
	reportBlipP.IPStats -> IPDispatchC.IPStats;
	reportBlipP.RouteStats -> IPDispatchC.RouteStats;
	reportBlipP.ICMPStats -> IPDispatchC.ICMPStats;

  	  	
  	/*********** Node Information ***************/
  	components mgmInfoP;
  	mgmInfoP.Rest -> Rest.Rest[unique("REST_CLIENT")]; 
  	mgmInfoP.Json -> Rest;
  	mgmInfoP.Boot -> MainC.Boot;
  	mgmInfoP.Device -> DeviceC; 

  	/*********** LCD Display ***************/
  	components DisplayP, LCDDisplayC;
  	DisplayP.Rest -> Rest.Rest[unique("REST_CLIENT")]; 
  	DisplayP.Json -> Rest;
  	DisplayP.Boot -> MainC.Boot;
  	DisplayP.LCD -> LCDDisplayC; 
	
      /********** ResetNodeP ************/
        components ResetNodeP, new UdpSocketC();
	ResetNodeP.Boot -> MainC.Boot;
	ResetNodeP.UDP -> UdpSocketC;

}
