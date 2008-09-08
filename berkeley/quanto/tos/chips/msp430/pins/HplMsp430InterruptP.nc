configuration HplMsp430InterruptP {
#ifdef __msp430_have_port1
  provides interface HplMsp430Interrupt as Port10;
  provides interface HplMsp430Interrupt as Port11;
  provides interface HplMsp430Interrupt as Port12;
  provides interface HplMsp430Interrupt as Port13;
  provides interface HplMsp430Interrupt as Port14;
  provides interface HplMsp430Interrupt as Port15;
  provides interface HplMsp430Interrupt as Port16;
  provides interface HplMsp430Interrupt as Port17;
#endif
#ifdef __msp430_have_port2
  provides interface HplMsp430Interrupt as Port20;
  provides interface HplMsp430Interrupt as Port21;
  provides interface HplMsp430Interrupt as Port22;
  provides interface HplMsp430Interrupt as Port23;
  provides interface HplMsp430Interrupt as Port24;
  provides interface HplMsp430Interrupt as Port25;
  provides interface HplMsp430Interrupt as Port26;
  provides interface HplMsp430Interrupt as Port27;
#endif
}

implementation {
    components HplMsp430InterruptImplP, ResourceContextsC;

    HplMsp430InterruptImplP.CPUContext -> ResourceContextsC.CPUContext;

#ifdef __msp430_have_port1
  Port10 = HplMsp430InterruptImplP.Port10;
  Port11 = HplMsp430InterruptImplP.Port11;
  Port12 = HplMsp430InterruptImplP.Port12;
  Port13 = HplMsp430InterruptImplP.Port13;
  Port14 = HplMsp430InterruptImplP.Port14;
  Port15 = HplMsp430InterruptImplP.Port15;
  Port16 = HplMsp430InterruptImplP.Port16;
  Port17 = HplMsp430InterruptImplP.Port17;
#endif
#ifdef __msp430_have_port2
  Port20 = HplMsp430InterruptImplP.Port20;
  Port21 = HplMsp430InterruptImplP.Port21;
  Port22 = HplMsp430InterruptImplP.Port22;
  Port23 = HplMsp430InterruptImplP.Port23;
  Port24 = HplMsp430InterruptImplP.Port24;
  Port25 = HplMsp430InterruptImplP.Port25;
  Port26 = HplMsp430InterruptImplP.Port26;
  Port27 = HplMsp430InterruptImplP.Port27;
#endif
}
