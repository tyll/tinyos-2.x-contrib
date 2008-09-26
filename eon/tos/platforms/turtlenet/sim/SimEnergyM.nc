

#include <sim_energy.h>


module SimEnergyM
{
  provides
  {
  	interface Energy;
  }
  

}

implementation
{

 	command double Energy.get_battery_size()
	{
		return sim_node_batt_size(sim_node());
	}
	
	command double Energy.get_energy()
	{
		return sim_node_energy(sim_node());
	}
	
	
	command double Energy.get_energy_in()
	{
		return sim_node_energy_in(sim_node());
	}
	
	command double Energy.get_energy_out()
	{
		return sim_node_energy_out(sim_node());
	}
	
	
	command bool Energy.consume(double mJ)
	{
		return sim_consume_energy(sim_node(), mJ);
	}
	
	command bool Energy.consume_profile(int path)
	{
		return sim_consume_profile(sim_node(), path);
	}

}
