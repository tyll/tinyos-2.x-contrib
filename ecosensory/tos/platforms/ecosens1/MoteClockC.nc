/* Copyright (c) 2007, Technische Universitaet Berlin All rights reserved.
 * BSD license full text at: 
 * http://tinyos.cvs.sourceforge.net/tinyos/tinyos-2.x-contrib/tub/license.txt
 *
 * $Id$
 * @author Vlado Handziski <handzisk@tkn.tu-berlind.de>
 */
 
configuration MoteClockC
{
  provides interface Init as MoteClockInit;
}
implementation

{
  components Msp430ClockC, MoteClockP;
  
  MoteClockInit = Msp430ClockC.Init;
  //MoteClockP.Msp430ClockInit -> Msp430ClockC;
}
