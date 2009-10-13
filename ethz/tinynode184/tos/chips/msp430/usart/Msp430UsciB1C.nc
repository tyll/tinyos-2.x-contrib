generic configuration Msp430UsciB1C() {

  provides interface Resource;
  provides interface ResourceRequested;
  provides interface ArbiterInfo;
  provides interface HplMsp430UsciSpi;
  provides interface HplMsp430UsartInterrupts;

  uses interface ResourceConfigure;
}

implementation {

  enum {
    CLIENT_ID = unique( MSP430_HPLUSCIB1_RESOURCE ),
  };

  components Msp430UsciShareB1P as UsciShareP;

  Resource = UsciShareP.Resource[ CLIENT_ID ];
  ResourceRequested = UsciShareP.ResourceRequested[ CLIENT_ID ];
  ResourceConfigure = UsciShareP.ResourceConfigure[ CLIENT_ID ];
  ArbiterInfo = UsciShareP.ArbiterInfo;
  HplMsp430UsartInterrupts = UsciShareP.Interrupts[ CLIENT_ID ];

  components HplMsp430UsciB1C as UsciC;
  HplMsp430UsciSpi = UsciC;

}
