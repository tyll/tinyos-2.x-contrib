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
 * The C functions that allow TOSSIM-side code to access the SimMoteP
 * component.
 *
 * @author Philip Levis
 * @date   Nov 22 2005
 */

 /**
  * Simplified to improve performance for the eon simulator
  * @author Jacob Sorber
  *
 */



#ifndef SIM_RADIO_H_INCLUDED
#define SIM_RADIO_H_INCLUDED


#ifdef __cplusplus
extern "C" {
#endif


#include <tos.h>
//#include <sim_tossim.h>

typedef struct radio_entry {
  int mote;
  int cap;
  double energy_per_pkt;
  sim_time_t expires;
  struct radio_entry* next;  
} radio_entry_t;
  
void sim_radio_add(int src, int dest, int cap, double energy_per_pkt, sim_time_t expires);
int sim_radio_capacity(int src, int dest);
void sim_radio_set_capacity(int src, int dest, int newcap);
bool sim_radio_consume_capacity(int src, int dest, int delta);
bool sim_radio_connected(int src, int dest);
void sim_radio_remove(int src, int dest);

 
radio_entry_t* sim_radio_first(int src);
radio_entry_t* sim_radio_next(radio_entry_t* e);
  
#ifdef __cplusplus
}
#endif
  
#endif // SIM_GAIN_H_INCLUDED
