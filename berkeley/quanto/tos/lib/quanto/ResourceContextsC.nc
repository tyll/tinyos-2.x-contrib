#include "ResourceContexts.h"
/* Centralized component to offer SingleContext interfaces for different
 * resources. Although new resources don't have to use this component,
 * applications MUST NOT instantiate the generic SingleContextC directly.
 * In the whole system there can be only one instantiation of SingleContextC
 * for each ...RESOURCE_CTX value.
 */
configuration ResourceContextsC {
    provides {
        interface SingleContext as CPUContext;

        interface MultiContext as Led0Context;
        interface MultiContext as Led1Context;
        interface MultiContext as Led2Context;

        //interface MultiContext as CC2420RxContext;
        //interface SingleContext as CC2420TxContext;
        interface SingleContext as CC2420Context;
        interface SingleContext as CC2420SpiContext;
        interface SingleContext as Msp430Usart0Context;
        interface SingleContext as Msp430Usart1Context;

        interface SingleContext as Sht11Context;
        //add more resources here...
    
        interface PowerState as CPUPowerState;
        interface PowerState as CC2420PowerState;
        interface PowerState as Led0PowerState;
        interface PowerState as Led1PowerState;
        interface PowerState as Led2PowerState;
    }
} 
implementation {
    components new SingleContextC(CPU_RESOURCE_ID) as CPU;
    CPUContext = CPU;

    components new SingleContextC(CC2420_RESOURCE_ID) as CC2420Ctx;
    CC2420Context = CC2420Ctx;

    components new SingleContextC(CC2420_SPI_RESOURCE_ID) as CC2420SpiCtx;
    CC2420SpiContext = CC2420SpiCtx;

    components new SingleContextC(MSP430_USART0_ID) as Msp430Usart0Ctx;
    Msp430Usart0Context = Msp430Usart0Ctx;

    components new SingleContextC(MSP430_USART1_ID) as Msp430Usart1Ctx;
    Msp430Usart1Context = Msp430Usart1Ctx;

    components new MultiContextC(LED0_RESOURCE_ID) as Led0;
    Led0Context = Led0;

    components new MultiContextC(LED1_RESOURCE_ID) as Led1;
    Led1Context = Led1;

    components new MultiContextC(LED2_RESOURCE_ID) as Led2;
    Led2Context = Led2;

    components new SingleContextC(SHT11_RESOURCE_ID) as Sht11;
    Sht11Context = Sht11;

    components new PowerStateC(CC2420_RESOURCE_ID) as CC2420Power;
    CC2420PowerState = CC2420Power;

    components new PowerStateC(LED0_RESOURCE_ID) as Led0Power;
    Led0PowerState = Led0Power;

    components new PowerStateC(LED1_RESOURCE_ID) as Led1Power;
    Led1PowerState = Led1Power;

    components new PowerStateC(LED2_RESOURCE_ID) as Led2Power;
    Led2PowerState = Led2Power;

    components new PowerStateC(CPU_RESOURCE_ID) as CPUPower;
    CPUPowerState = CPUPower;

}
