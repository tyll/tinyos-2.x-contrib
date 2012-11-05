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


configuration HarvesterC { }
implementation {
  components 
  	MainC,
  	HarvesterP,
  	LedsC,
  	new TimerMilliC() as SensorTimer, 
        new TimerMilliC() as ResetTimer,
        new TimerMilliC() as LedsTimer,
        new TimerMilliC() as SendAnteriorTimer,
        new TimerMilliC() as ReinicioMotaTimer,
        new TimerMilliC() as TimerWatchDog,
  	// Sensors
    new SensirionSht11C() as ExternalSensirion,
    //new SensirionSht71C() as ExternalSensirion,
    new VoltageC() as VoltageSensor;
  
  HarvesterP.Boot -> MainC;
  HarvesterP.SensorTimer -> SensorTimer;
  HarvesterP.ResetTimer -> ResetTimer;
  HarvesterP.LedsTimer -> LedsTimer;
  HarvesterP.SendAnteriorTimer -> SendAnteriorTimer;
  HarvesterP.ReinicioMotaTimer -> ReinicioMotaTimer;
  HarvesterP.TimerWatchDog -> TimerWatchDog;
  
  HarvesterP.ReadExternalTemperature -> ExternalSensirion.Temperature;
  HarvesterP.ReadExternalHumidity -> ExternalSensirion.Humidity;
  HarvesterP.ReadVoltage -> VoltageSensor;
  
  HarvesterP.Leds -> LedsC;

  //
  // Communication components.  These are documented in TEP 113:
  // Serial Communication, and TEP 119: Collection.
  //
  components CollectionC as Collector,   // Collection layer
    ActiveMessageC,                      // AM layer
    SerialActiveMessageC;                // Serial messaging
    
 // lpl
  components CC2420ActiveMessageC as Lpl;
  
  HarvesterP.LowPowerListening->Lpl;
  HarvesterP.CollectionLowPowerListening->Collector;

  HarvesterP.RadioControl -> ActiveMessageC;
  HarvesterP.AMPacket -> ActiveMessageC;
  HarvesterP.Packet -> ActiveMessageC;
  HarvesterP.SerialControl -> SerialActiveMessageC;
  HarvesterP.RoutingControl -> Collector;

  HarvesterP.SerialSend -> SerialActiveMessageC.AMSend;
  HarvesterP.SerialAMPacket -> SerialActiveMessageC;
  HarvesterP.SerialPacket -> SerialActiveMessageC;
  HarvesterP.RootControl -> Collector;
  
  // Sensor radio communication
  components new CollectionSenderC(AM_HARVESTERSENSOR) as SensorCollectionSender;
  HarvesterP.SensorReceive -> Collector.Receive[AM_HARVESTERSENSOR];
  HarvesterP.SensorSend -> SensorCollectionSender;
  
  HarvesterP.CtpInfo-> Collector;

  components
  	new PoolC(message_t, 10) as UARTMessagePoolP,
    new QueueC(message_t*, 10) as UARTQueueP;

  HarvesterP.UARTMessagePool -> UARTMessagePoolP;
  HarvesterP.UARTQueue -> UARTQueueP;
  
}
