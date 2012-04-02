interface PacketEnergyEstimator {

  async command void send_start(int, uint8_t, int);
  async command void send_done(int, uint8_t, sim_time_t);
  async command void send_busy(int, uint8_t, int);
  async command void recv_done(int);

  async command void poweron_start();
  async command void poweroff_start();

}
