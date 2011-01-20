interface CtpInstrumentation {
  command error_t ctrl_txpkt();
  command error_t ctrl_rxpkt();
  command error_t ctrl_parentchange();
  command error_t ctrl_tricklereset();
  command error_t data_txpkt();
  command error_t data_rxpkt();
  command error_t data_rxack();
  command error_t data_queuedrop();
  command error_t data_pktdup();
  command error_t data_inconsistent();

  command error_t init();
  command error_t summary(nx_uint8_t *buf);
  command uint8_t summary_size();
}
