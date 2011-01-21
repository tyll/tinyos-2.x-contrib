/** 
 * Definitions for ATmega328's SPI hardware
 *
 * @notes
 * This file is modified from 
 * <code>tinyos-2.1.0/tos/chips/atm128/spi/Atm128Spi.h</code>
 *
 * @author 
 * Chaiporn Jaikaeo (chaiporn.j@ku.ac.th)
 */

#ifndef _H_Atm328SPI_h
#define _H_Atm328SPI_h

//====================== SPI Bus ==================================

enum {
  ATM328_SPI_CLK_DIVIDE_4   = 0,
  ATM328_SPI_CLK_DIVIDE_16  = 1,
  ATM328_SPI_CLK_DIVIDE_64  = 2,
  ATM328_SPI_CLK_DIVIDE_128 = 3,
};

/* SPI Control Register */
typedef struct {
  uint8_t spie  : 1;  //!< SPI Interrupt Enable
  uint8_t spe   : 1;  //!< SPI Enable
  uint8_t dord  : 1;  //!< SPI Data Order
  uint8_t mstr  : 1;  //!< SPI Master/Slave Select
  uint8_t cpol  : 1;  //!< SPI Clock Polarity
  uint8_t cpha  : 1;  //!< SPI Clock Phase
  uint8_t spr   : 2;  //!< SPI Clock Rate

} Atm328SPIControl_s;
typedef union {
  uint8_t flat;
  Atm328SPIControl_s bits;
} Atm328SPIControl_t;

typedef Atm328SPIControl_t Atm328_SPCR_t;  //!< SPI Control Register

/* SPI Status Register */
typedef struct {
  uint8_t spif  : 1;  //!< SPI Interrupt Flag
  uint8_t wcol  : 1;  //!< SPI Write COLision flag
  uint8_t rsvd  : 5;  //!< Reserved
  uint8_t spi2x : 1;  //!< Whether we are in double speed

} Atm328SPIStatus_s;
typedef union {
  uint8_t flat;
  Atm328SPIStatus_s bits;
} Atm328SPIStatus_t;

typedef Atm328SPIStatus_t Atm328_SPSR_t;  //!< SPI Status Register

typedef uint8_t Atm328_SPDR_t;  //!< SPI Data Register

#endif //_H_Atm328SPI_h
