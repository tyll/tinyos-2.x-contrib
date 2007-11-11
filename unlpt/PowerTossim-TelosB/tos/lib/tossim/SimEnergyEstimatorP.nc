#include <sim_energy_estimate.h>

module SimEnergyEstimatorP {
	provides interface SimEnergyEstimator;
}

implementation {

	enum {
		VOLTAGE = 3
	};

	command void SimEnergyEstimator.txEnergy(uint8_t bytes, float current, uint32_t baudrate) {
		float txTime = (double)((1/(double)baudrate)*8.0*bytes);
		sim_update_radioTxEnergy(VOLTAGE * current * txTime);

	}

	command void SimEnergyEstimator.radioIdleEnergy(sim_time_t diff) {
		sim_update_cyrsOscEnergy(VOLTAGE * 0.0197 * (float) diff/sim_ticks_per_sec());

	}

	command void SimEnergyEstimator.rxEnergy(sim_time_t diff) { }

	command void SimEnergyEstimator.rxPacketEnergy(uint8_t bytes, float current, uint32_t baudrate) {
		double rxTime = (double)((1/(double)baudrate)*8.0*bytes);
		sim_update_radioRxPacketEnergy(VOLTAGE*current*rxTime);
	}


	command void SimEnergyEstimator.Stm25pWrite(uint8_t bytes) {
		sim_update_memWriteEnergy(VOLTAGE * 0.020 * 0.018);
	}

	command void SimEnergyEstimator.Stm25pRead(uint8_t bytes) {
		sim_update_memReadEnergy(VOLTAGE * 0.004 * 0.010);
	}


	command void SimEnergyEstimator.Msp430ActiveRadio(sim_time_t diff) {
		sim_update_cpuOnEnergy(VOLTAGE * 0.0021 * (float) diff/sim_ticks_per_sec());
	}

	command void SimEnergyEstimator.Msp430ActiveNoRadio(sim_time_t diff) {
		sim_update_cpuIdleEnergy(VOLTAGE * 0.0018 * (float) diff/sim_ticks_per_sec());
	}

}
