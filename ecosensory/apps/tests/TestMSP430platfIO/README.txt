TestNewPlatformIO  helps use GPIO pins to verify platform
port.pin assignments from processor to sensorboard names.

  myPin0 -> HplMsp430GeneralIOC.ADC0;  // = Port60
  myPin1 -> HplMsp430GeneralIOC.ADC1;  // = Port61
  Pin2G  -> HplMsp430GeneralIOC.ADC2;  // = Port62
  Pin3G  -> HplMsp430GeneralIOC.ADC3;  // = Port63
  Pin4G  -> HplMsp430GeneralIOC.ADC4;  // = Port64
  Pin5G  -> HplMsp430GeneralIOC.ADC5;  // = Port65
  Pin6G  -> HplMsp430GeneralIOC.ADC6;  // = Port66
  Pin7G  -> HplMsp430GeneralIOC.Port17; // = Port17  aka HUM_PWR on telosb

  myPin0 -> HplMsp430GeneralIOC.Port20; // = GIO0
  myPin1 -> HplMsp430GeneralIOC.ADC6;   // = Port66
  Pin2G  -> HplMsp430GeneralIOC.Port21; // = GIO1
  Pin3G  -> HplMsp430GeneralIOC.ADC7;  // = Port67
  Pin4G  -> HplMsp430GeneralIOC.Port23;  // = GIO2
  Pin5G  -> HplMsp430GeneralIOC.Port26;  // = GIO3
  Pin6G  -> HplMsp430GeneralIOC.ADC5;  // = Port65
  Pin7G  -> HplMsp430GeneralIOC.SVSOUT;  // = Port57


All these test good! 10aug07  JG
