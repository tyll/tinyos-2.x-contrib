
#warning "Using unit test's AcknowledgementC to block the transmit branch"

configuration AcknowledgementsC {
  provides {
    interface Send[radio_id_t id];
    interface PacketAcknowledgements;
  }
  
  uses {
    interface Send as SubSend[radio_id_t id];
  }
}

implementation {

  components DualRadioTestP;
  Send = DualRadioTestP.SendCapture;

  components DummyAcknowledgementsP;
  PacketAcknowledgements = DummyAcknowledgementsP;
  SubSend = DummyAcknowledgementsP.SubSend;
  

}

