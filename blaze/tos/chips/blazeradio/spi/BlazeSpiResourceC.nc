
#include "BlazeSpiResource.h"

/**
 * Share the Blaze chips' platform SPI resource with all the different
 * Blaze components that needs it.
 * @author David Moss
 */
generic configuration BlazeSpiResourceC() {

  provides interface Resource;
  provides interface ChipSpiResource;
}

implementation {


  enum {
    CLIENT_ID = unique( UQ_BLAZE_SPI_RESOURCE ),
  };
  
  // We want to write up BlazeSpiP here, but also include BlazeSpiC so that
  // configuration gets included 
  components BlazeSpiC,
      BlazeSpiP;
  Resource = BlazeSpiP.Resource[ CLIENT_ID ];
  ChipSpiResource = BlazeSpiP;

}

