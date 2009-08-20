

/**
 * CC2500 PARTNUM = 0x80 (version 0x3)
 * CC1100 PARTNUM = 0x0 (version 0x3)
 * CC1101 PARTNUM = 0x0 (version 0x4)
 */
interface AvailableRadios {
  
  command bool isCc1100(uint8_t radioId);
  
  command bool isCc1101(uint8_t radioId);
  
  command bool isCc2500(uint8_t radioId);
  
}

 