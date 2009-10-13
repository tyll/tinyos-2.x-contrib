/*
 * Msp430UsciShareA1P.nc
 *
 *  Created on: Jan 14, 2009
 *      Author: rlim
 */

configuration Msp430UsciShareB0P {

  provides interface HplMsp430UsartInterrupts as Interrupts[ uint8_t id ];
  provides interface Resource[ uint8_t id ];
  provides interface ResourceRequested[ uint8_t id ];
  provides interface ArbiterInfo;

  uses interface ResourceConfigure[ uint8_t id ];
}

implementation {

  components new Msp430UsartShareP() as UsartShareP;
  Interrupts = UsartShareP;
  UsartShareP.RawInterrupts -> UsciC;

  components new FcfsArbiterC( MSP430_HPLUSCIB0_RESOURCE ) as ArbiterC;
  Resource = ArbiterC;
  ResourceRequested = ArbiterC;
  ResourceConfigure = ArbiterC;
  ArbiterInfo = ArbiterC;
  UsartShareP.ArbiterInfo -> ArbiterC;

  components new AsyncStdControlPowerManagerC() as PowerManagerC;
  PowerManagerC.ResourceDefaultOwner -> ArbiterC;
	
  components HplMsp430UsciB0C as UsciC;
  PowerManagerC.AsyncStdControl -> UsciC;
}
