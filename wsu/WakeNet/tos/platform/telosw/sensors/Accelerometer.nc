interface Accelerometer
{
	command error_t init();
	command void clearInt();
	async event void int1();
	async event void int2();

}
