
#include "TestCase.h"
#include "CC2500.h"

/**
 * TWO REGISTERS DO NOT MATCH WITH THE DATASHEET:
 *  MDMCFG0: Default value is 0x0 (datasheet says 0xF8)
 *  FREND1: Default value is 0x56 (datasheet says 0xA6)
 *
 * @author David Moss
 */
module TestSpiP {
  uses {
    interface TestControl as SetUpOneTime;
    interface BlazeStrobe as SRES;
    interface GeneralIO as CSN;
    interface Resource;
    interface Leds;
    interface SplitControl;
    
    /***************** Register Interfaces ****************/
    interface BlazeRegister as IOCFG2;
    interface BlazeRegister as IOCFG1;
    interface BlazeRegister as IOCFG0;
    interface BlazeRegister as FIFOTHR;
    interface BlazeRegister as SYNC1;
    interface BlazeRegister as SYNC0;
    interface BlazeRegister as PKTLEN;
    interface BlazeRegister as PKTCTRL1;
    interface BlazeRegister as PKTCTRL0;
    interface BlazeRegister as ADDR;
    interface BlazeRegister as CHANNR;
    interface BlazeRegister as FSCTRL1;
    interface BlazeRegister as FSCTRL0;
    interface BlazeRegister as FREQ2;
    interface BlazeRegister as FREQ1;
    interface BlazeRegister as FREQ0;
    interface BlazeRegister as MDMCFG4;
    interface BlazeRegister as MDMCFG3;
    interface BlazeRegister as MDMCFG2;
    interface BlazeRegister as MDMCFG1;
    interface BlazeRegister as MDMCFG0;
    interface BlazeRegister as DEVIATN;
    interface BlazeRegister as MCSM2;
    interface BlazeRegister as MCSM1;
    interface BlazeRegister as MCSM0;
    interface BlazeRegister as FOCCFG;
    interface BlazeRegister as BSCFG;
    interface BlazeRegister as AGCTRL2;
    interface BlazeRegister as AGCTRL1;
    interface BlazeRegister as AGCTRL0;
    interface BlazeRegister as WOREVT1;
    interface BlazeRegister as WOREVT0;
    interface BlazeRegister as WORCTRL;
    interface BlazeRegister as FREND1;
    interface BlazeRegister as FREND0;
    interface BlazeRegister as FSCAL3;
    interface BlazeRegister as FSCAL2;
    interface BlazeRegister as FSCAL1;
    interface BlazeRegister as FSCAL0;
    interface BlazeRegister as RCCTRL1;
    interface BlazeRegister as RCCTRL0;
    interface BlazeRegister as FSTEST;
    interface BlazeRegister as PTEST;
    interface BlazeRegister as AGCTEST;
    interface BlazeRegister as TEST2;
    interface BlazeRegister as TEST1;
    interface BlazeRegister as TEST0;
    interface BlazeRegister as PARTNUM;
    interface BlazeRegister as VERSION;
    interface BlazeRegister as FREQEST;
    interface BlazeRegister as LQI;
    interface BlazeRegister as RSSI;
    interface BlazeRegister as MARCSTATE;
    interface BlazeRegister as WORTIME1;
    interface BlazeRegister as WORTIME0;
    interface BlazeRegister as PKTSTATUS;
    interface BlazeRegister as VCO_VC_DAC;
    interface BlazeRegister as TXBYTES;
    interface BlazeRegister as RXBYTES;
    
    /***************** Test Interfaces ****************/
    interface TestCase as IOCFG2_Test;
    interface TestCase as IOCFG1_Test;
    interface TestCase as IOCFG0_Test;
    interface TestCase as FIFOTHR_Test;
    interface TestCase as SYNC1_Test;
    interface TestCase as SYNC0_Test;
    interface TestCase as PKTLEN_Test;
    interface TestCase as PKTCTRL1_Test;
    interface TestCase as PKTCTRL0_Test;
    interface TestCase as ADDR_Test;
    interface TestCase as CHANNR_Test;
    interface TestCase as FSCTRL1_Test;
    interface TestCase as FSCTRL0_Test;
    interface TestCase as FREQ2_Test;
    interface TestCase as FREQ1_Test;
    interface TestCase as FREQ0_Test;
    interface TestCase as MDMCFG4_Test;
    interface TestCase as MDMCFG3_Test;
    interface TestCase as MDMCFG2_Test;
    interface TestCase as MDMCFG1_Test;
    interface TestCase as MDMCFG0_Test;
    interface TestCase as DEVIATN_Test;
    interface TestCase as MCSM2_Test;
    interface TestCase as MCSM1_Test;
    interface TestCase as MCSM0_Test;
    interface TestCase as FOCCFG_Test;
    interface TestCase as BSCFG_Test;
    interface TestCase as AGCTRL2_Test;
    interface TestCase as AGCTRL1_Test;
    interface TestCase as AGCTRL0_Test;
    interface TestCase as WOREVT1_Test;
    interface TestCase as WOREVT0_Test;
    interface TestCase as WORCTRL_Test;
    interface TestCase as FREND1_Test;
    interface TestCase as FREND0_Test;
    interface TestCase as FSCAL3_Test;
    interface TestCase as FSCAL2_Test;
    interface TestCase as FSCAL1_Test;
    interface TestCase as FSCAL0_Test;
    interface TestCase as RCCTRL1_Test;
    interface TestCase as RCCTRL0_Test;
    interface TestCase as FSTEST_Test;
    interface TestCase as PTEST_Test;
    interface TestCase as AGCTEST_Test;
    interface TestCase as TEST2_Test;
    interface TestCase as TEST1_Test;
    interface TestCase as TEST0_Test;
    interface TestCase as PARTNUM_Test;
    interface TestCase as VERSION_Test;
    interface TestCase as FREQEST_Test;
    interface TestCase as LQI_Test;
    interface TestCase as RSSI_Test;
    interface TestCase as MARCSTATE_Test;
    interface TestCase as WORTIME1_Test;
    interface TestCase as WORTIME0_Test;
    interface TestCase as PKTSTATUS_Test;
    interface TestCase as VCO_VC_DAC_Test;
    interface TestCase as TXBYTES_Test;
    interface TestCase as RXBYTES_Test;
  }
}

implementation {

  uint8_t readBuffer;
  
  event void SetUpOneTime.run() {
    call CSN.set();
    call Resource.request();
  }
  
  event void Resource.granted() {
    // Dance the CSN pin and Reset
    call CSN.clr();
    call CSN.set();
    call CSN.set();
    call CSN.clr();
    call CSN.clr();
    //call SRES.strobe();
    call CSN.set();
    
    // Keep the resource and keep the CSN pin low so we can access registers
    call CSN.clr();
    call SplitControl.start();
  }
  
  event void SplitControl.startDone(error_t error) {
    call CSN.set();
    call CSN.clr();
    call SetUpOneTime.done();
  }
  
  event void SplitControl.stopDone(error_t error) {
  }
  
  
  /***************** TestCases ****************/
  event void IOCFG2_Test.run() {
    call IOCFG2.read(&readBuffer);
    assertEquals("Wrong value", CC2500_CONFIG_IOCFG2, readBuffer);
    call IOCFG2_Test.done();
  }
  
  event void IOCFG1_Test.run() {
    call IOCFG1.read(&readBuffer);
    assertEquals("Wrong value", CC2500_CONFIG_IOCFG1, readBuffer);
    call IOCFG1_Test.done();
  }
  
  event void IOCFG0_Test.run() {
    call IOCFG0.read(&readBuffer);
    assertEquals("Wrong value", CC2500_CONFIG_IOCFG0, readBuffer);
    call IOCFG0_Test.done();
  }
  
  event void FIFOTHR_Test.run() {
    call FIFOTHR.read(&readBuffer);
    assertEquals("Wrong value", CC2500_CONFIG_FIFOTHR, readBuffer);
    call FIFOTHR_Test.done();
  }
  
  event void SYNC1_Test.run() {
    call SYNC1.read(&readBuffer);
    assertEquals("Wrong value", CC2500_CONFIG_SYNC1, readBuffer);
    call SYNC1_Test.done();
  }
  
  event void SYNC0_Test.run() {
    call SYNC0.read(&readBuffer);
    assertEquals("Wrong value", CC2500_CONFIG_SYNC0, readBuffer);
    call SYNC0_Test.done();
  }
  
  event void PKTLEN_Test.run() {
    call PKTLEN.read(&readBuffer);
    assertEquals("Wrong value", CC2500_CONFIG_PKTLEN, readBuffer);
    call PKTLEN_Test.done();
  }
  
  event void PKTCTRL1_Test.run() {
    call PKTCTRL1.read(&readBuffer);
    assertEquals("Wrong value", CC2500_CONFIG_PKTCTRL1, readBuffer);
    call PKTCTRL1_Test.done();
  }
  
  event void PKTCTRL0_Test.run() {
    call PKTCTRL0.read(&readBuffer);
    // Top bit reserved
    assertEquals("Wrong value", CC2500_CONFIG_PKTCTRL0, (readBuffer & 0x7F));
    call PKTCTRL0_Test.done();
  }
  
  event void ADDR_Test.run() {
    call ADDR.read(&readBuffer);
    assertEquals("Wrong value", CC2500_CONFIG_ADDR, readBuffer);
    call ADDR_Test.done();
  }
  
  event void CHANNR_Test.run() {
    call CHANNR.read(&readBuffer);
    assertEquals("Wrong value", CC2500_CONFIG_CHANNR, readBuffer);
    call CHANNR_Test.done();
  }
  
  event void FSCTRL1_Test.run() {
    call FSCTRL1.read(&readBuffer);
    // Top three bits reserved
    assertEquals("Wrong value", CC2500_CONFIG_FSCTRL1, (readBuffer & 0x1F));
    call FSCTRL1_Test.done();
  }
  
  event void FSCTRL0_Test.run() {
    call FSCTRL0.read(&readBuffer);
    assertEquals("Wrong value", CC2500_CONFIG_FSCTRL0, readBuffer);
    call FSCTRL0_Test.done();
  }
  
  event void FREQ2_Test.run() {
    call FREQ2.read(&readBuffer);
    assertEquals("Wrong value", (CC2500_CONFIG_FREQ2 | 0x40), readBuffer);
    call FREQ2_Test.done();
  }
  
  event void FREQ1_Test.run() {
    call FREQ1.read(&readBuffer);
    assertEquals("Wrong value", CC2500_CONFIG_FREQ1, readBuffer);
    call FREQ1_Test.done();
  }
  
  event void FREQ0_Test.run() {
    call FREQ0.read(&readBuffer);
    assertEquals("Wrong value", CC2500_CONFIG_FREQ0, readBuffer);
    call FREQ0_Test.done();
  }
  
  event void MDMCFG4_Test.run() {
    call MDMCFG4.read(&readBuffer);
    assertEquals("Wrong value", CC2500_CONFIG_MDMCFG4, readBuffer);
    call MDMCFG4_Test.done();
  }
  
  event void MDMCFG3_Test.run() {
    call MDMCFG3.read(&readBuffer);
    assertEquals("Wrong value", CC2500_CONFIG_MDMCFG3, readBuffer);
    call MDMCFG3_Test.done();
  }
  
  event void MDMCFG2_Test.run() {
    call MDMCFG2.read(&readBuffer);
    assertEquals("Wrong value", CC2500_CONFIG_MDMCFG2, readBuffer);
    call MDMCFG2_Test.done();
  }
  
  event void MDMCFG1_Test.run() {
    call MDMCFG1.read(&readBuffer);
    // 3:2 reserved
    assertEquals("Wrong value", CC2500_CONFIG_MDMCFG1, (readBuffer & 0xF3));
    call MDMCFG1_Test.done();
  }
  
  event void MDMCFG0_Test.run() {
    call MDMCFG0.read(&readBuffer);
    // WARNING: DATASHEET SAYS VALUE SHOULD BE 0xF8, BUT HARDWARE SHOWS 0x0
    // assertEquals("Wrong value", 0xF8, readBuffer);
    assertEquals("Wrong value", CC2500_CONFIG_MDMCFG0, readBuffer);
    call MDMCFG0_Test.done();
  }
  
  event void DEVIATN_Test.run() {
    call DEVIATN.read(&readBuffer);
    // Bits 7, 3 reserved
    assertEquals("Wrong value", CC2500_CONFIG_DEVIATN, (readBuffer & 0x77));
    call DEVIATN_Test.done();
  }
  
  event void MCSM2_Test.run() {
    call MCSM2.read(&readBuffer);
    // 7:5 reserved
    assertEquals("Wrong value", CC2500_CONFIG_MCSM2, (readBuffer & 0x1F));
    call MCSM2_Test.done();
  }
  
  event void MCSM1_Test.run() {
    call MCSM1.read(&readBuffer);
    // 7:6 reserved
    assertEquals("Wrong value", CC2500_CONFIG_MCSM1, (readBuffer & 0x3F));
    call MCSM1_Test.done();
  }
  
  event void MCSM0_Test.run() {
    call MCSM0.read(&readBuffer);
    // 7:6 reserved
    assertEquals("Wrong value", CC2500_CONFIG_MCSM0, (readBuffer & 0x3F));
    call MCSM0_Test.done();
  }
  
  event void FOCCFG_Test.run() {
    call FOCCFG.read(&readBuffer);
    // 7:6 reserved
    assertEquals("Wrong value", CC2500_CONFIG_FOCCFG, (readBuffer & 0x3F));
    call FOCCFG_Test.done();
  }
  
  event void BSCFG_Test.run() {
    call BSCFG.read(&readBuffer);
    assertEquals("Wrong value", CC2500_CONFIG_BSCFG, readBuffer);
    call BSCFG_Test.done();
  }
  
  event void AGCTRL2_Test.run() {
    call AGCTRL2.read(&readBuffer);
    assertEquals("Wrong value", CC2500_CONFIG_AGCTRL2, readBuffer);
    call AGCTRL2_Test.done();
  }
  
  event void AGCTRL1_Test.run() {
    call AGCTRL1.read(&readBuffer);
    assertEquals("Wrong value", CC2500_CONFIG_AGCTRL1, (readBuffer & 0x7F));
    call AGCTRL1_Test.done();
  }
  
  event void AGCTRL0_Test.run() {
    call AGCTRL0.read(&readBuffer);
    assertEquals("Wrong value", CC2500_CONFIG_AGCTRL0, readBuffer);
    call AGCTRL0_Test.done();
  }
  
  event void WOREVT1_Test.run() {
    call WOREVT1.read(&readBuffer);
    assertEquals("Wrong value", CC2500_CONFIG_WOREVT1, readBuffer);
    call WOREVT1_Test.done();
  }
  
  event void WOREVT0_Test.run() {
    call WOREVT0.read(&readBuffer);
    assertEquals("Wrong value", CC2500_CONFIG_WOREVT0, readBuffer);
    call WOREVT0_Test.done();
  }
  
  event void WORCTRL_Test.run() {
    call WORCTRL.read(&readBuffer);
    // Bit 2 reserved
    assertEquals("Wrong value", CC2500_CONFIG_WORCTRL, (readBuffer & 0xFB));
    call WORCTRL_Test.done();
  }
  
  event void FREND1_Test.run() {
    call FREND1.read(&readBuffer);
    // WARNING: DATASHEET SAYS VALUE SHOULD BE 0xA6, BUT HARDWARE SHOWS 0x56
    // assertEquals("Wrong value", 0xA6, readBuffer);
    assertEquals("Wrong value", CC2500_CONFIG_FREND1, readBuffer);
    call FREND1_Test.done();
  }
  
  event void FREND0_Test.run() {
    call FREND0.read(&readBuffer);
    // 7:6, 3 reserved
    assertEquals("Wrong value", CC2500_CONFIG_FREND0, (readBuffer & 0x37));
    call FREND0_Test.done();
  }
  
  event void FSCAL3_Test.run() {
    call FSCAL3.read(&readBuffer);
    assertEquals("Wrong value", CC2500_CONFIG_FSCAL3, readBuffer);
    call FSCAL3_Test.done();
  }
  
  event void FSCAL2_Test.run() {
    call FSCAL2.read(&readBuffer);
    // 7:6 reserved
    assertEquals("Wrong value", CC2500_CONFIG_FSCAL2, (readBuffer & 0x3F));
    call FSCAL2_Test.done();
  }
  
  event void FSCAL1_Test.run() {
    call FSCAL1.read(&readBuffer);
    // 7:6 reserved
    assertEquals("Wrong value", CC2500_CONFIG_FSCAL1, (readBuffer & 0x3F));
    call FSCAL1_Test.done();
  }
  
  event void FSCAL0_Test.run() {
    call FSCAL0.read(&readBuffer);
    // Bit 7 reserved
    assertEquals("Wrong value", CC2500_CONFIG_FSCAL0, (readBuffer & 0x7F));
    call FSCAL0_Test.done();
  }
  
  // NOT USED?
  event void RCCTRL1_Test.run() {
    call RCCTRL1.read(&readBuffer);
    // Bit 7 reserved
    assertSuccess();
    //assertEquals("Wrong value", CC2500_CONFIG_RCCTRL1, (readBuffer & 0x7F));
    call RCCTRL1_Test.done();
  }
  
  // NOT USED?
  event void RCCTRL0_Test.run() {
    call RCCTRL0.read(&readBuffer);
    // Bit 7 reserved
    assertSuccess();
    //assertEquals("Wrong value", CC2500_CONFIG_RCCTRL0, (readBuffer & 0x7F));
    call RCCTRL0_Test.done();
  }
  
  event void FSTEST_Test.run() {
    call FSTEST.read(&readBuffer);
    assertSuccess();
    call FSTEST_Test.done();
  }
  
  // NOT USED?
  event void PTEST_Test.run() {
    call PTEST.read(&readBuffer);
    assertEquals("Wrong value", 0x7F, readBuffer);
    call PTEST_Test.done();
  }
  
  // NOT USED?
  event void AGCTEST_Test.run() {
    call AGCTEST.read(&readBuffer);
    assertEquals("Wrong value", 0x3F, readBuffer);
    call AGCTEST_Test.done();
  }
  
  event void TEST2_Test.run() {
    call TEST2.read(&readBuffer);
    assertEquals("Wrong value", 0x88, readBuffer);
    call TEST2_Test.done();
  }
  
  event void TEST1_Test.run() {
    call TEST1.read(&readBuffer);
    assertEquals("Wrong value", 0x31, readBuffer);
    call TEST1_Test.done();
  }
  
  event void TEST0_Test.run() {
    call TEST0.read(&readBuffer);
    assertEquals("Wrong value", 0x0B, readBuffer);
    call TEST0_Test.done();
  }
  
  event void PARTNUM_Test.run() {
    call PARTNUM.read(&readBuffer);
    assertEquals("Wrong value", 0x80, readBuffer);
    call PARTNUM_Test.done();
  }
  
  event void VERSION_Test.run() {
    call VERSION.read(&readBuffer);
    assertEquals("Wrong value", 0x03, readBuffer);
    call VERSION_Test.done();
  }
  
  event void FREQEST_Test.run() {
    call FREQEST.read(&readBuffer);
    // No default value given
    assertSuccess();
    call FREQEST_Test.done();
  }
  
  event void LQI_Test.run() {
    call LQI.read(&readBuffer);
    // No default value given
    assertSuccess();
    call LQI_Test.done();
  }
  
  event void RSSI_Test.run() {
    call RSSI.read(&readBuffer);
    // No default value given
    assertSuccess();
    call RSSI_Test.done();
  }
  
  event void MARCSTATE_Test.run() {
    call MARCSTATE.read(&readBuffer);
    // No default value given
    assertSuccess();
    call MARCSTATE_Test.done();
  }
  
  event void WORTIME1_Test.run() {
    call WORTIME1.read(&readBuffer);
    // No default value given
    assertSuccess();
    call WORTIME1_Test.done();
  }
  
  event void WORTIME0_Test.run() {
    call WORTIME0.read(&readBuffer);
    // No default value given
    assertSuccess();
    call WORTIME0_Test.done();
  }
  
  event void PKTSTATUS_Test.run() {
    call PKTSTATUS.read(&readBuffer);
    // No default value given
    assertSuccess();
    call PKTSTATUS_Test.done();
  }
  
  event void VCO_VC_DAC_Test.run() {
    call VCO_VC_DAC.read(&readBuffer);
    // No default value given
    assertSuccess();
    call VCO_VC_DAC_Test.done();
  }
  
  event void TXBYTES_Test.run() {
    call TXBYTES.read(&readBuffer);
    // No default value given
    assertSuccess();
    call TXBYTES_Test.done();
  }
  
  event void RXBYTES_Test.run() {
    call RXBYTES.read(&readBuffer);
    // No default value given
    assertSuccess();
    call RXBYTES_Test.done();
  }
  
  
}


