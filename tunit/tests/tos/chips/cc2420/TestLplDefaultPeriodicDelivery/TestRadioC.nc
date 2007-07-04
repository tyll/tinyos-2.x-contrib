
#include "TestCase.h"

/**
 * @author David Moss
 */
configuration TestRadioC {
}

implementation {
  components
      new TestCaseC() as TestPeriodicDeliveryC,
      new StatisticsC() as AveragePktStatsC,
      new StatisticsC() as DetectRateStatsC;
      
  components TestRadioP,
      ActiveMessageC,
      CC2420ActiveMessageC,
      CC2420CsmaC,
      ActiveMessageAddressC,
      new AMSenderC(4),
      new AMReceiverC(4),
      new TimerMilliC(),
      new TimerMilliC() as WaitTimerC,
      new StateC(),
      LedsC;

  TestRadioP.SetUpOneTime -> TestPeriodicDeliveryC.SetUpOneTime;
  TestRadioP.TestPeriodicDelivery -> TestPeriodicDeliveryC;
  TestRadioP.TearDownOneTime -> TestPeriodicDeliveryC.TearDownOneTime;
  TestRadioP.AveragePktStats -> AveragePktStatsC;
  TestRadioP.DetectRateStats -> DetectRateStatsC;
  
  TestRadioP.LowPowerListening -> CC2420ActiveMessageC;
  TestRadioP.RadioPowerControl -> CC2420CsmaC.SplitControl;
  TestRadioP.ActiveMessageAddress -> ActiveMessageAddressC;
  TestRadioP.SplitControl -> ActiveMessageC;
  TestRadioP.PacketAcknowledgements -> ActiveMessageC;
  TestRadioP.AMSend -> AMSenderC;
  TestRadioP.AMPacket -> ActiveMessageC;
  TestRadioP.Receive -> AMReceiverC;
  TestRadioP.Timer -> TimerMilliC;
  TestRadioP.WaitTimer -> WaitTimerC;
  TestRadioP.State -> StateC;
  TestRadioP.Leds -> LedsC;

}
