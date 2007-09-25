
/**
 * Definition of the states our interrupt SFD pin can be in.
 * When we're transmitting, interrupts on that line belong to the Transmit
 * component.  When we're not transmitting, all interrupts on that line
 * belong to the receive component.  
 *
 * Tranmit uses the interrupt to know when its transmission is done to switch
 * back into RX mode.  Receive uses the interrupt to know when a packet
 * has been received. Both components can use the line for timestamping.
 *
 * @author David Moss
 */
 
#ifndef INTERRUPTSTATE_H
#define INTERRUPTSTATE_H

enum {
  S_INTERRUPT_RX, // default state
  S_INTERRUPT_TX,
};

#endif
