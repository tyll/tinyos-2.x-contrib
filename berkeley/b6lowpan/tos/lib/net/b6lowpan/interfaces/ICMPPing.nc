
#include <ICMP.h>

interface ICMPPing {

  command error_t ping(ip6_addr_t target, uint16_t period, uint16_t n);

  event void pingReply(ip6_addr_t source, struct icmp_stats *stats);

  event void pingDone(uint16_t ping_rcv, uint16_t ping_n);

}
