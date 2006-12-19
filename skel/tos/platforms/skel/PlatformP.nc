/*
 * @author Martin Leopold
 */

module PlatformP { 
  provides interface Init;
}
implementation {
  command error_t Init.init() {
    return SUCCESS;
  }
}
