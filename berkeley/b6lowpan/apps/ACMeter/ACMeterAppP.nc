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
#include <ip.h>
#include <router_address.h>

#include "ACReport.h"
#include "PrintfUART.h"

module ACMeterAppP {
  uses {
    interface Boot;
    interface SplitControl as RadioControl;
    interface UDP as Shell;
    interface UDP as ReportSend;

    interface Leds;
    
    interface SplitControl as MeterControl;
    interface ACMeter;
  }

} implementation {

  bool timerStarted;
  nx_struct ac_report report;
  struct sockaddr_in6 report_dest;

  char *help = "Outlet commands:\n\
  help - print this mesage\n\
  toggle - switch the light's state\n\
  set [on|off] - set the state\n\
  read - print the last power value\n";

  const char *cmd_toggle = "toggle";
  const char *cmd_set = "set";
  const char *cmd_set_on = "on";
  const char *cmd_set_off = "off";
  const char *cmd_read = "read";

  event void Boot.booted() {
    call RadioControl.start();

    report_dest.sin_port = hton16(7001);
    memcpy(&report_dest.sin_addr, router_address, 16);


    printfUART_init();

  }

  event void RadioControl.startDone(error_t e) {
    call MeterControl.start();
  }

  event void RadioControl.stopDone(error_t e) {

  }

  event void MeterControl.startDone(error_t e) {
    if (e == SUCCESS) {
      call ACMeter.start(1024);
    }
  }

  event void MeterControl.stopDone(error_t e) {
    
  }

  event void ReportSend.recvfrom(struct sockaddr_in6 *from,
                                 void *data, uint16_t len,
                                 struct ip_metadata *meta) {

  }

#define MAX_REPLY_LEN 100
  event void Shell.recvfrom(struct sockaddr_in6 *from,
                            void *data, uint16_t len,
                            struct ip_metadata *meta) {
    char rbuf[MAX_REPLY_LEN];
    char *reply = rbuf;

    if (memcmp(data, cmd_toggle, strlen(cmd_toggle)) == 0) {
      call ACMeter.toggle();
    } else if (memcmp(data, cmd_set, strlen(cmd_set)) == 0) {
      char *cmd = (char *)data;
      cmd += strlen(cmd_set);
      while (cmd - (char*)data < len && *cmd == ' ') cmd++;
      if (memcmp(cmd, cmd_set_on, strlen(cmd_set_on)) == 0) {
        call ACMeter.set(TRUE);
        call Leds.led1Toggle();
      } else if (memcmp(cmd, cmd_set_off, strlen(cmd_set_off)) == 0)
        call ACMeter.set(FALSE);
      else reply = help;
    } else if (memcmp(data, cmd_read, strlen(cmd_read)) == 0) {
      // fall through...
    } else {
      reply = help;
    }

    snprintf(rbuf, MAX_REPLY_LEN, "OK: switch: %i power: %li watts\n", call ACMeter.getState(), report.data / 5);

    call Shell.sendto(from, reply, strlen(reply));
  }

  event void ACMeter.sampleDone(uint32_t energy) {
    report.data = energy;
    call ReportSend.sendto(&report_dest, &report, sizeof(nx_struct ac_report));
  }
}
