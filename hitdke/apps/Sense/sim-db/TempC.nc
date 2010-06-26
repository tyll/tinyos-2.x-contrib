#include <synsb.h>

generic configuration TempC()
{
    provides interface Read<uint16_t>;
}
implementation
{
    components new VirtualSensorC(uint16_t, "S_TEMPERATURE");
    components DefaultSensorModelC;
    
    VirtualSensorC.LatencyModel -> DefaultSensorModelC;
    VirtualSensorC.EnergyModel -> DefaultSensorModelC;

    Read = VirtualSensorC;
}

