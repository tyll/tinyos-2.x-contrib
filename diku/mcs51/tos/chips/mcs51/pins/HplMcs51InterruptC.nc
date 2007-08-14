
/*
 * The standard 8051 features 2 external interrupts, originally these
 * are tied to P3.3 and P3.4, but many variants map them to different
 * pins on the chip
 */

/**
 * @author Martin Leopold <leopold@diku.dk>
 */

configuration HplMcs51InterruptC {
  provides {
    interface HplMcs51Interrupt as ext_int_0;
    interface HplMcs51Interrupt as ext_int_1;
  }
}
implementation
{
  components HplMcs51InterruptP;

  // I never got arround to test this.. So if you wan't to use it
  // maybee you should.
#pragma WARN UNTESTED!!!!
  
  ext_int_0 = HplMcs51InterruptP.ext_int_0;
  ext_int_1 = HplMcs51InterruptP.ext_int_1;
}
