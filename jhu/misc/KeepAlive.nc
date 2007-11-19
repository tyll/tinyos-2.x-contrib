interface KeepAlive
{
  command void startBroadcast(uint32_t intervalMs);
  // The interval value for startListen is only used for the first
  // timeout period. All the rest of the timeouts are using the value
  // received in the disseminated value.
  command void startListen(uint32_t intervalMs);
  command void stop();
  event void timeout();
}
