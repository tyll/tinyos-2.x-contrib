
/**
 * Connect up to dummy lines
 * @author David Moss
 */
 
#warning "Using dummy CC2500 radio pins"

configuration HplCC2500PinsC {

  provides interface GeneralIO as Power;
  provides interface GeneralIO as Csn;
  provides interface GeneralIO as Gdo0_io;
  provides interface GeneralIO as Gdo2_io;
  
  provides interface GpioInterrupt as Gdo2_int;
  provides interface GpioInterrupt as Gdo0_int;
  
}

implementation {
  
  components DummyIoP;
  Power = DummyIoP;
  Csn = DummyIoP;
  Gdo0_io = DummyIoP;
  Gdo2_io = DummyIoP;
  
  components DummyInterruptP;
  Gdo2_int = DummyInterruptP;
  Gdo0_int = DummyInterruptP;
  
}

