#ifndef _CC2420POWERSTATES_H
#define _CC2420POWERSTATES_H

#define SET_BITS(name, value) \
   setBits(name##_LEN, name##_OFF, value)

#define LEN2MASK(name) ((1 << ((name))) - 1)

typedef uint16_t powerstate_t;

typedef union {
    powerstate_t state;
    struct {
        unsigned int tx_pwr: 5,
        unsigned int :3,
        unsigned int starting: 1,
        unsigned int listen  : 1,
        unsigned int rx : 1,
        unsigned int tx : 1,    
        unsigned int stopping: 1,
        unsigned int rx_fifo : 1,
        unsigned int tx_fifo : 1,
        unsigned int :1,
    }
} cc2420_powerstate_t;
   
enum {
    RADIO_TX_PWR_LEN = 5,
    RADIO_TX_PWR_OFF = 0,
    RADIO_TX_PWR_MASK = LEN2MASK(RADIO_TX_PWR_LEN),
};

#endif
