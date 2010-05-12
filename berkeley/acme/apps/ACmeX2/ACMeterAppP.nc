/* "Copyright (c) 2008 The Regents of the University  of California.
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

/**
 * ACme Energy Monitor
 * @author Fred Jiang <fxjiang@eecs.berkeley.edu>
 * @version $Revision$
 */

#include <ip.h>
#include <Shell.h>

#include <IPDispatch.h>

#include <Timer.h>

#include "ACReport.h"
#include "PrintfUART.h"

#define PERIOD 60

module ACMeterAppP {
  uses {
    interface Boot;
    interface SplitControl as RadioControl;
    interface UDP as ReportSend;
    interface Leds;
    interface SplitControl as MeterControl;
    interface ACMeter;
    interface ShellCommand as ReadCmd;
    interface ShellCommand as SetCmd;
    // interface ShellCommand as CalCmd;
    interface ShellCommand as PeriodCmd;
    interface ShellCommand as ResetCmd;
	interface Statistics<route_statistics_t> as RouteStats;
	interface Timer<TMilli> as Timer;
	interface Random;
	interface LocalIeeeEui64;
  }

} implementation {

  bool timerStarted;
  nx_struct ac_report report;
  struct sockaddr_in6 report_dest;

  uint32_t power;
  uint32_t energy;
  uint64_t totalEnergy;
  uint32_t maxPower;
  uint32_t minPower;
  uint32_t averagePower;
  uint32_t apparentPower;
  uint32_t sumApparentPower;
  uint32_t mySeq;
  uint16_t tick;
  uint16_t myPeriod;
  ieee_eui64_t eui;

  event void Boot.booted() {
    myPeriod = PERIOD;
    power = 0;
    energy = 0;
    totalEnergy = 0;
    maxPower = 0;
    minPower = 99999;
    averagePower = 0;
	apparentPower = 0;
	sumApparentPower = 0;
    tick = 0;
    mySeq = 0;
  	
	eui = call LocalIeeeEui64.getId();
	
    call RouteStats.clear();
    call RadioControl.start();

    report_dest.sin6_port = hton16(7001);
    // memcpy(&report_dest.sin_addr, router_address, 16);
    inet_pton6(REPORT_ADDR, &report_dest.sin6_addr);

    printfUART_init();

  }

  event void RadioControl.startDone(error_t e) {
    call MeterControl.start();
  }

  event void RadioControl.stopDone(error_t e) {

  }

  event void MeterControl.startDone(error_t e) {
    if (e == SUCCESS) {
		call Timer.startOneShot(call Random.rand16() % (60L*1024L));
//		call ACMeter.start(1024);
    } else {
    }
  }

  event void Timer.fired() {
	  call ACMeter.start(1024);
  }
  
  
  event void MeterControl.stopDone(error_t e) {
    
  }

  event void ReportSend.recvfrom(struct sockaddr_in6 *from,
                                 void *data, uint16_t len,
                                 struct ip_metadata *meta) {

  }


#define MAX_REPLY_LEN 100

  event void ACMeter.sampleDone(uint32_t aenergy, uint32_t vaenergy) {
	// aenergy is active energy
	// vaenergy is apparent energy
    tick++;
    power = aenergy;
	apparentPower = vaenergy;
    if (power > maxPower) maxPower = power;
    if (power < minPower) minPower = power;
    energy += power;
	totalEnergy += power;
	sumApparentPower += apparentPower;
	
    if (tick >= myPeriod) {
      averagePower = energy / myPeriod;
      report.averagePower = averagePower;
      report.maxPower = maxPower;
      report.minPower = minPower;
	  report.cumulativeEnergy = totalEnergy;
	  report.apparentPower = sumApparentPower / myPeriod;
	
      maxPower = 0;
      minPower = 99999;
      energy = 0;
      tick = 0;
	  sumApparentPower = 0;
      //		  call Leds.led1Toggle();
      report.seq = mySeq;
      mySeq++;
	  call RouteStats.get(&report.route);
	  memcpy(report.eui64, eui.data, IEEE_EUI64_LENGTH);
      call ReportSend.sendto(&report_dest, &report, sizeof(nx_struct ac_report));
    }
  }

  event char *ReadCmd.eval(int argc, char **argv) {
    int len;
    char *reply_buf = call ReadCmd.getBuffer(MAX_REPLY_LEN);

    if (argc < 2) return NULL;
      
    if (!strcmp(argv[1], "average"))
      len = snprintf(reply_buf, MAX_REPLY_LEN, "Average power: %li watts\n",
                     power);
//    else if (!strcmp(argv[1], "min"))
//      len = snprintf(reply_buf, MAX_REPLY_LEN, "Min power: %li watts\n", minPower);
//    else if (!strcmp(argv[1], "max"))
//      len = snprintf(reply_buf, MAX_REPLY_LEN, "Max power: %li watts\n", maxPower);
    else if (!strcmp(argv[1], "apparent"))
      len = snprintf(reply_buf, MAX_REPLY_LEN, "Apparent power: %li watts\n",
                     apparentPower);
//    else if (!strcmp(argv[1], "energy"))
//      len = snprintf(reply_buf, MAX_REPLY_LEN, "Energy: %li jouls\n", energy);
    else if (!strcmp(argv[1], "cumulativeEnergy"))
      len = snprintf(reply_buf, MAX_REPLY_LEN, "Cumulative energy: %lli jouls\n", totalEnergy);
    else
      len = snprintf(reply_buf, MAX_REPLY_LEN, "Invalid argument\n");
    return reply_buf;
  }

  event char *SetCmd.eval(int argc, char **argv) {
    if (argc < 2) return NULL;
    if (!strcmp(argv[1], "on"))
      call ACMeter.set(TRUE);
    if (!strcmp(argv[1], "off"))
      call ACMeter.set(FALSE);
    return NULL;
  }

  event char *PeriodCmd.eval(int argc, char **argv) {
    int len;
    char *reply_buf = call PeriodCmd.getBuffer(MAX_REPLY_LEN);
    if (argc < 2) return NULL;
    myPeriod = atoi(argv[1]);
    len = snprintf(reply_buf, MAX_REPLY_LEN,
                   "Reporting period: %i seconds\n", myPeriod);
    return reply_buf;
  }

  event char *ResetCmd.eval(int argc, char **argv) {
    int len;
    char *reply_buf = call ResetCmd.getBuffer(MAX_REPLY_LEN);
    if (argc < 1) return NULL;
    len = snprintf(reply_buf, MAX_REPLY_LEN,
                   "Total energy reseted from %lli to 0\n", totalEnergy);
	totalEnergy = 0;
    return reply_buf;
  }

  /*
    event char *CalCmd.eval(int argc, char **argv) {
    int len;
    char *reply_buf = call PeriodCmd.getBuffer(MAX_REPLY_LEN);
    
    uint16_t watt;
    double coeff;
    if (argc < 2) return NULL;
    watt = (double) atoi(argv[1]);
    coeff = (double) power / (double) watt;
    len = snprintf(reply_buf, MAX_REPLY_LEN,
    "W: %f, P: %f, Calibration coefficient: %4.2f tick/watt\n", watt, (double) power, (double) coeff);
    return reply_buf;
    }
  */
}
