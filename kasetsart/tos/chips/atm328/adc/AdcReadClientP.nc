/**
 * Internal implementation of AdcReadClientC
 * 
 * @author
 * Chaiporn Jaikaeo (chaiporn.j@ku.ac.th)
 */

module AdcReadClientP
{
  provides 
  {
    interface Read<uint16_t>;
  }
  uses 
  {
    interface Resource;
	interface ReadNow<uint16_t>;
  }
}
implementation
{
  //////////////////////////////////
  // Read
  //////////////////////////////////
  command error_t Read.read()
  {
	return call Resource.request();
  }

  //////////////////////////////////
  // Resource
  //////////////////////////////////
  event void Resource.granted()
  {
	call ReadNow.read();
  }

  //////////////////////////////////
  // ReadNow
  //////////////////////////////////
  uint16_t m_data;
  error_t  m_error;

  task void readDone()
  {
    // Release the ADC resource
	call Resource.release();

    // Inform the client
    atomic signal Read.readDone(m_error, m_data);
  }

  async event void ReadNow.readDone(error_t error, uint16_t data)
  {
	atomic m_error = error;
	atomic m_data = data;
	post readDone();
  }
}
