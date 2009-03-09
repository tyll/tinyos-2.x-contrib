configuration HplAdc12P {
  provides interface HplAdc12;
}
implementation
{
    components HplAdc12ImplP, ResourceContextsC;
    HplAdc12P.CPUContext -> ResourceContextsC.CPUContext;
    
    HplAdc12 = HplAdc12ImplP;
}
    
