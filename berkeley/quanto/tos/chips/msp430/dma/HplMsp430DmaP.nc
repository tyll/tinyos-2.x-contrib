configuration HplMsp430DmaP {
  provides interface HplMsp430DmaControl as DmaControl;
  provides interface HplMsp430DmaInterrupt as Interrupt;
}
implementation {
    components HplMsp430DmaImplP, ResourceContextsC;
    HplMsp430DmaImplP.CPUContext -> ResourceContextsC.CPUContext;

    DmaControl = HplMsp430DmaImplP;
    Interrupt  = HplMsp430DmaImplP;
}
