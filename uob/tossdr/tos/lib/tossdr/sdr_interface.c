/*
 * "Copyright (c) 2005 Stanford University. All rights reserved.
 *
 * Permission to use, copy, modify, and distribute this software and
 * its documentation for any purpose, without fee, and without written
 * agreement is hereby granted, provided that the above copyright
 * notice, the following two paragraphs and the author appear in all
 * copies of this software.
 *
 * IN NO EVENT SHALL STANFORD UNIVERSITY BE LIABLE TO ANY PARTY FOR
 * DIRECT, INDIRECT, SPECIAL, INCIDENTAL, OR CONSEQUENTIAL DAMAGES
 * ARISING OUT OF THE USE OF THIS SOFTWARE AND ITS DOCUMENTATION, EVEN
 * IF STANFORD UNIVERSITY HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH
 * DAMAGE.
 *
 * STANFORD UNIVERSITY SPECIFICALLY DISCLAIMS ANY WARRANTIES,
 * INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
 * MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.  THE SOFTWARE
 * PROVIDED HEREUNDER IS ON AN "AS IS" BASIS, AND STANFORD UNIVERSITY
 * HAS NO OBLIGATION TO PROVIDE MAINTENANCE, SUPPORT, UPDATES,
 * ENHANCEMENTS, OR MODIFICATIONS."
 */

/**
 *
 * Injecting packets into TOSSIM.
 *
 * @author Markus Becker
 * @date   Apr 21 2009
 */

#include <sdr_interface.h>
#include <stdio.h>

TosSdrInterface::TosSdrInterface() {
}

TosSdrInterface::~TosSdrInterface() {
}

void TosSdrInterface::data2SdrDone() {
    //printf("SdrInterface: sendDone\n");
    sim_signal_data2SdrDone(); // from SdrTransmitP.nc
    //printf("SdrInterface: sendDone2\n");
}

void TosSdrInterface::receive(char* payload, int len) {
    //printf("SdrInterface: receive\n");
    printf("SdrInterface: receive &payload %x payload %x\n", &payload, payload);
    sim_signal_receive(payload, len); // from SdrReceiveP.nc
    //printf("SdrInterface: receive2\n");
}
