
interface Energy
{
	//all in mJ
	command double get_battery_size();
	command double get_energy();
	command double get_energy_in();
	command double get_energy_out();
	
	command bool consume(double mJ);
	command bool consume_profile(int path);
}
