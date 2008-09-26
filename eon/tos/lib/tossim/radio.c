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
 * C++ implementation of the gain-based TOSSIM radio model.
 *
 * @author Philip Levis
 * @date   Dec 10 2005
 */
 
 /**
 *
 * Modified to accomodate simplified radio model w/energy stuff added for eon simulations
 *
 * @author Jacob Sorber
 * @date   Sep 18 2008
 */

#include <radio.h>
#include <sim_radio.h>

Radio::Radio() {}
Radio::~Radio() {}

void Radio::add(int src, int dest, int cap, double energy_per_pkt, sim_time_t expires) {
  sim_radio_add(src, dest, cap, energy_per_pkt,expires);
}

int Radio::capacity(int src, int dest) {
  return sim_radio_capacity(src, dest);
}

bool Radio::connected(int src, int dest) {
  return sim_radio_connected(src, dest);
}

void Radio::remove(int src, int dest) {
  sim_radio_remove(src, dest);
}



