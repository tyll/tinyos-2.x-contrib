
interface BitVec
{
	command bool get16(uint16_t *buffer, uint8_t location);

	command result_t set16(uint16_t *buffer, uint8_t location, bool value);
	
}
