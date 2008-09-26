interface INetworkEnergy
{
	//tuning and energy accounting
  command error_t tune(int level); //performance level 0(no communication)-100(no energy limiting)
  
  event void packet_delivered();
  event void begin_consuming();
  event void done_consuming();
  
}
