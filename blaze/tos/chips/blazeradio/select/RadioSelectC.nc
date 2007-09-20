
/**
 * Above this layer, the Send and Receive interfaces are radio-agnostic 
 * and not parameterized.
 *
 * This layer selects which radio to use based on packet properties, and 
 * everything below it is parameterized by radio ID
 *
 * Use the RadioSelect interface to change the radio a particular message
 * uses to send.
 * 
 * @author David Moss
 */
 
configuration RadioSelectC {
  provides {
    interface Send;
    interface Receive;
    interface RadioSelect;
  }
  
  uses {
    interface Send as SubSend[ radio_id_t id ];
    interface Receive as SubReceive[ radio_id_t id ];
  }
}

implementation {

  components RadioSelectP;
  Send = RadioSelectP.Send;
  Receive = RadioSelectP.Receive;
  RadioSelect = RadioSelectP;
  
  SubSend = RadioSelectP.SubSend;
  SubReceive = RadioSelectP.SubReceive;
  
  components BlazePacketC;
  RadioSelectP.BlazePacketBody -> BlazePacketC;

}

