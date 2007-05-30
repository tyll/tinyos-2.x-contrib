/* packet-t2am.c
 * Routines for TinyOs2 Serial Active Message
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

#include "packet-t2am.h"

/* Forward declaration we need below */
void proto_reg_handoff_t2am(void);

/* for subdissectors */
static dissector_table_t t2am_type_dissector_table;
static heur_dissector_list_t heur_subdissector_list;
static dissector_handle_t data_handle;

/* Initialize the protocol and registered fields */
static int proto_t2am = -1;
static int hf_t2am_dest = -1;
static int hf_t2am_src = -1;
static int hf_t2am_length = -1;
static int hf_t2am_group = -1;
static int hf_t2am_type = -1;
static int hf_t2am_data = -1;

/* Initialize the subtree pointers */
static gint ett_t2am = -1;

/* Code to actually dissect the packets */
static void dissect_t2am(tvbuff_t *tvb, packet_info *pinfo, proto_tree *tree)
{
  tvbuff_t        *next_tvb;
  int             available_length;
  guint8 					am_payload_length = 0;
  guint8					am_type;
  
	/* Set up structures needed to add the protocol subtree and manage it */
	proto_item *ti;
	proto_tree *t2am_tree;
      
  /* check if this is really a complete AM. If not call sub dissector. */
  if (tvb_length(tvb) < T2_AM_HEADER_LEN) {
   	call_dissector(data_handle, tvb, pinfo, tree);
		return;
  }
  
  am_payload_length = tvb_get_guint8(tvb, T2_AM_HEADER_LENGTH_OFFSET);
  
  /* check again if this is really a complete AM. If not call sub dissector. */
  if (am_payload_length + T2_AM_HEADER_LEN != tvb_length(tvb)) {
   	call_dissector(data_handle, tvb, pinfo, tree);
		return;
  }
  
  am_type = tvb_get_guint8(tvb, T2_AM_HEADER_TYPE_OFFSET);

	/* Make entries in Protocol column and Info column on summary display */
	if (check_col(pinfo->cinfo, COL_PROTOCOL)) 
		col_set_str(pinfo->cinfo, COL_PROTOCOL, "T2 AM");

	if (check_col(pinfo->cinfo, COL_INFO)) 
		col_set_str(pinfo->cinfo, COL_INFO, "TinyOs2 ActiveMessage");

	if (tree) {

		/* create display subtree for the protocol */
		ti = proto_tree_add_item(tree, proto_t2am, tvb, 0, -1, FALSE);
		t2am_tree = proto_item_add_subtree(ti, ett_t2am);

		/* add items to the subtree */
		proto_tree_add_item(t2am_tree, hf_t2am_dest, tvb, T2_AM_HEADER_DEST_OFFSET, T2_AM_HEADER_DEST_LEN, TRUE);
		proto_tree_add_item(t2am_tree, hf_t2am_src, tvb, T2_AM_HEADER_SRC_OFFSET, T2_AM_HEADER_SRC_LEN, TRUE);
    proto_tree_add_item(t2am_tree, hf_t2am_length, tvb, T2_AM_HEADER_LENGTH_OFFSET, T2_AM_HEADER_LENGTH_LEN, FALSE);
		proto_tree_add_item(t2am_tree, hf_t2am_group, tvb, T2_AM_HEADER_GROUP_OFFSET, T2_AM_HEADER_GROUP_LEN, FALSE);
		proto_tree_add_item(t2am_tree, hf_t2am_type, tvb, T2_AM_HEADER_TYPE_OFFSET, T2_AM_HEADER_TYPE_LEN, FALSE);
    
    /*
  	if (serial_am_payload_length > 0) {
   		proto_tree_add_item(t2am_tree, hf_t2am_data, tvb, SERIAL_AM_DATA_OFFSET, serial_am_payload_length, FALSE);
  	}
    */
	}

	/* Calculate the available data in the packet, 
     set this to -1 to use all the data in the tv_buffer */
  available_length = tvb_length(tvb) - T2_AM_HEADER_LEN;

	/* Create the tvbuffer for the next dissector */
  next_tvb = tvb_new_subset(tvb, T2_AM_HEADER_LEN, MIN(available_length, am_payload_length), am_payload_length);
  
  /* check if message has type field */
  if (dissector_try_port(t2am_type_dissector_table, am_type, next_tvb, pinfo, tree)) {
    return;
  }

  /* try "heuristics */
  if (dissector_try_heuristic(heur_subdissector_list, next_tvb, pinfo, tree)) {
    return;
  }
  
	/* call the next dissector */
	call_dissector(data_handle, next_tvb, pinfo, tree);
  return;
}


/* Register the protocol with Wireshark */
void proto_register_t2am(void)
{                 
	/* TinyOs2 Serial Active Message Header */
	static hf_register_info hf[] = {
		{ &hf_t2am_dest,	{ "Destination_Address", "t2am.dest", FT_UINT16, BASE_HEX, NULL, 0x0, "", HFILL } },
    { &hf_t2am_src,	{ "Source_Address", "t2am.src", FT_UINT16, BASE_HEX, NULL, 0x0, "", HFILL } },
    { &hf_t2am_length,	{ "Length", "t2am.length", FT_UINT8, BASE_DEC, NULL, 0x0, "", HFILL } },
    { &hf_t2am_group,	{ "Group", "t2am.group", FT_UINT8, BASE_HEX, NULL, 0x0, "", HFILL } },
    { &hf_t2am_type,	{ "Type", "t2am.type", FT_UINT8, BASE_DEC, NULL, 0x0, "", HFILL } },
    { &hf_t2am_data, { "Payload_Data", "t2am.payload_data", FT_BYTES, BASE_HEX, NULL, 0x0, "", HFILL } }
	};

  
	/* Setup protocol subtree array */
	static gint *ett[] = {
		&ett_t2am
	};

	/* Register the protocol name and description */
	proto_t2am = proto_register_protocol("TinyOs2 Active Message", "T2 AM", "t2am");

	/* Required function calls to register the header fields and subtrees used */
	proto_register_field_array(proto_t2am, hf, array_length(hf));
	proto_register_subtree_array(ett, array_length(ett));
     
  /* subdissector code */
  t2am_type_dissector_table  = register_dissector_table("t2am.type", "T2 AM type", FT_UINT8, BASE_HEX);
	register_heur_dissector_list("t2am", &heur_subdissector_list);
  
}


/* If this dissector uses sub-dissector registration add a registration routine.
   This exact format is required because a script is used to find these routines 
   and create the code that calls these routines.
   
   This function is also called by preferences whenever "Apply" is pressed 
   (see prefs_register_protocol above) so it should accommodate being called 
   more than once.
*/
void proto_reg_handoff_t2am(void)
{
  static dissector_handle_t t2am_handle;
	static gboolean inited = FALSE;
        
	if (!inited) {
	    t2am_handle = create_dissector_handle(dissect_t2am, proto_t2am);
	    dissector_add("t2sf.type", T2_AM_SERIAL_TYPE, t2am_handle);
	    inited = TRUE;
	} else {
    	dissector_delete("t2sf.type", T2_AM_SERIAL_TYPE, t2am_handle);
  }
  
  dissector_add("t2sf.type", T2_AM_SERIAL_TYPE, t2am_handle);
 	data_handle = find_dissector("data");
}

