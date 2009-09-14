/**********************
 * types and register defs for ADE7753 energy meter
 * @author Fred Jiang <fxjiang@eecs.berkeley.edu>
 */



// Register addresses
#define ADE7753_GAIN            0x0F
#define ADE7753_AENERGY         0x02
#define ADE7753_RAENERGY        0x03
#define ADE7753_MODE            0x09
#define ADE7753_IRMS            0x16


// Register values

// Gain for CH2 is 2 and CH1 is 16 at 0.5 scale
#define ADE7753_GAIN_VAL        0x24


// MSB enabled for no-creep
#define ADE7753_MODE_VAL        0x800C
