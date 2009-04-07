/**
 * Implementation of the M16c62pClockCtrl Interface.
 *
 * @author Henrik Makitaavola
 */
module M16c62pClockCtrlC
{
  provides interface M16c62pClockCtrl @exactlyonce();
}
implementation
{
  M16c62pMainClkDiv clk_div;
  bool sub_clock;
  
  async command void M16c62pClockCtrl.reInit()
  {
    atomic call M16c62pClockCtrl.init(clk_div, sub_clock);
  }

  async command void M16c62pClockCtrl.init(
      M16c62pMainClkDiv main_clock_division,
	  bool sub_clock_on)
  {
    atomic
    {
      PRCR.BYTE = BIT1 | BIT0; // Turn off protection for the cpu and clock register.

      PM0.BYTE = BIT7;         // Single Chip mode. No BCLK output.
      PM1.BYTE = BIT3;         // Expand internal memory, no global wait state.
      PCLKR.BIT.PCLK0 = 1;     // Set Timer A and B clock bit to F1 (same speed as main crystal).

      WRITE_BIT(CM0.BYTE, 4, sub_clock_on); // Sub clock on/off.
      
      // Init the main clock
      if (main_clock_division == M16C62P_MAIN_CLK_DIV_8)
      {
        SET_BIT(CM0.BYTE, 6);
      }
      else
      {
        CLR_BIT(CM0.BYTE, 6); // Remove division by 8
        CLR_FLAG(CM1.BYTE, (0x3 << 6)); // Clear previous cpu speed setting
        SET_FLAG(CM1.BYTE, (main_clock_division << 6)); // New cpu speed
      }
      // TODO(Henrik) Maybe need to wait for a while to make sure that the crystals are stable?
      CLR_BIT(CM1.BYTE, 5); // Low drive on Xin-Xout.
      CLR_BIT(CM0.BYTE, 3); // Low drive on XCin-XCout.

      PRCR.BYTE = 0;           // Turn on protection on all registers.
      clk_div = main_clock_division;
      sub_clock = sub_clock_on;
    }
  }
}
