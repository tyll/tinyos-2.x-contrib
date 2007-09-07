
/**
 * @author David Moss
 */
 
#ifndef BLAZECONTROL_H
#define BLAZECONTROL_H

typedef enum {
  S_RADIO_OFF = 0,
  S_RADIO_INIT,
  S_RADIO_ON,
  S_RADIO_RX,
  S_RADIO_TX,
  S_RADIO_SLEEP,
  S_RADIO_STOPPING,
} radio_state_t;

#endif
