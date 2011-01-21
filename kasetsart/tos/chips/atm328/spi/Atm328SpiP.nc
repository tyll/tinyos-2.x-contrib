/**
 * Primitives for accessing the SPI module on ATmega328
 * microcontroller.  This module assumes the bus has been reserved and
 * checks that the bus owner is in fact the person using the bus.
 * SpiPacket provides an asynchronous send interface where the
 * transmit data length is equal to the receive data length, while
 * SpiByte provides an interface for sending a single byte
 * synchronously. SpiByte allows a component to send a few bytes
 * in a simple fashion: if more than a handful need to be sent,
 * SpiPacket should be used.
 *
 * @notes 
 * This file is modified from 
 * <code>tinyos-2.1.0/tos/chips/atm128/spi/Atm128SpiP.nc</code>
 *
 * @author 
 * Chaiporn Jaikaeo (chaiporn.j@ku.ac.th)
 */

module Atm328SpiP @safe() {
  provides {
    interface Init;
    interface SpiByte;
    interface SpiPacket;
    interface Resource[uint8_t id];
  }
  uses {
    interface Atm328Spi as Spi;
    interface Resource as ResourceArbiter[uint8_t id];
    interface ArbiterInfo;
    interface McuPowerState;
  }
}
implementation {
  uint16_t len;
  uint8_t* COUNT_NOK(len) txBuffer;
  uint8_t* COUNT_NOK(len) rxBuffer;
  uint16_t pos;
  
  enum {
    SPI_IDLE,
    SPI_BUSY,
    SPI_ATOMIC_SIZE = 10,
  };

  command error_t Init.init() {
    return SUCCESS;
  }
  
  void startSpi() {
    call Spi.enableSpi(FALSE);
    atomic {
      call Spi.initMaster();
      call Spi.enableInterrupt(FALSE);
      call Spi.setMasterDoubleSpeed(TRUE);
      call Spi.setClockPolarity(FALSE);
      call Spi.setClockPhase(FALSE);
      call Spi.setClock(0);
      call Spi.enableSpi(TRUE);
    }
    call McuPowerState.update();
  }

  void stopSpi() {
    call Spi.enableSpi(FALSE);
    atomic {
      call Spi.sleep();
    }
    call McuPowerState.update();
  }

  async command uint8_t SpiByte.write( uint8_t tx ) {
    call Spi.enableSpi(TRUE);
    call McuPowerState.update();
    call Spi.write( tx );
    while ( !( SPSR & (1 << SPIF) ) );
    return call Spi.read();
  }


  /**
   * This component sends SPI packets in chunks of size SPI_ATOMIC_SIZE
   * (which is normally 5). The tradeoff is between SPI performance
   * (throughput) and how much the component limits concurrency in the
   * rest of the system. Handling an interrupt on each byte is
   * very expensive: the context saving/register spilling constrains
   * the rate at which one can write out bytes. A more efficient
   * approach is to write out a byte and wait for a few cycles until
   * the byte is written (a tiny spin loop). This leads to greater
   * throughput, but blocks the system and prevents it from doing
   * useful work.
   *
   * This component takes a middle ground. When asked to transmit X
   * bytes in a packet, it transmits those X bytes in 10-byte parts.
   * <tt>sendNextPart()</tt> is responsible for sending one such
   * part. It transmits bytes with the SpiByte interface, which
   * disables interrupts and spins on the SPI control register for
   * completion. On the last byte, however, <tt>sendNextPart</tt>
   * re-enables SPI interrupts and sends the byte through the
   * underlying split-phase SPI interface. When this component handles
   * the SPI transmit completion event (handles the SPI interrupt),
   * it calls sendNextPart() again. As the SPI interrupt does
   * not disable interrupts, this allows processing in the rest of the
   * system to continue.
   */
   
  error_t sendNextPart() {
    uint16_t end;
    uint16_t tmpPos;
    uint16_t myLen;
    uint8_t* COUNT_NOK(myLen) tx;
    uint8_t* COUNT_NOK(myLen) rx;
    
    atomic {
      myLen = len;
      tx = txBuffer;
      rx = rxBuffer;
      tmpPos = pos;
      end = pos + SPI_ATOMIC_SIZE;
      end = (end > len)? len:end;
    }

    for (;tmpPos < (end - 1) ; tmpPos++) {
      uint8_t val;
      if (tx != NULL) 
        val = call SpiByte.write( tx[tmpPos] );
      else
        val = call SpiByte.write( 0 );
    
      if (rx != NULL) {
        rx[tmpPos] = val;
      }
    }

    // For the last byte, we re-enable interrupts.

   call Spi.enableInterrupt(TRUE);
   atomic {
     if (tx != NULL)
       call Spi.write(tx[tmpPos]);
     else
       call Spi.write(0);
     
     pos = tmpPos;
      // The final increment will be in the interrupt
      // handler.
    }
    return SUCCESS;
  }


  task void zeroTask() {
     uint16_t  myLen;
     uint8_t* COUNT_NOK(myLen) rx;
     uint8_t* COUNT_NOK(myLen) tx;

     atomic {
       myLen = len;
       rx = rxBuffer;
       tx = txBuffer;
       rxBuffer = NULL;
       txBuffer = NULL;
       len = 0;
       pos = 0;
       signal SpiPacket.sendDone(tx, rx, myLen, SUCCESS);
     }
  }

  /**
   * Send bufLen bytes in <tt>writeBuf</tt> and receive bufLen bytes
   * into <tt>readBuf</tt>. If <tt>readBuf</tt> is NULL, bytes will be
   * read out of the SPI, but they will be discarded. A byte is read
   * from the SPI before writing and discarded (to clear any buffered
   * bytes that might have been left around).
   *
   * This command only sets up the state variables and clears the SPI:
   * <tt>sendNextPart()</tt> does the real work.
   * 
   * If there's a send of zero bytes, short-circuit and just post
   * a task to signal the sendDone. This generally occurs due to an
   * error in the caler, but signaling an event will hopefully let
   * it recover better than returning FAIL.
   */

  
  async command error_t SpiPacket.send(uint8_t* writeBuf, 
               uint8_t* readBuf, 
               uint16_t  bufLen) {
    uint8_t discard;
    atomic {
      len = bufLen;
      txBuffer = writeBuf;
      rxBuffer = readBuf;
      pos = 0;
    }
    if (bufLen > 0) {
      call Spi.enableSs(TRUE);  // @@@Art indicate start of SPI packet
      discard = call Spi.read();
      return sendNextPart();
    }
    else {
      post zeroTask();
      return SUCCESS;
    }
  }

  default async event void SpiPacket.sendDone
       (uint8_t* _txbuffer, uint8_t* _rxbuffer, 
        uint16_t _length, error_t _success) { }
 
  async event void Spi.dataReady(uint8_t data) {
    bool again;
    
    atomic {
      if (rxBuffer != NULL) {
        rxBuffer[pos] = data;
        // Increment position
      }
      pos++;
    }
    call Spi.enableInterrupt(FALSE);
    
    atomic {
      again = (pos < len);
    }
    
    if (again) {
      sendNextPart();
    }
    else {
      uint8_t discard;
      uint16_t  myLen;
      uint8_t* COUNT_NOK(myLen) rx;
      uint8_t* COUNT_NOK(myLen) tx;
      
      atomic {
        myLen = len;
        rx = rxBuffer;
        tx = txBuffer;
        rxBuffer = NULL;
        txBuffer = NULL;
        len = 0;
        pos = 0;
      }
      discard = call Spi.read();

      call Spi.enableSs(FALSE);  // @@@Art indicate end of SPI packet
 
      signal SpiPacket.sendDone(tx, rx, myLen, SUCCESS);
    }
  }
 
  async command error_t Resource.immediateRequest[ uint8_t id ]() {
    error_t result = call ResourceArbiter.immediateRequest[ id ]();
    if ( result == SUCCESS ) {
      startSpi();
    }
    return result;
  }
  
  async command error_t Resource.request[ uint8_t id ]() {
    atomic {
      if (!call ArbiterInfo.inUse()) {
        startSpi();
      }
    }
    return call ResourceArbiter.request[ id ]();
  }
 
  async command error_t Resource.release[ uint8_t id ]() {
    error_t error = call ResourceArbiter.release[ id ]();
    atomic {
      if (!call ArbiterInfo.inUse()) {
        stopSpi();
      }
    }
    return error;
  }
 
  async command uint8_t Resource.isOwner[uint8_t id]() {
    return call ResourceArbiter.isOwner[id]();
  }
  
  event void ResourceArbiter.granted[ uint8_t id ]() {
    signal Resource.granted[ id ]();
  }
  
  default event void Resource.granted[ uint8_t id ]() {}
 
}
