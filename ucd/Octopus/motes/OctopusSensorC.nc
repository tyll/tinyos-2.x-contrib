/**
 * The default sensor for Octopus is a simple sine wave.
 *
 * @author Philip Levis
 */

generic configuration OctopusSensorC()
{
  provides interface Read<uint16_t>;
}
implementation
{
  components new SineSensorC() as DemoChannel;

  Read = DemoChannel;
}
