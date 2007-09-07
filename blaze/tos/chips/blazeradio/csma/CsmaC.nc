
/**
 * @author David Moss
 */
configuration CsmaC {
  provides {
    interface Send[radio_id_t radioId];
    // interface RadioBackoff[am_id_t amId];
  }
}

implementation {
  
  components CsmaP;
  Send = CsmaP;
  
  components BlazeTransmitC;
  CsmaP.AsyncSend -> BlazeTransmitC;

}
