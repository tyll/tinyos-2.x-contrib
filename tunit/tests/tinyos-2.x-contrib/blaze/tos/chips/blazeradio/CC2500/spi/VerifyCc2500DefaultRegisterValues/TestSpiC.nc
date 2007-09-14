
#include "TestCase.h"

/** 
 * MISMATCH:
 *  FREND1: Default value is 0x56 (datasheet says 0xA6)
 *
 * @author David Moss
 */
configuration TestSpiC {
}

implementation {

  components 
    new TestCaseC() as IOCFG2_TestC,
    new TestCaseC() as IOCFG1_TestC,
    new TestCaseC() as IOCFG0_TestC,
    new TestCaseC() as FIFOTHR_TestC,
    new TestCaseC() as SYNC1_TestC,
    new TestCaseC() as SYNC0_TestC,
    new TestCaseC() as PKTLEN_TestC,
    new TestCaseC() as PKTCTRL1_TestC,
    new TestCaseC() as PKTCTRL0_TestC,
    new TestCaseC() as ADDR_TestC,
    new TestCaseC() as CHANNR_TestC,
    new TestCaseC() as FSCTRL1_TestC,
    new TestCaseC() as FSCTRL0_TestC,
    new TestCaseC() as FREQ2_TestC,
    new TestCaseC() as FREQ1_TestC,
    new TestCaseC() as FREQ0_TestC,
    new TestCaseC() as MDMCFG4_TestC,
    new TestCaseC() as MDMCFG3_TestC,
    new TestCaseC() as MDMCFG2_TestC,
    new TestCaseC() as MDMCFG1_TestC,
    new TestCaseC() as MDMCFG0_TestC,
    new TestCaseC() as DEVIATN_TestC,
    new TestCaseC() as MCSM2_TestC,
    new TestCaseC() as MCSM1_TestC,
    new TestCaseC() as MCSM0_TestC,
    new TestCaseC() as FOCCFG_TestC,
    new TestCaseC() as BSCFG_TestC,
    new TestCaseC() as AGCTRL2_TestC,
    new TestCaseC() as AGCTRL1_TestC,
    new TestCaseC() as AGCTRL0_TestC,
    new TestCaseC() as WOREVT1_TestC,
    new TestCaseC() as WOREVT0_TestC,
    new TestCaseC() as WORCTRL_TestC,
    new TestCaseC() as FREND1_TestC,
    new TestCaseC() as FREND0_TestC,
    new TestCaseC() as FSCAL3_TestC,
    new TestCaseC() as FSCAL2_TestC,
    new TestCaseC() as FSCAL1_TestC,
    new TestCaseC() as FSCAL0_TestC,
    new TestCaseC() as RCCTRL1_TestC,
    new TestCaseC() as RCCTRL0_TestC,
    new TestCaseC() as FSTEST_TestC,
    new TestCaseC() as PTEST_TestC,
    new TestCaseC() as AGCTEST_TestC,
    new TestCaseC() as TEST2_TestC,
    new TestCaseC() as TEST1_TestC,
    new TestCaseC() as TEST0_TestC,
    new TestCaseC() as PARTNUM_TestC,
    new TestCaseC() as VERSION_TestC,
    new TestCaseC() as FREQEST_TestC,
    new TestCaseC() as LQI_TestC,
    new TestCaseC() as RSSI_TestC,
    new TestCaseC() as MARCSTATE_TestC,
    new TestCaseC() as WORTIME1_TestC,
    new TestCaseC() as WORTIME0_TestC,
    new TestCaseC() as PKTSTATUS_TestC,
    new TestCaseC() as VCO_VC_DAC_TestC,
    new TestCaseC() as TXBYTES_TestC,
    new TestCaseC() as RXBYTES_TestC;


  components TestSpiP,
      new BlazeSpiResourceC(),
      BlazeSpiC,
      HplCC2500PinsC,
      LedsC;
  
  TestSpiP.SetUpOneTime -> IOCFG2_TestC.SetUpOneTime;
  
  TestSpiP.SIDLE -> BlazeSpiC.SIDLE;
  TestSpiP.CSN -> HplCC2500PinsC.Csn;
  TestSpiP.SRES -> BlazeSpiC.SRES;
  TestSpiP.Resource -> BlazeSpiResourceC;
  TestSpiP.Leds -> LedsC;
  
  /***************** Register Connections ****************/
  TestSpiP.IOCFG2 -> BlazeSpiC.IOCFG2;
  TestSpiP.IOCFG1 -> BlazeSpiC.IOCFG1;
  TestSpiP.IOCFG0 -> BlazeSpiC.IOCFG0;
  TestSpiP.FIFOTHR -> BlazeSpiC.FIFOTHR;
  TestSpiP.SYNC1 -> BlazeSpiC.SYNC1;
  TestSpiP.SYNC0 -> BlazeSpiC.SYNC0;
  TestSpiP.PKTLEN -> BlazeSpiC.PKTLEN;
  TestSpiP.PKTCTRL1 -> BlazeSpiC.PKTCTRL1;
  TestSpiP.PKTCTRL0 -> BlazeSpiC.PKTCTRL0;
  TestSpiP.ADDR -> BlazeSpiC.ADDR;
  TestSpiP.CHANNR -> BlazeSpiC.CHANNR;
  TestSpiP.FSCTRL1 -> BlazeSpiC.FSCTRL1;
  TestSpiP.FSCTRL0 -> BlazeSpiC.FSCTRL0;
  TestSpiP.FREQ2 -> BlazeSpiC.FREQ2;
  TestSpiP.FREQ1 -> BlazeSpiC.FREQ1;
  TestSpiP.FREQ0 -> BlazeSpiC.FREQ0;
  TestSpiP.MDMCFG4 -> BlazeSpiC.MDMCFG4;
  TestSpiP.MDMCFG3 -> BlazeSpiC.MDMCFG3;
  TestSpiP.MDMCFG2 -> BlazeSpiC.MDMCFG2;
  TestSpiP.MDMCFG1 -> BlazeSpiC.MDMCFG1;
  TestSpiP.MDMCFG0 -> BlazeSpiC.MDMCFG0;
  TestSpiP.DEVIATN -> BlazeSpiC.DEVIATN;
  TestSpiP.MCSM2 -> BlazeSpiC.MCSM2;
  TestSpiP.MCSM1 -> BlazeSpiC.MCSM1;
  TestSpiP.MCSM0 -> BlazeSpiC.MCSM0;
  TestSpiP.FOCCFG -> BlazeSpiC.FOCCFG;
  TestSpiP.BSCFG -> BlazeSpiC.BSCFG;
  TestSpiP.AGCTRL2 -> BlazeSpiC.AGCTRL2;
  TestSpiP.AGCTRL1 -> BlazeSpiC.AGCTRL1;
  TestSpiP.AGCTRL0 -> BlazeSpiC.AGCTRL0;
  TestSpiP.WOREVT1 -> BlazeSpiC.WOREVT1;
  TestSpiP.WOREVT0 -> BlazeSpiC.WOREVT0;
  TestSpiP.WORCTRL -> BlazeSpiC.WORCTRL;
  TestSpiP.FREND1 -> BlazeSpiC.FREND1;
  TestSpiP.FREND0 -> BlazeSpiC.FREND0;
  TestSpiP.FSCAL3 -> BlazeSpiC.FSCAL3;
  TestSpiP.FSCAL2 -> BlazeSpiC.FSCAL2;
  TestSpiP.FSCAL1 -> BlazeSpiC.FSCAL1;
  TestSpiP.FSCAL0 -> BlazeSpiC.FSCAL0;
  TestSpiP.RCCTRL1 -> BlazeSpiC.RCCTRL1;
  TestSpiP.RCCTRL0 -> BlazeSpiC.RCCTRL0;
  TestSpiP.FSTEST -> BlazeSpiC.FSTEST;
  TestSpiP.PTEST -> BlazeSpiC.PTEST;
  TestSpiP.AGCTEST -> BlazeSpiC.AGCTEST;
  TestSpiP.TEST2 -> BlazeSpiC.TEST2;
  TestSpiP.TEST1 -> BlazeSpiC.TEST1;
  TestSpiP.TEST0 -> BlazeSpiC.TEST0;
  TestSpiP.PARTNUM -> BlazeSpiC.PARTNUM;
  TestSpiP.VERSION -> BlazeSpiC.VERSION;
  TestSpiP.FREQEST -> BlazeSpiC.FREQEST;
  TestSpiP.LQI -> BlazeSpiC.LQI;
  TestSpiP.RSSI -> BlazeSpiC.RSSI;
  TestSpiP.MARCSTATE -> BlazeSpiC.MARCSTATE;
  TestSpiP.WORTIME1 -> BlazeSpiC.WORTIME1;
  TestSpiP.WORTIME0 -> BlazeSpiC.WORTIME0;
  TestSpiP.PKTSTATUS -> BlazeSpiC.PKTSTATUS;
  TestSpiP.VCO_VC_DAC -> BlazeSpiC.VCO_VC_DAC;
  TestSpiP.TXBYTES -> BlazeSpiC.TXBYTES;
  TestSpiP.RXBYTES -> BlazeSpiC.RXBYTES;
  
  
  /***************** Test Connections ***************/
  TestSpiP.IOCFG2_Test -> IOCFG2_TestC;
  TestSpiP.IOCFG2_Test -> IOCFG2_TestC;
  TestSpiP.IOCFG1_Test -> IOCFG1_TestC;
  TestSpiP.IOCFG0_Test -> IOCFG0_TestC;
  TestSpiP.FIFOTHR_Test -> FIFOTHR_TestC;
  TestSpiP.SYNC1_Test -> SYNC1_TestC;
  TestSpiP.SYNC0_Test -> SYNC0_TestC;
  TestSpiP.PKTLEN_Test -> PKTLEN_TestC;
  TestSpiP.PKTCTRL1_Test -> PKTCTRL1_TestC;
  TestSpiP.PKTCTRL0_Test -> PKTCTRL0_TestC;
  TestSpiP.ADDR_Test -> ADDR_TestC;
  TestSpiP.CHANNR_Test -> CHANNR_TestC;
  TestSpiP.FSCTRL1_Test -> FSCTRL1_TestC;
  TestSpiP.FSCTRL0_Test -> FSCTRL0_TestC;
  TestSpiP.FREQ2_Test -> FREQ2_TestC;
  TestSpiP.FREQ1_Test -> FREQ1_TestC;
  TestSpiP.FREQ0_Test -> FREQ0_TestC;
  TestSpiP.MDMCFG4_Test -> MDMCFG4_TestC;
  TestSpiP.MDMCFG3_Test -> MDMCFG3_TestC;
  TestSpiP.MDMCFG2_Test -> MDMCFG2_TestC;
  TestSpiP.MDMCFG1_Test -> MDMCFG1_TestC;
  TestSpiP.MDMCFG0_Test -> MDMCFG0_TestC;
  TestSpiP.DEVIATN_Test -> DEVIATN_TestC;
  TestSpiP.MCSM2_Test -> MCSM2_TestC;
  TestSpiP.MCSM1_Test -> MCSM1_TestC;
  TestSpiP.MCSM0_Test -> MCSM0_TestC;
  TestSpiP.FOCCFG_Test -> FOCCFG_TestC;
  TestSpiP.BSCFG_Test -> BSCFG_TestC;
  TestSpiP.AGCTRL2_Test -> AGCTRL2_TestC;
  TestSpiP.AGCTRL1_Test -> AGCTRL1_TestC;
  TestSpiP.AGCTRL0_Test -> AGCTRL0_TestC;
  TestSpiP.WOREVT1_Test -> WOREVT1_TestC;
  TestSpiP.WOREVT0_Test -> WOREVT0_TestC;
  TestSpiP.WORCTRL_Test -> WORCTRL_TestC;
  TestSpiP.FREND1_Test -> FREND1_TestC;
  TestSpiP.FREND0_Test -> FREND0_TestC;
  TestSpiP.FSCAL3_Test -> FSCAL3_TestC;
  TestSpiP.FSCAL2_Test -> FSCAL2_TestC;
  TestSpiP.FSCAL1_Test -> FSCAL1_TestC;
  TestSpiP.FSCAL0_Test -> FSCAL0_TestC;
  TestSpiP.RCCTRL1_Test -> RCCTRL1_TestC;
  TestSpiP.RCCTRL0_Test -> RCCTRL0_TestC;
  TestSpiP.FSTEST_Test -> FSTEST_TestC;
  TestSpiP.PTEST_Test -> PTEST_TestC;
  TestSpiP.AGCTEST_Test -> AGCTEST_TestC;
  TestSpiP.TEST2_Test -> TEST2_TestC;
  TestSpiP.TEST1_Test -> TEST1_TestC;
  TestSpiP.TEST0_Test -> TEST0_TestC;
  TestSpiP.PARTNUM_Test -> PARTNUM_TestC;
  TestSpiP.VERSION_Test -> VERSION_TestC;
  TestSpiP.FREQEST_Test -> FREQEST_TestC;
  TestSpiP.LQI_Test -> LQI_TestC;
  TestSpiP.RSSI_Test -> RSSI_TestC;
  TestSpiP.MARCSTATE_Test -> MARCSTATE_TestC;
  TestSpiP.WORTIME1_Test -> WORTIME1_TestC;
  TestSpiP.WORTIME0_Test -> WORTIME0_TestC;
  TestSpiP.PKTSTATUS_Test -> PKTSTATUS_TestC;
  TestSpiP.VCO_VC_DAC_Test -> VCO_VC_DAC_TestC;
  TestSpiP.TXBYTES_Test -> TXBYTES_TestC;
  TestSpiP.RXBYTES_Test -> RXBYTES_TestC;
  
}

