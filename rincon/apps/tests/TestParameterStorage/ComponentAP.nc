
/**
 * This component adds bytes and words to a network struct, and verifies
 * it can store/load data into those locations.
 *
 * @author David Moss
 * @author Kevin Klues (klues@tkn.tu-berlin.de)
 */
 
#include "ComponentA.h"

module ComponentAP {
  provides {
    interface Init;
  }
  
  uses {
    interface Boot;
    interface ParameterStorage as ByteOne;
    interface ParameterStorage as WordTwo;
    interface ParameterStorage as ByteThree;
    interface ParameterStorage as WordFour;
    interface Leds;
    interface Timer<TMilli>;
  }
}

implementation {
  
  enum {
    INIT_BYTE = 5,
    INIT_WORD = 500,
  };
  
  /** Double check our values here */
  uint8_t byteOne;
  uint16_t wordTwo;
  uint8_t byteThree;
  uint16_t wordFour;
  
  /** Metadata we're storing extended parameters into */
  cc5000_metadata_t myMetadata;
  
  /***************** Prototypes ****************/
  task void checkParameters();
  
  /***************** Init Commands ****************/
  command error_t Init.init() {
    byteOne = INIT_BYTE + 1;
    wordTwo = INIT_WORD + 2;
    byteThree = INIT_BYTE + 3;
    wordFour = INIT_WORD + 4;
    
    call ByteOne.store(&myMetadata.extendedParameters, &byteOne);
    call WordTwo.store(&myMetadata.extendedParameters, &wordTwo);
    call ByteThree.store(&myMetadata.extendedParameters, &byteThree);
    call WordFour.store(&myMetadata.extendedParameters, &wordFour);
    
    return SUCCESS;
  }
  
  /***************** Boot Events ****************/
  event void Boot.booted() {
    post checkParameters();
    call Timer.startPeriodic(500);
  }
  
  /***************** Timer Events ****************/
  event void Timer.fired() {
    byteOne += 1;
    wordTwo += 100;
    byteThree += 2;
    wordFour += 200;
    
    call ByteOne.store(&myMetadata.extendedParameters, &byteOne);
    call WordTwo.store(&myMetadata.extendedParameters, &wordTwo);
    call ByteThree.store(&myMetadata.extendedParameters, &byteThree);
    call WordFour.store(&myMetadata.extendedParameters, &wordFour);
    
    post checkParameters();
  }
  
  /***************** Tasks ****************/
  task void checkParameters() {
    call Leds.led1Off();
    call Leds.led2Toggle();
    
    if(*((uint8_t *) call ByteOne.load(&myMetadata.extendedParameters)) != byteOne) {
      call Leds.led0On();
    } else {
      call Leds.led1On();
    }
    
    if(*((uint16_t *) call WordTwo.load(&myMetadata.extendedParameters)) != wordTwo) {
      call Leds.led0On();
    } else {
      call Leds.led1On();
    }
    
    if(*((uint8_t *) call ByteThree.load(&myMetadata.extendedParameters)) != byteThree) {
      call Leds.led0On();
    } else {
      call Leds.led1On();
    }
    
    if(*((uint16_t *) call WordFour.load(&myMetadata.extendedParameters)) != wordFour) {
      call Leds.led0On();
    } else {
      call Leds.led1On();
    }
  }
  
}
