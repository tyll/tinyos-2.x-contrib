/**
 * "Copyright (c) 2007 CENTRE FOR ELECTRONICS AND DESIGN TECHNOLOGY,IISc.
 *  All rights reserved.
 *
 * Permission to use, copy, modify, and distribute this software and
 * its documentation for any purpose, without fee, and without written
 * agreement is hereby granted, provided that the above copyright
 * notice, the following two paragraphs and the author appear in all
 * copies of this software.
 *
 * IN NO EVENT SHALL CENTRE FOR ELECTRONICS AND DESIGN TECHNOLOGY,IISc BE LIABLE TO
 * ANY PARTY FOR DIRECT, INDIRECT, SPECIAL, INCIDENTAL, OR CONSEQUENTIAL DAMAGES
 * ARISING OUT OF THE USE OF THIS SOFTWARE AND ITS DOCUMENTATION, EVEN
 * IF CENTRE FOR ELECTRONICS AND DESIGN TECHNOLOGY,IISc HAS BEEN ADVISED OF THE
 * POSSIBILITY OF SUCH DAMAGE.
 *
 * CENTRE FOR ELECTRONICS AND DESIGN TECHNOLOGY,IISc SPECIFICALLY DISCLAIMS
 * ANY WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
 * MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.  THE SOFTWARE
 * PROVIDED HEREUNDER IS ON AN "AS IS" BASIS, AND CENTRE FOR ELECTRONICS
 * AND DESIGN TECHNOLOGY,IISc HAS NO OBLIGATION TO PROVIDE MAINTENANCE,
 * SUPPORT, UPDATES, ENHANCEMENTS, OR MODIFICATIONS."
 *
 */
 
 
/**
 * This acts a channel provider for the nodes to access and then release 
 * the channel after transmission
 *
 * @author Venkatesh S
 * @author Prabhakar T V
 */

#include <stdio.h>
#include <sim_channel.h>

sim_channel_t cc1k_channel;

void sim_channel_init()
{
  cc1k_channel.channel = FALSE;
}

void sim_channel_acquire(){
  cc1k_channel.channel = TRUE;
  cc1k_channel.nodeId = sim_node();
  dbg("CC1000Channel","Channel acquired by node %d\n",cc1k_channel.nodeId);
}

bool sim_channel_get(){
  return cc1k_channel.channel;
}

void sim_channel_release(){
  if(sim_node()==cc1k_channel.nodeId) {
    dbg("CC1000Channel","Channel released by node %d\n",cc1k_channel.nodeId);
    cc1k_channel.channel = FALSE;
  }
}


