#include <synsb.h>

generic configuration TempC()
{
    provides interface Read<uint16_t>;
}
implementation
{
    components new SyntheticSensorC(uint16_t, "S_TEMPERATURE");
    components DefaultSensorModelC;
    
    SyntheticSensorC.LatencyModel -> DefaultSensorModelC;
    SyntheticSensorC.EnergyModel -> DefaultSensorModelC;

    Read = SyntheticSensorC;
}

