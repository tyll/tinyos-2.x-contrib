/**
 * Implementation of the RV-8564-C2 real time clock.
 *
 * @author Henrik Makitaavola
 */

#include "rv8564.h"
#include "I2C.h"
// TODO(henrik) The request to the I2C is done throuh a immediateRequest, this perhaps needs to be changed because
//              its bad if the battery monitor has hold of the I2C bus.
module RV8564P
{
  provides interface RV8564 as RTC;
  // TODO(henrik) Exactly how is the RTC connected to mulle, what is the functionallity of GeneralIO?
  //              Maybe there is only a init needed because the chip is always on?
  uses interface GeneralIO;
  uses interface GpioInterrupt;
  uses interface I2CPacket<TI2CBasicAddr> as I2C;
  uses interface Resource as I2CResource;
}
implementation
{
  async command void RTC.on()
  {
    call GeneralIO.makeOutput();
    call GeneralIO.set();
  }

  async command void RTC.off()
  {
    call GeneralIO.clr();
    call GeneralIO.makeInput();
  }

  async command bool RTC.isOn()
  {
    return (call GeneralIO.get() && call GeneralIO.isOutput());
  }

  async command void RTC.enableInterrupt()
  {
    call GpioInterrupt.enableFallingEdge();
  }

  async command void RTC.disableInterrupt()
  {
    call GpioInterrupt.disable();
  }
  
  async command uint8_t RTC.readRegister(uint16_t reg)
  {
    uint8_t val;
    atomic
    {
      if (call I2CResource.immediateRequest() == SUCCESS)
      {
        call I2C.write(I2C_START, RV8564_WR_ADDR, 1, (uint8_t*)&reg);
        call I2C.read(I2C_START | I2C_STOP, RV8564_RD_ADDR, 1, &val);
        call I2CResource.release();
      }
    }
    return val;
  }

  async command void RTC.writeRegister(uint16_t reg, uint8_t value)
  {
    uint8_t wr[2] = {reg, value};
    atomic
    {
      if (call I2CResource.immediateRequest() == SUCCESS)
      {
        call I2C.write(I2C_START | I2C_STOP, RV8564_WR_ADDR, 2, wr);
        call I2CResource.release();
      }
    }
  }

  event void I2CResource.granted()
  {
    // TODO(henrik) Insert communication code here.
  }
  
  async event void GpioInterrupt.fired()
  {
    signal RTC.fired();
  }
  default async event void RTC.fired() { }

  async event void I2C.readDone(error_t error, uint16_t addr, uint8_t length, uint8_t* data) {}
  async event void I2C.writeDone(error_t error, uint16_t addr, uint8_t length, uint8_t* data) {}
}
