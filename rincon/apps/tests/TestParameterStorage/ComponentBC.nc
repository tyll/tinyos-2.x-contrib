
/**
 * This component adds bytes and words to a regular struct, and verifies
 * it can store/load data into those locations.
 *
 * @author David Moss
 * @author Kevin Klues (klues@tkn.tu-berlin.de)
 */
 
#include "ComponentB.h"

configuration ComponentBC {
}

implementation {
  components ComponentBP,
      MainC,
      new ExtendedByteC(UQ_COMPONENTB_EXTENSION) as ByteOneC,
      new ExtendedWordC(UQ_COMPONENTB_EXTENSION) as WordTwoC,
      new ExtendedByteC(UQ_COMPONENTB_EXTENSION) as ByteThreeC,
      new ExtendedWordC(UQ_COMPONENTB_EXTENSION) as WordFourC,
      LedsC,
      new TimerMilliC();
  
  MainC.SoftwareInit -> ComponentBP;
  
  ComponentBP.Boot -> MainC;
  ComponentBP.ByteOne -> ByteOneC;
  ComponentBP.WordTwo -> WordTwoC;
  ComponentBP.ByteThree -> ByteThreeC;
  ComponentBP.WordFour -> WordFourC;
  ComponentBP.Timer -> TimerMilliC;
  ComponentBP.Leds -> LedsC;

}

