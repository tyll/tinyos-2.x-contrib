/**
 * Interface to initialize and control the M16c/62p mcu.
 *
 * @author Henrik Makitaavola
 */
interface M16c62pClockCtrl
{
  /**
   * Makes the cpu run at a certain speed and with or without the sub_clock on.
   *
   * @param main_clock_division 'CPU speed' =
   *                                'Main crystal speed'/main_clock_division.
   * @param sub_clock The sub clock is turned on if true else off.
   */
  async command void init(M16c62pMainClkDiv main_clock_division, bool sub_clock);
  
  /**
   * Reinits the MCU to its last known state.
   */
  async command void reInit();
}
