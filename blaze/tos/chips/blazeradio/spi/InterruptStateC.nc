
/**
 * We create a new State machine for the SFD interrupt line (defined in
 * the blaze stack as GDO2) so we can share it between Receive and Transmit.
 * Those two branches should be able to be compiled without dependency on
 * each other, so they refer to this component to pull in the state machine.
 * That way, one can be compiled without the other and unit testing becomes
 * more modular
 *
 * @author David Moss
 */

#include "InterruptState.h"

configuration InterruptStateC {
  provides {
    interface State as InterruptState;
  }
}

implementation {
  components new StateC();
  
  InterruptState = StateC;
  
}

