#ifndef _CC2420_QUANTO_H
#define _CC2420_QUANTO_H

/* Quanto constants for the CC2420 */
/* Power states for the radio:
 *  OFF/LISTEN/RX/TX
 *  States are set on the msB of the powerstate_t 
 *  Powerlevels are set on the lower 5 bits of the lsB 
 */
enum {
  ACT_PXY_CC2420_RX = 0x50,   

  CC2420_PW_STOPPED  = 0x0000, //set by CC2420Csma. override others
  CC2420_PW_STARTING = 0x0100, //set by CC2420Csma. override others. unused.
  CC2420_PW_LISTEN   = 0x0200, //set by CC2420Csma. override others
  CC2420_PW_RX       = 0x0400, //set by CC2420Transmit on SFD & !Tx
  CC2420_PW_TX       = 0x0800, //set by CC2420Transmit on attemptSend successful
  CC2420_PW_STOPPING = 0x1000, //set by CC2420Csma. override others. unused
  CC2420_PW_RXFIFO   = 0x2000, //set by CC2420Receive
  CC2420_PW_TXFIFO   = 0x4000, //set by CC2420Transmit
  
  CC2420_POWERSTATE_MASK = 0xFF00u, //mask
  CC2420_POWERSTATE_OFF  = 8     ,  //offset
  
  CC2420_POWERLEVEL_MASK = 0x001F, //mask    this is set when the state is TX
  CC2420_POWERLEVEL_OFF  = 0      , //offset
};

#endif


