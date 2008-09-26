
#include "sim_energy.h"
#include "EnergyMonitor.h"

EnergyMonitor::EnergyMonitor(int id) {
  sim_energy_init(id);

  m_id = id;
}

EnergyMonitor::~EnergyMonitor() {

}
	
double EnergyMonitor::getEnergyStored()
{
	return sim_node_energy(m_id);
}
		
double EnergyMonitor::getEnergyIn()
{
	return sim_node_energy_in(m_id);
}

double EnergyMonitor::getEnergyOut()
{
	return sim_node_energy_out(m_id);
}

double EnergyMonitor::getBatterySize()
{
	return sim_node_batt_size(m_id);
}
		
double EnergyMonitor::getWaste()
{	
	return sim_node_waste(m_id);
}


void EnergyMonitor::setEnergyStored(double mJ)
{
	set_sim_node_energy(m_id, mJ);
}
		
void EnergyMonitor::harvestEnergy(double mJ)
{
	sim_harvest_energy(m_id, mJ);
}

void EnergyMonitor::consumeEnergy(double mJ)
{
	sim_consume_energy(m_id, mJ);
}

void EnergyMonitor::setBatterySize(double mJ)
{
	set_sim_node_batt_size(m_id, mJ);
}
