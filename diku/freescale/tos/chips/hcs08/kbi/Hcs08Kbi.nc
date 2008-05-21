interface Hcs08Kbi
{
  async command bool pin0Fired(uint8_t data);
  async command bool pin1Fired(uint8_t data);
  async command bool pin2Fired(uint8_t data);
  async command bool pin3Fired(uint8_t data);
  async command bool pin4Fired(uint8_t data);
  async command bool pin5Fired(uint8_t data);
  async command bool pin6Fired(uint8_t data);
  async command bool pin7Fired(uint8_t data);
  async command void setEdge();
  async command void setEdgeLevel();
  async command void setKbiPin4Low();
  async command void setKbiPin4High();
  async command void setKbiPin5Low();
  async command void setKbiPin5High();
  async command void setKbiPin6Low();
  async command void setKbiPin6High();
  async command void setKbiPin7Low();
  async command void setKbiPin7High();
  async command void enableKbiPin0();
  async command void enableKbiPin1();
  async command void enableKbiPin2();
  async command void enableKbiPin3();
  async command void enableKbiPin4();
  async command void enableKbiPin5();
  async command void enableKbiPin6();
  async command void enableKbiPin7();
  async command void disableKbiPin0();
  async command void disableKbiPin1();
  async command void disableKbiPin2();
  async command void disableKbiPin3();
  async command void disableKbiPin4();
  async command void disableKbiPin5();
  async command void disableKbiPin6();
  async command void disableKbiPin7();
  async event void fired(uint8_t);
  
}