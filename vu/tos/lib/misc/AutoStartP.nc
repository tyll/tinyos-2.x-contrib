generic module AutoStartP() {
  uses {
    interface Boot;
    interface StdControl;
    interface SplitControl;
  }
}
implementation {
  event void Boot.booted() {
    call StdControl.start();
    call SplitControl.start();
  }

  event void SplitControl.startDone(error_t) {}
  event void SplitControl.stopDone(error_t) {}

  default command error_t StdControl.start() { return SUCCESS; }
  default command error_t SplitControl.start() { return SUCCESS; }

}
