#include "message.h"
#include "../antitheft.h"

module AntiTheftRootC {
  uses {
    interface Leds;
    interface Boot;
    interface SplitControl as SerialControl;
    interface SplitControl as CommControl;
    interface StdControl as CollectionControl;
    interface StdControl as DisseminationControl;

    interface RootControl;
    interface Receive as RTheft;
    interface AMSend as STheft;

    interface DisseminationUpdate<settings_t> as USettings;
    interface Receive as RSettings;
  }
}
implementation {
  message_t fwdMsg;
  bool fwdBusy;

  event void Boot.booted() {
    call SerialControl.start();
  }

  event void SerialControl.startDone(error_t ok) {
    call CommControl.start();
  }

  event void SerialControl.stopDone(error_t ok) { }

  event void CommControl.startDone(error_t error) {
    // Start multi-hop routing and dissemination
    call CollectionControl.start();
    call DisseminationControl.start();
    // Set ourselves as the root of the collection tree
    call RootControl.setRoot();
  }

  event void CommControl.stopDone(error_t ok) { }

  /* When we receive new settings from the serial port, we disseminate
     them by calling the change command */
  event message_t *RSettings.receive(message_t* msg, void* payload, uint8_t len) {
    call Leds.led2Toggle();
    if (len == sizeof(settings_t))
      call USettings.change((settings_t *)payload);
    return msg;
  }

  /* When we (as root of the collection tree) receive a new theft alert,
     we forward it to the PC via the serial port */
  event message_t *RTheft.receive(message_t* msg, void* payload, uint8_t len) {
    if (len == sizeof(theft_t) && !fwdBusy)
      {
        /* Copy payload from collection system to our serial message buffer
           (fwdTheft), then send our serial message */
        theft_t *fwdTheft = call STheft.getPayload(&fwdMsg, sizeof(theft_t));
	 if (fwdTheft != NULL) {
          *fwdTheft = *(theft_t *)payload;
          if (call STheft.send(TOS_BCAST_ADDR, &fwdMsg, sizeof *fwdTheft) == SUCCESS)
            fwdBusy = TRUE;
        }
      }
    return msg;
  }

  event void STheft.sendDone(message_t *msg, error_t error) {
    call Leds.led1Toggle();
    fwdBusy = FALSE;
  }
}
