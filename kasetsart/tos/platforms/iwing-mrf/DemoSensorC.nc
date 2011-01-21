/**
 * Default sensor for IWING-MRF, wired to Atm328TemperatureC
 *
 * @author
 * Chaiporn Jaikaeo (chaiporn.j@ku.ac.th)
 */
generic configuration DemoSensorC()
{
  provides interface Read<uint16_t>;
}
implementation
{
  components new Atm328TemperatureC();

  Read = Atm328VoltageC;
}
