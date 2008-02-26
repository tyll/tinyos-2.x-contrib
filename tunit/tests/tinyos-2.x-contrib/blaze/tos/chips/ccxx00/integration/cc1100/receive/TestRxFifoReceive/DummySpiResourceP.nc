
module DummySpiResourceP {
  provides {
    interface Resource;
  }
}

implementation {

  bool owned = FALSE;
  
  async command error_t Resource.request() {
    owned = TRUE;
    signal Resource.granted();
    return SUCCESS;
  }

  async command error_t Resource.immediateRequest() {
    owned = TRUE;
    return SUCCESS;
  }

  async command error_t Resource.release() {
    owned = FALSE;
    return SUCCESS;
  }

  async command bool Resource.isOwner() {
    return owned;
  }
  
}
