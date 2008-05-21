/*
 * 
 * @author Marcus Chang
 *
 */

generic configuration PinC() {
  provides interface GeneralIO;
}

implementation {
    components LoggerC;

    enum { ID = unique("UNIQUE_LOGGING_PIN") + 1 }; // ID = 0 reserved for MCU power mode logging

    GeneralIO = LoggerC.GeneralIO[ID];
}
