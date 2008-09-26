includes scheduler;

interface IScheduler
{
	//command error_t schedule (EdgeIn edge);
	//event error_t edge_ready(uint16_t dest, void *invar, void *outvar);
	command void adjust_intervals(uint8_t state, double grade);
	event void flow_energy (uint16_t path, uint32_t energy);
}
