module HplCC2420AlarmP {
  provides interface Init;
}
implementation {
 
  command error_t Init.init() {
    return SUCCESS;
  }

}
