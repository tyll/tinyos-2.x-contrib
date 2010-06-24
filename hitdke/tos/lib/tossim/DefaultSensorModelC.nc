
module DefaultSensorModelC
{
    provides
    {
        interface SensorLatencyModel;
        interface SensorEnergyModel;
    }
}
implementation
{
    command uint8_t SensorLatencyModel.getUnitLatency(void)
    {
        return 1;
    }

    command double SensorEnergyModel.getUnitEnergy(void)
    {
        return 0.0;
    }
}

