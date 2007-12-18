configuration HplOutputC {
  provides {
    interface HplOutput;
  }
}
implementation {
  components HplOutputP;
  HplOutput = HplOutputP.HplOutput;
}
