
#include "Msp430Dac12.h"

/**
 * MSP430 DAC12 Hardware Presentation Layer interface
 * @author David Moss
 */
 
interface HplMsp430Dac12 {

  /**
   * Configure all the registers
   * @param dac12ctl the DAC12_xCTL register settings
   */
  command void configure(const msp430_dac12_control_t *dac12ctl);
  
  /**
   * Set the resolution of the DAC.
   * @param eightBit TRUE for 8-bit resolution, FALSE for 12-bit resolution
   */
  command void useEightBitResolution(bool eightBit);
  
  /**
   * Sets the reference voltage source.  If you select FALSE for Vref+, the
   * ADC reference voltage generator must be enabled and configured.
   * 
   * @param veRefPlus TRUE for VeRef+, FALSE for Vref+. 
   */
  command void useVeRefPlusVoltageSource(bool veRefPlus);
  
  /**
   * Set the reference input and full-scale output voltage range. Options
   * are TRUE to set the full-scale output voltage to 1x the input
   * reference voltage. FALSE to set the full-scale output voltage to 3x the
   * input reference voltage.
   * 
   * @param oneTimesRefVoltage TRUE for 1x Reference Voltage, FALSE for 3x.
   */
  command void use1xInputRange(bool oneTimesRefVoltage);
  
  /**
   * DAC12 Amplifier setting. These bits select settling time vs. current
   * consumption for the DAC12 input and output amplifiers.
   * 
   *    DAC12AMPx   | Input Buffer         | Output Buffer
   *  ______________|______________________|_______________________________
   *       0        | Off                  | DAC12 off, output high Z
   *       1        | Off                  | DAC12 off, output 0V
   *       2        | Low speed/current    | Low speed/current
   *       3        | Low speed/current    | Medium speed/current
   *       4        | Low speed/current    | High speed/current
   *       5        | Medium speed/current | Medium speed/current
   *       6        | Medium speed/current | High speed/current
   *       7        | High speed/current   | High speed/current
   *
   * Any setting > 0 automatically selects the DAC12 pin, regardless of the 
   * associated P6SELx and P6DIRx bits.
   *
   * The reference input and voltage output buffers of the DAC12 can be 
   * configured for optimized settling time vs. power consumption. In the
   * low/low setting, the settling time is the slowest and the current
   * connsumption of both buffers is the lowest.  The medium and high settings 
   * have faster settling times, but the current consumption increases.
   * 
   * @param dac12Amp The DAC12AMPx register setting.
   */
  command void setDac12Amp(uint8_t dac12Amp);
  
  /** 
   * DAC12 Load Select. Selects the load trigger for the DAC12 latch.
   * DAC12ENC must be set for the DAC to update, except when DAC12LSELx = 0.
   *   0 = DAC12 latch loads when DAC12_xDAT written (DAC12ENC is ignored)
   *   1 = DAC12 latch loads when DAC12_xDAT written, or, when grouped,
   *       when all DAC12_xDAT registers in the group have been written.
   *   2 = Rising edge of Timer_A.OUT1 (TA1)
   *   3 = Rising edge of Timer_B.OUT2 (TB2)
   * 
   * @param load Defines the point at which data gets loaded into the DAC.
   */
  command void selectLoad(uint8_t load);
  
  /**
   * Sets the data format.
   * @param twosComplement TRUE for 2's complement, FALSE for straight binary
   */
  command void useTwosComplimentDataFormat(bool twosCompliment);
  
  /**
   * @param on TRUE to activate DAC12 interrupts, FALSE to deactivate
   */
  command void enableInterrupt(bool on);
  
  /** 
   * Group this DAC12_x with the next higher DAC12_x
   * @param grouped TRUE to group two DAC12's together so they update simultaneously
   */
  command void group(bool grouped);
  
  /**
   * Calibrates the DAC. This must be run at least once when the DAC turns on.
   * The DAC12AMPx should be configured before calibration. For best calibration
   * results, port and CPU activity should be minimized during calibration.
   */
  command void calibrate();
  
  /**
   * This enables the DAC12 module when the load select > 0. When the load 
   * select == 0, enableConversion() is ignored.
   * @param active TRUE when the DAC12 is enabled. FALSE to disable.
   */
  command void enableConversion(bool active);
  
  /**
   * Write data to the DAC
   * @param data The data to convert into a voltage.
   */
  command void write(uint16_t data);
  
}

