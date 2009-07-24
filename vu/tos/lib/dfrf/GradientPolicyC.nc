/*
 * Copyright (c) 2009, Vanderbilt University
 * All rights reserved.
 *
 * Permission to use, copy, modify, and distribute this software and its
 * documentation for any purpose, without fee, and without written agreement is
 * hereby granted, provided that the above copyright notice, the following
 * two paragraphs and the author appear in all copies of this software.
 *
 * IN NO EVENT SHALL THE VANDERBILT UNIVERSITY BE LIABLE TO ANY PARTY FOR
 * DIRECT, INDIRECT, SPECIAL, INCIDENTAL, OR CONSEQUENTIAL DAMAGES ARISING OUT
 * OF THE USE OF THIS SOFTWARE AND ITS DOCUMENTATION, EVEN IF THE VANDERBILT
 * UNIVERSITY HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 *
 * THE VANDERBILT UNIVERSITY SPECIFICALLY DISCLAIMS ANY WARRANTIES,
 * INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY
 * AND FITNESS FOR A PARTICULAR PURPOSE.  THE SOFTWARE PROVIDED HEREUNDER IS
 * ON AN "AS IS" BASIS, AND THE VANDERBILT UNIVERSITY HAS NO OBLIGATION TO
 * PROVIDE MAINTENANCE, SUPPORT, UPDATES, ENHANCEMENTS, OR MODIFICATIONS.
 *
 * Author: Miklos Maroti, Gabor Pap, Janos Sallai
 */

configuration GradientPolicyC
{
	provides
	{
		interface DfrfPolicy;
	}
}

implementation
{
	components GradientPolicyP, GradientFieldP;

	components new TimerMilliC() as TimerC, ActiveMessageC as AM, LedsC;

  components BroadcastPolicyC as Policy;
  components new DfrfClientC(APPID_GRADIENTFIELD, gradient_field_packet_t, offsetof(gradient_field_packet_t,hopCount), 16) as DfrfService;

  // routing control/send/receive/policy
  GradientFieldP.DfrfControl -> DfrfService.StdControl;
  GradientFieldP.DfrfSend -> DfrfService;
  GradientFieldP.DfrfReceive -> DfrfService;
  DfrfService.Policy -> Policy;

	DfrfPolicy = GradientPolicyP;
  GradientPolicyP.GradientField -> GradientFieldP;
	GradientFieldP.Timer -> TimerC;
	GradientFieldP.AMPacket -> AM;
	GradientFieldP.Leds -> LedsC;

  components GradientPolicyCommandsC;

}
