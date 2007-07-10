/*
 * Authors:		Sarah Bergbreiter
 * Date last modified:  10/3/03
 *
 */

/** 
 * SlotManagerC is a tiny OS configuration module.
 * This module maintains a relatively current neighbor list used
 * for a slotted ring protocol. A table of neighbors is currently 
 * kept using the Neighborhood interface and timers are used to 
 * broadcast our presence (and our current neighborhood table) 
 * occasionally as well as check if I have heard from my
 * neighbors recently.
 *
 * @author Sarah Bergbreiter
 **/

includes SlotMsg;

configuration SlotManagerC { 
  provides {
    interface StdControl;
    interface SlotRing;
  }
}

implementation {
  components SlotManagerM, TimerC, GenericComm as Comm, ClockC, NoLeds as Display;

  StdControl = SlotManagerM.StdControl;
  SlotRing = SlotManagerM.SlotRing;
  
  SlotManagerM.CommControl -> Comm;
  SlotManagerM.Send -> Comm.SendMsg[AM_SLOTMSG];
  SlotManagerM.Receive -> Comm.ReceiveMsg[AM_SLOTMSG];
  SlotManagerM.ReceiveTick -> Comm.ReceiveMsg[AM_TICKMSG];

  SlotManagerM.TimerControl -> TimerC;
  SlotManagerM.BcastTimer -> TimerC.Timer[unique("Timer")];
  SlotManagerM.InitTimer -> TimerC.Timer[unique("Timer")];
  SlotManagerM.CatchUpTimer -> TimerC.Timer[unique("Timer")];
  
  SlotManagerM.Leds -> Display;

} // end of implementation
