/* Copyright (c) 2005-2006 Arch Rock Corporation All rights reserved.
 * BSD license full text at: 
 * http://tinyos.cvs.sourceforge.net/tinyos/tinyos-2.x-contrib/ecosensory/license.txt
 *
 * DemoSensorStreamC is a generic sensor device that provides a 16-bit
 * value. The platform author chooses which sensor actually sits
 * behind DemoSensorStreamC, and though it's probably Voltage, Light, or
 * Temperature, there are no guarantees.
 *
 * This particular DemoSensorStreamC on the ecosens1 platform provides a
 * voltage reading, using VoltageStreamC. 
 *
 * To convert from ADC counts to actual voltage, divide this reading
 * by 4096 and multiply by 3.
 *
 * @author Gilman Tolle <gtolle@archrock.com>
 * revised John Griessen 13Dec2007
 */
generic configuration DemoSensorStreamC()
{
  provides interface ReadStream<uint16_t>;
}
implementation
{
  components new VoltageStreamC() as DemoSensor;
  ReadStream = DemoSensor;
}
