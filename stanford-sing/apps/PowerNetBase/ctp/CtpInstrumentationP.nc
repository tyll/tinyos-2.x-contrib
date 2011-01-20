module CtpInstrumentationP {
  provides interface CtpInstrumentation;
}

implementation {

  typedef nx_struct StatCounters {
    nx_uint16_t ctrl_ntxpkt;
    nx_uint16_t ctrl_nrxpkt;
    nx_uint16_t ctrl_nparentchange;
    nx_uint16_t ctrl_ntricklereset;
    
    nx_uint16_t data_ntxpkt;
    nx_uint16_t data_nrxpkt;
    nx_uint16_t data_nrxacks;
    nx_uint16_t data_nqueuedrops;
    nx_uint16_t data_ndups;
    nx_uint16_t data_ninconsistencies;
  } StatCounters;

  StatCounters stats;

  command error_t CtpInstrumentation.init() {
    stats.ctrl_ntxpkt = 0;
    stats.ctrl_nrxpkt = 0;
    stats.ctrl_nparentchange = 0;
    stats.ctrl_ntricklereset = 0;
 
    stats.data_ntxpkt = 0;
    stats.data_nrxpkt = 0;
    stats.data_nrxacks = 0;
    stats.data_nqueuedrops = 0;
    stats.data_ndups = 0;
    stats.data_ninconsistencies = 0;

    return SUCCESS;

  }
    
  command error_t CtpInstrumentation.summary(nx_uint8_t *buf) {
    memcpy(buf, &stats, sizeof(StatCounters));
    return SUCCESS;
  }


  command uint8_t CtpInstrumentation.summary_size() {
    return sizeof(StatCounters);
  }


  command error_t CtpInstrumentation.ctrl_txpkt() {
    stats.ctrl_ntxpkt++;
    return SUCCESS;
  }

  command error_t CtpInstrumentation.ctrl_rxpkt() {
    stats.ctrl_nrxpkt++;
    return SUCCESS;
  }

  command error_t CtpInstrumentation.ctrl_parentchange() {
    stats.ctrl_nparentchange++;
    return SUCCESS;
  }

  command error_t CtpInstrumentation.ctrl_tricklereset() {
    stats.ctrl_ntricklereset++;
    return SUCCESS;
  }

  command error_t CtpInstrumentation.data_txpkt() {
    stats.data_ntxpkt++;
    return SUCCESS;
  }

  command error_t CtpInstrumentation.data_rxpkt() {
    stats.data_nrxpkt++;
    return SUCCESS;
  }

  command error_t CtpInstrumentation.data_rxack() {
    stats.data_nrxacks++;
    return SUCCESS;
  }

  command error_t CtpInstrumentation.data_queuedrop() {
    stats.data_nqueuedrops++;
    return SUCCESS;
  }

  command error_t CtpInstrumentation.data_pktdup() {
    stats.data_ndups++;
    return SUCCESS;
  }

  command error_t CtpInstrumentation.data_inconsistent() {
    stats.data_ninconsistencies++;
    return SUCCESS;
  }

 
}
