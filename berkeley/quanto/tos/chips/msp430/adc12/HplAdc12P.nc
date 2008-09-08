configuration HplAdc12P {
  provides interface HplAdc12;
}
implementation
{
    components HplAdc12P, ResourceContextsC;
    HplAdc12P.CPUContext -> ResourceContextsC.CPUContext;
    
    HplAdc12 = HplAdc12P;
}
    
