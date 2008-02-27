

/**
 * See the readme for more info
 * @author David Moss
 */
 
#include "Analysis.h"

configuration AnalysisC {
}

implementation {

  components AnalysisP,
      MainC,
      LedsC,
      new TimerMilliC() as SendTimerC,
      new TimerMilliC() as LedsOffTimerC;
      
  AnalysisP.Boot -> MainC;
  AnalysisP.Leds -> LedsC;
  AnalysisP.SendTimer -> SendTimerC;
  AnalysisP.LedsOffTimer -> LedsOffTimerC;
  
  
  components 
      ActiveMessageC,
      SerialActiveMessageC,
      new AMSenderC(AM_ANALYSISMSG) as CommandSenderC,
      new AMSenderC(AM_DUMMYMSG) as DummySenderC,
      new SerialAMReceiverC(AM_ANALYSISMSG) as SerialCommandReceiverC,
      new AMReceiverC(AM_ANALYSISMSG) as RadioCommandReceiverC,
      new AMReceiverC(AM_DUMMYMSG) as DummyReceiverC;
      
  AnalysisP.RadioSplitControl -> ActiveMessageC;
  AnalysisP.SerialSplitControl -> SerialActiveMessageC;
  AnalysisP.SerialCommandReceiver -> SerialCommandReceiverC;
  AnalysisP.RadioCommandReceiver -> RadioCommandReceiverC;
  AnalysisP.CommandSender -> CommandSenderC;
  AnalysisP.DummySender -> DummySenderC;
  AnalysisP.DummyReceiver -> DummyReceiverC;

  AnalysisP.PacketLink -> ActiveMessageC;
  AnalysisP.LowPowerListening -> ActiveMessageC;
      
}
