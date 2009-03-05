#include "QuantoLogCompressedMyUartWriter.h"

configuration QuantoLogCompressedMyUartWriterC {
}
implementation {
    components MainC;
    components QuantoLogCompressedMyUartWriterP as QLog;
    components TinySchedulerC;

    QLog.Boot -> MainC;
    QLog.CompressTask -> TinySchedulerC.TaskQuanto[unique("TinySchedulerC.TaskQuanto")];

    components new BitBufferC(BITBUFSIZE) as BitBuffer,
               new MoveToFrontC() as MTF,
               //EliasDeltaC as Elias;
               EliasGammaC as Elias;
    
    QLog.BitBuffer -> BitBuffer;
    QLog.MoveToFront -> MTF;
    QLog.Elias -> Elias;

    //components PortWriterC;
    components MySerialWriterC;
   
    QLog.PortWriter -> MySerialWriterC;    
    QLog.WriterInit -> MySerialWriterC;
    QLog.WriterControl -> MySerialWriterC;
    

    components SingleContextTrackC;
    components MultiContextTrackC;
    components PowerStateTrackC;

    QLog.SingleContextTrack -> SingleContextTrackC;
    QLog.MultiContextTrack -> MultiContextTrackC;
    QLog.PowerStateTrack -> PowerStateTrackC;

    components Counter32khz32C as Counter;
    QLog.Counter -> Counter;

    components EnergyMeterC;
    QLog.EnergyMeter -> EnergyMeterC;

}
