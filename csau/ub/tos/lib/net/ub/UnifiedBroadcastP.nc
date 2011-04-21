
/**
 * @author Morten Tranberg Hansen <mth at cs dot au dot dk>
 * @date   June 6 2010
 */


#include "UnifiedBroadcast.h"

configuration UnifiedBroadcastP @safe() {

	provides {
		interface Send[uint8_t client];
		interface Receive[am_id_t id];
		interface UnifiedBroadcast[uint8_t client];
	}

} implementation {

  enum {
    NUM_CLIENTS = uniqueCount(UQ_AMQUEUE_SEND)
  };

	components 
		ActiveMessageC,
		AMQueueP;

#ifdef UNIFIED_BROADCAST

#warning "*** UNIFIED BROADCAST IS ENABLED ***"

	components
		new UnifiedBroadcastImplP(NUM_CLIENTS) as UB,
		MainC,
		new AMSenderC(AM_UNIFIEDBROADCAST_MSG),
		new BitVectorC(NUM_CLIENTS) as PendingVector,
		new BitVectorC(NUM_CLIENTS) as SendingVector,
		new BitVectorC(NUM_CLIENTS) as UrgentVector,
		LocalTimeMilliC;

	MainC.SoftwareInit -> UB;
	UB.RadioControl -> ActiveMessageC;
	UB.PendingVector -> PendingVector;
	UB.SendingVector -> SendingVector;
	UB.UrgentVector -> UrgentVector;
	UB.BroadcastSend -> AMSenderC;
	UB.Packet -> ActiveMessageC;
	UB.LocalTime -> LocalTimeMilliC;

#ifndef UB_NO_TIMESTAMP
	components CC2420PacketC;
	UB.PacketTimeSyncOffset -> CC2420PacketC;
#endif

#else

#warning "*** UNIFIED BROADCAST IS NOT USED ***"

	components
		new DummyUnifiedBroadcastImplP() as UB;

#endif

	UB.AMPacket -> ActiveMessageC;
	UB.SubSend -> AMQueueP.Send;
	UB.SubReceive -> ActiveMessageC.Receive;

	UB.Send = Send;
	UB.Receive = Receive;
	UB.UnifiedBroadcast = UnifiedBroadcast;

}
