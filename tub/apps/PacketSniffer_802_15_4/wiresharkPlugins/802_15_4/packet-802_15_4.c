/* packet-802_15_4.c
 * Routines for cc2420 802.15.4 packet dissector.
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

#include "packet-802_15_4.h"

/* Forward declaration we need below */
void proto_reg_handoff_802_15_4(void);

/* Initialize the protocol and registered fields */

/* 802.15.4 stuff */
static int proto_802_15_4 = -1;
static int hf_802_15_4_fc = -1;
static int hf_802_15_4_fc_type = -1;
static int hf_802_15_4_fc_security = -1;
static int hf_802_15_4_fc_framepending = -1;
static int hf_802_15_4_fc_ackrequest = -1;
static int hf_802_15_4_fc_intrapan = -1;
static int hf_802_15_4_fc_dstaddrmode = -1;
static int hf_802_15_4_fc_srcaddrmode = -1;
static int hf_802_15_4_seqno = -1;
static int hf_802_15_4_dst_pan_id = -1;
static int hf_802_15_4_dst_adr_16 = -1;
static int hf_802_15_4_dst_adr_64 = -1;
static int hf_802_15_4_src_pan_id = -1;
static int hf_802_15_4_src_adr_16 = -1;
static int hf_802_15_4_src_adr_64 = -1;

static int hf_802_15_4_superframe_spec = -1;
static int hf_802_15_4_superframe_spec_bo = -1;
static int hf_802_15_4_superframe_spec_so = -1;
static int hf_802_15_4_superframe_spec_final_cap_slot = -1;
static int hf_802_15_4_superframe_spec_ble = -1;
static int hf_802_15_4_superframe_spec_pan_coord = -1;
static int hf_802_15_4_superframe_spec_ap = -1;
static int hf_802_15_4_gts = -1;
static int hf_802_15_4_gts_spec = -1;
static int hf_802_15_4_gts_spec_dc = -1;
static int hf_802_15_4_gts_spec_gp = -1;
static int hf_802_15_4_gts_dirs = -1;
static int hf_802_15_4_gts_dir_slot0 = -1;
static int hf_802_15_4_gts_dir_slot1 = -1;
static int hf_802_15_4_gts_dir_slot2 = -1;
static int hf_802_15_4_gts_dir_slot3 = -1;
static int hf_802_15_4_gts_dir_slot4 = -1;
static int hf_802_15_4_gts_dir_slot5 = -1;
static int hf_802_15_4_gts_dir_slot6 = -1;
static int hf_802_15_4_gts_desc = -1;
static int hf_802_15_4_gts_desc_short_addr = -1;
static int hf_802_15_4_gts_desc_start = -1;
static int hf_802_15_4_gts_desc_length = -1;
static int hf_802_15_4_pending_adr = -1;
static int hf_802_15_4_pending_adr_spec = -1;
static int hf_802_15_4_pending_adr_spec_short_adr_count = -1;
static int hf_802_15_4_pending_adr_spec_ext_adr_count = -1;
static int hf_802_15_4_pending_short_adr_list = -1;
static int hf_802_15_4_pending_ext_adr_list = -1;
static int hf_802_15_4_pending_ext_adr = -1;
static int hf_802_15_4_pending_short_adr = -1;
static int hf_802_15_4_beacon_payload = -1;

static int hf_802_15_4_command_id = -1;
static int hf_802_15_4_capability_info = -1;
static int hf_802_15_4_alternate_pan_coord = -1;
static int hf_802_15_4_device_type = -1;
static int hf_802_15_4_power_source = -1;
static int hf_802_15_4_rx_on_idle = -1;
static int hf_802_15_4_security_capability = -1;
static int hf_802_15_4_allocate_address = -1;

static int hf_802_15_4_assigned_address = -1;
static int hf_802_15_4_association_status = -1;
static int hf_802_15_4_mac_enumeration = -1;
static int hf_802_15_4_disassociation_reason = -1;
static int hf_802_15_4_pan_id = -1;
static int hf_802_15_4_coord_short_adr = -1;
static int hf_802_15_4_assigned_short_adr = -1;
static int hf_802_15_4_channel	= -1;
static int hf_802_15_4_gts_characteristics = -1;
static int hf_802_15_4_gts_length = -1;
static int hf_802_15_4_gts_dir = -1;
static int hf_802_15_4_gts_type = -1;

static int hf_802_15_4_fcs = -1;

/* needed for address tracking */
static char* src_adr[255];
static char* src_pan[255];
static char* dst_adr[255];
static char* dst_pan[255];
    	
/* Initialize the subtree pointers */
static gint ett_802_15_4 = -1;

/* handle to the next dissector (payload data for us) */
static dissector_handle_t data_handle;

/* description for mac enumeration codes */
static const value_string vals_802_15_4_mac_enumeration[] = {
	{ 0x0, "SUCCESS" },
	{ 0xe0, "BEACON_LOSS" },
	{ 0xe1, "CHANNEL_ACCESS_FAILURE" },
  { 0xe2, "DENIED" },
	{ 0xe3, "DISABLE_TRX_FAILURE" },
 	{ 0xe4, "FAILED_SECURITY_CHECK" },
 	{ 0xe5, "FRAME_TOO_LONG" },
 	{ 0xe6, "INVALID_GTS" },
 	{ 0xe7, "INVALID_HANDLE" },
 	{ 0xe8, "INVALID_PARAMETER" },
 	{ 0xe9, "NO_ACK" },
 	{ 0xea, "NO_BEACON" },
 	{ 0xeb, "NO_DATA" },
 	{ 0xec, "NO_SHORT_ADDRESS" },
 	{ 0xed, "OUT_OF_CAP" },
 	{ 0xee, "PAN_ID_CONFLICT" },
 	{ 0xef, "REALIGNMENT" },
 	{ 0xf0, "TRANSACTION_EXPIRED" },
 	{ 0xf1, "TRANSACTION_OVERFLOW" },
 	{ 0xf2, "TX_ACTIVE" },
 	{ 0xf3, "UNAVAILABLE_KEY" },
 	{ 0xf4, "UNSUPPORTED_ATTRIBUTE" },

  { 0x0,	NULL }
};
/* description for addressing mode */
static const value_string vals_802_15_4_addressing_mode[] = {
	{ 0x0, "addressing fields not present" },
	{ 0x1, "reserved" },
	{ 0x2, "addressing mode 16bit" },
  { 0x3, "addressing mode 64bit" },
 	{ 0x0,	NULL }
};

/* description for frame types */
static const value_string vals_802_15_4_frame_type[] = {
	{ 0x0, "beacon frame" },
	{ 0x1, "data frame" },
	{ 0x2, "ack frame" },
  { 0x3, "command frame" },
 	{ 0x0,	NULL }
};

/* description for frame types */
static const value_string vals_802_15_4_command_id[] = {
	{ 0x1, "association request" },
	{ 0x2, "association response" },
	{ 0x3, "disassociation notification" },
  { 0x4, "data request" },
  { 0x5, "PAN ID conflict notification" },
  { 0x6, "orphan notification" },
  { 0x7, "beacon request" },
  { 0x8, "coordinator realignment" },
  { 0x9, "GTS request" },
 	{ 0x0,	NULL }
};

/* description for association status types */
static const value_string vals_802_15_4_association_status[] = {
  { 0x0, "association successful" },
	{ 0x1, "PAN at capacity" },
	{ 0x2, "PAN access denied" },
 	{ 0x0,	NULL }
};
    
/* description for disassociation reason */
static const value_string vals_802_15_4_disassociation_reason[] = {
  { 0x1, "coordinator wants to leave PAN" },
	{ 0x2, "device wants to leave PAN" },
 	{ 0x0,	NULL }
};
        
/* description for gts direction */
static const true_false_string tf_802_15_4_gts_dir = {
	"transmit only",
	"receive only"
};

/* alternate_pan */
static const true_false_string tf_802_15_4_alternate_pan = {
	"can become PAN coordinator",
	"cannot becaome PAN coordinator",
};

/* device type */
static const true_false_string tf_802_15_4_device_type = {
	"RFD",
	"FFD",
};

/* power source */
static const true_false_string tf_802_15_4_power_source = {
	"battery powered",
	"mains powered",
};

/* rx on idle */
static const true_false_string tf_802_15_4_rx_on_idle = {
	"receiver disabled during idle periods",
	"receiver is always on",
};

/* security cap */
static const true_false_string tf_802_15_4_security_capability = {
	"no support for security suite",
	"support for security suite",
};

/* allocate_address */
static const true_false_string tf_802_15_4_allocate_address = {
	"short address request",
	"no short address request",
};

/* gts request/release */
static const true_false_string tf_802_15_4_gts_type = {
  "GTS deallocation request",
  "GTS allocation request"
};

/* enum for addr modes */
enum addr_mode_t {
	NO_SRC = 1 << 0,
  NO_DST = 1 << 1,
  SRC_ADR_16 = 1 << 2,
  SRC_ADR_64 = 1 << 3,
  DST_ADR_16 = 1 << 4,
  DST_ADR_64 = 1 << 5,
  INTRA_PAN = 1 << 6
};

/* adr info type */
typedef struct {
  guint8 addr_mode;
  guint64 src;
  guint16 src_pan;
  guint64 dst;
  guint16 dst_pan;
} ack_adr_info_t;

/* frame adr infos for acks */
static ack_adr_info_t ack_adr_info[256];
    
    
/* Dissects ack packets.
	 Basically searches for a former frame sequence number belonging to this ack*/
static void dissect_802_15_4_ack(guint8 seqno) {
  if (ack_adr_info[seqno].addr_mode) {
    if (ack_adr_info[seqno].addr_mode & NO_SRC) {
   		g_snprintf((char*) src_adr, 8, "unknown");
    } else {
      if (ack_adr_info[seqno].addr_mode & SRC_ADR_16) {
        g_snprintf((char*)src_adr, 5, "%04X", (guint16)ack_adr_info[seqno].dst);
      } else if (ack_adr_info[seqno].addr_mode & SRC_ADR_64) {
        g_snprintf((char*)src_adr, 17, "%016X" G_GUINT64_FORMAT, ack_adr_info[seqno].dst);
    	} else {
	   		g_snprintf((char*)src_adr, 8, "unknown");
      }
    }
    if (ack_adr_info[seqno].addr_mode & NO_DST) {
   		g_snprintf((char*)dst_adr, 8, "unknown");
    } else {
      if (ack_adr_info[seqno].addr_mode & DST_ADR_16) {
        g_snprintf((char*)dst_adr, 5, "%04X", (guint16)ack_adr_info[seqno].src);
      } else if (ack_adr_info[seqno].addr_mode & DST_ADR_64) {
        g_snprintf((char*)dst_adr, 17, "%016X" G_GUINT64_FORMAT, ack_adr_info[seqno].src);
    	} else {
	   		g_snprintf((char*)dst_adr, 8, "unknown");
      }
    }
      
    if (ack_adr_info[seqno].addr_mode & INTRA_PAN) {
      /* only dst pan id is present */
      g_snprintf((char*)src_pan, 5,"%04X", ack_adr_info[seqno].dst_pan);
      g_snprintf((char*)dst_pan, 5,"%04X", ack_adr_info[seqno].dst_pan);
    } else {
      g_snprintf((char*)src_pan, 5,"%04X", ack_adr_info[seqno].dst_pan);
      g_snprintf((char*)dst_pan, 5,"%04X", ack_adr_info[seqno].src_pan);
    }
    
    /* reset frame adr info */
    ack_adr_info[seqno].addr_mode = 0;
  } else {
		g_snprintf((char*)src_adr, 8, "unknown");
    g_snprintf((char*)src_pan, 8, "unknown");
    g_snprintf((char*)dst_adr, 8, "unknown");
    g_snprintf((char*)dst_pan, 8, "unknown");
  }
}

static int dissect_802_15_4_adr_info(tvbuff_t *tvb, packet_info *pinfo, proto_tree *tree, guint8 seqno) {
  int             payload_offset, header_offset, buffer_length;
  int 						src_adr_mode, dst_adr_mode, intra_pan;
  guint64					src_address, dst_address;
	guint16 				src_pan_adr,dst_pan_adr;
  
  buffer_length = tvb_length(tvb);
  
  /* check addressing mode */
  src_adr_mode = (tvb_get_guint8(tvb, 1) & 0xC0) >> 6;
	dst_adr_mode = (tvb_get_guint8(tvb, 1) & 0xC) >> 2;
  intra_pan = (tvb_get_guint8(tvb, 0) & 0x40);
    
  /* static offset (fc 16bit + seqno 8 bit) */
  payload_offset = 3;
  header_offset = 3;
  
  /* sanity check */
  if ( (buffer_length >= (header_offset + 2)) && dst_adr_mode ) {
      payload_offset += 2;
      dst_pan_adr = tvb_get_letohs(tvb, header_offset);
      ack_adr_info[seqno].dst_pan = dst_pan_adr;
      g_snprintf((char*)dst_pan, 5,"%04X", (guint16)dst_pan_adr);
      if (tree) proto_tree_add_item(tree, hf_802_15_4_dst_pan_id, tvb, header_offset, 2, TRUE);
      header_offset += 2;
  }
  
  /* sanity check */
  if ( buffer_length >= 
       (header_offset + ((dst_adr_mode == 2) ? 2 : 0) + ((dst_adr_mode == 3) ? 8 : 0) )) {
    switch (dst_adr_mode) {
      case 2:
        payload_offset += 2;
        dst_address = tvb_get_letohs(tvb, header_offset);
        ack_adr_info[seqno].addr_mode |= DST_ADR_16;
        ack_adr_info[seqno].dst = (guint16)dst_address;
        g_snprintf((char*)dst_adr, 5, "%04X", (guint16)dst_address);
        if (tree) proto_tree_add_item(tree, hf_802_15_4_dst_adr_16, tvb, header_offset, 2, TRUE);
        header_offset += 2;
        break;
      case 3:
        payload_offset += 8;
        dst_address = tvb_get_letoh64(tvb, header_offset);
        ack_adr_info[seqno].addr_mode |= DST_ADR_64;
        ack_adr_info[seqno].dst = dst_address;
        g_snprintf((char*)dst_adr, 17, "%016X" G_GUINT64_FORMAT, dst_address);
        if (tree) proto_tree_add_item(tree, hf_802_15_4_dst_adr_64, tvb, header_offset, 8, TRUE);
        header_offset += 8;
        break;
      default:
        ack_adr_info[seqno].addr_mode |= NO_DST;
        ack_adr_info[seqno].dst = 0;
        g_snprintf((char*)dst_adr, 11, "no_address");
        ;
    }
  }
  
  /* sanity check */
  if ( buffer_length >= (header_offset + (intra_pan ? 0 : 2))) {
    /* calculate payload offset */    
    if (intra_pan != 0) {
      ack_adr_info[seqno].addr_mode |= INTRA_PAN;
    } else {
      payload_offset += 2;
      src_pan_adr = tvb_get_letohs(tvb, header_offset);
      ack_adr_info[seqno].src_pan = src_pan_adr;
      g_snprintf((char*)src_pan, 5,"%04X", (guint16)src_pan_adr);
      if (tree) proto_tree_add_item(tree, hf_802_15_4_src_pan_id, tvb, header_offset, 2, TRUE);
      header_offset += 2;
    }
  }

  /* sanity check */
  if ( buffer_length >= 
       (header_offset + ((src_adr_mode == 2) ? 2 : 0) + ((src_adr_mode == 3) ? 8 : 0) )) {
    switch (src_adr_mode) {
      case 2:
        payload_offset += 2;
        src_address = tvb_get_letohs(tvb, header_offset);
        ack_adr_info[seqno].addr_mode |= SRC_ADR_16;
        ack_adr_info[seqno].src = (guint16)src_address;
        g_snprintf((char*)src_adr, 5, "%04X", (guint16)src_address);
        if (tree) proto_tree_add_item(tree, hf_802_15_4_src_adr_16, tvb, header_offset, 2, TRUE);
        header_offset += 2;
        break;
      case 3:
        payload_offset += 8;
        src_address = tvb_get_letoh64(tvb, header_offset);
        ack_adr_info[seqno].addr_mode |= SRC_ADR_64;
        ack_adr_info[seqno].src = src_address;
        g_snprintf((char*)src_adr, 17, "%016X" G_GUINT64_FORMAT , src_address);
        if (tree) proto_tree_add_item(tree, hf_802_15_4_src_adr_64, tvb, header_offset, 8, TRUE);
        header_offset += 8;
        break;
      default:
        ack_adr_info[seqno].addr_mode |= NO_SRC;
        ack_adr_info[seqno].src = 0;
        g_snprintf((char*)dst_adr, 11, "no_address");
        ;
    }
  }
  
	return payload_offset;
}

/* TODO: test */
static void dissect_802_15_4_beacon(tvbuff_t *tvb, packet_info *pinfo, proto_tree *tree, guint8 seqno) {
 	int payload_length = 0;
  int buffer_length = 0;
  int offset = 0;
  int gts = 0;
  int count_pending_ext = 0;
  int count_pending_short = 0;
  int i = 0;
  tvbuff_t* next_tvb = NULL;
  proto_item* sfs = NULL;
 	proto_item* gts_info = NULL;
 	proto_item* gts_spec = NULL;
  proto_item* gts_dir = NULL;
  proto_item* gts_desc = NULL;
	proto_item* pending_info = NULL;
  proto_item* pending_spec = NULL;
	proto_item* pending_short = NULL;
	proto_item* pending_ext = NULL;

  proto_tree* sfs_tree = NULL;
 	proto_tree* gts_info_tree = NULL;
  proto_tree* gts_spec_tree = NULL;
  proto_tree* gts_dir_tree = NULL;
  proto_tree* gts_desc_tree = NULL;
	proto_tree* pending_info_tree = NULL;
  proto_tree* pending_spec_tree = NULL;
  proto_tree* pending_short_tree = NULL;
	proto_tree* pending_ext_tree = NULL;
 	
	if (check_col(pinfo->cinfo, COL_INFO)) {
		col_append_str(pinfo->cinfo, COL_INFO, "beacon frame");
  }
  
  offset = dissect_802_15_4_adr_info(tvb, pinfo, tree, seqno);
  
  /* 2 byte fcs*/
  buffer_length = tvb_length(tvb) - 2;
  
  /* sanity check */
 	if ( buffer_length >= (offset + 2) ) {
    /* superframe specification */
    if (tree) {
      sfs = proto_tree_add_item(tree, hf_802_15_4_superframe_spec, tvb, offset, 2, TRUE);
      sfs_tree = proto_item_add_subtree(sfs, ett_802_15_4);
      proto_tree_add_item(sfs_tree, hf_802_15_4_superframe_spec_bo, tvb, offset, 2, TRUE);
      proto_tree_add_item(sfs_tree, hf_802_15_4_superframe_spec_so, tvb, offset, 2, TRUE);
      proto_tree_add_item(sfs_tree, hf_802_15_4_superframe_spec_final_cap_slot, tvb, offset, 2, TRUE);
      proto_tree_add_item(sfs_tree, hf_802_15_4_superframe_spec_ble, tvb, offset, 2, TRUE);
      proto_tree_add_item(sfs_tree, hf_802_15_4_superframe_spec_pan_coord, tvb, offset, 2, TRUE);
      proto_tree_add_item(sfs_tree, hf_802_15_4_superframe_spec_ap, tvb, offset, 2, TRUE);
    }
    offset += 2;
  }
  
  /* sanity check */
 	if ( buffer_length >= (offset + 1) ) {
  	/* gts fields */
  	gts = (tvb_get_guint8(tvb, offset) & 7);
    if (tree) {
      if (gts) {
        gts_info = proto_tree_add_item(tree, hf_802_15_4_gts, tvb, offset, (gts*3)+2, TRUE);
      } else {
        gts_info = proto_tree_add_item(tree, hf_802_15_4_gts, tvb, offset, (gts*3)+1, TRUE);
      }
      gts_info_tree = proto_item_add_subtree(gts_info, ett_802_15_4);
      
      gts_spec = proto_tree_add_item(gts_info_tree, hf_802_15_4_gts_spec, tvb, offset, 1, TRUE);
      gts_spec_tree = proto_item_add_subtree(gts_spec, ett_802_15_4);
      proto_tree_add_item(gts_spec_tree, hf_802_15_4_gts_spec_dc, tvb, offset, 1, TRUE);
      proto_tree_add_item(gts_spec_tree, hf_802_15_4_gts_spec_gp, tvb, offset, 1, TRUE);
    }
    offset += 1;
  }
  
  /* sanity check */
 	if ( buffer_length >= (offset + 1 + (3*gts)) && (gts)) {  
  	if (gts_info_tree) {
      if (tree) {
        /* gts directions tree */
        gts_dir = proto_tree_add_item(gts_info_tree, hf_802_15_4_gts_dirs, tvb, offset, 1, TRUE);
        gts_dir_tree = proto_item_add_subtree(gts_dir, ett_802_15_4);
        if (gts > 0) proto_tree_add_item(gts_dir_tree, hf_802_15_4_gts_dir_slot0, tvb, offset, 1, TRUE);
        if (gts > 1) proto_tree_add_item(gts_dir_tree, hf_802_15_4_gts_dir_slot1, tvb, offset, 1, TRUE);
        if (gts > 2) proto_tree_add_item(gts_dir_tree, hf_802_15_4_gts_dir_slot2, tvb, offset, 1, TRUE);
        if (gts > 3) proto_tree_add_item(gts_dir_tree, hf_802_15_4_gts_dir_slot3, tvb, offset, 1, TRUE);
        if (gts > 4) proto_tree_add_item(gts_dir_tree, hf_802_15_4_gts_dir_slot4, tvb, offset, 1, TRUE);
        if (gts > 5) proto_tree_add_item(gts_dir_tree, hf_802_15_4_gts_dir_slot5, tvb, offset, 1, TRUE);
        if (gts > 6) proto_tree_add_item(gts_dir_tree, hf_802_15_4_gts_dir_slot6, tvb, offset, 1, TRUE);
      }
      offset += 1;
      /* gts list trees */
      if (tree) {       
        for (i = 0; i < gts; i++) {
          gts_desc = proto_tree_add_uint_format(gts_info_tree, hf_802_15_4_gts_desc, tvb, offset, 3, 0, "GTS_Descriptor %i", i);
          gts_desc_tree = proto_item_add_subtree(gts_desc, ett_802_15_4);
          proto_tree_add_item(gts_desc_tree, hf_802_15_4_gts_desc_short_addr, tvb, offset, 3, TRUE);
          proto_tree_add_item(gts_desc_tree, hf_802_15_4_gts_desc_start, tvb, offset, 3, TRUE);
          proto_tree_add_item(gts_desc_tree, hf_802_15_4_gts_desc_length, tvb, offset, 3, TRUE);
          offset += 3;
       }
        
      } else {
        offset += gts*3;
      }
    }
  } 
  
  /* sanity check */
  if ( buffer_length >= (offset + 1) ) {
  	/* pending addresses fields */
  	count_pending_short = (tvb_get_guint8(tvb, offset) & 7);
		count_pending_ext = (tvb_get_guint8(tvb, offset) & 0x70) >> 4;
    if (tree) {
      /* pending address num here */
     	if ( buffer_length >= (offset + (count_pending_short*2) + (count_pending_ext*8))) {
      	pending_info = proto_tree_add_item(tree, hf_802_15_4_pending_adr, tvb, offset, (count_pending_short*2)+(count_pending_ext*8)+1, TRUE);
      } else {
       	pending_info = proto_tree_add_item(tree, hf_802_15_4_pending_adr, tvb, offset, 1, TRUE); 
      }
      pending_info_tree = proto_item_add_subtree(pending_info, ett_802_15_4);
      pending_spec = proto_tree_add_item(pending_info_tree, hf_802_15_4_pending_adr_spec, tvb, offset, 1, TRUE);
      pending_spec_tree = proto_item_add_subtree(pending_spec, ett_802_15_4);
      proto_tree_add_item(pending_spec_tree, hf_802_15_4_pending_adr_spec_short_adr_count, tvb, offset, 1, TRUE);
      proto_tree_add_item(pending_spec_tree, hf_802_15_4_pending_adr_spec_ext_adr_count, tvb, offset, 1, TRUE);
    }
    offset += 1;
  }
 	if ( buffer_length >= (offset + (count_pending_short*2) + (count_pending_ext*8))) {
    if (pending_info_tree) {
      if (count_pending_short) {
        pending_short = proto_tree_add_item(pending_info_tree, hf_802_15_4_pending_short_adr_list, tvb, offset, (count_pending_short*2), TRUE);
        pending_short_tree = proto_item_add_subtree(pending_short, ett_802_15_4);
        for (i = 0; i < count_pending_short; i++) {
          proto_tree_add_item(pending_short_tree, hf_802_15_4_pending_short_adr, tvb, offset, 2, TRUE);
          offset += 2;
        }
      } else {
        offset += count_pending_short*2;
      }
    }
    if (pending_info_tree) {
      if (count_pending_ext) {
        pending_ext = proto_tree_add_item(pending_info_tree, hf_802_15_4_pending_ext_adr_list, tvb, offset, (count_pending_ext*8), TRUE);
        pending_ext_tree = proto_item_add_subtree(pending_ext, ett_802_15_4);
        for (i = 0; i < count_pending_ext; i++) {
          proto_tree_add_item(pending_ext_tree, hf_802_15_4_pending_ext_adr, tvb, offset, 8, TRUE);
          offset += 8;
        }
      } else {
        offset += count_pending_ext*8;
      }
    }
  }
  
  /* Calculate the available data in the packet: 
     complete length - payload_offsett - 2 byte fcs */
  payload_length = tvb_length(tvb) - offset - 2;
  
  if (payload_length) {
    /* add beacon payload field (just for filtering) */
 	  proto_tree_add_item(tree, hf_802_15_4_beacon_payload, tvb, offset, payload_length, TRUE);

    /* Create the tvbuffer for the next dissector */
  	next_tvb = tvb_new_subset(tvb, offset, payload_length, -1);

		/* call the next dissector */
		call_dissector(data_handle, next_tvb, pinfo, tree);
  }
}

/* TODO: test */
int dissect_802_15_4_association_request(tvbuff_t *tvb, packet_info *pinfo, proto_tree *tree, int buffer_length, int offset) 
{
	proto_item* capability_info = NULL;
	proto_tree* capability_info_tree = NULL; 
  if (check_col(pinfo->cinfo, COL_INFO)) {
  	col_append_str(pinfo->cinfo, COL_INFO, "association request");
  }
  if ( buffer_length >= (offset + 1) ) {
  	if (tree) {
      capability_info = proto_tree_add_item(tree, hf_802_15_4_capability_info, tvb, offset, 1, TRUE);
      capability_info_tree = proto_item_add_subtree(capability_info, ett_802_15_4);
      proto_tree_add_item(capability_info_tree, hf_802_15_4_alternate_pan_coord, tvb, offset, 1, TRUE);
      proto_tree_add_item(capability_info_tree, hf_802_15_4_device_type, tvb, offset, 1, TRUE);
      proto_tree_add_item(capability_info_tree, hf_802_15_4_power_source, tvb, offset, 1, TRUE);
      proto_tree_add_item(capability_info_tree, hf_802_15_4_rx_on_idle, tvb, offset, 1, TRUE);
      proto_tree_add_item(capability_info_tree, hf_802_15_4_security_capability, tvb, offset, 1, TRUE);
      proto_tree_add_item(capability_info_tree, hf_802_15_4_allocate_address, tvb, offset, 1, TRUE);
     }
     offset += 1;
	} 
  return offset;   
}

/* TODO: test */
int dissect_802_15_4_association_response(tvbuff_t *tvb, packet_info *pinfo, proto_tree *tree, int buffer_length, int offset) 
{
  int short_adr = -1;
  
  if (check_col(pinfo->cinfo, COL_INFO)) {
    col_append_str(pinfo->cinfo, COL_INFO, "association response");
  }

  if ( buffer_length >= (offset + 3) ) {
    if (tree) {
      proto_tree_add_item(tree, hf_802_15_4_assigned_address, tvb, offset, 2, TRUE);
			short_adr = tvb_get_guint8(tvb, offset+1);
      if (short_adr == 0xffff) {
				proto_tree_add_item(tree, hf_802_15_4_mac_enumeration, tvb, offset+2, 1, TRUE);
      } else {
        proto_tree_add_item(tree, hf_802_15_4_assigned_address, tvb, offset+2, 1, TRUE);
      }
    }
    offset += 3;
  }  
  return offset;
}

/* TODO: test */
int dissect_802_15_4_disassociation_notification(tvbuff_t *tvb, packet_info *pinfo, proto_tree *tree, int buffer_length, int offset) 
{
  if (check_col(pinfo->cinfo, COL_INFO)) {
    col_append_str(pinfo->cinfo, COL_INFO, "disassociation notification");
  }
  if ( buffer_length >= (offset + 1) ) {
    if (tree) {
      proto_tree_add_item(tree, hf_802_15_4_disassociation_reason, tvb, offset, 1, TRUE);
    }
    offset += 1;
  }  
  return offset;
}

/* TODO: test */
int dissect_802_15_4_coordinator_realignment(tvbuff_t *tvb, packet_info *pinfo, proto_tree *tree, int buffer_length, int offset) 
{
  if (check_col(pinfo->cinfo, COL_INFO)) {
    col_append_str(pinfo->cinfo, COL_INFO, "coordinator realignment");
  }  
  
  if ( buffer_length >= (offset + 2) ) {
    if (tree) {
      proto_tree_add_item(tree, hf_802_15_4_pan_id, tvb, offset, 2, TRUE);
    }
    offset += 2;
  }  
  
  if ( buffer_length >= (offset + 2) ) {
    if (tree) {
      proto_tree_add_item(tree, hf_802_15_4_coord_short_adr, tvb, offset, 2, TRUE);
    }
    offset += 2;
  }  
  
  if ( buffer_length >= (offset + 1) ) {
    if (tree) {
      proto_tree_add_item(tree, hf_802_15_4_channel, tvb, offset, 1, TRUE);
    }
    offset += 2;
  }    
  
  if ( buffer_length >= (offset + 2) ) {
    if (tree) {
      proto_tree_add_item(tree, hf_802_15_4_assigned_short_adr, tvb, offset, 2, TRUE);
    }
    offset += 2;
  }   
  
  return offset;
}

/* TODO: test */
int dissect_802_15_4_gts_request(tvbuff_t *tvb, packet_info *pinfo, proto_tree *tree, int buffer_length, int offset) 
{
  proto_item* gts_info = NULL;
	proto_tree* gts_info_tree = NULL; 
  
  if (check_col(pinfo->cinfo, COL_INFO)) {
    col_append_str(pinfo->cinfo, COL_INFO, "GTS request");
  }
  if ( buffer_length >= (offset + 1) ) {
    if (tree) {
      gts_info = proto_tree_add_item(tree, hf_802_15_4_gts_characteristics, tvb, offset, 1, TRUE);
      gts_info_tree = proto_item_add_subtree(gts_info, ett_802_15_4);
      proto_tree_add_item(gts_info_tree, hf_802_15_4_gts_length, tvb, offset, 1, TRUE);
      proto_tree_add_item(gts_info_tree, hf_802_15_4_gts_dir, tvb, offset, 1, TRUE);
      proto_tree_add_item(gts_info_tree, hf_802_15_4_gts_type, tvb, offset, 1, TRUE);
    }
    offset += 1;
  }  
  return offset;
}
        
/* TODO: */
/* code to dissect command frames */
static void dissect_802_15_4_command(tvbuff_t *tvb, packet_info *pinfo, proto_tree *tree, guint8 seqno) {
	int offset = 0;
	int command_id = 0;
	int buffer_length = 0;
  tvbuff_t* next_tvb = NULL;
  
  offset = dissect_802_15_4_adr_info(tvb, pinfo, tree, seqno);
  
  buffer_length = tvb_length(tvb) - offset;

  // sanity check
 	if ( buffer_length >= (offset + 1) ) {
 		command_id = tvb_get_guint8(tvb, offset);
    if (tree) proto_tree_add_item(tree, hf_802_15_4_command_id, tvb, offset, 1, TRUE);
    offset += 1;
    switch (command_id) {
      case 1:
        offset = dissect_802_15_4_association_request(tvb, pinfo, tree, buffer_length, offset);
        break;
      case 2:
		    offset = dissect_802_15_4_association_response(tvb, pinfo, tree, buffer_length, offset);
        break;
      case 3:
 		    offset = dissect_802_15_4_disassociation_notification(tvb, pinfo, tree, buffer_length, offset);
        break;
      case 4:
        if (check_col(pinfo->cinfo, COL_INFO)) {
          col_append_str(pinfo->cinfo, COL_INFO, "data request");
        }
        break;
      case 5:
        if (check_col(pinfo->cinfo, COL_INFO)) {
          col_append_str(pinfo->cinfo, COL_INFO, "PAN ID conflict notification");
        }
        break;
      case 6:
        if (check_col(pinfo->cinfo, COL_INFO)) {
          col_append_str(pinfo->cinfo, COL_INFO, "orphan notification");
        }
        break;
      case 7:
        if (check_col(pinfo->cinfo, COL_INFO)) {
          col_append_str(pinfo->cinfo, COL_INFO, "beacon request");
        }
        break;
      case 8:
        offset = dissect_802_15_4_coordinator_realignment(tvb, pinfo, tree, buffer_length, offset);
        break;
      case 9:
        offset = dissect_802_15_4_gts_request(tvb, pinfo, tree, buffer_length, offset);
        break;
      default:
        if (check_col(pinfo->cinfo, COL_INFO)) {
          col_append_str(pinfo->cinfo, COL_INFO, "reserved command frame");
        }
        next_tvb = tvb_new_subset(tvb, offset, tvb_length(tvb)-offset-2, -1);
        call_dissector(data_handle, next_tvb, pinfo, tree);
    }
  }
}

/* code to dissect data frames */
static void dissect_802_15_4_data(tvbuff_t *tvb, packet_info *pinfo, proto_tree *tree, guint8 seqno) {
  tvbuff_t        *next_tvb;
  int             payload_length, payload_offset;

  if (check_col(pinfo->cinfo, COL_INFO)) {
		col_append_str(pinfo->cinfo, COL_INFO, "data frame");
  }  
  
  payload_offset = dissect_802_15_4_adr_info(tvb, pinfo, tree, seqno);
    
	/* Calculate the available data in the packet: 
     complete length - payload_offsett - 2 byte fcs */
  payload_length = tvb_length(tvb) - payload_offset - 2;

	/* Create the tvbuffer for the next dissector */
  next_tvb = tvb_new_subset(tvb, payload_offset, payload_length, -1);

	/* call the next dissector */
	call_dissector(data_handle, next_tvb, pinfo, tree);
}

    
/* Code to actually dissect general frame fields */
static void dissect_802_15_4(tvbuff_t *tvb, packet_info *pinfo, proto_tree *tree)
{  
	/* Set up structures needed to add the protocol subtree and manage it */
 	proto_item* ti;
  proto_item *fc;
 	proto_tree* tree_802_15_4;
 	proto_tree* fc_tree;
  int frame_type;
  tvbuff_t* next_tvb;
  guint8 seqno;
  int offset;

	tree_802_15_4 = NULL;
  
  offset = 0;
  seqno = tvb_get_guint8(tvb, 2);
  
	/* Make entries in Protocol column and Info column on summary display */
	if (check_col(pinfo->cinfo, COL_PROTOCOL)) 
		col_set_str(pinfo->cinfo, COL_PROTOCOL, "802.15.4");

	if (check_col(pinfo->cinfo, COL_INFO)) {
		col_set_str(pinfo->cinfo, COL_INFO, "");
  }

	if (tree) {

		/* create display subtree for the protocol */
 		ti = proto_tree_add_item(tree, proto_802_15_4, tvb, 0, -1, FALSE);
 		tree_802_15_4 = proto_item_add_subtree(ti, ett_802_15_4);

    /* tree for frame control */
    fc = proto_tree_add_item(tree_802_15_4, hf_802_15_4_fc, tvb, 0, 2, TRUE);
    fc_tree = proto_item_add_subtree(fc, ett_802_15_4);
    proto_tree_add_item(fc_tree, hf_802_15_4_fc_type, tvb, 0, 2, TRUE);
    proto_tree_add_item(fc_tree, hf_802_15_4_fc_security, tvb, 0, 2, TRUE);
    proto_tree_add_item(fc_tree, hf_802_15_4_fc_framepending, tvb, 0, 2, TRUE);
    proto_tree_add_item(fc_tree, hf_802_15_4_fc_ackrequest, tvb, 0, 2, TRUE);
    proto_tree_add_item(fc_tree, hf_802_15_4_fc_intrapan, tvb, 0, 2, TRUE);
    proto_tree_add_item(fc_tree, hf_802_15_4_fc_dstaddrmode, tvb, 0, 2, TRUE);
    proto_tree_add_item(fc_tree, hf_802_15_4_fc_srcaddrmode, tvb, 0, 2, TRUE);

		/* seqno */
    proto_tree_add_item(tree_802_15_4, hf_802_15_4_seqno, tvb, 2, 1, FALSE);

	}
  
  frame_type = (tvb_get_letohs(tvb, 0) & 0x7);
  switch (frame_type) {
    case 0:
      /* beacon */
      dissect_802_15_4_beacon(tvb, pinfo, tree_802_15_4, seqno);
      break;
    case 1:
      /* data */
      dissect_802_15_4_data(tvb, pinfo, tree_802_15_4, seqno);
      break;
    case 2:
      /* ack */
      if (check_col(pinfo->cinfo, COL_INFO)) {
				col_append_str(pinfo->cinfo, COL_INFO, "ack frame");
      }
      dissect_802_15_4_ack(seqno);
      break;
    case 3:
      /* command */
      dissect_802_15_4_command(tvb, pinfo, tree_802_15_4, seqno);
      break;
    default:
      if (check_col(pinfo->cinfo, COL_INFO)) {
				col_append_str(pinfo->cinfo, COL_INFO, "reserved frame format");
  		}
      offset = dissect_802_15_4_adr_info(tvb, pinfo, tree_802_15_4, seqno);
      /*
      g_snprintf((char*)src_adr, 8, "unknown");
      g_snprintf((char*)src_pan, 8, "unknown");
      g_snprintf((char*)dst_adr, 8, "unknown");
      g_snprintf((char*)dst_pan, 8, "unknown");
      */
      /* we don't know the frame type, so just pass the data 
      	after framecontrol + adress info as payload to the next dissector */
    	next_tvb = tvb_new_subset(tvb, offset, tvb_length(tvb)-offset-2, -1);
			call_dissector(data_handle, next_tvb, pinfo, tree_802_15_4);
  }

  if (tree) {
  	/* print fcs field */
    proto_tree_add_item(tree_802_15_4, hf_802_15_4_fcs, tvb, tvb_length(tvb)-2, 2, TRUE);
  }
    
  if (check_col(pinfo->cinfo, COL_INFO)) {
    col_append_fstr(pinfo->cinfo, COL_INFO, " (seqno = %i)", seqno);
  }
  
  /* set the address information */
  SET_ADDRESS(&pinfo->net_src, AT_STRINGZ, 8, src_pan);
  SET_ADDRESS(&pinfo->src, AT_STRINGZ, 17, src_adr);
  SET_ADDRESS(&pinfo->net_dst, AT_STRINGZ, 8, dst_pan);
  SET_ADDRESS(&pinfo->dst, AT_STRINGZ, 17, dst_adr);
  pinfo->ptype=PT_NONE;
  pinfo->srcport=pinfo->destport=0;
      

}


/* try to determine if this is a 802.15.4 frame */
gboolean dissect_heuristic_802_15_4(tvbuff_t *tvb, packet_info *pinfo, proto_tree *tree) 
{
  /* just check length. Don't know another criteria */
  if ((tvb_length(tvb) < 127) && (tvb_length(tvb) > 4)) {
    dissect_802_15_4(tvb, pinfo, tree);
 		return TRUE; 
  } else {
    return FALSE; 
  }
}

/* Register the protocol with Wireshark */
void proto_register_802_15_4(void)
{                 
	module_t *module_802_15_4;

	/* 802.15.4 Header */
	static hf_register_info hf[] = {
    
    /* Frame Control fields */
    { &hf_802_15_4_fc,	{ "Frame_Control", "802_15_4.fc", FT_UINT16, BASE_HEX, NULL, 0x0, "", HFILL } },
		{ &hf_802_15_4_fc_type,	{ "Frame_Type", "802_15_4.fc.type", FT_UINT16, BASE_DEC, VALS(vals_802_15_4_frame_type), 7 << 0, "", HFILL } },
    { &hf_802_15_4_fc_security,	{ "Security_Enabled", "802_15_4.fc.security", FT_BOOLEAN, 16, NULL, 1 << 3, "", HFILL } },
    { &hf_802_15_4_fc_framepending,	{ "Frame_Pending", "802_15_4.fc.framepending", FT_BOOLEAN, 16, NULL, 1 << 4, "", HFILL } },
    { &hf_802_15_4_fc_ackrequest,	{ "Ack_Request", "802_15_4.fc.ackrequest", FT_BOOLEAN, 16, NULL, 1 << 5, "", HFILL } },
    { &hf_802_15_4_fc_intrapan,	{ "Intra_PAN", "802_15_4.fc.intrapan", FT_BOOLEAN, 16, NULL, 1 << 6, "", HFILL } },
    { &hf_802_15_4_fc_dstaddrmode,	{ "Destination_Addressing_Mode", "802_15_4.fc.dstaddrmode", FT_UINT16, BASE_HEX, VALS(vals_802_15_4_addressing_mode), 3 << 10, "", HFILL } },
    { &hf_802_15_4_fc_srcaddrmode,	{ "Source_Addressing_Mode", "802_15_4.fc.srcaddrmode", FT_UINT16, BASE_HEX, VALS(vals_802_15_4_addressing_mode), 3 << 14, "", HFILL } },
    
    /* DSN/BSN */
    { &hf_802_15_4_seqno,	{ "Sequence_Number", "802_15_4.seqno", FT_UINT8, BASE_DEC, NULL, 0x0, "", HFILL } },
    
    /* Addressing fields */
    { &hf_802_15_4_dst_pan_id,	{ "Destination_PAN_ID", "802_15_4.dstPANID", FT_UINT16, BASE_HEX, NULL, 0x0, "", HFILL } },
    { &hf_802_15_4_dst_adr_16,	{ "Destination_Address", "802_15_4.dst", FT_UINT16, BASE_HEX, NULL, 0x0, "", HFILL } },
    { &hf_802_15_4_dst_adr_64,	{ "Destination_Address", "802_15_4.dst", FT_UINT64, BASE_HEX, NULL, 0x0, "", HFILL } },
    { &hf_802_15_4_src_pan_id,	{ "Source_PAN_ID", "802_15_4.srcPANID", FT_UINT16, BASE_HEX, NULL, 0x0, "", HFILL } },
    { &hf_802_15_4_src_adr_16,	{ "Source_Address", "802_15_4.src", FT_UINT16, BASE_HEX, NULL, 0x0, "", HFILL } },
    { &hf_802_15_4_src_adr_64,	{ "Source_Address", "802_15_4.src", FT_UINT64, BASE_HEX, NULL, 0x0, "", HFILL } },

    /* beacon specific fields */
    { &hf_802_15_4_superframe_spec,	{ "Superframe_Specification", "802_15_4.beacon.superframe_spec", FT_UINT16, BASE_HEX, NULL, 0x0, "", HFILL } },
    { &hf_802_15_4_superframe_spec_bo,	{ "Beacon_Order", "802_15_4.beacon.superframe_spec.bo", FT_UINT16, BASE_DEC, NULL, 0xf << 0, "", HFILL } },
		{ &hf_802_15_4_superframe_spec_so,	{ "Superframe_Order", "802_15_4.beacon.superframe_spec.so", FT_UINT16, BASE_DEC, NULL, 0xf << 4, "", HFILL } },
  	{ &hf_802_15_4_superframe_spec_final_cap_slot,	{ "Final_CAP_Slot", "802_15_4.beacon.superframe_spec.final_cap_slot", FT_UINT16, BASE_DEC, NULL, 0xf << 8, "", HFILL } },
  	{ &hf_802_15_4_superframe_spec_ble,	{ "Battery_Life_Extension", "802_15_4.beacon.superframe_spec.ble", FT_BOOLEAN, 16, NULL, 1 << 12, "", HFILL } },
    { &hf_802_15_4_superframe_spec_pan_coord,	{ "PAN_Coordinator", "802_15_4.beacon.superframe_spec.pan_coord", FT_BOOLEAN, 16, NULL, 1 << 14, "", HFILL } },
    { &hf_802_15_4_superframe_spec_ap,	{ "Association_Permit", "802_15_4.beacon.superframe_spec.ap", FT_BOOLEAN, 16, NULL, 1 << 15, "", HFILL } },
    { &hf_802_15_4_gts,	{ "GTS_Fields", "802_15_4.gts", FT_BYTES, BASE_HEX, NULL, 0x0, "", HFILL } },
    { &hf_802_15_4_gts_spec,	{ "GTS_Specification", "802_15_4.beacon.gts.spec", FT_UINT8, BASE_HEX, NULL, 0x0, "", HFILL } },
    { &hf_802_15_4_gts_spec_dc,	{ "Descriptor_Count", "802_15_4.beacon.gts.dc", FT_UINT8, BASE_HEX, NULL, 7 << 0, "", HFILL } },
    { &hf_802_15_4_gts_spec_gp,	{ "GTS_Permit", "802_15_4.beacon.gts.gp", FT_BOOLEAN, 8, NULL, 1 << 7, "", HFILL } },
    { &hf_802_15_4_gts_dirs,	{ "GTS_Directions", "802_15_4.beacon.gts.dirs", FT_UINT8, BASE_HEX, NULL, 0x0, "", HFILL } },
    { &hf_802_15_4_gts_dir_slot0,	{ "Slot_0", "802_15_4.beacon.gts.dir.slot0", FT_BOOLEAN, 8, TFS(&tf_802_15_4_gts_dir), 1 << 0, "", HFILL } },
    { &hf_802_15_4_gts_dir_slot1,	{ "Slot_1", "802_15_4.beacon.gts.dir.slot1", FT_BOOLEAN, 8, TFS(&tf_802_15_4_gts_dir), 1 << 1, "", HFILL } },
    { &hf_802_15_4_gts_dir_slot2,	{ "Slot_2", "802_15_4.beacon.gts.dir.slot2", FT_BOOLEAN, 8, TFS(&tf_802_15_4_gts_dir), 1 << 2, "", HFILL } },
    { &hf_802_15_4_gts_dir_slot3,	{ "Slot_3", "802_15_4.beacon.gts.dir.slot3", FT_BOOLEAN, 8, TFS(&tf_802_15_4_gts_dir), 1 << 3, "", HFILL } },
    { &hf_802_15_4_gts_dir_slot4,	{ "Slot_4", "802_15_4.beacon.gts.dir.slot4", FT_BOOLEAN, 8, TFS(&tf_802_15_4_gts_dir), 1 << 4, "", HFILL } },
    { &hf_802_15_4_gts_dir_slot5,	{ "Slot_5", "802_15_4.beacon.gts.dir.slot5", FT_BOOLEAN, 8, TFS(&tf_802_15_4_gts_dir), 1 << 5, "", HFILL } },
    { &hf_802_15_4_gts_dir_slot6,	{ "Slot_6", "802_15_4.beacon.gts.dir.slot6", FT_BOOLEAN, 8, TFS(&tf_802_15_4_gts_dir), 1 << 6, "", HFILL } },
        
    { &hf_802_15_4_gts_desc,	{ "GTS_Descriptor", "802_15_4.beacon.gts.desc", FT_UINT24, BASE_HEX, NULL, 0x0, "", HFILL } },
    { &hf_802_15_4_gts_desc_short_addr,	{ "Short_Address", "802_15_4.beacon.gts.short_adr", FT_UINT24, BASE_HEX, NULL, 0xFFFF << 0, "", HFILL } },
    { &hf_802_15_4_gts_desc_start,	{ "Start_Slot", "802_15_4.beacon.gts.start", FT_UINT24, BASE_HEX, NULL, 0xF << 16, "", HFILL } },
    { &hf_802_15_4_gts_desc_length,	{ "Length", "802_15_4.beacon.gts.length", FT_UINT24, BASE_HEX, NULL, 0xF << 20, "", HFILL } },
    
    { &hf_802_15_4_pending_adr,	{ "Pending_Address_Fields", "802_15_4.beacon.pending_adr", FT_BYTES, BASE_HEX, NULL, 0x0, "", HFILL } },
    { &hf_802_15_4_pending_adr_spec,	{ "Pending_Address_Specification", "802_15_4.beacon.pending_adr.spec", FT_UINT8, BASE_HEX, NULL, 0x0, "", HFILL } },
    { &hf_802_15_4_pending_adr_spec_short_adr_count,	{ "Short_Address_Count", "802_15_4.beacon.pending_adr.spec.short_adr_count", FT_UINT8, BASE_HEX, NULL, 0x7 << 0, "", HFILL } },
		{ &hf_802_15_4_pending_adr_spec_ext_adr_count,	{ "Extended_Address_Count", "802_15_4.beacon.pending_adr.spec.ext_adr_count", FT_UINT8, BASE_HEX, NULL, 0x7 << 4, "", HFILL } },
  	{ &hf_802_15_4_pending_short_adr_list,	{ "Pending_Short_Addresses", "802_15_4.beacon.pending_short_adr_list", FT_BYTES, BASE_HEX, NULL, 0x0, "", HFILL } },
    { &hf_802_15_4_pending_ext_adr_list,	{ "Pending_Ext_Addresses", "802_15_4.beacon.pending_ext_adr_list", FT_BYTES, BASE_HEX, NULL, 0x0, "", HFILL } },
  	{ &hf_802_15_4_pending_ext_adr,	{ "Pending_Extended_Address", "802_15_4.beacon.pending_adr.ext_adr", FT_UINT64, BASE_HEX, NULL, 0x0, "", HFILL } },
  	{ &hf_802_15_4_pending_short_adr,	{ "Pending_Short_Address", "802_15_4.beacon.pending_adr.short_adr", FT_UINT16, BASE_HEX, NULL, 0x0, "", HFILL } },
    { &hf_802_15_4_beacon_payload,	{ "Beacon_Payload", "802_15_4.beacon.payload",  FT_BYTES, BASE_HEX, NULL, 0x0, "", HFILL } },

    { &hf_802_15_4_command_id,	{ "Command_ID", "802_15_4.command.id",  FT_UINT8, BASE_HEX, VALS(vals_802_15_4_command_id), 0x0, "", HFILL } },
    { &hf_802_15_4_capability_info,	{ "Capability_Info", "802_15_4.command.associate.request.capability_info",  FT_UINT8, BASE_HEX, NULL, 0x0, "", HFILL } },
    { &hf_802_15_4_alternate_pan_coord,	{ "Alternate_PAN_Coordinator", "802_15_4.associate.request.alternate_pan_coord",  FT_BOOLEAN, 8, TFS(&tf_802_15_4_alternate_pan), 0x1 << 0, "", HFILL } },
		{ &hf_802_15_4_device_type,	{ "Device_Type", "802_15_4.associate.request.device_type",  FT_BOOLEAN,  8, TFS(&tf_802_15_4_device_type), 0x1 << 1, "", HFILL } },
  	{ &hf_802_15_4_power_source,	{ "Power_Source", "802_15_4.associate.request.power_source", FT_BOOLEAN, 8, TFS(&tf_802_15_4_power_source), 0x1 << 2, "", HFILL } },
    { &hf_802_15_4_rx_on_idle,	{ "Receiver_On_When_Idle", "802_15_4.associate.request.rx_on_when_idle",  FT_BOOLEAN,  8, TFS(&tf_802_15_4_rx_on_idle), 0x1 << 3, "", HFILL } },
    { &hf_802_15_4_security_capability,	{ "Security_Capability", "802_15_4.associate.request.security_capability",  FT_BOOLEAN,  8, TFS(&tf_802_15_4_security_capability), 0x1 << 6, "", HFILL } },
    { &hf_802_15_4_allocate_address,	{ "Allocate_Address", "802_15_4.associate.request.allocate_adr",  FT_BOOLEAN,  8, TFS(&tf_802_15_4_allocate_address), 0x1 << 7, "", HFILL } },
    
		{ &hf_802_15_4_assigned_address,	{ "Assigned_Short_Address", "802_15_4.command.association.response.assigned_adr",  FT_UINT16, BASE_HEX, NULL, 0x0, "", HFILL } },
		{ &hf_802_15_4_association_status,	{ "Association_Status", "802_15_4.command.association.response.status",  FT_UINT8, BASE_HEX, VALS(vals_802_15_4_association_status), 0x0, "", HFILL } },
		{ &hf_802_15_4_mac_enumeration,	{ "Association_Failure", "802_15_4command.association.response.failure",  FT_UINT8, BASE_HEX, VALS(vals_802_15_4_mac_enumeration), 0x0, "", HFILL } },
    { &hf_802_15_4_disassociation_reason, { "Disassociation_Reason", "802_15_4.command.disassociation.reason",  FT_UINT8, BASE_HEX, VALS(vals_802_15_4_disassociation_reason), 0x0, "", HFILL } },
    { &hf_802_15_4_pan_id,	{ "PAN_ID", "802_15_4.command.realignment.pan_id", FT_UINT16, BASE_HEX, NULL, 0x0, "", HFILL } },
    { &hf_802_15_4_coord_short_adr,	{ "Coordinator_Short_Address", "802_15_4.command.realignment.coord_short_adr", FT_UINT16, BASE_HEX, NULL, 0x0, "", HFILL } },
		{ &hf_802_15_4_channel,	{ "Logical_Channel", "802_15_4.command.realignment.channel", FT_UINT8, BASE_HEX, NULL, 0x0, "", HFILL } },
    { &hf_802_15_4_assigned_short_adr,	{ "Assigned_Short_Address", "802_15_4.command.realignment.assigned_short_adr", FT_UINT16, BASE_HEX, NULL, 0x0, "", HFILL } },

    
    { &hf_802_15_4_gts_characteristics,	{ "GTS_Characteristics", "802_15_4.command.gts.characteristic", FT_UINT8, BASE_HEX, NULL, 0xF << 0, "", HFILL } },
    { &hf_802_15_4_gts_length,	{ "GTS_Length", "802_15_4.802_15_4.command.gts.length", FT_UINT8, BASE_HEX, NULL, 0x0, "", HFILL } },
    { &hf_802_15_4_gts_dir,	{ "GTS_Direction", "802_15_4.command.gts.dir", FT_BOOLEAN, 8, TFS(&tf_802_15_4_gts_dir), 0x1 << 4, "", HFILL } },
    { &hf_802_15_4_gts_type,	{ "GTS_Type", "802_15_4.command.gts.type", FT_BOOLEAN, 8, TFS(&tf_802_15_4_gts_type), 0x1 << 4, "", HFILL } },

        
    /* depends heavily on phy spec */
    { &hf_802_15_4_fcs,	{ "FCS", "802_15_4.fcs", FT_UINT16, BASE_HEX, NULL, 0x00, "", HFILL } }

	};

  
	/* Setup protocol subtree array */
	static gint *ett[] = {
		&ett_802_15_4
	};

	/* Register the protocol name and description */
	proto_802_15_4 = proto_register_protocol("802.15.4 MAC Protocol", "802.15.4", "802_15_4");

	/* Required function calls to register the header fields and subtrees used */
	proto_register_field_array(proto_802_15_4, hf, array_length(hf));
	proto_register_subtree_array(ett, array_length(ett));
        
}


/* If this dissector uses sub-dissector registration add a registration routine.
   This exact format is required because a script is used to find these routines 
   and create the code that calls these routines.
   
   This function is also called by preferences whenever "Apply" is pressed 
   (see prefs_register_protocol above) so it should accommodate being called 
   more than once.
*/
void proto_reg_handoff_802_15_4(void)
{
	static dissector_handle_t handle_802_15_4;
	static gboolean inited = FALSE;
  int i;
  
	if (!inited) {
	    handle_802_15_4 = create_dissector_handle(dissect_802_15_4, proto_802_15_4);
	    //dissector_add_handle("802_15_4", handle_802_15_4);
	    inited = TRUE;
	}
  
  /* init some internal stuff, like ack tracking */
  for (i = 0; i < 255; i++) {
    ack_adr_info[i].addr_mode = 0;
  }
  
  /* adds heuristic dissecor (we don't know if the cc2420 frame is really an 802.15.4 frame) */
	heur_dissector_add("cc2420", dissect_heuristic_802_15_4, proto_802_15_4);
    
 	data_handle = find_dissector("data");
}

