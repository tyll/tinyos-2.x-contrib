/**
 * Generic component to expose a full 8-bit port of GPIO pins.
 *
 * @notes 
 * This file is modified from 
 * <code>tinyos-2.1.0/tos/chips/atm128/pins/HplAtm128GeneralIOPortP.nc</code>
 *
 * @author 
 * Chaiporn Jaikaeo (chaiporn.j@ku.ac.th)
 */

generic configuration HplAtm328GeneralIOPortP (uint8_t port_addr, uint8_t ddr_addr, uint8_t pin_addr)
{
  // provides all the ports as raw ports
  provides {
    interface GeneralIO as Pin0;
    interface GeneralIO as Pin1;
    interface GeneralIO as Pin2;
    interface GeneralIO as Pin3;
    interface GeneralIO as Pin4;
    interface GeneralIO as Pin5;
    interface GeneralIO as Pin6;
    interface GeneralIO as Pin7;
  }
}
implementation
{
  components 
  new HplAtm328GeneralIOPinP (port_addr, ddr_addr, pin_addr, 0) as Bit0,
    new HplAtm328GeneralIOPinP (port_addr, ddr_addr, pin_addr, 1) as Bit1,
    new HplAtm328GeneralIOPinP (port_addr, ddr_addr, pin_addr, 2) as Bit2,
    new HplAtm328GeneralIOPinP (port_addr, ddr_addr, pin_addr, 3) as Bit3,
    new HplAtm328GeneralIOPinP (port_addr, ddr_addr, pin_addr, 4) as Bit4,
    new HplAtm328GeneralIOPinP (port_addr, ddr_addr, pin_addr, 5) as Bit5,
    new HplAtm328GeneralIOPinP (port_addr, ddr_addr, pin_addr, 6) as Bit6,
    new HplAtm328GeneralIOPinP (port_addr, ddr_addr, pin_addr, 7) as Bit7;

  Pin0 = Bit0;
  Pin1 = Bit1;
  Pin2 = Bit2;
  Pin3 = Bit3;
  Pin4 = Bit4;
  Pin5 = Bit5;
  Pin6 = Bit6;
  Pin7 = Bit7;
}
