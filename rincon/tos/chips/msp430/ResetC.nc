module ResetC {
  provides {
    interface Reset;
  }
}

implementation {
  command void Reset.reset() {
    WDTCTL = 0;
  }
}
