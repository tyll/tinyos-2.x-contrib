
%{
#include <EnergyMonitor.h>
%}

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
	
	
};



