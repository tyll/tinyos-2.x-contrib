/** 
 * Implements a "reliable" sccb protocol.  Every sccb write is followed by a
 * read to ensure the value was actually written.  If not, the layer will
 * retry a specified number of times.
 */

configuration HplSCCBReliableC
{
  provides {
    interface HplSCCB[uint8_t id];
  }
}
implementation {
  components HplSCCBReliableM, HplSCCBC, LedsC;

  // Interface wiring
  HplSCCB   = HplSCCBReliableM; 

  HplSCCBReliableM.Leds -> LedsC;
  // Component wiring
  HplSCCBReliableM.actualHplSCCB -> HplSCCBC.HplSCCB[0x42]; //OVWRITE
}
