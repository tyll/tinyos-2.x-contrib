d
/**
 * This component shares extra bytes out of both ComponentA's and 
 * ComponentB's structures
 *
 * @author David Moss
 * @author Kevin Klues (klues@tkn.tu-berlin.de)
 */
 
#include "ComponentA.h"
#include "ComponentB.h"

module ComponentCP {
  provides {
    interface Init;
  }
  
  uses {
    interface Boot;
    
    interface ParameterStorage as AByteOne;
    interface ParameterStorage as AWordTwo;
    
    interface ParameterStorage as BByteThree;
    interface ParameterStorage as BWordFour;
    interface Leds;
    interface Timer<TMilli>;
  }
}

implementation {
  
  enum {
    INIT_BYTE = 7,
    INIT_WORD = 700,
  };
  
  /** Double check our values here */
  uint8_t a_byteOne;
  uint16_t a_wordTwo;
  uint8_t b_byteThree;
  uint16_t b_wordFour;
  
  cc5000_metadata_t componentAStruct;
  
  growing_struct_t componentBStruct;
  
  /***************** Prototypes ****************/
  task void checkParameters();
  
  /***************** Init Commands ****************/
  command error_t Init.init() {
    a_byteOne = INIT_BYTE + 1;
    a_wordTwo = INIT_WORD + 2;
    b_byteThree = INIT_BYTE + 3;
    b_wordFour = INIT_WORD + 4;
    
    call AByteOne.store(&componentAStruct.extendedParameters, &a_byteOne);
    call AWordTwo.store(&componentAStruct.extendedParameters, &a_wordTwo);
    call BByteThree.store(&componentBStruct.extendedParameters, &b_byteThree);
    call BWordFour.store(&componentBStruct.extendedParameters, &b_wordFour);
    
    return SUCCESS;
  }
  
  /***************** Boot Events ****************/
  event void Boot.booted() {
    post checkParameters();
    call Timer.startPeriodic(500);
  }
  
  /***************** Timer Events ****************/
  event void Timer.fired() {
    a_byteOne += 1;
    a_wordTwo += 100;
    b_byteThree += 2;
    b_wordFour += 200;
    
    call AByteOne.store(&componentAStruct.extendedParameters, &a_byteOne);
    call AWordTwo.store(&componentAStruct.extendedParameters, &a_wordTwo);
    
    call BByteThree.store(&componentBStruct.extendedParameters, &b_byteThree);
    call BWordFour.store(&componentBStruct.extendedParameters, &b_wordFour);
    
    post checkParameters();
  }
  
  /***************** Tasks ****************/
  task void checkParameters() {

    if(*((uint8_t *) call AByteOne.load(&componentAStruct.extendedParameters)) != a_byteOne) {
      call Leds.led0On();
    }
    
    if(*((uint16_t *) call AWordTwo.load(&componentAStruct.extendedParameters)) != a_wordTwo) {
      call Leds.led0On();
    }
    
    if(*((uint8_t *) call BByteThree.load(&componentBStruct.extendedParameters)) != b_byteThree) {
      call Leds.led0On();
    }
    
    if(*((uint16_t *) call BWordFour.load(&componentBStruct.extendedParameters)) != b_wordFour) {
      call Leds.led0On();
    }
  }
}
