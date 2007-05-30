/* packet-cc2420.c
 * Routines for cc2420 packet dissector.
 * Copyright 2007, Philipp Huppertz <huppertz@tkn.tu-berlin.de>
 *
 * $Id$
 *
 * Wireshark - Network traffic analyzer
 * By Gerald Combs <gerald@wireshark.org>
 * Copyright 1998 Gerald Combs
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License
 * as published by the Free Software Foundation; either version 2
 * of the License, or (at your option) any later version.
 * 
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 * 
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
 */

#ifdef HAVE_CONFIG_H
#include "config.h"
#endif

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include <glib.h>

#include <epan/packet.h>
#include <epan/prefs.h>

#include "packet-cc2420.h"

/* Forward declaration we need below */
void proto_reg_handoff_cc2420(void);

/* Initialize the protocol and registered fields */

/* phy / cc2420 stuff */
static int proto_cc2420 = -1;
static int hf_cc2420_length = -1;
static int hf_cc2420_fcs = -1;
static int hf_cc2420_crc = -1;
static int hf_cc2420_lqi = -1;
static int hf_cc2420_rssi = -1;
	
/* Global preferences */
/* pref for AM type to registrate with  */
static guint global_am_type_cc2420 = CC2420_STANDARD_AM_TYPE;
static guint am_type_cc2420 = CC2420_STANDARD_AM_TYPE;
static guint global_channel_cc2420 = CC2420_CHANNEL;
static guint channel_cc2420 = CC2420_CHANNEL;


/* Initialize the subtree pointers */
static gint ett_cc2420 = -1;

/* for sub dissectors */
static dissector_handle_t data_handle;
static heur_dissector_list_t heur_subdissector_list;

/* description for packet dispatch type */
static const true_false_string cc2420_crc_string = {
	"16 bit crc correct",
	"16 bit crc failed"
};

/* writes the channel given by the pref to a file, hoping that it's the
   named pipe read by the app which takes care of switching. any questions!? ;) */
static void setChannel_cc2420() {
  FILE* pipe = 0;
  pipe = fopen( "./sniffControlPipeIn", "a" );
  if (pipe) fprintf(pipe, "setChannel_cc2420 %i\n", channel_cc2420);
  fclose(pipe);
}
    
/* Code to actually dissect general frame fields */
static void dissect_cc2420(tvbuff_t *tvb, packet_info *pinfo, proto_tree *tree)
{  
	/* Set up structures needed to add the protocol subtree and manage it */
 	proto_item* ti;
  proto_item *fc;
 	proto_tree* tree_cc2420;
  proto_tree* fc_tree;
  unsigned int cc2420_length, available_length;
  tvbuff_t* next_tvb;

	tree_cc2420 = NULL;
 
  cc2420_length = tvb_get_guint8(tvb, 0);
    
  /* check if this cc2420 packet is really sane. If length is incorrect this might be another packet */
  if (cc2420_length+1 != tvb_length(tvb)) {
   	call_dissector(data_handle, tvb, pinfo, tree);
		return;
  }
  
	/* Make entries in Protocol column and Info column on summary display */
	if (check_col(pinfo->cinfo, COL_PROTOCOL)) 
		col_set_str(pinfo->cinfo, COL_PROTOCOL, "CC2420");

	if (check_col(pinfo->cinfo, COL_INFO)) {
		col_set_str(pinfo->cinfo, COL_INFO, "CC2420 Phy Frame");
  }

	if (tree) {
		/* create display subtree for the protocol */
 		ti = proto_tree_add_item(tree, proto_cc2420, tvb, 0, -1, FALSE);
 		tree_cc2420 = proto_item_add_subtree(ti, ett_cc2420);
    /* print cc2420 phy header */
    proto_tree_add_item(tree_cc2420, hf_cc2420_length, tvb, 0, 1, FALSE);
    /* tree for cc2420 phy footer / fcs */
    fc = proto_tree_add_item(tree_cc2420, hf_cc2420_fcs, tvb, tvb_length(tvb)-2, 2, FALSE);
    fc_tree = proto_item_add_subtree(fc, ett_cc2420);
    proto_tree_add_item(fc_tree, hf_cc2420_rssi, tvb, tvb_length(tvb)-2, 2, FALSE);
    proto_tree_add_item(fc_tree, hf_cc2420_crc, tvb, tvb_length(tvb)-2, 2, FALSE);
    proto_tree_add_item(fc_tree, hf_cc2420_lqi, tvb, tvb_length(tvb)-2, 2, FALSE);
	}
  
  /* Calculate the available data in the packet, 
     set this to -1 to use all the data in the tv_buffer (FCS field is passed to next dissector too)*/
  available_length = tvb_length(tvb) - CC2420_HEADER_LEN + 2;

	/* Create the tvbuffer for the next dissector, this also passes the last two bytes to subdissector */
  next_tvb = tvb_new_subset(tvb, CC2420_HEADER_LENGTH_OFFSET, MIN(cc2420_length, available_length), cc2420_length);
  
  /* try "heuristics */
  if (dissector_try_heuristic(heur_subdissector_list, next_tvb, pinfo, tree)) {
    return;
  }
  
	/* call the next dissector */
	call_dissector(data_handle, next_tvb, pinfo, tree);
  return;
}


/* Register the protocol with Wireshark */
void proto_register_cc2420(void)
{                 
	module_t *module_cc2420;

	/* 802.15.4 Header */
	static hf_register_info hf[] = {
    /* cc2420 specific phy header */
    { &hf_cc2420_length,	{ "Length", "cc2420.length", FT_UINT8, BASE_DEC, NULL, 0x0, "", HFILL } },
    /* cc2420 specific FCS */
    { &hf_cc2420_fcs,	{ "FCS", "cc2420.fcs", FT_NONE, FT_NONE, NULL, 0x0, "", HFILL } },
    { &hf_cc2420_crc,	{ "Crc", "cc2420.crc", FT_BOOLEAN, 16, TFS(&cc2420_crc_string), 0x80, "", HFILL } },
    /* cc2420 specific FCS fields containing rssi & lqi & crc_pass*/
    { &hf_cc2420_lqi,	{ "Lqi", "cc2420.lqi", FT_UINT16, BASE_HEX, NULL, 0x7f, "", HFILL } },
    { &hf_cc2420_rssi,	{ "Rssi", "cc2420.rssi", FT_UINT16, BASE_HEX, NULL, 0xff00, "", HFILL } }
	};
  
	/* Setup protocol subtree array */
	static gint *ett[] = {
		&ett_cc2420
	};

	/* Register the protocol name and description */
	proto_cc2420 = proto_register_protocol("CC2420 Frame Format", "CC2420", "cc2420");

	/* Required function calls to register the header fields and subtrees used */
	proto_register_field_array(proto_cc2420, hf, array_length(hf));
	proto_register_subtree_array(ett, array_length(ett));
        
	/* Register preferences module (See Section 2.6 for more on preferences) */
	module_cc2420 = prefs_register_protocol(proto_cc2420, proto_reg_handoff_cc2420);
     
  /* subdissector code */
	register_heur_dissector_list("cc2420", &heur_subdissector_list);
  
	/* Register prefs */
	prefs_register_uint_preference(module_cc2420, "am_type",
				 "AM type ",
				 "The AM type of AM messgaes which "
				 "contain CC2420 "
				 "packets as payload",
				 10, &global_am_type_cc2420);
  
  prefs_register_uint_preference(module_cc2420, "channel",
				 "Standard Channel ",
				 "The channel on which "
				 "the CC2420 radio"
				 "receives",
				 10, &global_channel_cc2420);
}


/* If this dissector uses sub-dissector registration add a registration routine.
   This exact format is required because a script is used to find these routines 
   and create the code that calls these routines.
   
   This function is also called by preferences whenever "Apply" is pressed 
   (see prefs_register_protocol above) so it should accommodate being called 
   more than once.
*/
void proto_reg_handoff_cc2420(void)
{
	static dissector_handle_t handle_cc2420;
	static gboolean inited = FALSE;
        
	if (!inited) {
	    handle_cc2420 = create_dissector_handle(dissect_cc2420, proto_cc2420);
	    dissector_add("t2am.type", am_type_cc2420, handle_cc2420);
	    inited = TRUE;
	} else {
    	dissector_delete("t2am.type", am_type_cc2420, handle_cc2420);
  }

  am_type_cc2420 = global_am_type_cc2420;
  channel_cc2420 = global_channel_cc2420;
  
  setChannel_cc2420();
  dissector_add("t2am.type", global_am_type_cc2420, handle_cc2420);
 	data_handle = find_dissector("data");
}

