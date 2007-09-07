

#include "Blaze.h"
 
/**
 * @author Jared Hill
 * @author David Moss
 */ 
module BlazeSpiP {

  provides interface BlazeFifo as Fifo[ uint8_t id ];
  provides interface BlazeRegister as Reg[ uint8_t id ];
  provides interface BlazeStrobe as Strobe[ uint8_t id ];
  provides interface RadioInit;
  provides interface RadioStatus;
  
  uses interface SpiByte;
  uses interface SpiPacket;
  uses interface Leds;
  uses interface State;
 
}

implementation {

  enum {
    S_IDLE = 0,
    S_READ_FIFO = 1,
    S_STOPPED = 2,
    S_INIT = 3,
    S_WRITE_FIFO = 4,
    S_WRITE_REG = 5,
    S_READ_REG = 6,
  };

  /** Address to read / write */
  uint16_t m_addr;
  
  /***************** Prototypes ****************/
  uint8_t getRadioStatus();
  task void radioInitDone();
    
  /***************RadioInit Commands*************************/
  command error_t RadioInit.init(uint8_t startAddr, uint8_t* regs, 
      uint8_t len) {
      
    if(call State.requestState(S_INIT) != SUCCESS) {
      return FAIL;
    }
    
    call SpiByte.write(startAddr | BLAZE_BURST | BLAZE_WRITE);
    call SpiPacket.send(regs, NULL, len);
    
    
    return SUCCESS;  
  }
  
  /************************** Fifo Commands ******************************/
  async command blaze_status_t Fifo.beginRead[ uint8_t addr ]( uint8_t* data, 
      uint8_t len ) {
      
    blaze_status_t status;
    call State.forceState(S_READ_FIFO);
    status = call SpiByte.write( addr | BLAZE_BURST | BLAZE_READ );
    call Fifo.continueRead[ addr ]( data, len );
    
    return status;
  }

  async command error_t Fifo.continueRead[ uint8_t addr ]( uint8_t* data,
      uint8_t len ) {
      
    atomic m_addr = addr;
    call SpiPacket.send( NULL, data, len );
    return SUCCESS;
  }

  async command blaze_status_t Fifo.write[ uint8_t addr ]( uint8_t* data, 
      uint8_t len ) {
      
    uint8_t status;
    
    call State.forceState(S_WRITE_FIFO);    
    atomic m_addr = addr;
    status = call SpiByte.write( m_addr | BLAZE_BURST | BLAZE_WRITE );
    call SpiPacket.send( data, NULL, len );

    return status;
  }
  
  /********************SpiPacket Events***************************/
  async event void SpiPacket.sendDone( uint8_t* tx_buf, uint8_t* rx_buf, 
      uint16_t len, error_t error ) {
      
    uint8_t status = call State.getState();
    call State.toIdle();
    
    if(status == S_INIT) {
      // Because we're in async context...
      post radioInitDone();
      
    } else if ( status == S_READ_FIFO ) {
      signal Fifo.readDone[ m_addr ]( rx_buf, len, error );
      
    } else if( status == S_WRITE_FIFO) {
      signal Fifo.writeDone[ m_addr ]( tx_buf, len, error );
    }  
    
  }

  /*************** Reg Commands ***************/
  async command blaze_status_t Reg.read[ uint8_t addr ](uint8_t* data ) {
	blaze_status_t status;
	status = call SpiByte.write(addr | BLAZE_READ | BLAZE_SINGLE); 
	*data = call SpiByte.write(BLAZE_SNOP);
    return status;
  }

  async command blaze_status_t Reg.write[ uint8_t addr ]( uint8_t data ) {
    call SpiByte.write(addr | BLAZE_WRITE | BLAZE_SINGLE);
    return call SpiByte.write(data);
  }

  /******************Strobe Commands***********************/
  async command blaze_status_t Strobe.strobe[ uint8_t addr ]() {
    return call SpiByte.write( addr );
  }

  /***************** RadioStatus Commands ****************/
  async command uint8_t RadioStatus.getRadioStatus() { 
    uint8_t ret;
    uint8_t chk;
    ret = getRadioStatus();
    /*** wait 'til we read the same value twice, a feature of these radios */
    while ((chk = getRadioStatus()) != ret) {
      ret = chk;
    }
    
    return ret;
  }

  /***************** Functions ****************/
  uint8_t getRadioStatus(){
    return ((call SpiByte.write(BLAZE_SNOP) >> 4) & 0x07);
  }

  task void radioInitDone() {
    signal RadioInit.initDone(); 
  }
    
  /***************** Defaults ***************/
  default async event void Fifo.readDone[ uint8_t addr ]( uint8_t* rx_buf, uint8_t rx_len, error_t error ) {}
  default async event void Fifo.writeDone[ uint8_t addr ]( uint8_t* tx_buf, uint8_t tx_len, error_t error ) {}
  
  default event void RadioInit.initDone() {}
  
}
