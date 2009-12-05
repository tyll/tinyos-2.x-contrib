/*
 * Copyright (c) 2006 Intel Corporation
 * All rights reserved.
 *
 * This file is distributed under the terms in the attached INTEL-LICENSE     
 * file. If you do not find these files, copies can be found by writing to
 * Intel Research Berkeley, 2150 Shattuck Avenue, Suite 1300, Berkeley, CA, 
 * 94704.  Attention:  Intel License Inquiry.
 */

/**
 * Oscilloscope demo application. Uses the demo sensor - change the
 * new DemoSensorC() instantiation if you want something else.
 *
 * See README.txt file in this directory for usage instructions.
 *
 * @author David Gay
 */
configuration OscilloscopeAppC { }
implementation
{
  components OscilloscopeC, MainC, ActiveMessageC, LedsC,
    new TimerMilliC(),
    // Use PseudoSensorC instead of DemoSensorC
    new DemoSensorC() as Sensor,
    // All messages are send directly to serial port (for testing)
    SerialActiveMessageC as Serial;

  OscilloscopeC.Boot -> MainC;
  OscilloscopeC.RadioControl -> ActiveMessageC;
  OscilloscopeC.SerialControl -> Serial;
  OscilloscopeC.AMSend -> Serial.AMSend[AM_OSCILLOSCOPE];
  OscilloscopeC.Receive -> Serial.Receive[AM_OSCILLOSCOPE];
  OscilloscopeC.Timer -> TimerMilliC;
  OscilloscopeC.Read -> Sensor.Read;
  OscilloscopeC.Leds -> LedsC;
  
}
