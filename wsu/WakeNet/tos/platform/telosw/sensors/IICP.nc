
module IICP {
	uses {
		interface GeneralIO as DATA;
		interface GeneralIO as CLOCK;
	}
	provides{
		interface IIC;
	}
}

implementation
{
	void delay()
	{
		uint8_t i;
		for(i=0;i<1;i++)
		{}
	}

	command void IIC.init()
	{
		call DATA.makeOutput();
		call DATA.set();
		call CLOCK.makeOutput();
		call CLOCK.set();
	}

	command void IIC.start()
	{
		call DATA.makeOutput();

		call DATA.set();
		delay();
		call CLOCK.set();
		delay();
		call DATA.clr();
		delay();
		call CLOCK.clr();
	}

	command void IIC.stop()
	{
		call DATA.makeOutput();

		call DATA.clr();
		delay();
		call CLOCK.set();
		delay();
		call DATA.set();
	}

	command void IIC.writeByte(uint8_t val)
	{
		int i;
		call DATA.makeOutput();

		for(i=0;i<8;i++)
		{
			call CLOCK.clr();
			delay();
			if(val & 0x80)
				call DATA.set();
			else
				call DATA.clr();
			val = val << 1;
			delay();

			call CLOCK.set();
			delay();
		}
		call CLOCK.clr();
		call DATA.set();
		delay();
	}

	command uint8_t IIC.readByte()
	{
		uint8_t val=0;
		int i;
//		call CLOCK.clr();
//		delay();
		call DATA.set();
		call DATA.makeInput();

		for(i=0;i<8;i++)
		{
			call CLOCK.set();
			delay();
			if(call DATA.get())
				val |= 1;
			if(i != 7)
				val = val << 1;
			delay();
			call CLOCK.clr();
			delay();
		}
		return val;
	}

	command error_t IIC.receiveACK()
	{
		error_t flag = SUCCESS;

		call DATA.makeInput();

		call CLOCK.set();
		delay();
	//	while(call DATA.get() == 1);
		call CLOCK.clr();
		delay();

		return flag;
	}

	command error_t IIC.receiveNACK()
	{
		call DATA.makeInput();

		call CLOCK.set();
		delay();
		//while(call DATA.get() == 0 )
		call CLOCK.clr();
		delay();

		return SUCCESS;
	}

	command void IIC.sendACK()
	{
		call DATA.makeOutput();

		call CLOCK.clr();
		call DATA.clr();
		call CLOCK.set();
		call CLOCK.clr();
	}

	command void IIC.sendNACK()
	{
		call DATA.makeOutput();

		call CLOCK.clr();
		call DATA.set();
		call CLOCK.set();
		call CLOCK.clr();
	}

	command error_t IIC.inUse()
	{
		call DATA.makeInput();
		call CLOCK.makeInput();

		if(call DATA.get()==0 || call CLOCK.get()==0)
			return SUCCESS;
		else 
			return FAIL;
	}
}
