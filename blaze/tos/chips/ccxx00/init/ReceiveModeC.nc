
#include "ReceiveMode.h"

/**
 * Created in response to bad state logic on the CCxx00 
 * radios. Advice from TI: reset the radio using SRES everytime before you 
 * put the radio into RX mode.  To do this, we modify BlazeInitP to do an
 * SRES followed by burst init, then an SRX and signal an event out to the 
 * proper client.  Our SRX strobes become split-phase by doing this, so having
 * each client parameterized makes state handling in the other modules easier.
 * 
 * It is assumed that you own the SPI bus resource and have set the CSn pin
 * low before attempting to call the ReceiveMode.srx() command.
 * 
 * @author David Moss
 */
generic configuration ReceiveModeC() {
  provides {
    interface ReceiveMode;
  }
}

implementation {

  components BlazeInitP;
  ReceiveMode = BlazeInitP.ReceiveMode[unique(UQ_RECEIVE_MODE)];

}
