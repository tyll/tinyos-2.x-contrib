/* Copyright (c) 2007 Ecosensory  MIT license  
 *
 * by John Griessen <john@ecosensory.com>
 * Rev 1.0 12aug07
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

