#include "RawUartMsg.h"

configuration QuantoLogRawUARTC {
    provides interface QuantoLog;
}
implementation {
    components MainC;
    components QuantoLogRawUARTP as QLog;
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
    
    components SerialActiveMessageC as Serial;
    components new SerialAMSenderC(QUANTO_LOG_AM_TYPE) as UARTSender;
    QLog.SerialControl -> Serial;
    QLog.UARTSend -> UARTSender;

    components EnergyMeterC;
    QLog.EnergyMeter -> EnergyMeterC;
}
