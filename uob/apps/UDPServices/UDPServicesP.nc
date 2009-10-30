/*
 * "Copyright (c) 2008 The Regents of the University  of California.
 * All rights reserved."
 *
 * Permission to use, copy, modify, and distribute this software and its
 * documentation for any purpose, without fee, and without written agreement is
 * hereby granted, provided that the above copyright notice, the following
 * two paragraphs and the author appear in all copies of this software.
 *
 * IN NO EVENT SHALL THE UNIVERSITY OF CALIFORNIA BE LIABLE TO ANY PARTY FOR
 * DIRECT, INDIRECT, SPECIAL, INCIDENTAL, OR CONSEQUENTIAL DAMAGES ARISING OUT
 * OF THE USE OF THIS SOFTWARE AND ITS DOCUMENTATION, EVEN IF THE UNIVERSITY OF
 * CALIFORNIA HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 *
 * THE UNIVERSITY OF CALIFORNIA SPECIFICALLY DISCLAIMS ANY WARRANTIES,
 * INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY
 * AND FITNESS FOR A PARTICULAR PURPOSE.  THE SOFTWARE PROVIDED HEREUNDER IS
 * ON AN "AS IS" BASIS, AND THE UNIVERSITY OF CALIFORNIA HAS NO OBLIGATION TO
 * PROVIDE MAINTENANCE, SUPPORT, UPDATES, ENHANCEMENTS, OR MODIFICATIONS."
 *
 */

#include <IPDispatch.h>
#include <lib6lowpan.h>
#include <ip.h>
#include <lib6lowpan.h>

//#include <string.h>

#include "UDPReport.h"
#include "Service.h"
#include "PrintfUART.h"

#include "MoteIdDb.h"

#define REPORT_PERIOD 75L
#define SERVICE_PUSH_PERIOD 10L

module UDPServicesP {
  uses {
    interface Boot;
    interface SplitControl as RadioControl;

    interface UDP as Echo;
    interface UDP as Status;
    interface UDP as Services;

    interface Leds;

    interface Timer<TMilli> as StatusTimer;
    interface Timer<TMilli> as ServicesPushTimer;

    interface Statistics<ip_statistics_t> as IPStats;
    interface Statistics<udp_statistics_t> as UDPStats;
    interface Statistics<route_statistics_t> as RouteStats;
    interface Statistics<icmp_statistics_t> as ICMPStats;

    interface Random;

    interface ShellCommand;

#if defined(PLATFORM_TELOSB)
    interface ReadId48 as SerialId;

    interface MoteIdDb;
    interface IPAddress;
    interface CC2420Config;
#endif
  }

} implementation {

  bool statusTimerStarted;
  bool servicePushTimerStarted;

  nx_struct udp_report stats;
  nx_struct mdns_service_t service;

  struct sockaddr_in6 route_dest;
  struct sockaddr_in6 service_dest;

  uint8_t serial[6] = {0x0, 0x0, 0x0, 0x0, 0x0, 0x0};
  char usbid[USB_ID_SIZE] = "00000000";
  ieee154_saddr_t tosnodeid = 0xff;

  event void Boot.booted() {
    call RadioControl.start();
    statusTimerStarted = FALSE;
    servicePushTimerStarted = FALSE;

    call IPStats.clear();
    call RouteStats.clear();
    call ICMPStats.clear();
    printfUART_init();

#ifdef REPORT_DEST
    route_dest.sin6_port = hton16(7000);
    inet_pton6(REPORT_DEST, &route_dest.sin6_addr);
    call StatusTimer.startOneShot(call Random.rand16() % (1024 * REPORT_PERIOD));
#endif


#ifdef SERVICE_DEST
    service_dest.sin6_port = hton16(5353);
    inet_pton6(SERVICE_DEST, &route_dest.sin6_addr);
    //    call ServicesPushTimer.startOneShot(call Random.rand16() % (1024 * SERVICE_PUSH_PERIOD));
    call ServicesPushTimer.startOneShot(1024 * SERVICE_PUSH_PERIOD);
#endif

    dbg("Boot", "booted: %i\n", TOS_NODE_ID);

    tosnodeid = TOS_NODE_ID;

#if defined(PLATFORM_TELOSB)
    if (call SerialId.read(serial) == SUCCESS) {};
    if (call MoteIdDb.getUsbId(serial, usbid) == SUCCESS) {};
    if (call MoteIdDb.getShortAddr(serial, &tosnodeid) == SUCCESS) {
      dbg("Boot", "resetting id to: %i\n", tosnodeid);
      call IPAddress.setShortAddr(tosnodeid);
      call CC2420Config.sync();
    };
#endif

    call Echo.bind(7);
    call Status.bind(7001);
    call Services.bind(7002);
  }

  event void RadioControl.startDone(error_t e) {

  }

  event void RadioControl.stopDone(error_t e) {
  }

  event void CC2420Config.syncDone(error_t error) {

  }

  event void Status.recvfrom(struct sockaddr_in6 *from, void *data,
                             uint16_t len, struct ip_metadata *meta) {

  }

  event void Echo.recvfrom(struct sockaddr_in6 *from, void *data,
                           uint16_t len, struct ip_metadata *meta) {
    call Echo.sendto(from, data, len);
  }

  char *id_string = "\t[serialID: %x:%x:%x:%x:%x:%x]\n\t[usbID: %c%c%c%c%c%c%c%c]\n\t[addr: 0x%x]\n";

  event char *ShellCommand.eval(int argc, char **argv) {
    char *ret = call ShellCommand.getBuffer(50);

    if (ret != NULL) {
      snprintf(ret, strlen(id_string), id_string,
	       serial[0], serial[1], serial[2],
	       serial[3], serial[4], serial[5],
	       usbid[0], usbid[1], usbid[2], usbid[3],
	       usbid[4], usbid[5], usbid[6], usbid[7],
	       tosnodeid);
    }

    return ret;
  }

  event void Services.recvfrom(struct sockaddr_in6 *from, void *data,
			       uint16_t len, struct ip_metadata *meta) {
  }

  event void StatusTimer.fired() {

    if (!statusTimerStarted) {
      call StatusTimer.startPeriodic(1024 * REPORT_PERIOD);
      statusTimerStarted = TRUE;
    }

    stats.seqno++;
    stats.sender = TOS_NODE_ID;

    call IPStats.get(&stats.ip);
    call UDPStats.get(&stats.udp);
    call ICMPStats.get(&stats.icmp);
    call RouteStats.get(&stats.route);

    call Status.sendto(&route_dest, &stats, sizeof(stats));
  }


  event void ServicesPushTimer.fired() {
    char* id    = "01";
    char* wsn   = "_wsn";
    char* udp   = "_udp";
    char* local = "local";

    uint8_t id_len    = 2;
    uint8_t wsn_len   = 4;
    uint8_t udp_len   = 4;
    uint8_t local_len = 5;

    if (!servicePushTimerStarted) {
      call ServicesPushTimer.startPeriodic(1024 * SERVICE_PUSH_PERIOD);
      servicePushTimerStarted = TRUE;
    }

    service.transaction_id = 0x0;
    service.flags     = FLAG_RESPONSE | FLAG_AUTHORATIVE;
    service.questions = 0;
    service.answer_rr = 2;
    service.auth_rr   = 0;
    service.additional_rr = 0;

    // X01X_wsnX_udpXlocal
    //  +1||   ||   ||
    //    +id_len   ||
    //     +1  ||   ||
    //         +wsn_len
    //          +1  ||
    //              +udp_len
    //               +1

    // TODO: more beautiful...
    memcpy(service.srv_answer.name, &id_len, 1);
    memcpy(service.srv_answer.name + 1, id, id_len);

    memcpy(service.srv_answer.name + 1 + id_len, &wsn_len, 1);
    memcpy(service.srv_answer.name + 2 + id_len, wsn, wsn_len);

    memcpy(service.srv_answer.name + 2 + id_len + wsn_len, &udp_len, 1);
    memcpy(service.srv_answer.name + 3 + id_len + wsn_len, udp, udp_len);

    memcpy(service.srv_answer.name + 3 + id_len + wsn_len + udp_len, &local_len, 1);
    memcpy(service.srv_answer.name + 4 + id_len + wsn_len + udp_len, local, local_len +1); // final '0'

    service.srv_answer.type   = TYPE_SRV;
    service.srv_answer.class  = CACHE_FLUSH_TRUE | CLASS_IN;
    service.srv_answer.ttl    = 120;
    service.srv_answer.data_length = MAX_SNAME_LENGTH +6; // CHECK
    service.srv_answer.prio   = 0;
    service.srv_answer.weight = 0;
    service.srv_answer.port   = 5353;

    // TODO: more beautiful
    memcpy(service.srv_answer.target, &id_len, 1);
    memcpy(service.srv_answer.target + 1, id, id_len);

    memcpy(service.srv_answer.target + 1 + id_len, &local_len, 1);
    memcpy(service.srv_answer.target + 2 + id_len, local, local_len +1); // final '0'
    //strncpy((char*)service.srv_answer.target, "node1.local", MAX_DATA_LENGTH);

    // TODO: more beautiful
    memcpy(service.a4_answer.name, &id_len, 1);
    memcpy(service.a4_answer.name + 1, id, id_len);

    memcpy(service.a4_answer.name + 1 + id_len, &local_len, 1);
    memcpy(service.a4_answer.name + 2 + id_len, local, local_len +1); // final '0'
    //strncpy((char*)service.a4_answer.name, "node1.local", MAX_SNAME_LENGTH);
    service.a4_answer.type  = TYPE_AAAA;
    service.a4_answer.class = CACHE_FLUSH_TRUE | CLASS_IN;
    service.a4_answer.ttl   = 120;
    service.a4_answer.data_length = MAX_DATA_LENGTH;
    service.a4_answer.addr[ 0] = 0xfe;
    service.a4_answer.addr[ 1] = 0xc0;
    service.a4_answer.addr[ 2] = 0x0;
    service.a4_answer.addr[ 3] = 0x0;
    service.a4_answer.addr[ 4] = 0x0;
    service.a4_answer.addr[ 5] = 0x0;
    service.a4_answer.addr[ 6] = 0x0;
    service.a4_answer.addr[ 7] = 0x0;
    service.a4_answer.addr[ 8] = 0x0;
    service.a4_answer.addr[ 9] = 0x0;
    service.a4_answer.addr[10] = 0x0;
    service.a4_answer.addr[11] = 0x0;
    service.a4_answer.addr[12] = 0x0;
    service.a4_answer.addr[13] = 0x0;
    service.a4_answer.addr[14] = 0x0;
    service.a4_answer.addr[15] = tosnodeid;

    //service.type = SOURCE_SERVICE_TYPE;

    //strncpy((char*)service.name, "Temperature", MAX_NAME_LENGTH);
    // FIXME? char* -> nx_uint8_t OK?

    call Services.sendto(&service_dest, &service, sizeof(service));
  }
}
