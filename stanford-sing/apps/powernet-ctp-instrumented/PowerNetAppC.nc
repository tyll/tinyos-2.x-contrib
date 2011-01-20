/*
 * "Copyright (c) 2009 Stanford University. All rights reserved.
 *
 * Permission to use, copy, modify, and distribute this software and
 * its documentation for any purpose, without fee, and without written
 * agreement is hereby granted, provided that the above copyright
 * notice, the following two paragraphs and the author appear in all
 * copies of this software.
 *
 * IN NO EVENT SHALL STANFORD UNIVERSITY BE LIABLE TO ANY
 * PARTY FOR DIRECT, INDIRECT, SPECIAL, INCIDENTAL, OR CONSEQUENTIAL
 * DAMAGES ARISING OUT OF THE USE OF THIS SOFTWARE AND ITS
 * DOCUMENTATION, EVEN IF STANFORD UNIVERSITY HAS BEEN
 * ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 *
 * STANFORD UNIVERSITY SPECIFICALLY DISCLAIMS ANY WARRANTIES,
 * INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
 * MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.  THE SOFTWARE
 * PROVIDED HEREUNDER IS ON AN "AS IS" BASIS, AND THE UNIVERSITY OF
 * CALIFORNIA HAS NO OBLIGATION TO PROVIDE MAINTENANCE, SUPPORT,
 * UPDATES, ENHANCEMENTS, OR MODIFICATIONS."
 *
 */


/* Wiring to powernet test application
*
* @author Maria A. Kazandjieva, <mariakaz@cs.stanford.edu>
* @date Nov 18, 2008 
*/

#include "ctp/Ctp.h"

configuration PowerNetAppC {}

implementation {
    components MainC;
    components LedsC;
    components ADE7753C;
    components PowerNetAppP;
    components new TimerMilliC() as Timer;
    components new TimerMilliC() as CtpTimer;
    components ActiveMessageC;
    components CollectionC as Collector;
    components new CollectionSenderC(AM_METER_MSG);
    components CtpInstrumentationP;
    components DelugeC;
    components RandomC;

    DelugeC.Leds -> LedsC;
    PowerNetAppP.Boot -> MainC;
    PowerNetAppP.Send -> CollectionSenderC; 
    PowerNetAppP.Receive -> Collector.Receive[AM_METER_MSG];
    PowerNetAppP.AMControl -> ActiveMessageC;
    PowerNetAppP.ADE7753 -> ADE7753C.ADE7753;
    PowerNetAppP.Timer -> Timer;
    PowerNetAppP.CtpTimer -> CtpTimer;
    PowerNetAppP.Leds -> LedsC;
    PowerNetAppP.RoutingControl -> Collector;
    PowerNetAppP.CtpInstrumentation -> CtpInstrumentationP;
    PowerNetAppP.Random -> RandomC;
}
