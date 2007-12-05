
#warning "Using unit test's BlazeInitC"

configuration BlazeInitC {
  provides {
    interface SplitControl[ radio_id_t id ];
    interface BlazeCommit[ radio_id_t id ];
    interface BlazePower[ radio_id_t id ];
  }
}

implementation {

  components DualRadioTestP;
  SplitControl = DualRadioTestP.SplitControlCapture;
  
  components DummyInitP;
  BlazeCommit = DummyInitP.BlazeCommitCapture;
  BlazePower = DummyInitP.BlazePowerCapture;
  
}

