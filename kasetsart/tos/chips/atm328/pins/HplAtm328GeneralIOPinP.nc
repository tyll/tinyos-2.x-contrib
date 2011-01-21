/**
 * Generic pin access for pins mapped into I/O space (for which the sbi, cbi
 * instructions give atomic updates). This can be used for ports B-D.
 *
 * @notes 
 * This file is modified from 
 * <code>tinyos-2.1.0/tos/chips/atm128/pins/HplAtm128GeneralIOPinP.nc</code>
 *
 * @author 
 * Chaiporn Jaikaeo (chaiporn.j@ku.ac.th)
 */
generic module HplAtm328GeneralIOPinP (uint8_t port_addr, 
				 uint8_t ddr_addr, 
				 uint8_t pin_addr,
				 uint8_t bit) @safe()
{
  provides interface GeneralIO as IO;
}
implementation
{
#define pin (*TCAST(volatile uint8_t * ONE, pin_addr))
#define port (*TCAST(volatile uint8_t * ONE, port_addr))
#define ddr (*TCAST(volatile uint8_t * ONE, ddr_addr))

  inline async command bool IO.get()        { return READ_BIT (pin, bit); }
  inline async command void IO.set()        { SET_BIT  (port, bit); }
  inline async command void IO.clr()        { CLR_BIT  (port, bit); }
  async command void IO.toggle()     { atomic FLIP_BIT (port, bit); }
    
  inline async command void IO.makeInput()  { CLR_BIT  (ddr, bit);  }
  inline async command bool IO.isInput() { return !READ_BIT(ddr, bit); }
  inline async command void IO.makeOutput() { SET_BIT  (ddr, bit);  }
  inline async command bool IO.isOutput() { return READ_BIT(ddr, bit); }
}

