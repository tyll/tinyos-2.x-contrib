configuration HplMsp430InterruptNMIP {
  provides interface HplMsp430Interrupt as NMI;
  provides interface HplMsp430Interrupt as OF;
  provides interface HplMsp430Interrupt as ACCV;
}
implementation {
    components HplMsp430InterruptNMIImplP, ResourceContextsC;
    HplMsp430InterruptNMIImplP.CPUContext -> ResourceContextsC.CPUContext;

    NMI = HplMsp430InterruptNMIImplP;
    OF = HplMsp430InterruptNMIImplP;
    ACCV = HplMsp430InterruptNMIImplP;
}   
