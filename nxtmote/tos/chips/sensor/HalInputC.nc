configuration HalInputC {
  provides {
    interface HalInput;
  }
  uses {
    interface Boot;
  }
}
implementation {
  components HalInputP, HplInputC;
  
  HalInput = HalInputP.HalInput;
  
  Boot = HalInputP.Boot;
  
  HalInputP.HplInput -> HplInputC;
}
