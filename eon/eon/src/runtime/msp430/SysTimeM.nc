
module SysTimeM
{
	provides 
	{
		interface SysTime;
	}
	uses
	{
		interface LocalTime;
	}
}

implementation
{
	uint16_t currentTime;

	union time_u
	{
		struct
		{
			uint16_t low;
			uint16_t high;
		};
		uint32_t full;
	};

	async command uint16_t SysTime.getTime16()
	{
		uint16_t t16;
		t16 = call LocalTime.read();
		return t16;
	}

	async command uint32_t SysTime.getTime32()
	{
		return call LocalTime.read();
	}

	async command uint32_t SysTime.castTime16(uint16_t time16)
	{
		//currently not needed
		return 0;
	}

	
}
