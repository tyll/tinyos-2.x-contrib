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

configuration ACMeterC {
	provides interface SplitControl;
	provides interface ACMeter;
}

implementation {
	components MainC;
	components ACMeterM, ADE7753P, LedsC;
	components new TimerMilliC() as TimerC;
	components new Msp430Spi1C() as SpiC;
	components HplMsp430GeneralIOC;
	
	SplitControl = ACMeterM;
	ACMeter = ACMeterM;
	MainC.SoftwareInit -> ADE7753P.Init;	
	ACMeterM.Leds -> LedsC;
	ACMeterM.ADE7753 -> ADE7753P;
	ACMeterM.MeterControl -> ADE7753P;
	ACMeterM.Timer -> TimerC;
	ACMeterM.onoff -> HplMsp430GeneralIOC.Port21;
	ADE7753P.SpiPacket -> SpiC;
	ADE7753P.SPIFRM -> HplMsp430GeneralIOC.Port54;
	ADE7753P.Leds -> LedsC;
	ADE7753P.Resource -> SpiC;
}
