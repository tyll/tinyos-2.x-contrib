inline int check_time(sim_time_t avr_time){
	//printf("%lld",sim_time());
	sim_time_t temp=((sim_time_t)avr_time * sim_ticks_per_sec());
    	temp /= 7372800ULL;			
	sim_set_time(sim_time()+temp);

return 0;
}
