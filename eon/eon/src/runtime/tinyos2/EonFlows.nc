includes scheduler;

interface EonFlows
{
	event void flow_error (uint16_t nodeid, uint8_t error);
	event void schedule_edge (uint16_t srcid, uint16_t dstid, uint16_t edgewt);
  	event void schedule_src_edge (uint16_t srcid, uint16_t dstid);
	event void flow_exit (uint16_t nodeid);

	event bool functional_check(uint8_t state);
	
	
	
}
