/**
 *
 * $Rev:: 112         $:  Revision of last commit
 * $Author$:  Author of last commit
 * $Date$:  Date of last commit
 *
 **/
#ifndef __BTPACKET_H__
#define __BTPACKET_H__

// Remember that this packet size must be "large enough" to contain both
// data AND what ever headers the stack decides to put on.
// At the moment that is:
//
// 1 byte from HCIPacket.addTransport() - serial transport +
// 4 byte max (HCI_COMMAND_HDR_SIZE,
//             HCI_ACL_HDR_SIZE,
//             HCI_SCO_HDR_SIZE,
//             HCI_EVENT_HDR_SIZE )
// = 5 bytes

enum {
    HCIPACKET_BUF_SIZE=300,
  MAX_DLEN=HCIPACKET_BUF_SIZE-5
};
#include "hci.h"
#include "additional_hci.h"

/*
 *   Header that defines a generic packet structure for use with Bluetooth.
 * 
 *   Copyright (C) 2002 & 2003 Martin Leopold, <leopold@diku.dk>
 * 
 *   This program is free software; you can redistribute it and/or modify
 *   it under the terms of the GNU General Public License as published by
 *   the Free Software Foundation; either version 2 of the License, or
 *   (at your option) any later version.
 * 
 *   This program is distributed in the hope that it will be useful,
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *   GNU General Public License for more details.
 * 
 *   You should have received a copy of the GNU General Public License
 *   along with this program; if not, write to the Free Software
 *   Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
 * */


// Apparently defines are bad mkay... At least it doesn't work if I include
// This file from other .nc files...

// Defines a generic packet structure "gen_pkt"
//  - start is the first full byte
//  - end is the first empty byte
// start==end means the buffer is empty
// All packets (ie. the ones ending in _pkt) defined below can be
// typecast to this buffer
// Remember that when seting start and end to the begining and end of data:
//         _________
// data: x|0|1|2|3|4|x|x
//        *         @
// * Start has to point to data[0]
// @ While end has to point to data+NO_ELEMENTS=data[last+1]
// Since end points to the _next_ element, not the last!!

// Order _is_ important to be most efficient the program takes advantage
// of the order of data!!

typedef enum {
  OK=0x00,
  UNKNOWN_PTYPE=0x01,
  UNKNOWN_PTYPE_DONE=0x02,
  EVENT_PKT_TOO_LONG=0x03,
  ACL_PKT_TOO_LONG=0x04,
  UNKNOWN_EVENT=0x05,
  UNKNOWN_CMD_COMPLETE=0x06,
  HW_ERROR=0x07,

  // parm=evtNo of evt that took too long
  // Data corruption has occured
  UART_UNABLE_TO_HANDLE_EVENTS=0x08,

  HCIPACKET_SEND_OVERFLOW=0x09,
  EVENT_HANDLER_TO_SLOW=0x10,

  // parm=evtNo of evt that took too long
  // New event will be droped!!
  HCI_UNABLE_TO_HANDLE_EVENTS = 0x11,

  NO_FREE_RECV_PACKET = 0x12,
  WRONG_ACK = 0x13,
}  errcode;

typedef enum {
  HCI_COMMAND = 0x01,
  HCI_ACLDATA = 0x02,
  HCI_SCODATA = 0x03,
  HCI_EVENT   = 0x04
} hci_data_t;

typedef struct {
  uint8_t *end;
  uint8_t *start;
  uint8_t data[HCIPACKET_BUF_SIZE];
} __attribute__ ((packed)) gen_pkt;

// Reset the buffer to appear empty
static inline void rst_pkt(gen_pkt *pkt) {
  pkt->start = pkt->data;
  pkt->end   = pkt->data;
}

// Setup the buffer to appear empty, but start/end at the other end
// -> what you wan't when you're about to send in this buffer
static inline void rst_send_pkt(gen_pkt *pkt) {
  pkt->start = &pkt->data[HCIPACKET_BUF_SIZE];
  pkt->end   = &pkt->data[HCIPACKET_BUF_SIZE];
}

// Copy a pkt. This keeps the layout but only copies the data between
// start and end.
static inline void pkt_cpy(gen_pkt *dest, const gen_pkt *src) {
  dest->start = 
  ((uint8_t *) dest) + (((uint8_t *) src->start) - ((uint8_t *) src));
  dest->end = 
  ((uint8_t *) dest) + (((uint8_t *) src->end) - ((uint8_t *) src));
  memcpy(dest->start, src->start, 
      (((uint8_t *) src->end) -  ((uint8_t *) src->start)));
}

/*****************************************************************************
 *                             Response structures                           *
 *****************************************************************************/

// Inquiry response
// start is an array of responses - this is not what the spec describes,
// but it is the only thing that makes sense
typedef struct {
  uint8_t *end;
  struct {
    uint8_t numresp;
    inquiry_info info[(MAX_DLEN - 1)/sizeof(inquiry_info)];
  } *devices;
  uint8_t data[HCIPACKET_BUF_SIZE];
} __attribute__ ((packed)) inq_resp_pkt;

typedef struct {
  uint8_t *end;
  struct {
    uint8_t numresp;
    inquiry_rssi_info info[(MAX_DLEN - 1)/sizeof(inquiry_rssi_info)];
  } *devices;
  uint8_t data[HCIPACKET_BUF_SIZE];
} __attribute__ ((packed)) inq_resp_rssi_pkt;

// Response to a create_conn
typedef struct {
  uint8_t *end;
  evt_conn_complete *start;
  uint8_t data[HCIPACKET_BUF_SIZE];
} __attribute__ ((packed)) conn_complete_pkt;

// Incoming connection request
typedef struct {
  uint8_t *end;
  evt_conn_request *start;
  uint8_t data[HCIPACKET_BUF_SIZE];
} __attribute__ ((packed)) conn_request_pkt;

typedef struct {
  uint8_t *end;
  evt_disconn_complete *start;
  uint8_t data[HCIPACKET_BUF_SIZE];
} __attribute__ ((packed)) disconn_complete_pkt;

typedef struct {
  uint8_t *end;
  evt_num_comp_pkts *start;
  uint8_t data[HCIPACKET_BUF_SIZE];
} __attribute__ ((packed)) num_comp_pkts_pkt;

typedef struct {
  uint8_t *end;
  evt_mode_change *start;
  uint8_t data[HCIPACKET_BUF_SIZE];
} __attribute__ ((packed)) evt_mode_change_pkt;

typedef struct {
  uint8_t *end;
  evt_role_change *start;
  uint8_t data[HCIPACKET_BUF_SIZE];
} __attribute__ ((packed)) evt_role_change_pkt;

typedef struct {
  uint8_t *end;
  evt_conn_ptype_changed *start;
  uint8_t data[HCIPACKET_BUF_SIZE];
} __attribute__ ((packed)) evt_conn_ptype_changed_pkt;

/****************/

typedef struct {
  uint8_t *end;
  read_bd_addr_rp *start;
  uint8_t data[HCIPACKET_BUF_SIZE];
} __attribute__ ((packed)) read_bd_addr_pkt;

typedef struct {
  uint8_t *end;
  read_buffer_size_rp *start;
  uint8_t data[HCIPACKET_BUF_SIZE];
} __attribute__ ((packed)) read_buf_size_pkt;

typedef struct {
  uint8_t *end;
  write_link_policy_rp *start;
  uint8_t data[HCIPACKET_BUF_SIZE];
} __attribute__ ((packed)) write_link_policy_complete_pkt;

/**
 * A lot of commands return a simple status parameter. Error codes can be read
 * on p. 766 of the V1.1 spec
 */
typedef struct {
  uint8_t status;
} __attribute__ ((packed)) status_rp;

typedef struct {
  uint8_t *end;
  status_rp *start;
  uint8_t data[HCIPACKET_BUF_SIZE];
} __attribute__ ((packed)) status_pkt;

/*****************************************************************************
 *                             Request structures                            *
 *****************************************************************************/

// Inquiry request
typedef struct {
  uint8_t *end;// = &data[HCIPACKET_BUF_SIZE-1];
  inquiry_cp *start;// = &req;
  uint8_t data[HCIPACKET_BUF_SIZE-sizeof(inquiry_cp)];
  inquiry_cp req;
} __attribute__ ((packed)) inq_req_pkt;

typedef struct {
  uint8_t *end;
  write_inq_activity_cp *start;
  uint8_t data[HCIPACKET_BUF_SIZE-sizeof(write_inq_activity_cp)];
  write_inq_activity_cp cp;
} __attribute__ ((packed)) write_inq_activity_pkt;

typedef struct {
  uint8_t *end;
  periodic_inq_mode_cp *start;
  uint8_t data[HCIPACKET_BUF_SIZE-sizeof(periodic_inq_mode_cp)];
  periodic_inq_mode_cp cp;
} __attribute__ ((packed)) periodic_inq_mode_pkt;

// Create conn request
typedef struct {
  uint8_t *end;
  create_conn_cp *start;
  uint8_t data[HCIPACKET_BUF_SIZE-sizeof(create_conn_cp)];
  create_conn_cp cp;
} __attribute__ ((packed)) create_conn_pkt;

// Accept incoming connection request
typedef struct {
  uint8_t *end;
  accept_conn_req_cp *start;
  uint8_t data[HCIPACKET_BUF_SIZE-sizeof(accept_conn_req_cp)];
  accept_conn_req_cp cp;
} __attribute__ ((packed)) accept_conn_req_pkt;

// Reject incomming connection request
typedef struct {
  uint8_t *end;
  reject_conn_req_cp *start;
  uint8_t data[HCIPACKET_BUF_SIZE-sizeof(reject_conn_req_cp)];
  reject_conn_req_cp cp;
} __attribute__ ((packed)) reject_conn_req_pkt;

/** Request disconnect */
typedef struct {
  uint8_t *end;
  disconnect_cp *start;
  uint8_t data[HCIPACKET_BUF_SIZE-sizeof(disconnect_cp)];
  disconnect_cp cp;
} __attribute__ ((packed)) disconnect_pkt;

/** Sniff mode */
typedef struct {
  uint8_t *end;
  sniff_mode_cp *start;
  uint8_t data[HCIPACKET_BUF_SIZE-sizeof(sniff_mode_cp)];
  sniff_mode_cp cp;
} __attribute__ ((packed)) sniff_mode_pkt;

/** Write the link policy */
typedef struct {
  uint8_t *end;
  write_link_policy_cp *start;
  uint8_t data[HCIPACKET_BUF_SIZE-sizeof(write_link_policy_cp)];
  write_link_policy_cp cp;
} __attribute__ ((packed)) write_link_policy_pkt;

typedef struct {
  uint8_t *end;
  write_default_link_policy_cp *start;
  uint8_t data[HCIPACKET_BUF_SIZE-sizeof(write_default_link_policy_cp)];
  write_default_link_policy_cp cp;
} __attribute__ ((packed)) write_default_link_policy_pkt;

typedef struct {
  uint8_t *end;
  switch_role_cp *start;
  uint8_t data[HCIPACKET_BUF_SIZE-sizeof(switch_role_cp)];
  switch_role_cp cp;
} __attribute__ ((packed)) switch_role_pkt;

typedef struct {
  uint8_t *end;
  set_conn_ptype_cp *start;
  uint8_t data[HCIPACKET_BUF_SIZE-sizeof(set_conn_ptype_cp)];
  set_conn_ptype_cp cp;
} __attribute__ ((packed)) set_conn_ptype_pkt;


/*****************************************************************************
 *                              Send/recv data                               *
 *****************************************************************************/

typedef struct {
  uint8_t *end;
  hci_acl_hdr *start;
  uint8_t data[HCIPACKET_BUF_SIZE];
} __attribute__ ((packed)) hci_acl_data_pkt;

#endif
