
/**
 * Above this layer, the Send and Receive interfaces are radio-agnostic 
 * and not parameterized.  The SplitControl interface remains parameterized
 * because there is no metadata associated with it.
 *
 * This layer selects which radio to use based on packet properties, and 
 * everything below it is parameterized by radio ID.  
 * It also the logical place to intersect Send and SplitControl. It queues up a 
 * SplitControl.stop request when we're in the middle of sending, and blocks
 * send requests when the radio is off.
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
    interface SplitControl[radio_id_t id];
    interface RadioSelect;
  }
  
  uses {
    interface Send as SubSend[ radio_id_t id ];
    interface Receive as SubReceive[ radio_id_t id ];
    interface SplitControl as SubControl[ radio_id_t id ];
  }
}

implementation {

  components RadioSelectP;
  Send = RadioSelectP.Send;
  Receive = RadioSelectP.Receive;
  SplitControl = RadioSelectP.SplitControl;
  RadioSelect = RadioSelectP;
  
  SubSend = RadioSelectP.SubSend;
  SubReceive = RadioSelectP.SubReceive;
  SubControl = RadioSelectP.SubControl;
  
  components BlazePacketC;
  RadioSelectP.BlazePacketBody -> BlazePacketC;

}

