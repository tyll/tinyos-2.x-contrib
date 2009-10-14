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

#include "UDPReport.h"
#include "PrintfUART.h"

#include "MoteIdDb.h"

#define REPORT_PERIOD 75L
#define MEASUREMENT_PERIOD 4L

module UDPEchoP {
  uses {
    interface Boot;
    interface SplitControl as RadioControl;

    interface UDP as Echo;
    interface UDP as Status;
    interface UDP as Measurements;

    interface Leds;

    interface Timer<TMilli> as StatusTimer;
    interface Timer<TMilli> as MeasurementTimer;

    interface MeasurementCollector as MeasCollector;

    interface Statistics<ip_statistics_t> as IPStats;
    interface Statistics<udp_statistics_t> as UDPStats;
    interface Statistics<route_statistics_t> as RouteStats;
    interface Statistics<icmp_statistics_t> as ICMPStats;

    interface Random;

    interface ShellCommand as IdShellCommand;
    interface ShellCommand as MeasShellCommand;

#if defined(PLATFORM_TELOSB)
    interface ReadId48 as SerialId;

    interface MoteIdDb;
    interface IPAddress;
    interface CC2420Config;
#endif
  }

} implementation {

  bool timerStarted;
  bool measToggle;

  nx_struct udp_report stats;
  struct sockaddr_in6 route_dest;

  nx_struct udp_measurement meas;
  struct sockaddr_in6 meas_dest;

  uint8_t serial[6] = {0x0, 0x0, 0x0, 0x0, 0x0, 0x0};
  char usbid[USB_ID_SIZE] = "00000000";
  ieee154_saddr_t tosnodeid = 0xff;

  event void Boot.booted() {
    call RadioControl.start();
    timerStarted = FALSE;
    measToggle = FALSE;

    call IPStats.clear();
    call RouteStats.clear();
    call ICMPStats.clear();
    printfUART_init();

#ifdef REPORT_DEST
    route_dest.sin6_port = hton16(7000);
    inet_pton6(REPORT_DEST, &route_dest.sin6_addr);
    call StatusTimer.startOneShot(call Random.rand16() % (1024 * REPORT_PERIOD));
#endif

    meas_dest.sin6_port = hton16(7000);
    inet_pton6("fec0::66", &meas_dest.sin6_addr); // FIXME: hardcoded IP

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
  event char *IdShellCommand.eval(int argc, char **argv) {
    char *ret = call IdShellCommand.getBuffer(50);

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

  char *meas_string = "\t[measure: %d]\n";
  event char *MeasShellCommand.eval(int argc, char **argv) {
    char *ret = call MeasShellCommand.getBuffer(50);

    if (ret != NULL) {

      if (measToggle == FALSE) {
	measToggle = TRUE;
	call MeasurementTimer.startPeriodic(1024 * MEASUREMENT_PERIOD);
      } else {
	measToggle = FALSE;
	call MeasurementTimer.stop();
      }

      snprintf(ret, strlen(meas_string), meas_string,
	       measToggle);
    }

    return ret;
  }

  event void StatusTimer.fired() {

    if (!timerStarted) {
      call StatusTimer.startPeriodic(1024 * REPORT_PERIOD);
      timerStarted = TRUE;
    }

    stats.seqno++;
    stats.sender = TOS_NODE_ID;

    call IPStats.get(&stats.ip);
    call UDPStats.get(&stats.udp);
    call ICMPStats.get(&stats.icmp);
    call RouteStats.get(&stats.route);

    call Status.sendto(&route_dest, &stats, sizeof(stats));
  }

  event void Measurements.recvfrom(struct sockaddr_in6 *from, void *data,
				   uint16_t len, struct ip_metadata *meta) {

  }

  event void MeasurementTimer.fired() {
    call MeasCollector.readAllSensors();
  }

  event void MeasCollector.allMeasurementsDone(uint16_t temp,
					       uint16_t hum,
					       uint16_t volt,
					       uint16_t tsr,
					       uint16_t par,
					       uint8_t valid) {
    meas.seqno++;
    meas.sender = TOS_NODE_ID;

    meas.temp = temp;
    meas.hum  = hum;
    meas.volt = volt;
    meas.tsr  = tsr;
    meas.par  = par;

    meas.valid = valid;

    call Measurements.sendto(&meas_dest, &meas, sizeof(meas));
  }

}
