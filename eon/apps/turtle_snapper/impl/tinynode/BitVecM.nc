

module BitVecM {

  provides {
		interface BitVec;
	}

  
  
}
implementation {
	
	command bool BitVec.get16(uint16_t *buffer, uint8_t location)
	{
		if (location > 15)
		{
			return FALSE;
		}	
		return ((*buffer >> location) & 0x0001);
	}
	
	command result_t BitVec.set16(uint16_t *buffer, uint8_t location, bool value)
	{
		
		if (location > 15)
		{
			return FAIL;
		}	
			
		if (value)
		{
			*buffer |= (0x0001 << location);
		} else {
			*buffer &= ~(0x0001 << location);
		}
		return SUCCESS;
		
	}
	
}

