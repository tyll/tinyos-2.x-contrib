/* Copyright (c) 2007, Ecosensory Austin Texas All rights reserved. 
 * BSD license full text at: 
 * http://tinyos.cvs.sourceforge.net/tinyos/tinyos-2.x-contrib/ecosensory/license.txt
 *
 * @author John Griessen <john@ecosensory.com>  
 * @version $Revision$ $Date$
 */

configuration UserSwitchC {
  provides interface Get<state_t>;
  provides interface Notify<state_t>;
}
implementation {
  components HplUserSwitchC;
  components new SwitchC() as userswitchlocal;
// userswitchlocal local use only -- need not end in C or P.
  userswitchlocal.GpioInterrupt -> HplUserSwitchC.GpioInterrupt;
  userswitchlocal.GeneralIO -> HplUserSwitchC.GeneralIO;

  components UserSwitchP;
  Notify =  UserSwitchP;
  Get = UserSwitchP;
  UserSwitchP.GetGeneric -> userswitchlocal.Get;
  UserSwitchP.NotifyGeneric -> userswitchlocal.Notify;
}

