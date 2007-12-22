/* Copyright (c) 2007, Ecosensory Austin Texas All rights reserved. 
 * BSD license full text at: 
 * http://tinyos.cvs.sourceforge.net/tinyos/tinyos-2.x-contrib/ecosensory/license.txt
 * @author Joe Polastre and Cory Sharp
 * derived telosb  John Griessen 
 * @version $Revision$ $Date$
 */
#include "hardware.h"

configuration PlatformC
{
  provides interface Init;
}
implementation
{
  components PlatformP, MotePlatformC, MoteClockC;

  Init = PlatformP;
  PlatformP.MoteClockInit -> MoteClockC;
  PlatformP.MoteInit -> MotePlatformC;
}

