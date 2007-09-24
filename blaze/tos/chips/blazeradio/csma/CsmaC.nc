
#include "Csma.h"
#include "Blaze.h"

/**
 * The CSMA layer sits directly above the asynchronous portion of the
 * transmit branch.  It is responsible for loading the TX FIFO with data
 * to send, then sending the data by either forcing it (no CCA) or using
 * backoffs to avoid collisions.
 *
 * The CSMA interface is provided to determine the properties of CCA
 * and backoff durations.  The use of call-backs is done very deliberately, 
 * described below.
 *
 * If you signal out an *event* to request an initial backoff and
 * several components happen to be listening, then those components
 * would be required to return a backoff value, regardless of whether or not
 * those components are interested in affecting the backoff for the given
 * AM type.  We don't want that behavior.
 * 
 * With a call back strategy, components can listen for the requests and then
 * decide if they want to affect the behavior.  If the component wants to
 * affect the behavior, it calls back using the setXYZBackoff(..) command.
 * If several components call back, then the last component to get its 
 * word in has the final say. 
 * 
 * @author David Moss
 */
configuration CsmaC {
  provides {
    interface Send[radio_id_t radioId];
    interface Csma[am_id_t amId];
  }
}

implementation {
  
  components CsmaP;
  Send = CsmaP;
  Csma = CsmaP;
  
  components new BlazeSpiResourceC();
  CsmaP.Resource -> BlazeSpiResourceC;
  
  components BlazeTransmitC;
  CsmaP.AsyncSend -> BlazeTransmitC.AsyncSend;

  components BlazePacketC;
  CsmaP.BlazePacketBody -> BlazePacketC;
  
  components new StateC();
  CsmaP.State -> StateC;
  
  components AlarmMultiplexC;
  CsmaP.BackoffTimer -> AlarmMultiplexC;
  
  components RandomC;
  CsmaP.Random -> RandomC;
  
  components LedsC;
  CsmaP.Leds -> LedsC;
  
}
