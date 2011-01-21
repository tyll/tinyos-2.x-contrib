/**
 * Provide internal voltage reading for IWING-MRF platform
 *
 * @author
 * Chaiporn Jaikaeo (chaiporn.j@ku.ac.th)
 */
generic configuration VoltageC()
{
  provides interface Read<uint16_t>;
}
implementation
{
  components new Atm328VoltageC();

  Read = Atm328VoltageC;
}
