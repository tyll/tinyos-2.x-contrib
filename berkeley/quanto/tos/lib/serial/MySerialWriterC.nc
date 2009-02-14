/* MySerialWriter is a serial interface that provides the PortWriter interface
 * to log quanto log messages. 
 * It uses a TaskQuanto task that runs in the lowest priority in the scheduler.
 */

configuration MySerialWriterC {
  provides {
    interface Init;
    interface SplitControl;
    interface PortWriter;
  }
}
implementation {
  components LPSerialP as SerialP, MySerialWriterP,
    HdlcTranslateC,
    PlatformSerialC;

  PortWriter = MySerialWriterP;
  SplitControl = SerialP;

  Init = SerialP;
  //Leds = SerialP;
  //Leds = MySerialSenderP;
  //Leds = HdlcTranslateC;

  MySerialWriterP.SendBytePacket -> SerialP;

  SerialP.SerialControl -> PlatformSerialC;
  //  SerialP.SerialFlush -> PlatformSerialC;
  SerialP.SerialFrameComm -> HdlcTranslateC;
  HdlcTranslateC.UartStream -> PlatformSerialC;
  
  components TinySchedulerC;

  MySerialWriterP.SignalSendDoneTask -> TinySchedulerC.TaskQuanto[unique("TinySchedulerC.TaskQuanto")];
    
  components ResourceContextsC;
  MySerialWriterP.CPUContext -> ResourceContextsC.CPUContext;

}
