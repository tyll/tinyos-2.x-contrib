interface Scp
{
	async command void setWakeupInterval(uint16_t ms);
	async command uint16_t getWakeupInterval();	
}