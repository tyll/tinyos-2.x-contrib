#include "detector.h"
#include <Atm128Adc.h>

configuration DetectorAppC { }
implementation {
  components ActiveMessageC, MainC, LedsC, MicaBusC;

  components SynchronizerC, StatsC, DetectorC, MicrophoneC;

  components new AMReceiverC(AM_COORDINATION_MSG) as CReceive;
  components new AMReceiverC(AM_DETECTION_MSG) as DReceive;
  components new AMSenderC(AM_DETECTION_MSG) as DSend;
  components new TimerMilliC() as VTimer;
  components CounterMicro32C;
  SynchronizerC.Boot -> MainC;
  SynchronizerC.RadioControl -> ActiveMessageC;
  SynchronizerC.Leds -> LedsC;
  SynchronizerC.Stats -> StatsC;
  SynchronizerC.Counter -> CounterMicro32C;
  SynchronizerC.RCoordination -> CReceive;
  SynchronizerC.RDetection -> DReceive;
  SynchronizerC.SDetection -> DSend;
  SynchronizerC.VotingTimer -> VTimer;

  components new AlarmMicro32C() as DAlarm;
  components Atm128AdcC;
  DetectorC.Leds -> LedsC;
  DetectorC.Alarm -> DAlarm;
  DetectorC.AdcResource -> Atm128AdcC.Resource[unique(UQ_ATM128ADC_RESOURCE)];
  DetectorC.Atm128AdcSingle -> Atm128AdcC;
  DetectorC.MicAdcChannel -> MicaBusC.Adc2;

  components new TimerMilliC() as MTimer;
  components new Atm128I2CMasterC() as I2CPot;
  MicrophoneC.Timer -> MTimer;
  MicrophoneC.MicPower  -> MicaBusC.PW3;
  MicrophoneC.MicMuxSel -> MicaBusC.PW6;
  MicrophoneC.I2CResource -> I2CPot;
  MicrophoneC.I2CPacket -> I2CPot;

  SynchronizerC.Detector -> DetectorC;
  DetectorC.Microphone -> MicrophoneC;
}
