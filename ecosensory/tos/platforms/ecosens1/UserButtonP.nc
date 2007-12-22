/* Copyright (c) 2007 Arch Rock Corporation  All rights reserved.
 * Implementation of the user button for the telosb platform
 *
 * @author Gilman Tolle <gtolle@archrock.com>   @version $Revision$
 */

#include <UserButton.h>

module UserButtonP {
  provides interface Get<button_state_t>;
  provides interface Notify<button_state_t>;

  uses interface Get<bool> as GetLower;
  uses interface Notify<bool> as NotifyLower;
}
implementation {
  
  command button_state_t Get.get() { 
    // telosb user button pin is high when released - invert state
    if ( call GetLower.get() ) {
      return BUTTON_RELEASED;
    } else {
      return BUTTON_PRESSED;
    }
  }

  command error_t Notify.enable() {
    return call NotifyLower.enable();
  }

  command error_t Notify.disable() {
    return call NotifyLower.disable();
  }

  event void NotifyLower.notify( bool val ) {
    // telosb user button pin is high when released - invert state
    if ( val ) {
      signal Notify.notify( BUTTON_RELEASED );
    } else {
      signal Notify.notify( BUTTON_PRESSED );
    }
  }
}
