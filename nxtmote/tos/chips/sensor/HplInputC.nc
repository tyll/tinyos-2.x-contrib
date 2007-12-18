configuration HplInputC {
  provides {
    interface HplInput;
  }
}
implementation {
  components HplInputP;
  
  HplInput = HplInputP.HplInput;
}
