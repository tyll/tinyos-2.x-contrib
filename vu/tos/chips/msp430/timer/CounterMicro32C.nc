configuration CounterMicro32C {
	provides interface Counter<TMicro, uint32_t>;
} implementation {

  components new TransformCounterC(TMicro,uint32_t,TMicro,uint16_t,0,uint16_t);
  
  components Msp430CounterMicroC;
  
  TransformCounterC.CounterFrom -> Msp430CounterMicroC;
  Counter = TransformCounterC;

}
