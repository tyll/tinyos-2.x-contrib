generic configuration Msp430UartP() {

  provides interface Resource[ uint8_t id ];
  provides interface ResourceConfigure[ uint8_t id ];
  //provides interface Msp430UartControl as UartControl[ uint8_t id ];
  provides interface UartStream[ uint8_t id ];
  provides interface UartByte[ uint8_t id ];
   
  uses interface Resource as UsartResource[ uint8_t id ];
  uses interface Msp430UartConfigure[ uint8_t id ];
  uses interface HplMsp430Usart as Usart;
  uses interface HplMsp430UsartInterrupts as UsartInterrupts[ uint8_t id ];
  uses interface Counter<T32khz,uint16_t>;
  uses interface Leds;
}

implementation {
    components new Msp430UartImplP() as Impl, ResourceContextsC;
        
    Resource = Impl;
    ResourceConfigure = Impl;
    //UartControl = Impl;
    UartStream = Impl;
    UartByte = Impl;
    
    UsartResource = Impl.UsartResource;
    Msp430UartConfigure = Impl;
    Usart = Impl;
    UsartInterrupts = Impl;
    Counter = Impl;
    Leds = Impl;
     
    Impl.CPUContext -> ResourceContextsC.CPUContext;
}
