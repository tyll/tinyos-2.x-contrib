#include "AM.h"

generic configuration LplAMSenderC(am_id_t AMId)
{
  provides {
    interface AMSend;
    interface Packet;
    interface AMPacket;
    interface PacketAcknowledgements as Acks;
		interface UnifiedBroadcast;
  }
}

implementation
{
  components new DirectAMSenderC(AMId);
  components new LplAMSenderP();
  components ActiveMessageC;
  components SystemLowPowerListeningC;

  AMSend = LplAMSenderP;
  Packet = DirectAMSenderC;
  AMPacket = DirectAMSenderC;
  Acks = DirectAMSenderC;
	UnifiedBroadcast = DirectAMSenderC;

  LplAMSenderP.SubAMSend -> DirectAMSenderC;
  LplAMSenderP.Lpl -> ActiveMessageC;
  LplAMSenderP.SystemLowPowerListening -> SystemLowPowerListeningC;
}
