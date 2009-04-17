/**
 * Implementation of the time capture on RF230 interrupt and the
 * FastSpiBus interface.
 *
 * @author Henrik Makitaavola
 */

module HplRF230P
{
  provides
  {
    interface GpioCapture as IRQ;
    interface Init as PlatformInit;
    interface FastSpiByte;
  }

  uses
  {
    interface GeneralIO as PortIRQ;
	interface GeneralIO as PortVCC;
    interface GpioInterrupt as GIRQ;
    interface SoftSpiBus as Spi;
    interface Alarm<TRadio, uint16_t> as Alarm;
  }
}

implementation
{
  command error_t PlatformInit.init()
  {
    call PortIRQ.makeInput(); 
    call PortIRQ.clr();
    call GIRQ.disable();
    call PortVCC.makeOutput(); 
    call PortVCC.set(); 

    return SUCCESS;
  }

  async event void GIRQ.fired()
  {
    signal IRQ.captured(call Alarm.getNow());
  }
  async event void Alarm.fired() {}

  default async event void IRQ.captured(uint16_t time) {}

  async command error_t IRQ.captureRisingEdge()
  {
    call GIRQ.enableRisingEdge();
    return SUCCESS;
  }

  async command error_t IRQ.captureFallingEdge()
  {
    //call Leds.led1Toggle();
    // falling edge comes when the IRQ_STATUS register of the RF230 is read
    return FAIL;	
  }

  async command void IRQ.disable()
  {
    call GIRQ.disable();
  }


  uint8_t tmp_data;
  async command void FastSpiByte.splitWrite(uint8_t data)
  {
    atomic tmp_data = data;
  }

  async command uint8_t FastSpiByte.splitRead()
  {
    atomic return call Spi.write(tmp_data);
  }

  async command uint8_t FastSpiByte.splitReadWrite(uint8_t data)
  {
    uint8_t b;
    atomic
    {
      b = call Spi.write(tmp_data);
      tmp_data = data;
    }
    return b;
  }

  async command uint8_t FastSpiByte.write(uint8_t data)
  {
    return call Spi.write(data);
  }
}
