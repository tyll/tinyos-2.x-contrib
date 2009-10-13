generic module BusyWaitMicroP(uint8_t divisor)
{
  provides interface BusyWait<TMicro,uint16_t>;
  uses interface BusyWait<TMicro,uint16_t> as SubBusyWait;
}
implementation
{
	async command void BusyWait.wait(uint16_t dt) {
		call SubBusyWait.wait(divisor * dt);
	}
	
}

