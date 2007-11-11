configuration SimEnergyEstimatorC {
	provides interface SimEnergyEstimator;
}

implementation {

	components SimEnergyEstimatorP;
	SimEnergyEstimator = SimEnergyEstimatorP;

}
