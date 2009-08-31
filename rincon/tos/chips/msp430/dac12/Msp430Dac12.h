
/**
 * @author David Moss
 */
 
#ifndef MSP430DAC12_H
#define MSP430DAC12_H


/**
 * DAC12 Control Register
 */
typedef struct {

  /** MSB is reserved */
  unsigned int reserved : 1;
  
  /** Reference Voltage. 0 = Vref+; 1 = Vref+; 2 = VeRef+; 3 = VeRef+ */
  unsigned int dac12srefx : 2;
  
  /** Resolution. 0 = 12-bit resolution; 1 = 8-bit resolution */
  unsigned int dac12res : 1;
  
  /** 
   * DAC12 Load Select. Selects the load trigger for the DAC12 latch.
   * DAC12ENC must be set for the DAC to update, except when DAC12LSELx = 0.
   *   0 = DAC12 latch loads when DAC12_xDAT written (DAC12ENC is ignored)
   *   1 = DAC12 latch loads when DAC12_xDAT written, or, when grouped,
   *       when all DAC12_xDAT registers in the group have been written.
   *   2 = Rising edge of Timer_A.OUT1 (TA1)
   *   3 = Rising edge of Timer_B.OUT2 (TB2)
   */
  unsigned int dac12lselx : 2;
  
  /** Calibration. This bit initiates calibration and is automatically reset */
  unsigned int dac12calon : 1;
  
  /** 
   * Input Range. This bit sets the reference input and voltage output range.
   *   0 = DAC12 full-scale output = 3x reference voltage.
   *   1 = DAC12 full-scale output = 1x reference voltage.
   */
  unsigned int dac12ir : 1;
  
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
   */
  unsigned int dac12ampx : 3;
  
  /** Data Format. 0 = Straight binary; 1 = 2's compliment */
  unsigned int dac12df : 1;
  
  /** Interrupt Enable. 0 = Disabled; 1 = Enabled */
  unsigned int dac12ie : 1;
  
  /** Interrupt Flag */
  unsigned int dac12ifg : 1;
  
  /** 
   * DAC12 Enable Conversion. This bit enables the DAC12 module when 
   * DAC12LSELx > 0. When DAC12LSELx = 0, DAC12ENC is ignored.
   *   0 = DAC12 disabled
   *   1 = DAC12 enabled
   */
  unsigned int dac12enc : 1;
  
  /** Groups DAC12_x with the next higher DAC12_x. 0 = Not Grouped; 1 = Grouped */
  unsigned int dac12grp : 1;
  
} msp430_dac12_control_t;


/**
 * Reference voltage source settings
 */
enum dac12sref_enum {
  DAC12SREF_VREF = 0,
  DAC12SREF_VEREF = 3,
};

/**
 * Data resolution settings
 */
enum dac12res_enum {
  DAC12RES_12BIT = 0,
  DAC12RES_8BIT = 1,
};

/**
 * Load select settings
 */
enum dac12lsel_enum {
  DAC12LSEL_DATA_WRITTEN_ALWAYS = 0,
  DAC12LSEL_DATA_WRITTEN_WHEN_ENABLED = 1,
  DAC12LSEL_RISINGEDGE_TIMERA1 = 2,
  DAC12LSEL_RISINGEDGE_TIMERB2 = 3,
};

/**
 * Input Range settings
 */
enum dac12ir_enum {
  DAC12IR_3X_VOLTREF = 0,
  DAC12IR_1X_VOLTREF = 1,
};

enum dac12amp_enum {
  DAC12AMP_INPUTOFF_OUTPUTHIGHZ = 0,
  DAC12AMP_INPUTOFF_OUTPUT0V = 1,
  DAC12AMP_INPUTLOW_OUTPUTLOW = 2,
  DAC12AMP_INPUTLOW_OUTPUTMED = 3,
  DAC12AMP_INPUTLOW_OUTPUTHIGH = 4,
  DAC12AMP_INPUTMED_OUTPUTMED = 5,
  DAC12AMP_INPUTMED_OUTPUTHIGH = 6,
  DAC12AMP_INPUTHIGH_OUTPUTHIGH = 7,
};

enum dac12df_enum {
  DAC12_DATAFORMAT_BINARY = 0,
  DAC12_DATAFORMAT_TWOSCOMPLIMENT = 1,
};

enum dac12ie_enum {
  DAC12_INTERRUPTS_DISABLED = 0,
  DAC12_INTERRUPTS_ENABLED = 1,
};

enum dac12enc_enum {
  DAC12_DISABLED = 0,
  DAC12_ENABLED = 1,
};

enum dac12grp_enum {
  DAC12_NOT_GROUPED = 0,
  DAC12_GROUPED = 1,
};



/**
 * DAC12 Control Bit Locations
 */
enum dac12_ctl_bits {
  DAC12_DAC12SREF = 14,  // Reference Voltage (LSB = Don't Care)
  DAC12_DAC12RES = 12,   // Resolution
  DAC12_DAC12LSEL = 10,  // Load Select
  DAC12_DAC12CALON = 9,  // Calibration On. Automatically resets.
  DAC12_DAC12IR = 8,     // Input Range (1x or 3x reference voltage)
  DAC12_DAC12AMP = 5,    // Amplifier Setting
  DAC12_DAC12DF = 4,     // Data Format
  DAC12_DAC12IE = 3,     // Interrupt Enable
  DAC12_DAC12IFG = 2,    // Interrupt Flag
  DAC12_DAC12ENC = 1,    // Enable Conversion
  DAC12_DAC12GRP = 0,    // Group with the next higher DAC12_x
};


#endif
