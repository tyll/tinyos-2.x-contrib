/* Copyright (c) 2007 Arch Rock Corporation  All rights reserved.
 *
 * Implementation of the user button for the ecosens1 platform. Get
 * returns the current state of the button by reading the pin,
 * regardless of whether enable() or disable() has been called on the
 * Interface. Notify.enable() and Notify.disable() modify the
 * underlying interrupt state of the pin, and have the effect of
 * enabling or disabling notifications that the button has changed
 * state.
 *
 * @author Gilman Tolle <gtolle@archrock.com>  @version $Revision$
 */

#include <UserButton.h>

configuration UserButtonC {
  provides interface Get<button_state_t>;
  provides interface Notify<button_state_t>;
}
implementation {
  components HplUserButtonC;
  components new SwitchToggleC();
  SwitchToggleC.GpioInterrupt -> HplUserButtonC.GpioInterrupt;
  SwitchToggleC.GeneralIO -> HplUserButtonC.GeneralIO;

  components UserButtonP;
  Get = UserButtonP;
  Notify = UserButtonP;

  UserButtonP.GetLower -> SwitchToggleC.Get;
  UserButtonP.NotifyLower -> SwitchToggleC.Notify;
}
