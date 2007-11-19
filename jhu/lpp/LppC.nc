/* Copyright (c) 2007 Johns Hopkins University.
*  All rights reserved.
*
*  Permission to use, copy, modify, and distribute this software and its
*  documentation for any purpose, without fee, and without written
*  agreement is hereby granted, provided that the above copyright
*  notice, the (updated) modification history and the author appear in
*  all copies of this source code.
*
*  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS `AS IS'
*  AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
*  IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
*  ARE DISCLAIMED.  IN NO EVENT SHALL THE COPYRIGHT HOLDERS OR CONTRIBUTORS
*  BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
*  CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, LOSS OF USE, DATA,
*  OR PROFITS) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
*  CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
*  ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF
*  THE POSSIBILITY OF SUCH DAMAGE.
*/

/**
 * Low Power Probing (LPP) is a LPL technique in which:
 * - the probing for activity is done by sending an empty broadcast
 *   packet and 
 * - the wake-up is triggered (signaling SplitControl.startDone) when
 *   the broadcast packet is acked.
 *
 * This implementation is for CC2420 and is using hardware acks. The
 * AM ID used for probing is 10 (defined in Lpp.h).
 *
 * @author Razvan Musaloiu-E. <razvanm@cs.jhu.edu>
 */

#include "Lpp.h"

configuration LppC
{
  provides {
    interface SplitControl;
    interface LowPowerProbing as Lpp;
    interface AMSend[uint8_t id];
  }
  uses {
    interface SplitControl as SubSplitControl;
    interface AMSend as SubAMSend[uint8_t id];
  }
}

implementation
{
  components MainC, ActiveMessageC, CC2420PacketC, CC2420ControlC;
  components new AMSenderC(SLOW_LPL_AM);
  components new TimerMilliC() as Timer;
  components LppP;
  components RandomC;
  components LedsC, NoLedsC;

  SplitControl = LppP;
  SubSplitControl = LppP;
  Lpp = LppP;
  AMSend = LppP;
  SubAMSend = LppP.SubAMSend;
  
  LppP.Boot -> MainC;
  LppP.Timer -> Timer;
  LppP.Acks -> ActiveMessageC;
  LppP.BeaconAMSend -> AMSenderC;
  LppP.CC2420Config -> CC2420ControlC;
  LppP.Random -> RandomC;
  LppP.Leds -> NoLedsC;
}
