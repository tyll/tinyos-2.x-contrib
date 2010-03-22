
module AccelerometerP
{
	provides
	{
		interface Accelerometer;
		interface Read<acc_t> as AccelerometerRead;
	}
	uses{
		interface GpioInterrupt as INT1;
		interface GpioInterrupt as INT2;
		interface GeneralIO as INT1_IO;
		interface GeneralIO as INT2_IO;
		interface GeneralIO as ADC4;
		interface IIC;

		interface Leds;
	}
}

implementation
{
	void delay(){
		uint8_t i;
		for(i=0;i<16;i++) {}
	}

	uint8_t singleByteRead(uint8_t reg_add)
	{
		uint8_t val = 0;

		call IIC.start();
		delay();
		call IIC.writeByte(ADDRESS_WRITE);
		call IIC.receiveACK();
		call IIC.writeByte(reg_add);
		call IIC.receiveACK();
		call IIC.stop();
		call IIC.start();
		delay();
		call IIC.writeByte(ADDRESS_READ);
		call IIC.receiveACK();
		delay();
		val = call IIC.readByte();
		call IIC.sendNACK();
		delay();
		call IIC.stop();

		return val;
	}

	void singleByteWrite(uint8_t reg_add, uint8_t data)
	{
		call IIC.start();
		delay();

		call IIC.writeByte(ADDRESS_WRITE);
		call IIC.receiveACK();

		call IIC.writeByte(reg_add);
		call IIC.receiveACK();

		call IIC.writeByte(data);
		call IIC.receiveACK();

		call IIC.stop();
	}

	void enableInt(){
		singleByteWrite(ADDRESS_INT_ENABLE, DATA_INT_ENABLE);
	}

	void config()
	{
		//disable interruption
		singleByteWrite(ADDRESS_INT_ENABLE, 0x00);

//		singleByteWrite(ADDRESS_THRESH_TAP, DATA_THRESH_TAP);
//		singleByteWrite(ADDRESS_OFSX, DATA_OFSX);
//		singleByteWrite(ADDRESS_OFSY, DATA_OFSY);
//		singleByteWrite(ADDRESS_OFSZ, DATA_OFSZ);
//		singleByteWrite(ADDRESS_DUR, DATA_DUR);
//		singleByteWrite(ADDRESS_LATENT, DATA_LATENT);
//		singleByteWrite(ADDRESS_WINDOW, DATA_WINDOW);
		singleByteWrite(ADDRESS_THRESH_ACT, DATA_THRESH_ACT);
		singleByteWrite(ADDRESS_THRESH_INACT, DATA_THRESH_INACT);
		singleByteWrite(ADDRESS_TIME_INACT, DATA_TIME_INACT);
		singleByteWrite(ADDRESS_ACT_INACT_CTL, DATA_ACT_INACT_CTL);
//		singleByteWrite(ADDRESS_THRESH_FF, DATA_THRESH_FF);
//		singleByteWrite(ADDRESS_TAP_AXES, DATA_TAP_AXES);

		singleByteWrite(ADDRESS_BW_RATE, DATA_BW_RATE);
		singleByteWrite(ADDRESS_POWER_CTL, DATA_POWER_CTL_STANDBY);
//		singleByteWrite(ADDRESS_POWER_CTL, DATA_POWER_CTL_MEASURE);
		singleByteWrite(ADDRESS_INT_MAP, DATA_INT_MAP);
		singleByteWrite(ADDRESS_DATA_FORMAT, DATA_DATA_FORMAT);

//		singleByteWrite(ADDRESS_FIFO_CTL, DATA_FIFO_CTL);

	}

	command error_t Accelerometer.init()
	{
		call IIC.init();
		call INT1.enableRisingEdge();
		call INT2.enableRisingEdge();

		call ADC4.makeOutput();
		call ADC4.set();

		call INT1_IO.makeInput();
		call INT2_IO.makeInput();

		config();
		enableInt();

		return SUCCESS;
	}

	async event void INT1.fired()
	{
		signal Accelerometer.int1();
		singleByteRead(ADDRESS_INT_SOURCE);
	}

	async event void INT2.fired()
	{
		signal Accelerometer.int2();
	}

	command void Accelerometer.clearInt(){
	}

	uint16_t dataRead(uint8_t channel0, uint8_t channel1)
	{
		uint16_t x0, x1;
		x0 = singleByteRead(channel0);
		x1 = singleByteRead(channel1);
		return (x1<<8) + x0;
	}

	uint16_t data_x(){
		return dataRead(ADDRESS_DATAX0, ADDRESS_DATAX1);
	}

	uint16_t data_y(){
		return dataRead(ADDRESS_DATAY0, ADDRESS_DATAY1);
	}

	uint16_t data_z(){
		return dataRead(ADDRESS_DATAZ0, ADDRESS_DATAZ1);
	}

	task void readTask()
	{
		acc_t accData;

	//	accData.x = singleByteRead(ADDRESS_DEVID);
		accData.x = data_x();
		accData.y = data_y();
		accData.z = data_z();		

		singleByteRead(ADDRESS_INT_SOURCE);
		signal AccelerometerRead.readDone(SUCCESS, accData);	
	}

	command error_t AccelerometerRead.read()
	{
		post readTask();
		return SUCCESS;
	}

	default event void AccelerometerRead.readDone(error_t res, acc_t val) {}
	default async event void Accelerometer.int1() {}
	default async event void Accelerometer.int2() {}
}
