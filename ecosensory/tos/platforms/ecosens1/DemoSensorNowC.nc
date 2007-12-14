/* Copyright (c) 2005-2006 Arch Rock Corporation All rights reserved.
 * BSD license full text at: 
 * http://tinyos.cvs.sourceforge.net/tinyos/tinyos-2.x-contrib/ecosensory/license.txt
 *
 * DemoSensorNowC is a generic sensor device that provides a 16-bit
 * value that can be read from async context. The platform author
 * chooses which sensor actually sits behind DemoSensorNowC, and
 * though it's probably Voltage, Light, or Temperature, there are no
 * guarantees.
 *
 * This particular DemoSensorNowC on the ecosens1 platform provides a
 * voltage reading, using VoltageC.
 *
 * To convert from ADC counts to actual voltage, divide this reading
 * by 4096 and multiply by 3.
 *
 * @author Gilman Tolle <gtolle@archrock.com>
 * revised John Griessen 13Dec2007
 */

generic configuration DemoSensorNowC()
{
  provides interface Resource;
  provides interface ReadNow<uint16_t>;
}
implementation
{
  components new Msp430InternalVoltageC() as DemoSensorNow;

  Resource = DemoSensorNow;
  ReadNow = DemoSensorNow;
}
