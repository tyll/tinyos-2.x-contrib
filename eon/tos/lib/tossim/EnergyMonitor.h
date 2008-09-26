

#ifndef  _ENERGYMONITOR_H_
#define  _ENERGYMONITOR_H_

class EnergyMonitor {

	public: 
		EnergyMonitor(int id);
		~EnergyMonitor();

		double getEnergyStored();
		double getEnergyIn();
		double getEnergyOut();
		double getBatterySize();
		double getWaste();

		void setEnergyStored(double mJ);
		void harvestEnergy(double mJ);
		void consumeEnergy(double mJ);
		void setBatterySize(double mJ);

	protected:
		int m_id;
	
};
#endif
