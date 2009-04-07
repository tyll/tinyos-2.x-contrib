configuration BroadcastPolicyC {
	provides interface DfrfPolicy;
} implementation {
  components ActiveMessageC, BroadcastPolicyP;

  ActiveMessageC.AMPacket <- BroadcastPolicyP;
  DfrfPolicy = BroadcastPolicyP;
}
