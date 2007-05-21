
/**
 * This component shares extra bytes out of both ComponentA's and 
 * ComponentB's structures
 *
 * @author David Moss
 * @author Kevin Klues (klues@tkn.tu-berlin.de)
 */
 
 
#include "ComponentA.h"
#include "ComponentB.h"

configuration ComponentCC {
}

implementation {
  components ComponentCP,
      MainC,
      
      new ExtendedByteC(UQ_COMPONENTA_EXTENSION) as AByteOneC,
      new ExtendedWordC(UQ_COMPONENTA_EXTENSION) as AWordTwoC,
      
      new ExtendedByteC(UQ_COMPONENTB_EXTENSION) as BByteThreeC,
      new ExtendedWordC(UQ_COMPONENTB_EXTENSION) as BWordFourC,
      
      LedsC,
      new TimerMilliC();
  
  MainC.SoftwareInit -> ComponentCP;
  
  ComponentCP.Boot -> MainC;
  ComponentCP.AByteOne -> AByteOneC;
  ComponentCP.AWordTwo -> AWordTwoC;
  ComponentCP.BByteThree -> BByteThreeC;
  ComponentCP.BWordFour -> BWordFourC;
  ComponentCP.Timer -> TimerMilliC;
  ComponentCP.Leds -> LedsC;

}

