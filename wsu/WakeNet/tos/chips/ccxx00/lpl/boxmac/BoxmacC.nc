
/**
 * Reference this file in the application layer and you can acheive
 * shorter wake-up transmissions for a given receive check interval.
 * This library makes your BMAC implementation more efficient by turning it 
 * into BoX-MAC (short energy based BMAC receive checks + semi-packetized
 * wake-up transmissions).
 *
 * The original wake-up transmission is divided by WAKEUP_TRANSMISSION_DIVISIONS
 * defined in the Boxmac.h header file.  The PacketLink layer is
 * accessed to perform automatic retries of the packet, and the CSMA layer
 * is tapped to remove clear channel assessments on subsequent retries.
 *
 * Your application layer must supply the SendNotifier interface which allows 
 * this library to function. The reason you supply the interface is so your
 * system can setup an initial default packet configuration before letting
 * the boxmac hybrid work its energy saving magic.
 *
 * Your packet delivery success rate will decrease slightly because of the
 * gaps introduced in the modulation of the wake-up transmission.
 * 
 * @author David Moss.
 */

#ifndef BMACLPL_H
// Be sure to reference BMAC before attempting to compile in this library.
#warning "Out-of-order compile error?"
#error "You must be using BMAC with the BoX-MAC Hybrid implementation."
#endif

#warning "Including BMAC / BoX-MAC Hybrid Modification Layer"

configuration BoxmacC {
  uses {
    interface SendNotifier[am_id_t amId];
  }
}

implementation {

  components BlazeC;
  components BoxmacP;
  
  SendNotifier = BoxmacP;
  
  BoxmacP.PacketLink -> BlazeC;
  BoxmacP.LowPowerListening -> BlazeC;
  BoxmacP.Csma -> BlazeC;
  BoxmacP.AMSend -> BlazeC;

}
