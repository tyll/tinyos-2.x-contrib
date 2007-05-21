
/**
 * This component adds bytes and words to a network struct, and verifies
 * it can store/load data into those locations.
 *
 * @author David Moss
 * @author Kevin Klues (klues@tkn.tu-berlin.de)
 */
 
#include "ComponentA.h"

configuration ComponentAC {
}

implementation {
  components ComponentAP,
      MainC,
      new ExtendedByteC(UQ_COMPONENTA_EXTENSION) as ByteOneC,
      new ExtendedWordC(UQ_COMPONENTA_EXTENSION) as WordTwoC,
      new ExtendedByteC(UQ_COMPONENTA_EXTENSION) as ByteThreeC,
      new ExtendedWordC(UQ_COMPONENTA_EXTENSION) as WordFourC,
      LedsC,
      new TimerMilliC();
  
  MainC.SoftwareInit -> ComponentAP;
  
  ComponentAP.Boot -> MainC;
  ComponentAP.ByteOne -> ByteOneC;
  ComponentAP.WordTwo -> WordTwoC;
  ComponentAP.ByteThree -> ByteThreeC;
  ComponentAP.WordFour -> WordFourC;
  ComponentAP.Timer -> TimerMilliC;
  ComponentAP.Leds -> LedsC;

}

