

interface IPathDone
{
	event result_t done(uint16_t pathid, uint32_t cost, uint8_t prob, uint8_t srcprob);
}
