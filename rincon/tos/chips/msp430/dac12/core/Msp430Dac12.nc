
interface Msp430Dac12 {
  
  command void write(uint16_t data);
  
  command void recalibrate();
  
  command void group(bool grouped);
  
}
