generic configuration Msp430UsciA1C() {

  provides interface Resource;
  provides interface ResourceRequested;
  provides interface ArbiterInfo;
  provides interface HplMsp430UsciSpi;
  provides interface HplMsp430UsciUart;
  provides interface HplMsp430UsartInterrupts;

  uses interface ResourceConfigure;
}

implementation {

  enum {
    CLIENT_ID = unique( MSP430_HPLUSCIA1_RESOURCE ),
  };

  components Msp430UsciShareA1P as UsciShareP;

  Resource = UsciShareP.Resource[ CLIENT_ID ];
  ResourceRequested = UsciShareP.ResourceRequested[ CLIENT_ID ];
  ResourceConfigure = UsciShareP.ResourceConfigure[ CLIENT_ID ];
  ArbiterInfo = UsciShareP.ArbiterInfo;
  HplMsp430UsartInterrupts = UsciShareP.Interrupts[ CLIENT_ID ];

  components HplMsp430UsciA1C as UsciC;
  HplMsp430UsciSpi = UsciC;
  HplMsp430UsciUart = UsciC;

}
