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
    interface ShellCommand as SetShellCommand;

#if defined(PLATFORM_TELOSB)
    interface ReadId48 as SerialId;

    interface MoteIdDb;
    interface IPAddress;
    interface CC2420Config;
#endif
  }

} implementation {

  bool timerStarted = FALSE;
  bool measToggle = FALSE;
  bool server_set = FALSE;
  bool port_set = FALSE;

  nx_struct udp_report stats;
  struct sockaddr_in6 route_dest;

  nx_struct udp_measurement meas;
  struct sockaddr_in6 meas_dest;

  uint8_t serial[6] = {0x0, 0x0, 0x0, 0x0, 0x0, 0x0};
  char usbid[USB_ID_SIZE] = "00000000";
  ieee154_saddr_t tosnodeid = 0xff;

  uint16_t measurement_period = 4;

  enum {
    N_BUILTINS = 3,
    /*    CMD_SERVER = 0,
    CMD_PORT = 1,
    CMD_MEAS_PERIOD = 2,*/
    CMD_NO_CMD = 0xfe,
    CMDNAMSIZ = 11,
  };

  struct cmd_name {
    uint8_t c_len;
    char c_name[CMDNAMSIZ];
  };
  struct cmd_builtin {
    bool (*action)(int, char **);
  };


  event void Boot.booted() {
    call RadioControl.start();

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
    //inet_pton6("fec0::66", &meas_dest.sin6_addr); // FIXME: hardcoded IP

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

#define CHAR_VAL(X)  ((X) - '0')

  uint16_t atoi(char *p) {
    uint16_t cur = 0;

    while (*p != '\0') {
      cur *= 10;
      cur |= CHAR_VAL(*p);
      p++;
      if (*p == '\0')
	return cur;
    }
    return cur;
  }

  bool set_server(int argc, char **argv) {
    if (argc < 3) return FALSE;

    server_set = TRUE;
    inet_pton6(argv[2], &meas_dest.sin6_addr); // does no error checking...
    return TRUE;
  }

  bool set_port(int argc, char **argv) {
    if (argc < 3) return FALSE;

    port_set = TRUE;
    meas_dest.sin6_port = hton16(atoi(argv[2]));
    return TRUE;
  }

  bool set_meas_period(int argc, char **argv) {
    if (argc < 3) return FALSE;

    measurement_period = atoi(argv[2]);
    return TRUE;
  }

  struct cmd_name set[N_BUILTINS] = {{6,  "server"},
				     {4,  "port"},
				     {11, "meas_period"}};
  struct cmd_builtin set_actions[N_BUILTINS] = {{set_server},
						{set_port},
						{set_meas_period}};

  int lookup_cmd(char *cmd, int dbsize, struct cmd_name *db) {
    int i;
    for (i = 0; i < dbsize; i++) {
      if (memcmp(cmd, db[i].c_name, db[i].c_len) == 0
	  && cmd[db[i].c_len] == '\0')
	return i;
    }
    return CMD_NO_CMD;
  }

  char* set_string = "";
  char *wrong_arg_string = "Usage:  set <option> <value>\noptions: server, port, meas_period\n";
  char *set_ok_string = "set OK\n";
  char *set_wrong_string = "no such option: %s\n";

  event char *SetShellCommand.eval(int argc, char **argv) {
    char *ret = call MeasShellCommand.getBuffer(50);
    int cmd;
    bool cmd_ok;

    if (ret != NULL) {
      if (argc < 3) {
	snprintf(ret, strlen(wrong_arg_string), wrong_arg_string);
	return ret;
      } else {
	cmd = lookup_cmd(argv[1], N_BUILTINS, set);
	if (cmd != CMD_NO_CMD) {
	  cmd_ok = set_actions[cmd].action(argc, argv);
	  if (cmd_ok) {
	    snprintf(ret, strlen(set_ok_string), set_ok_string);
	  } else {
	    snprintf(ret, strlen(wrong_arg_string), wrong_arg_string);
	  }
	  return ret;
	} else {
	  snprintf(ret, strlen(wrong_arg_string), set_wrong_string, argv[0]);
	  return ret;
	}
      }
    }

    return ret;
  }

  char *meas_on_string = "\t[measure: on]\n";
  char *meas_off_string = "\t[measure: off]\n";
  char *set_config_string = "[ERR: set server and port first]\n";
  event char *MeasShellCommand.eval(int argc, char **argv) {
    char *ret = call MeasShellCommand.getBuffer(50);

    if (ret != NULL) {
      if (!server_set || !port_set) {
	snprintf(ret, strlen(set_config_string), set_config_string);
	return ret;
      }

      if (measToggle == FALSE) {
	measToggle = TRUE;
	signal MeasurementTimer.fired();
	snprintf(ret, strlen(meas_on_string), meas_on_string,
		 measToggle);
      } else {
	measToggle = FALSE;
	call MeasurementTimer.stop();
	snprintf(ret, strlen(meas_off_string), meas_off_string,
		 measToggle);
      }
    }
    return ret;
  }

  event void MeasurementTimer.fired() {
    call MeasCollector.readAllSensors();
    if (measToggle == TRUE) {
      call MeasurementTimer.startOneShot(1024 * measurement_period);
    }
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
