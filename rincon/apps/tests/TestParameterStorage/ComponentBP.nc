
/**
 * This component adds bytes and words to a regular struct, and verifies
 * it can store/load data into those locations.
 *
 * @author David Moss
 * @author Kevin Klues (klues@tkn.tu-berlin.de)
 */

 
#include "ComponentB.h"

module ComponentBP {
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
    INIT_BYTE = 6,
    INIT_WORD = 600,
  };
  
  /** Double check our values here */
  uint8_t byteOne;
  uint16_t wordTwo;
  uint8_t byteThree;
  uint16_t wordFour;
  
  /** Metadata we're storing extended parameters into */
  growing_struct_t myGrowingStruct;
  
  /***************** Prototypes ****************/
  task void checkParameters();
  
  /***************** Init Commands ****************/
  command error_t Init.init() {
    byteOne = INIT_BYTE + 1;
    wordTwo = INIT_WORD + 2;
    byteThree = INIT_BYTE + 3;
    wordFour = INIT_WORD + 4;
    
    call ByteOne.store(&myGrowingStruct.extendedParameters, &byteOne);
    call WordTwo.store(&myGrowingStruct.extendedParameters, &wordTwo);
    call ByteThree.store(&myGrowingStruct.extendedParameters, &byteThree);
    call WordFour.store(&myGrowingStruct.extendedParameters, &wordFour);
    
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
    
    call ByteOne.store(&myGrowingStruct.extendedParameters, &byteOne);
    call WordTwo.store(&myGrowingStruct.extendedParameters, &wordTwo);
    call ByteThree.store(&myGrowingStruct.extendedParameters, &byteThree);
    call WordFour.store(&myGrowingStruct.extendedParameters, &wordFour);
    
    post checkParameters();
  }
  
  /***************** Tasks ****************/
  task void checkParameters() {
    if(*((uint8_t *) call ByteOne.load(&myGrowingStruct.extendedParameters)) != byteOne) {
      call Leds.led0On();
    }
    
    if(*((uint16_t *) call WordTwo.load(&myGrowingStruct.extendedParameters)) != wordTwo) {
      call Leds.led0On();
    }
    
    if(*((uint8_t *) call ByteThree.load(&myGrowingStruct.extendedParameters)) != byteThree) {
      call Leds.led0On();
    }
    
    if(*((uint16_t *) call WordFour.load(&myGrowingStruct.extendedParameters)) != wordFour) {
      call Leds.led0On();
    }
  }
}
