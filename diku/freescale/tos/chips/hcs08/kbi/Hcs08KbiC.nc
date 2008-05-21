module Hcs08KbiC
{
  provides interface StdControl;
  provides interface Hcs08Kbi;
}
implementation
{
  command error_t StdControl.start()
  {
    KBISC_KBIE = 1;
    PTAPE = 0xFF;
    return SUCCESS;
  }
  
  command error_t StdControl.stop()
  {
    KBISC_KBIE = 0;
    return SUCCESS;
  }
  
  TOSH_SIGNAL(KEYBOARD)
  {
  	signal Hcs08Kbi.fired(PTAD);
    KBISC_KBACK = 1; // Keyboard Interrupt Acknowledge
  }
  
  async command bool Hcs08Kbi.pin0Fired(uint8_t data) { return !(data & 0x01); }
  async command bool Hcs08Kbi.pin1Fired(uint8_t data) { return !(data & 0x02); }
  async command bool Hcs08Kbi.pin2Fired(uint8_t data) { return !(data & 0x04); }
  async command bool Hcs08Kbi.pin3Fired(uint8_t data) { return !(data & 0x08); }
  async command bool Hcs08Kbi.pin4Fired(uint8_t data) { return !(((data & 0x10) >> 4)^KBISC_KBEDG4); }
  async command bool Hcs08Kbi.pin5Fired(uint8_t data) { return !(((data & 0x20) >> 4)^KBISC_KBEDG5); }
  async command bool Hcs08Kbi.pin6Fired(uint8_t data) { return !(((data & 0x40) >> 4)^KBISC_KBEDG6); }
  async command bool Hcs08Kbi.pin7Fired(uint8_t data) { return !(((data & 0x80) >> 4)^KBISC_KBEDG7); }
  async command void Hcs08Kbi.setEdge() {KBISC_KBIMOD = 0;}
  async command void Hcs08Kbi.setEdgeLevel() {KBISC_KBIMOD = 1;}
  async command void Hcs08Kbi.setKbiPin4Low() {KBISC_KBEDG4 = 0;}
  async command void Hcs08Kbi.setKbiPin4High() {KBISC_KBEDG4 = 1;}
  async command void Hcs08Kbi.setKbiPin5Low() {KBISC_KBEDG5 = 0;}
  async command void Hcs08Kbi.setKbiPin5High() {KBISC_KBEDG5 = 1;}
  async command void Hcs08Kbi.setKbiPin6Low() {KBISC_KBEDG6 = 0;}
  async command void Hcs08Kbi.setKbiPin6High() {KBISC_KBEDG6 = 1;}
  async command void Hcs08Kbi.setKbiPin7Low() {KBISC_KBEDG7 = 0;}
  async command void Hcs08Kbi.setKbiPin7High() {KBISC_KBEDG7 = 1;}
  async command void Hcs08Kbi.enableKbiPin0() {KBIPE_KBIPE0 = 1;}
  async command void Hcs08Kbi.enableKbiPin1() {KBIPE_KBIPE1 = 1;}
  async command void Hcs08Kbi.enableKbiPin2() {KBIPE_KBIPE2 = 1;}
  async command void Hcs08Kbi.enableKbiPin3() {KBIPE_KBIPE3 = 1;}
  async command void Hcs08Kbi.enableKbiPin4() {KBIPE_KBIPE4 = 1;}
  async command void Hcs08Kbi.enableKbiPin5() {KBIPE_KBIPE5 = 1;}
  async command void Hcs08Kbi.enableKbiPin6() {KBIPE_KBIPE6 = 1;}
  async command void Hcs08Kbi.enableKbiPin7() {KBIPE_KBIPE7 = 1;}
  async command void Hcs08Kbi.disableKbiPin0() {KBIPE_KBIPE0 = 0;}
  async command void Hcs08Kbi.disableKbiPin1() {KBIPE_KBIPE1 = 0;}
  async command void Hcs08Kbi.disableKbiPin2() {KBIPE_KBIPE2 = 0;}
  async command void Hcs08Kbi.disableKbiPin3() {KBIPE_KBIPE3 = 0;}
  async command void Hcs08Kbi.disableKbiPin4() {KBIPE_KBIPE4 = 0;}
  async command void Hcs08Kbi.disableKbiPin5() {KBIPE_KBIPE5 = 0;}
  async command void Hcs08Kbi.disableKbiPin6() {KBIPE_KBIPE6 = 0;}
  async command void Hcs08Kbi.disableKbiPin7() {KBIPE_KBIPE7 = 0;}

}