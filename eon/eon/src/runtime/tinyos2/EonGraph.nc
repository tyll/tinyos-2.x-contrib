includes scheduler;

interface EonGraph
{
	command uint16_t translate_edge_complete (EdgeIn * e, uint16_t * wt);
	command error_t adjust_intervals(uint8_t state, double grade);
	command error_t call_edge(uint16_t dest, void *invar, void *outvar);
	command error_t call_error_handler(uint16_t nodeid, uint8_t error);
	
	command bool *getOutValid(uint16_t srcid);
	command void *getOutVar(uint16_t nodeid);
	command void *getInVar(uint16_t nodeid);
	command rt_data *getRTData(uint16_t nodeid);
	command void* getOutQueue(uint16_t srcid, uint8_t entry);
	command int16_t getOutSize(uint16_t nodeid);
	command int16_t getSrcWeight (uint16_t srcid);
	command uint16_t getErrorWeight (uint16_t nodeid);
}
