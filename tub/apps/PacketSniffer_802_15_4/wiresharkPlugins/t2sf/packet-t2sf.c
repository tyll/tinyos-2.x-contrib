/* packet-t2sf.c
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

#include "packet-t2sf.h"

/* Forward declaration we need below */
void proto_reg_handoff_t2sf(void);
static void dissect_t2sf(tvbuff_t *tvb, packet_info *pinfo, proto_tree *tree);

/* for subdissectors */
static dissector_table_t t2sf_type_dissector_table;
static heur_dissector_list_t heur_subdissector_list;
static dissector_handle_t data_handle;

/* Initialize the protocol and registered fields */
static int proto_t2sf = -1;
static int hf_t2sf_length = -1;
static int hf_t2sf_type = -1;
static int hf_t2sf_data = -1;
	
/* Global preferences */
static guint global_tcp_port_t2sf = T2_SF_STANDARD_TCP_PORT;
static guint tcp_port_t2sf = T2_SF_STANDARD_TCP_PORT;

/* Initialize the subtree pointers */
static gint ett_t2sf = -1;

/* description for packet dispüatch type */
static const value_string vals_t2sf_type[] = {
	{ 0x0, "TOS Active Message" },
	{ 0x1, "CC1000 Packet" },
	{ 0x2, "802.15.4 Packet" },
  { 0xff, "Unknown Packet" },
 	{ 0x0,	NULL }
};

/* Returns the length of a serial forwareder packet */
static guint8 get_t2sf_pdu_len(packet_info *pinfo, tvbuff_t *tvb, guint offset) {
	return tvb_get_guint8(tvb, offset) + 1;
}

// Reassemble tcp payload and call generic dissection
static void	dissect_t2sf_tcp(tvbuff_t *tvb, packet_info *pinfo, proto_tree *tree)
{
	tcp_dissect_pdus(tvb, pinfo, tree, TRUE, T2_SF_LENGTH_NUM_BYTES, get_t2sf_pdu_len, dissect_t2sf);
}

/* Code to actually dissect the packets */
static void dissect_t2sf(tvbuff_t *tvb, packet_info *pinfo, proto_tree *tree)
{
  tvbuff_t        *next_tvb;
  int             available_length;
  guint8 					sf_payload_length = 0;
  guint8					sf_type;
  
	/* Set up structures needed to add the protocol subtree and manage it */
	proto_item *ti;
	proto_tree *t2sf_tree;
  
  /* check if this is sf packet is really sane. If length is incorrect this might be another packet */
  if (tvb_get_guint8(tvb, 0)+1 != tvb_length(tvb)) {
   	call_dissector(data_handle, tvb, pinfo, tree);
		return;
  }
  
  sf_payload_length = tvb_get_guint8(tvb, T2_SF_HEADER_LENGTH_OFFSET)+1;
  sf_type = tvb_get_guint8(tvb, T2_SF_HEADER_TYPE_OFFSET);

	/* Make entries in Protocol column and Info column on summary display */
	if (check_col(pinfo->cinfo, COL_PROTOCOL)) 
		col_set_str(pinfo->cinfo, COL_PROTOCOL, "T2 SF");

	if (check_col(pinfo->cinfo, COL_INFO)) 
		col_set_str(pinfo->cinfo, COL_INFO, "TinyOs 2 SerialForwarder Packet");

	if (tree) {

		/* create display subtree for the protocol */
		ti = proto_tree_add_item(tree, proto_t2sf, tvb, 0, -1, FALSE);
		t2sf_tree = proto_item_add_subtree(ti, ett_t2sf);

		/* add items to the subtree */
		proto_tree_add_item(t2sf_tree, hf_t2sf_length, tvb, T2_SF_HEADER_LENGTH_OFFSET, T2_SF_LENGTH_NUM_BYTES, FALSE);
		proto_tree_add_item(t2sf_tree, hf_t2sf_type, tvb, T2_SF_HEADER_TYPE_OFFSET, T2_SF_TYPE_NUM_BYTES, FALSE);
 
  	/*
    if (sf_length > 0) {
   		proto_tree_add_item(t2sf_tree, hf_t2sf_data, tvb, SERIAL_AM_DATA_OFFSET, serial_am_payload_length, FALSE);
  	}
    */
	}
  
	/* Calculate the available data in the packet, 
     set this to -1 to use all the data in the tv_buffer */
  available_length = tvb_length(tvb) - T2_SF_HEADER_LEN;

	/* Create the tvbuffer for the next dissector */
  next_tvb = tvb_new_subset(tvb, T2_SF_HEADER_LEN, MIN(available_length, sf_payload_length), sf_payload_length);
  
  /* check if message has type field */
  if (dissector_try_port(t2sf_type_dissector_table, sf_type, next_tvb, pinfo, tree)) {
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
void proto_register_t2sf(void)
{                 
	module_t *t2sf_module;

	/* TinyOs2 Serial Active Message Header */
	static hf_register_info hf[] = {
    { &hf_t2sf_length,	{ "Length", "t2sf.length", FT_UINT8, BASE_DEC, NULL, 0x0, "", HFILL } },
    { &hf_t2sf_type,	{ "Type", "t2sf.type", FT_UINT8, BASE_DEC, VALS(vals_t2sf_type), 0x0, "", HFILL } },
    { &hf_t2sf_data, { "Payload_Data", "t2sf.payload_data", FT_BYTES, BASE_HEX, NULL, 0x0, "", HFILL } }
	};

  
	/* Setup protocol subtree array */
	static gint *ett[] = {
		&ett_t2sf
	};

	/* Register the protocol name and description */
	proto_t2sf = proto_register_protocol("TinyOs2 SerialForwarder Protocol", "T2 SF", "t2sf");

	/* Required function calls to register the header fields and subtrees used */
	proto_register_field_array(proto_t2sf, hf, array_length(hf));
	proto_register_subtree_array(ett, array_length(ett));
        
	/* Register preferences module (See Section 2.6 for more on preferences) */
	t2sf_module = prefs_register_protocol(proto_t2sf, proto_reg_handoff_t2sf);
     
  /* subdissector code */
  t2sf_type_dissector_table  = register_dissector_table("t2sf.type", "T2 SF type", FT_UINT8, BASE_HEX);
	//register_heur_dissector_list("t2sf", &heur_subdissector_list);
  
	/* Register prefs */
	prefs_register_uint_preference(t2sf_module, "tcp_port",
				 "TCP Port",
				 "The TCP port on which "
				 "SerialForwarder "
				 "sends the packets",
				 10, &global_tcp_port_t2sf);
}


/* If this dissector uses sub-dissector registration add a registration routine.
   This exact format is required because a script is used to find these routines 
   and create the code that calls these routines.
   
   This function is also called by preferences whenever "Apply" is pressed 
   (see prefs_register_protocol above) so it should accommodate being called 
   more than once.
*/
void proto_reg_handoff_t2sf(void)
{
  static dissector_handle_t t2sf_handle;
	static dissector_handle_t t2sf_tcp_handle;
  static gboolean inited = FALSE;
        
	if (!inited) {
	    t2sf_handle = create_dissector_handle(dissect_t2sf, proto_t2sf);
      t2sf_tcp_handle = create_dissector_handle(dissect_t2sf_tcp, proto_t2sf);
      /* for dissection based upon tcp */
      dissector_add("tcp.port", tcp_port_t2sf, t2sf_tcp_handle);
	    inited = TRUE;
	} else {
     	dissector_delete("tcp.port", tcp_port_t2sf, t2sf_tcp_handle);
  }

  tcp_port_t2sf = global_tcp_port_t2sf;
  
  dissector_add("tcp.port", tcp_port_t2sf, t2sf_tcp_handle);
 	data_handle = find_dissector("data");
}

