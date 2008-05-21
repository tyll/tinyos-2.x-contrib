#include <mc13192Const.h>

configuration mc13192SendReceiveC
{
  provides
  {
    interface SplitControl;
    interface Send;
    interface Receive;
    interface Packet;
    interface PacketAcknowledgements;
  }
}
implementation
{
  components mc13192SendReceiveP as SendReceive,
             mc13192ControlM as RadioControl,
             mc13192InterruptM as Interrupt,
	         mc13192TimerM as Timer,
	         mc13192TimerCounterM as TimerCounter,
	         mc13192StateM as State,
	         Mc13192HardwareC as Hardware;

  SplitControl = SendReceive;
  Send = SendReceive;
  Receive = SendReceive;
  Packet = SendReceive;
  PacketAcknowledgements = SendReceive;

  SendReceive.HardwareControl -> Hardware.StdControl;
  SendReceive.RadioSplitControl -> RadioControl.SplitControl;
  SendReceive.TimerControl -> Timer.StdControl;
  SendReceive.RadioControl -> RadioControl.RadioControl;

  RadioControl.Interrupt -> Interrupt.Control;
  RadioControl.Regs -> Hardware.mc13192Regs;
  RadioControl.Timer2 -> Timer.Timer[1];
  RadioControl.Time -> TimerCounter.Time;
  RadioControl.State -> State.State;
  RadioControl.Pins -> Hardware;
  RadioControl.HwInterrupt -> Hardware;
  
  SendReceive.Regs -> Hardware.mc13192Regs;
  SendReceive.Interrupt -> Interrupt.Data;
  SendReceive.State -> State.State;
  
  Interrupt -> Hardware.mc13192Regs;
  Interrupt -> Hardware.mc13192Interrupt;
  
  State.Regs -> Hardware.mc13192Regs;
  State.EventTimer -> Timer.EventTimer;
  State -> Hardware.mc13192Pins;
  
  Timer.Regs -> Hardware.mc13192Regs;
  Timer.Interrupt -> Interrupt.Timer;
  
  TimerCounter.Regs -> Hardware.mc13192Regs;
}