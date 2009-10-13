module TinyNodeSerialP {
  provides interface StdControl;
  provides interface Msp430UartConfigure;
  uses interface Resource;
}
implementation {

  msp430_uart_union_config_t msp430_uart_tinynode_config = {
      {
	  ubr: UBR_12MHZ_57600, 
	  umctl: UMCTL_12MHZ_57600,
	  ssel: 0x02,
	  pena : 0, 
	  pev : 0, 
	  spb : 0, 
	  clen : 0, 
	  mode :0,
	  msb: 0,
	  dorm: 0,
	  brkeie: 0,
	  rxeie: 1,
	  utxe : 1,
	  urxe : 1
      }
  };
  
  
  command error_t StdControl.start(){
    return call Resource.immediateRequest();
  }

  command error_t StdControl.stop(){
    call Resource.release();
    return SUCCESS;
  }

  event void Resource.granted(){}
  
  async command msp430_uart_union_config_t* Msp430UartConfigure.getConfig() {
    return &msp430_uart_tinynode_config;
  }

}

