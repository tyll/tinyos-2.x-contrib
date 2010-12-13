/**
 * Wiring for the LS7366RControl component
 * 
 * </br> KTH | Royal Institute of Technology
 * </br> Automatic Control
 *
 * @author Aitor Hernandez <aitorhh@kth.se>
 * @version $Revision$ $Date$
 * 
 */

#include "LS7366R.h"
#include "IEEE802154.h"

configuration LS7366RControlC {

  provides{
	  interface Resource;
	  interface LS7366RConfig;
	  interface LS7366RReceive; 
  }
 
}


implementation {
  

  components LS7366RControlP;
  Resource = LS7366RControlP;
  LS7366RConfig = LS7366RControlP;
  LS7366RReceive = LS7366RControlP;
		  
  components MainC;
  MainC.SoftwareInit -> LS7366RControlP;

  components HplLS7366RPinsC as Pins;
  LS7366RControlP.SS -> Pins.SS;
  LS7366RControlP.SOMI -> Pins.SOMI;


  components new LS7366RSpiC() as Spi;
  LS7366RControlP.SpiResource -> Spi;
  
  components BusyWaitMicroC as BusyWait;
  LS7366RControlP.BusyWait -> BusyWait;

  // registers
  LS7366RControlP.MDR0 -> Spi.MDR0;
  LS7366RControlP.MDR1 -> Spi.MDR1;
  LS7366RControlP.DTR -> Spi.DTR;
  LS7366RControlP.CNTR -> Spi.CNTR;
  LS7366RControlP.OTR -> Spi.OTR;
  LS7366RControlP.STR -> Spi.STR;
  
  // strobe
  LS7366RControlP.LDOTR -> Spi.LDOTR;
  LS7366RControlP.CLRCNTR -> Spi.CLRCNTR;
  
  components new LS7366RSpiC() as SyncSpiC;
  LS7366RControlP.SyncResource -> SyncSpiC;

}

