generic configuration AutoStartC() {
  uses {
    interface StdControl;
    interface SplitControl;
  }
}
implementation {
  components MainC, new AutoStartP();

  MainC.Boot <- AutoStartP;
  StdControl = AutoStartP;
  SplitControl = AutoStartP;
}
