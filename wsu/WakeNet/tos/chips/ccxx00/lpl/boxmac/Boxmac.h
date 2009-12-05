
#ifndef BOXMAC_H
#define BOXMAC_H

/**
 * This is what we divide the original wake-up transmission by. The more
 * divisions, the more efficient your wake-up transmission with less time 
 * on-air, but your receptions will become less reliable.
 * See the readme.txt file.
 */
#ifndef BOXMAC_WAKEUP_TRANSMISSION_DIVISIONS
#define BOXMAC_WAKEUP_TRANSMISSION_DIVISIONS 4
#endif

#endif
