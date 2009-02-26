interface Detector
{
  /**
   * Start event detection at t0+dt (parameters based on Alarm.startAt)
   * @param t0 Base time 
   * @param dt Offset from base time at which event detection should start
   */
  command void start(uint32_t t0, uint32_t dt);

  /**
   * Called immediately if event is detected
   */
  async event void detected();

  /**
   * Called when event detection complete
   * @param ok SUCCESS if event detected, FAIL if some error occurred
   */
  event void done(error_t ok);
}
