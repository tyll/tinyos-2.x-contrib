module HplCC2420PinsC {

  provides interface GeneralIO as CCA;
  provides interface GeneralIO as CSN;
  provides interface GeneralIO as FIFO;
  provides interface GeneralIO as FIFOP;
  provides interface GeneralIO as RSTN;
  provides interface GeneralIO as SFD;
  provides interface GeneralIO as VREN;

}

implementation {

#define MAKE_NEW_RFSTATUS_GIO(name, bit_no)	     \
  inline async command bool name.get()         { return ( _CC2430_RFSTATUS & _BV(bit_no) ); } \
    inline async command void name.set()       { _CC2430_RFSTATUS |=  _BV(bit_no); } \
    inline async command void name.clr()       { _CC2430_RFSTATUS &= ~_BV(bit_no); } \
    async command void        name.toggle()    { atomic { _CC2430_RFSTATUS = _CC2430_RFSTATUS & _BV(bit_no) ? \
                                            _CC2430_RFSTATUS & ~_BV(bit_no) : _CC2430_RFSTATUS | _BV(bit_no);}}\
    inline async command bool name.isInput()   { }			\
    inline async command bool name.isOutput()  { }			\
    inline async command void name.makeInput() { }			\
    inline async command void name.makeOutput(){ }

#define MAKE_NEW_EMPTY_GIO(name)	     \
  inline async command bool name.get()         { } \
    inline async command void name.set()       { } \
    inline async command void name.clr()       { } \
    async command void        name.toggle()    { } \
    inline async command bool name.isInput()   { } \
    inline async command bool name.isOutput()  { } \
    inline async command void name.makeInput() { } \
    inline async command void name.makeOutput(){ }

  MAKE_NEW_RFSTATUS_GIO(CCA, 0);
  MAKE_NEW_RFSTATUS_GIO(SFD, 1);
  MAKE_NEW_RFSTATUS_GIO(FIFOP, 2);
  MAKE_NEW_RFSTATUS_GIO(FIFO, 3);

  // I'm not really shure how to shutdown the radio =]
  MAKE_NEW_EMPTY_GIO(RSTN);
  MAKE_NEW_EMPTY_GIO(VREN);
  MAKE_NEW_EMPTY_GIO(CSN);
  
}

