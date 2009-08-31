
#ifndef MSP430VREF_H
#define MSP430VREF_H

/** Time for generator to become stable (don't change). */
#define STABILIZE_INTERVAL 17

/**
 * Delay before generator is switched off after it has been stopped (in ms). 
 * This avoids having to wait the 17ms in case the generator is needed again
 * shortly after it has been stopped (value may be modified).
 */
#define SWITCHOFF_INTERVAL 20

#endif
