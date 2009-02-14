#include "RawUartMsg.h"

generic configuration QuantoLogStagedMyUARTC(uint8_t continuous) {
    provides interface QuantoLog;
}
implementation {
    components MainC;
    components new QuantoLogStagedMyUARTP(continuous) as QLog;
    QuantoLog =  QLog; 

    QLog.Boot -> MainC;

    components SingleContextTrackC;
    components MultiContextTrackC;
    components PowerStateTrackC;

    QLog.SingleContextTrack -> SingleContextTrackC;
    QLog.MultiContextTrack -> MultiContextTrackC;
    QLog.PowerStateTrack -> PowerStateTrackC;

    components Counter32khz32C as Counter;
    QLog.Counter -> Counter;
    
    components MySerialSenderC as Serial;
    QLog.SerialControl -> Serial;
    QLog.UARTSend -> Serial.MySend;

    components EnergyMeterC;
    QLog.EnergyMeter -> EnergyMeterC;
}
