
configuration PacketEnergyEstimatorC {
	provides interface PacketEnergyEstimator;
}

implementation {
	components PacketEnergyEstimatorP;
	PacketEnergyEstimator = PacketEnergyEstimatorP;
}
