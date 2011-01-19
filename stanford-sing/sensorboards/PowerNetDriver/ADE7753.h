/*
 * Register definitions for the ADE7753 power chip.
 * Some ideas borrowed from the Berkeley ACMeter.
 *
 * @author Maria Kazandjieva <mariakaz@cs.stanford.edu>
 * @date Oct 2, 2008
 *
 */

// Addresses of registers we care about

//active power integrated over time
#define AENERGY		0x02
//active power, reset register to 0 after reading
#define RAENERGY	0x03
// access chip functionality, eg. set temperature bit
#define MODE		0x09
// adjust gain for analog input
#define GAIN		0x0F
// latest temperature conversion
#define TEMP		0x26
// interupt enable register
#define IRQ		0x0A
// waveform register
#define WAVE		0x01

// GAIN value
#define ADE7753_GAIN_VAL	0x21

// MODE register value (default)
#define ADE7753_MODE_VAL	0x000C

enum {
  SETREG = 1,
  GETREG = 2,
};

enum {
  ON = 1,
  OFF = 0,
};

typedef struct {
  unsigned int ubr: 16;     //Clock division factor (>=0x0002)

  unsigned int :1;
  unsigned int mm: 1;       //Master mode (0=slave; 1=master)
  unsigned int :1;
  unsigned int listen: 1;   //Listen enable (0=disabled; 1=enabled, feed tx back to receiver)
  unsigned int clen: 1;     //Character length (0=7-bit data; 1=8-bit data)
  unsigned int: 3;

  unsigned int:1;
  unsigned int stc: 1;      //Slave transmit (0=4-pin SPI && STE enabled; 1=3-pin SPI && STE disabled)
  unsigned int:2;
  unsigned int ssel: 2;     //Clock source (00=external UCLK [slave]; 01=ACLK [master]; 10=SMCLK [master] 11=SMCLK [master]); 
  unsigned int ckpl: 1;     //Clock polarity (0=inactive is low && data at rising edge; 1=inverted)
  unsigned int ckph: 1;     //Clock phase (0=normal; 1=half-cycle delayed)
  unsigned int :0;
} my_msp430_spi_config_t;

typedef struct {
  uint16_t ubr;
  uint8_t uctl;
  uint8_t utctl;
} my_msp430_spi_registers_t;

typedef union {
  my_msp430_spi_config_t spiConfig;
  my_msp430_spi_registers_t spiRegisters;
} my_msp430_spi_union_config_t;

// Setting bits in the uxTCTL register so SPI works.
// Clock Phase Select must be 0, which is not the default for the MSP430, so set
// it here.  
my_msp430_spi_union_config_t my_msp430_spi_default_config = {
  {
    ubr : 0x0002,
    ssel : 0x03,
    clen : 1,
    listen : 0,
    mm : 1,
    ckph : 0,
    ckpl : 0,
    stc : 1
  }
};

