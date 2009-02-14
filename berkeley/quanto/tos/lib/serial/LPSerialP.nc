/* LPSerialP - Low Priority Serial
 *
 * This module is based on SerialP, but runs the transmit task as
 * a low priority QuantoTask.
 *
 * The main difference here is that the RunTxTask is a TaskQuanto, a 
 * task with the lowest priority. This means it will only run after all
 * other tasks, when the CPU would otherwise be idle.
 * The other difference is that it also does not have a receive path!
 * 
 * This modules provides framing for arbitrary msgs using PPP-HDLC-like
 * framing (see RFC 1662).  When sending, a msg is encapsulated in
 * an HDLC frame.  
 *
 * @author Rodrigo Fonseca
 * @date October 2008
 * Based on SerialP by:
 * @author Phil Buonadonna
 * @author Lewis Girod
 * @author Ben Greenstein
 *
 *  
 *Proxy configuration for QSerialImplP, wiring the CPUContext 
 */
configuration LPSerialP {

  provides {
    interface Init;
    interface SplitControl;
    interface SendBytePacket;
  }

  uses {
    interface SerialFrameComm;
    interface StdControl as SerialControl;
    interface SerialFlush;
  }
}
implementation {

    components LPSerialImplP as Impl;
    Init = Impl;
    SplitControl = Impl;
    SendBytePacket = Impl;
    
    SerialFrameComm = Impl;
    SerialControl = Impl;
    SerialFlush = Impl;

    components ResourceContextsC;
    Impl.CPUContext -> ResourceContextsC.CPUContext; 

    components TinySchedulerC;
    Impl.RunTxTask -> TinySchedulerC.TaskQuanto[unique("TinySchedulerC.TaskQuanto")];
}
