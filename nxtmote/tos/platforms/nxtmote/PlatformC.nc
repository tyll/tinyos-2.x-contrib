/*
 * Copyright (c) 2005-2006 Intel Corporation
 * All rights reserved.
 *
 * This file is distributed under the terms in the attached INTEL-LICENSE     
 * file. If you do not find these files, copies can be found by writing to
 * Intel Research Berkeley, 2150 Shattuck Avenue, Suite 1300, Berkeley, CA, 
 * 94704.  Attention:  Intel License Inquiry.
 */
/**
 * Dummy implementation to support the null platform.
 */

/**
 * Adapted for nxtmote.
 * @author Rasmus Pedersen
 */

configuration PlatformC { 
  provides interface Init;
}
implementation {
  //Must
  components PlatformP, HplAT91InterruptM;
  Init = PlatformP;
  
  //Optional components
  components HplAT91PitC;
  PlatformP.InitL3 -> HplAT91PitC.Init;
  
  //components HalBtC;

  //components NxtAvrC;
  //PlatformP.InitL2 -> NxtAvrC.Init;  
  
  
}
