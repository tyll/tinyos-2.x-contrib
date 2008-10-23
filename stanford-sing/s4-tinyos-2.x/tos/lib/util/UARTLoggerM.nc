/* ex: set tabstop=2 shiftwidth=2 expandtab syn=c:*/
/* $Id$ */

/*                                                                      
 * "Copyright (c) 2000-2003 The Regents of the University  of California.  
 * All rights reserved.
 *
 * Permission to use, copy, modify, and distribute this software and its
 * documentation for any purpose, without fee, and without written agreement is
 * hereby granted, provided that the above copyright notice, the following
 * two paragraphs and the author appear in all copies of this software.
 * 
 * IN NO EVENT SHALL THE UNIVERSITY OF CALIFORNIA BE LIABLE TO ANY PARTY FOR
 * DIRECT, INDIRECT, SPECIAL, INCIDENTAL, OR CONSEQUENTIAL DAMAGES ARISING OUT
 * OF THE USE OF THIS SOFTWARE AND ITS DOCUMENTATION, EVEN IF THE UNIVERSITY OF
 * CALIFORNIA HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 * 
 * THE UNIVERSITY OF CALIFORNIA SPECIFICALLY DISCLAIMS ANY WARRANTIES,
 * INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY
 * AND FITNESS FOR A PARTICULAR PURPOSE.  THE SOFTWARE PROVIDED HEREUNDER IS
 * ON AN "AS IS" BASIS, AND THE UNIVERSITY OF CALIFORNIA HAS NO OBLIGATION TO
 * PROVIDE MAINTENANCE, SUPPORT, UPDATES, ENHANCEMENTS, OR MODIFICATIONS."
 *
 * Copyright (c) 2002-2003 Intel Corporation
 * All rights reserved.
 *
 * This file is distributed under the terms in the attached INTEL-LICENSE     
 * file. If you do not find these files, copies can be found by writing to
 * Intel Research Berkeley, 2150 Shattuck Avenue, Suite 1300, Berkeley, CA, 
 * 94704.  Attention:  Intel License Inquiry.
 */

/*
 * Author:  Rodrigo Fonseca
 * Date Last Modified: 2005/05/26
 */
 
 
/* Implements Logger, logging non-packet events to the UART.*/


includes BVR;
//includes BufferPool; //included below as #include
includes Logging;

module UARTLoggerM {
  provides {
    interface Init;
    interface StdControl;
    interface Logger;
    //interface LoggerCommand;
  }
  uses {
    interface AMSend as LogSend;
    interface Timer<TMilli> as SelfTimer;
    interface QueueControl;
    interface Leds;
    
    
    
    interface AMPacket;
  }
}


/* UARTLogger implements the Logger interface, only the non-packet events.
   The packets are logged by copying them, so the packet calls are inocuous.
   Each event is currently a packet of its own which is sent over the UART.
   We are going to rely on the QueuedSend to manage the sends.
   We have a buffer pool of messages to allow us to have outstanding messages.
*/

implementation {

  enum {
    LOG_ROOT_BEACON=0,
    LOG_COORDS=1,
    LOG_COORD=0,
    LOG_ROUTE=1,
    LOG_RETRANSMIT=1,
    LOG_SELF=0,
    LOG_LINK=0,
    LOG_NEIGHBOR=0,
    LOG_LOGGER=0,
    LOG_LRX=0,
    LOG_DEBUG=0,
  };

#include "BufferPool.nc"
  uint16_t stat_interval;

  BufferPool buffers;
   
  //Stats
  uint32_t stat_received; // A total requests received
  uint32_t stat_self_log; // A' total self reports generated
  uint32_t stat_self_log_no_buffer;
  uint32_t stat_written;  // B total successfully written
  uint32_t stat_bad_buffer; 
  uint32_t stat_no_buffer;  // C total failed no buffer  
  uint32_t stat_send_failed; // D total send failed
  uint32_t stat_send_done_failed; //E total send done returned fail
  // A + A' = B + C + D + E
  uint8_t min_available_buffers;
  uint8_t max_queued_send;

  uint16_t msg_size;
  
  void update_max_queued_send() {
    uint8_t queue_occupancy = 0;//call QueueControl.getOccupancy();
    max_queued_send = (max_queued_send > queue_occupancy)?
                       max_queued_send:queue_occupancy;
  }

  command error_t Init.init() {
    stat_received = 0;
    stat_written = 0;
    stat_no_buffer = 0;
    stat_bad_buffer = 0;
    stat_self_log = 0;
    stat_self_log_no_buffer = 0;
    stat_interval = SELF_LOG_INTERVAL;
    min_available_buffers = 255;
    max_queued_send = 0;
    msg_size = sizeof(BVRLogMsgWrapper);
    bufferPoolInit(&buffers);
    
    
    return SUCCESS;
  }

  command error_t StdControl.start() {
    if (LOG_SELF) {
      call SelfTimer.startPeriodic(stat_interval);
    }
    return SUCCESS;
  }

  command error_t StdControl.stop() {
    call SelfTimer.stop();
    return SUCCESS;
  }

  command error_t Logger.LogSendBeacon(uint8_t seqno) {
   return SUCCESS;
  }

  command error_t Logger.LogReceiveBeacon(uint8_t seqno, uint16_t from) {
    return SUCCESS;
  }
  command error_t Logger.LogSendRootBeacon(uint8_t seqno, uint8_t hopcount) {
    return SUCCESS;
  }
  command error_t Logger.LogReceiveRootBeacon(uint8_t seqno, uint8_t id, 
                            uint16_t last_hop, uint8_t hopcount, uint8_t quality) {
    message_t* msg_ptr;
    BVRLogMsgWrapper* log_msg;
    BVRLogMsg* log_ptr;
    uint8_t bp_status;
    error_t result;

    if (!LOG_ROOT_BEACON)
      return SUCCESS;
    atomic{      
        stat_received++;
        min_available_buffers = (min_available_buffers < bufferPoolGetNumberFree(&buffers))?
                                 min_available_buffers:bufferPoolGetNumberFree(&buffers);
        update_max_queued_send();
        result = bufferPoolGetFree(&buffers,&msg_ptr,&bp_status);
    }
    if (result == FAIL) {
      dbg("BVR-debug","Logger: could not get free buffer\n");
      if (bp_status)
        stat_bad_buffer++;
      else 
        stat_no_buffer++;
      return FAIL;
    }
    log_msg = (BVRLogMsgWrapper*) &msg_ptr->data[0];
    log_ptr = (BVRLogMsg*) &log_msg->log_msg;

    log_msg->header.last_hop = call AMPacket.address();
    log_msg->header.seqno = (uint16_t)stat_received;

    log_ptr->type = LOG_RECEIVE_ROOT_BEACON;
    log_ptr->receive_root_beacon.seqno = seqno;
    log_ptr->receive_root_beacon.id = id;
    log_ptr->receive_root_beacon.hopcount = hopcount;
    log_ptr->receive_root_beacon.last_hop = last_hop;
    log_ptr->receive_root_beacon.quality = quality;
    

    if (call LogSend.send(AM_BROADCAST_ADDR,msg_ptr, msg_size) != SUCCESS) {
      stat_send_failed++;
      dbg("BVR-debug","Logger: send failed, freeing the buffer\n"); 
      bufferPoolSetFree(&buffers,msg_ptr);
      return FAIL;
    }
    return SUCCESS;
  }

  command error_t Logger.LogSendLinkInfo() {
    return SUCCESS;
  }
  command error_t Logger.LogReceiveLinkInfo() {
    return SUCCESS;
  }
  command error_t Logger.LogSendAppMsg(uint8_t id, uint16_t to, uint8_t mode, 
                                   uint8_t fallback_thresh, Coordinates* dest) {
    return SUCCESS;
  }
  command error_t Logger.LogReceiveAppMsg(uint8_t id, uint8_t result) {
    return SUCCESS;
  }

  /* These are logged. The others are ignored, since they are already logged
     by the packet logger */

  command error_t Logger.LogAddLink(LinkNeighbor* n) {
    message_t* msg_ptr;
    BVRLogMsgWrapper* log_msg;
    BVRLogMsg* log_ptr;
    uint8_t bp_status;
    error_t result;
    if (!LOG_LINK)
      return SUCCESS;
    dbg("BVR-debug","Logger$AddLink\n");
    if (n == NULL)
      return FAIL;
    atomic{      
        stat_received++;
        min_available_buffers = (min_available_buffers < bufferPoolGetNumberFree(&buffers))?
                                 min_available_buffers:bufferPoolGetNumberFree(&buffers);
        update_max_queued_send();
        result = bufferPoolGetFree(&buffers,&msg_ptr,&bp_status);
    }
    if (result == FAIL) {
      dbg("BVR-debug","Logger: could not get free buffer\n");
      if (bp_status)
        stat_bad_buffer++;
      else 
        stat_no_buffer++;
      return FAIL;
    }
    log_msg = (BVRLogMsgWrapper*) &msg_ptr->data[0];
    log_ptr = (BVRLogMsg*) &log_msg->log_msg;

    log_msg->header.last_hop = call AMPacket.address();
    log_msg->header.seqno = (uint16_t)stat_received;

    log_ptr->type = LOG_ADD_LINK;
    log_ptr->change_link.link = *n;

    if (call LogSend.send(AM_BROADCAST_ADDR,msg_ptr,msg_size) != SUCCESS) {
      stat_send_failed++;
      dbg("BVR-debug","Logger: send failed, freeing the buffer\n"); 
      bufferPoolSetFree(&buffers,msg_ptr);
      return FAIL;
    }
    return SUCCESS;
  }
  command error_t Logger.LogChangeLink(LinkNeighbor *n) {
    message_t* msg_ptr;
    BVRLogMsgWrapper* log_msg;
    BVRLogMsg* log_ptr;
    uint8_t bp_status;
    error_t result;

    if (!LOG_LINK)
      return SUCCESS;
    if (n == NULL)
      return FAIL;
    atomic{      
        stat_received++;
        min_available_buffers = (min_available_buffers < bufferPoolGetNumberFree(&buffers))?
                                 min_available_buffers:bufferPoolGetNumberFree(&buffers);
        update_max_queued_send();
        result = bufferPoolGetFree(&buffers,&msg_ptr,&bp_status);
    }
    if (result == FAIL) {
      dbg("BVR-debug","Logger: could not get free buffer\n");
      if (bp_status)
        stat_bad_buffer++;
      else 
        stat_no_buffer++;
      return FAIL;
    }
    log_msg = (BVRLogMsgWrapper*) &msg_ptr->data[0];
    log_ptr = (BVRLogMsg*) &log_msg->log_msg;

    log_msg->header.last_hop = call AMPacket.address();
    log_msg->header.seqno = (uint16_t)stat_received;

    log_ptr->type = LOG_CHANGE_LINK;
    log_ptr->change_link.link = *n;

    if (call LogSend.send(AM_BROADCAST_ADDR,msg_ptr,msg_size) != SUCCESS) {
      stat_send_failed++;
      dbg("BVR-debug","Logger: send failed, freeing the buffer\n"); 
      bufferPoolSetFree(&buffers,msg_ptr);
      return FAIL;
    }
    return SUCCESS;
  }
  command error_t Logger.LogDropLink(uint16_t addr) {
    message_t* msg_ptr;
    BVRLogMsgWrapper* log_msg;
    BVRLogMsg* log_ptr;
    uint8_t bp_status;
    error_t result;

    if (!LOG_LINK)
      return SUCCESS;
    atomic{      
        stat_received++;
        min_available_buffers = (min_available_buffers < bufferPoolGetNumberFree(&buffers))?
                                 min_available_buffers:bufferPoolGetNumberFree(&buffers);
        update_max_queued_send();
        result = bufferPoolGetFree(&buffers,&msg_ptr,&bp_status);
    }
    if (result == FAIL) {
      dbg("BVR-debug","Logger: could not get free buffer\n");
      if (bp_status)
        stat_bad_buffer++;
      else 
        stat_no_buffer++;
      return FAIL;
    }
    log_msg = (BVRLogMsgWrapper*) &msg_ptr->data[0];
    log_ptr = (BVRLogMsg*) &log_msg->log_msg;

    log_msg->header.last_hop = call AMPacket.address();
    log_msg->header.seqno = (uint16_t)stat_received;

    log_ptr->type = LOG_DROP_LINK;
    log_ptr->drop_link.addr = addr;

    if (call LogSend.send(AM_BROADCAST_ADDR, msg_ptr, msg_size) != SUCCESS) {
      stat_send_failed++;
      dbg("BVR-debug","Logger: send failed, freeing the buffer\n"); 
      bufferPoolSetFree(&buffers,msg_ptr);
      return FAIL;
    }
    return SUCCESS;
  }
  command error_t Logger.LogAddNeighbor(CoordinateTableEntry * ce) {
    message_t* msg_ptr;
    BVRLogMsgWrapper* log_msg;
    BVRLogMsg* log_ptr;
    uint8_t bp_status;
    error_t result;

    if (!LOG_NEIGHBOR)
      return SUCCESS;
    if (ce == NULL)
      return FAIL;
    atomic{      
        stat_received++;
        min_available_buffers = (min_available_buffers < bufferPoolGetNumberFree(&buffers))?
                                 min_available_buffers:bufferPoolGetNumberFree(&buffers);
        update_max_queued_send();
        result = bufferPoolGetFree(&buffers,&msg_ptr,&bp_status);
    }
    if (result == FAIL) {
      dbg("BVR-debug","Logger: could not get free buffer\n");
      if (bp_status)
        stat_bad_buffer++;
      else 
        stat_no_buffer++;
      return FAIL;
    }
    log_msg = (BVRLogMsgWrapper*) &msg_ptr->data[0];
    log_ptr = (BVRLogMsg*) &log_msg->log_msg;

    log_msg->header.last_hop = call AMPacket.address();
    log_msg->header.seqno = (uint16_t)stat_received;

    log_ptr->type = LOG_ADD_NEIGHBOR;
    log_ptr->add_neighbor.neighbor = *ce;

    if (call LogSend.send(AM_BROADCAST_ADDR,msg_ptr, msg_size) != SUCCESS) {
      stat_send_failed++;
      dbg("BVR-debug","Logger: send failed, freeing the buffer\n"); 
      bufferPoolSetFree(&buffers,msg_ptr);
      return FAIL;
    }
    return SUCCESS;
  }
  command error_t Logger.LogUpdateNeighbor(CoordinateTableEntry *ce) {
    message_t* msg_ptr;
    BVRLogMsgWrapper* log_msg;
    BVRLogMsg* log_ptr;
    uint8_t bp_status;
    error_t result;

    if (!LOG_NEIGHBOR)
      return SUCCESS;
    if (ce == NULL)
      return FAIL;
    atomic{      
        stat_received++;
        min_available_buffers = (min_available_buffers < bufferPoolGetNumberFree(&buffers))?
                                 min_available_buffers:bufferPoolGetNumberFree(&buffers);
        update_max_queued_send();
        result = bufferPoolGetFree(&buffers,&msg_ptr,&bp_status);
    }
    if (result == FAIL) {
      dbg("BVR-debug","Logger: could not get free buffer\n");
      if (bp_status)
        stat_bad_buffer++;
      else 
        stat_no_buffer++;
      return FAIL;
    }
    log_msg = (BVRLogMsgWrapper*) &msg_ptr->data[0];
    log_ptr = (BVRLogMsg*) &log_msg->log_msg;

    log_msg->header.last_hop = call AMPacket.address();
    log_msg->header.seqno = (uint16_t)stat_received;

    log_ptr->type = LOG_CHANGE_NEIGHBOR;
    log_ptr->change_neighbor.neighbor = *ce;

    if (call LogSend.send(AM_BROADCAST_ADDR,msg_ptr,msg_size) != SUCCESS) {
      stat_send_failed++;
      dbg("BVR-debug","Logger: send failed, freeing the buffer\n"); 
      bufferPoolSetFree(&buffers,msg_ptr);
      return FAIL;
    }
    return SUCCESS;
  }
  command error_t Logger.LogDropNeighbor(uint16_t addr) {
    message_t* msg_ptr;
    BVRLogMsgWrapper* log_msg;
    BVRLogMsg* log_ptr;
    uint8_t bp_status;
    error_t result;

    if (!LOG_NEIGHBOR)
      return SUCCESS;
    atomic{      
        stat_received++;
        min_available_buffers = (min_available_buffers < bufferPoolGetNumberFree(&buffers))?
                                 min_available_buffers:bufferPoolGetNumberFree(&buffers);
        update_max_queued_send();
        result = bufferPoolGetFree(&buffers,&msg_ptr,&bp_status);
    }
    if (result == FAIL) {
      dbg("BVR-debug","Logger: could not get free buffer\n");
      if (bp_status)
        stat_bad_buffer++;
      else 
        stat_no_buffer++;
      return FAIL;
    }
    log_msg = (BVRLogMsgWrapper*) &msg_ptr->data[0];
    log_ptr = (BVRLogMsg*) &log_msg->log_msg;

    log_msg->header.last_hop = call AMPacket.address();
    log_msg->header.seqno = (uint16_t)stat_received;

    log_ptr->type = LOG_DROP_NEIGHBOR;
    log_ptr->drop_neighbor.addr = addr;

    if (call LogSend.send(AM_BROADCAST_ADDR,msg_ptr,msg_size) != SUCCESS) {
      stat_send_failed++;
      dbg("BVR-debug","Logger: send failed, freeing the buffer\n"); 
      bufferPoolSetFree(&buffers,msg_ptr);
      return FAIL;
    }
    return SUCCESS;
  }
  command error_t Logger.LogUpdateCoordinates(Coordinates* coords,CoordsParents* parents) {
    message_t* msg_ptr;
    BVRLogMsgWrapper* log_msg;
    BVRLogMsg* log_ptr;
    uint8_t bp_status;
    error_t result;

    if (!LOG_COORDS)
      return SUCCESS;
    if (coords == NULL && parents == NULL)
      return FAIL;
    atomic{      
        stat_received++;
        min_available_buffers = (min_available_buffers < bufferPoolGetNumberFree(&buffers))?
                                 min_available_buffers:bufferPoolGetNumberFree(&buffers);
        update_max_queued_send();
        result = bufferPoolGetFree(&buffers,&msg_ptr,&bp_status);
    }
    if (result == FAIL) {
      dbg("BVR-debug","Logger: could not get free buffer\n");
      if (bp_status)
        stat_bad_buffer++;
      else 
        stat_no_buffer++;
      return FAIL;
    }
    log_msg = (BVRLogMsgWrapper*) &msg_ptr->data[0];
    log_ptr = (BVRLogMsg*) &log_msg->log_msg;

    log_msg->header.last_hop = call AMPacket.address();
    log_msg->header.seqno = (uint16_t)stat_received;

    log_ptr->type = LOG_CHANGE_COORDS;
    log_ptr->update_coordinates.Coords = *coords;
    log_ptr->update_coordinates.parents = *parents;

    if (call LogSend.send(AM_BROADCAST_ADDR,msg_ptr,msg_size) != SUCCESS) {
      stat_send_failed++;
      dbg("BVR-debug","Logger: send failed, freeing the buffer\n"); 
      bufferPoolSetFree(&buffers,msg_ptr);
      return FAIL;
    }
    return SUCCESS;
  }
  
  command error_t Logger.LogUpdateCoordinate(uint8_t beacon, uint8_t hopcount, uint16_t parent, uint8_t combined_quality) {
    message_t* msg_ptr;
    BVRLogMsgWrapper* log_msg;
    BVRLogMsg* log_ptr;
    uint8_t bp_status;
    error_t result;

    if (!LOG_COORD)
      return SUCCESS;
    atomic{      
        stat_received++;
        min_available_buffers = (min_available_buffers < bufferPoolGetNumberFree(&buffers))?
                                 min_available_buffers:bufferPoolGetNumberFree(&buffers);
        update_max_queued_send();
        result = bufferPoolGetFree(&buffers,&msg_ptr,&bp_status);
    }
    if (result == FAIL) {
      dbg("BVR-debug","Logger: could not get free buffer\n");
      if (bp_status)
        stat_bad_buffer++;
      else 
        stat_no_buffer++;
      return FAIL;
    }
    log_msg = (BVRLogMsgWrapper*) &msg_ptr->data[0];
    log_ptr = (BVRLogMsg*) &log_msg->log_msg;

    log_msg->header.last_hop = call AMPacket.address();
    log_msg->header.seqno = (uint16_t)stat_received;

    log_ptr->type = LOG_CHANGE_COORD;
    log_ptr->update_coordinate.beacon = beacon;
    log_ptr->update_coordinate.hopcount = hopcount;
    log_ptr->update_coordinate.parent = parent;
    log_ptr->update_coordinate.combined_quality = combined_quality;

    if (call LogSend.send(AM_BROADCAST_ADDR,msg_ptr,msg_size) != SUCCESS) {
      stat_send_failed++;
      dbg("BVR-debug","Logger: send failed, freeing the buffer\n"); 
      bufferPoolSetFree(&buffers,msg_ptr);
      return FAIL;
    }
    
    return SUCCESS;
  }

  command error_t Logger.LogRouteReport(uint8_t status, uint16_t id, uint16_t origin_addr, uint16_t dest_addr, uint8_t hopcount, Coordinates* coords, Coordinates* my_coords) {
    message_t* msg_ptr;
    BVRLogMsgWrapper* log_msg;
    BVRLogMsg* log_ptr;
    uint8_t bp_status;
    error_t result;

    
    if (!LOG_ROUTE)
      return SUCCESS;
    if (coords == NULL || my_coords == NULL || 
        (status != LOG_ROUTE_START &&
        status != LOG_ROUTE_FAIL_STUCK &&
        status != LOG_ROUTE_FAIL_BEACON &&
        status != LOG_ROUTE_FAIL_STUCK_0 &&
        status != LOG_ROUTE_SUCCESS &&
        status != LOG_ROUTE_FAIL_NO_QUEUE_BUFFER &&
        status != LOG_ROUTE_FAIL_NO_LOCAL_BUFFER &&
        status != LOG_ROUTE_INVALID_STATUS &&
        status != LOG_ROUTE_TO_SELF &&
        status != LOG_ROUTE_BUFFER_ERROR &&
        status != LOG_ROUTE_STATUS_NEXT_ROUTE &&
        status != LOG_ROUTE_SENT_NORMAL_OK &&
        status != LOG_ROUTE_SENT_FALLBACK_OK &&
        status != LOG_ROUTE_RECEIVED_OK &&
        status != LOG_ROUTE_RECEIVED_DUPLICATE &&
        status != LOG_ROUTE_BCAST_START &&
        status != LOG_ROUTE_STATUS_BCAST_RETRY &&
        status != LOG_ROUTE_STATUS_BCAST_FAIL  &&
        status != LOG_ROUTE_SENT_BCAST_OK    &&
        status != LOG_ROUTE_BCAST_END_SCOPE &&
        status != LOG_ROUTE_RECEIVED_BCAST_OK 
      ))
      return FAIL;

    atomic{      
        stat_received++;
        min_available_buffers = (min_available_buffers < bufferPoolGetNumberFree(&buffers))?
                                 min_available_buffers:bufferPoolGetNumberFree(&buffers);
        update_max_queued_send();
        result = bufferPoolGetFree(&buffers,&msg_ptr,&bp_status);
    }
    if (result == FAIL) {
      dbg("BVR-debug","Logger: could not get free buffer\n");
      if (bp_status)
        stat_bad_buffer++;
      else 
        stat_no_buffer++;
      return FAIL;
    }

    log_msg = (BVRLogMsgWrapper*) &msg_ptr->data[0];
    log_ptr = (BVRLogMsg*) &log_msg->log_msg;

    log_msg->header.last_hop = call AMPacket.address();
    log_msg->header.seqno = (uint16_t)stat_received;

    log_ptr->type = status;
    log_ptr->route_report.id = id;
    log_ptr->route_report.origin_addr = origin_addr;
    log_ptr->route_report.dest_addr = dest_addr;
    log_ptr->route_report.dest_coords = *coords;
    log_ptr->route_report.my_coords = *my_coords;
    log_ptr->route_report.hopcount = hopcount;

    if (call LogSend.send(AM_BROADCAST_ADDR,msg_ptr,msg_size) != SUCCESS) {
      stat_send_failed++;
      dbg("BVR-debug","Logger: send failed, freeing the buffer\n"); 
      bufferPoolSetFree(&buffers,msg_ptr);
      return FAIL;
    }
    return SUCCESS;
  }

  command error_t Logger.LogRetransmitReport(
    uint8_t status, 
    uint16_t id, 
    uint16_t origin_addr, 
    uint16_t dest_addr, 
    uint8_t hopcount, 
    uint16_t next_hop,
    uint8_t retransmit_count)
  {
    message_t* msg_ptr;
    BVRLogMsgWrapper* log_msg;
    BVRLogMsg* log_ptr;
    uint8_t bp_status;
    error_t result;

    if (!LOG_RETRANSMIT)
      return SUCCESS;
    
    if (status != LOG_ROUTE_RETRANSMIT_SUCCESS &&
        status != LOG_ROUTE_RETRANSMIT_FAIL)
      return FAIL;

    atomic{      
        stat_received++;
        min_available_buffers = (min_available_buffers < bufferPoolGetNumberFree(&buffers))?
                                 min_available_buffers:bufferPoolGetNumberFree(&buffers);
        update_max_queued_send();
        result = bufferPoolGetFree(&buffers,&msg_ptr,&bp_status);
    }
    if (result == FAIL) {
      dbg("BVR-debug","Logger: could not get free buffer\n");
      if (bp_status)
        stat_bad_buffer++;
      else 
        stat_no_buffer++;
      return FAIL;
    }

    log_msg = (BVRLogMsgWrapper*) &msg_ptr->data[0];
    log_ptr = (BVRLogMsg*) &log_msg->log_msg;

    log_msg->header.last_hop = call AMPacket.address();
    log_msg->header.seqno = (uint16_t)stat_received;

    log_ptr->type = status;
    log_ptr->retransmit_report.id = id;
    log_ptr->retransmit_report.origin_addr = origin_addr;
    log_ptr->retransmit_report.dest_addr = dest_addr;
    log_ptr->retransmit_report.hopcount = hopcount;
    log_ptr->retransmit_report.retransmit_count = retransmit_count;
    log_ptr->retransmit_report.next_hop = next_hop;

    if (call LogSend.send(AM_BROADCAST_ADDR,msg_ptr,msg_size) != SUCCESS) {
      stat_send_failed++;
      dbg("BVR-debug","Logger: send failed, freeing the buffer\n"); 
      bufferPoolSetFree(&buffers,msg_ptr);
      return FAIL;
    }
    return SUCCESS;
  }



  command error_t Logger.LogUARTCommStats(
  
     uint16_t stat_receive_duplicate_no_buffer,
     uint16_t stat_receive_duplicate_send_failed,
     uint16_t stat_receive_total,                
     uint16_t stat_send_duplicate_no_buffer,     
     uint16_t stat_send_duplicate_send_fail,     
     uint16_t stat_send_duplicate_send_done_fail,
     uint16_t stat_send_duplicate_success,       
     uint16_t stat_send_duplicate_total,         
     uint16_t stat_send_original_send_done_fail, 
     uint16_t stat_send_original_send_failed,    
     uint16_t stat_send_original_success,        
     uint16_t stat_send_original_total        
   )
   {
    message_t* msg_ptr;
    BVRLogMsgWrapper* log_msg;
    BVRLogMsg* log_ptr;
    uint8_t bp_status;
    error_t result;
    
    if (!LOG_LOGGER)
      return SUCCESS; 
    atomic{      
        stat_received++;
        min_available_buffers = (min_available_buffers < bufferPoolGetNumberFree(&buffers))?
                                 min_available_buffers:bufferPoolGetNumberFree(&buffers);
        update_max_queued_send();
        result = bufferPoolGetFree(&buffers,&msg_ptr,&bp_status);
    }
    if (result == FAIL) {
      dbg("BVR-debug","Logger: could not get free buffer\n");
      if (bp_status)
        stat_bad_buffer++;
      else 
        stat_no_buffer++;
      return FAIL;
    }

    log_msg = (BVRLogMsgWrapper*) &msg_ptr->data[0];
    log_ptr = (BVRLogMsg*) &log_msg->log_msg;

    log_msg->header.last_hop = call AMPacket.address();
    log_msg->header.seqno = (uint16_t)stat_received;

    log_ptr->type = LOG_UART_COMM_STATS;
    
    log_ptr->UART_comm_stats.stat_receive_duplicate_no_buffer     =    stat_receive_duplicate_no_buffer  ;
    log_ptr->UART_comm_stats.stat_receive_duplicate_send_failed   =    stat_receive_duplicate_send_failed;
    log_ptr->UART_comm_stats.stat_receive_total                   =    stat_receive_total                ;
    log_ptr->UART_comm_stats.stat_send_duplicate_no_buffer        =    stat_send_duplicate_no_buffer     ;
    log_ptr->UART_comm_stats.stat_send_duplicate_send_fail        =    stat_send_duplicate_send_fail     ;
    log_ptr->UART_comm_stats.stat_send_duplicate_send_done_fail   =    stat_send_duplicate_send_done_fail;
    log_ptr->UART_comm_stats.stat_send_duplicate_success          =    stat_send_duplicate_success       ;
    log_ptr->UART_comm_stats.stat_send_duplicate_total            =    stat_send_duplicate_total         ;
    log_ptr->UART_comm_stats.stat_send_original_send_done_fail    =    stat_send_original_send_done_fail ;
    log_ptr->UART_comm_stats.stat_send_original_send_failed       =    stat_send_original_send_failed    ;
    log_ptr->UART_comm_stats.stat_send_original_success           =    stat_send_original_success        ;
    log_ptr->UART_comm_stats.stat_send_original_total             =    stat_send_original_total          ;
    

    if (call LogSend.send(AM_BROADCAST_ADDR,msg_ptr,msg_size) != SUCCESS) {
      stat_send_failed++;
      dbg("BVR-debug","Logger: send failed, freeing the buffer\n"); 
      bufferPoolSetFree(&buffers,msg_ptr);
      return FAIL;
    }
    return SUCCESS;
  }

  command error_t Logger.LogLRXPkt(uint8_t type,
    uint16_t sender, uint16_t sender_session_id, uint8_t sender_msg_id,
    uint16_t receiver, uint16_t receiver_session_id, uint8_t receiver_msg_id,
    uint8_t ctrl, uint8_t blockNum, uint8_t subCtrl, uint8_t state) {
    message_t* msg_ptr;
    BVRLogMsgWrapper* log_msg;
    BVRLogMsg* log_ptr;
    uint8_t bp_status;
    error_t result;

    if (!LOG_LRX)
      return SUCCESS;
    
    if (type != LOG_LRX_SEND &&
        type != LOG_LRX_RECEIVE)
      return FAIL;

    atomic{      
        stat_received++;
        min_available_buffers = (min_available_buffers < bufferPoolGetNumberFree(&buffers))?
                                 min_available_buffers:bufferPoolGetNumberFree(&buffers);
        update_max_queued_send();
        result = bufferPoolGetFree(&buffers,&msg_ptr,&bp_status);
    }
    if (result == FAIL) {
      dbg("BVR-debug","Logger: could not get free buffer\n");
      if (bp_status)
        stat_bad_buffer++;
      else 
        stat_no_buffer++;
      return FAIL;
    }

    log_msg = (BVRLogMsgWrapper*) &msg_ptr->data[0];
    log_ptr = (BVRLogMsg*) &log_msg->log_msg;

    log_msg->header.last_hop = call AMPacket.address();
    log_msg->header.seqno = (uint16_t)stat_received;

    log_ptr->type = type;

    log_ptr->lrx_pkt.sender = sender;
    log_ptr->lrx_pkt.sender_session_id = sender_session_id;
    log_ptr->lrx_pkt.sender_msg_id = sender_msg_id;
    log_ptr->lrx_pkt.receiver = receiver;
    log_ptr->lrx_pkt.receiver_session_id = receiver_session_id;
    log_ptr->lrx_pkt.receiver_msg_id = receiver_msg_id;
    log_ptr->lrx_pkt.ctrl = ctrl;
    log_ptr->lrx_pkt.blockNum = blockNum;
    log_ptr->lrx_pkt.subCtrl = subCtrl;
    log_ptr->lrx_pkt.state = state;

    if (call LogSend.send(AM_BROADCAST_ADDR,msg_ptr,msg_size) != SUCCESS) {
      stat_send_failed++;
      dbg("BVR-debug","Logger: send failed, freeing the buffer\n"); 
      bufferPoolSetFree(&buffers,msg_ptr);
      return FAIL;
    }
    return SUCCESS;
  }
  command error_t Logger.LogLRXXfer(uint8_t type,
    uint16_t sender, uint16_t receiver,
    uint16_t session_id, uint8_t msg_id, uint8_t numofBlock,
    uint8_t success, uint8_t state) {
    message_t* msg_ptr;
    BVRLogMsgWrapper* log_msg;
    BVRLogMsg* log_ptr;
    uint8_t bp_status;
    error_t result;

    if (!LOG_LRX)
      return SUCCESS;
    
    if (type != LOG_LRX_SXFER_START &&
        type != LOG_LRX_SXFER_FINISH &&
        type != LOG_LRX_RXFER_START &&
        type != LOG_LRX_RXFER_FINISH)
      return FAIL;

    atomic{      
        stat_received++;
        min_available_buffers = (min_available_buffers < bufferPoolGetNumberFree(&buffers))?
                                 min_available_buffers:bufferPoolGetNumberFree(&buffers);
        update_max_queued_send();
        result = bufferPoolGetFree(&buffers,&msg_ptr,&bp_status);
    }
    if (result == FAIL) {
      dbg("BVR-debug","Logger: could not get free buffer\n");
      if (bp_status)
        stat_bad_buffer++;
      else 
        stat_no_buffer++;
      return FAIL;
    }

    log_msg = (BVRLogMsgWrapper*) &msg_ptr->data[0];
    log_ptr = (BVRLogMsg*) &log_msg->log_msg;

    log_msg->header.last_hop = call AMPacket.address();
    log_msg->header.seqno = (uint16_t)stat_received;

    log_ptr->type = type;

    log_ptr->lrx_xfer.sender = sender;
    log_ptr->lrx_xfer.receiver = receiver;
    log_ptr->lrx_xfer.session_id = session_id;
    log_ptr->lrx_xfer.msg_id = msg_id;
    log_ptr->lrx_xfer.numofBlock = numofBlock;
    log_ptr->lrx_xfer.success = success;
    log_ptr->lrx_xfer.state = state;

    if (call LogSend.send(AM_BROADCAST_ADDR,msg_ptr,msg_size) != SUCCESS) {
      stat_send_failed++;
      dbg("BVR-debug","Logger: send failed, freeing the buffer\n"); 
      bufferPoolSetFree(&buffers,msg_ptr);
      return FAIL;
    }
    return SUCCESS;
  }

  command error_t Logger.LogDebug(uint8_t type, uint16_t arg1, uint16_t arg2, uint16_t arg3) {
    message_t* msg_ptr;
    BVRLogMsgWrapper* log_msg;
    BVRLogMsg* log_ptr;
    uint8_t bp_status;
    error_t result;
    if (!LOG_DEBUG)
      return SUCCESS;
    atomic{      
        stat_received++;
        min_available_buffers = (min_available_buffers < bufferPoolGetNumberFree(&buffers))?
                                 min_available_buffers:bufferPoolGetNumberFree(&buffers);
        update_max_queued_send();
        result = bufferPoolGetFree(&buffers,&msg_ptr,&bp_status);
    }
    if (result == FAIL) {
      dbg("BVR-debug","Logger: could not get free buffer\n");
      if (bp_status)
        stat_bad_buffer++;
      else 
        stat_no_buffer++;
      return FAIL;
    }
    log_msg = (BVRLogMsgWrapper*) &msg_ptr->data[0];
    log_ptr = (BVRLogMsg*) &log_msg->log_msg;

    log_msg->header.last_hop = call AMPacket.address();
    log_msg->header.seqno = (uint16_t)stat_received;

    log_ptr->type = type;
    log_ptr->debug.arg1 = arg1;
    log_ptr->debug.arg2 = arg2;
    log_ptr->debug.arg3 = arg3;

    if (call LogSend.send(AM_BROADCAST_ADDR,msg_ptr,msg_size) != SUCCESS) {
      stat_send_failed++;
      dbg("BVR-debug","Logger: send failed, freeing the buffer\n"); 
      bufferPoolSetFree(&buffers,msg_ptr);
      return FAIL;
    }
    return SUCCESS;
  }

  /* This assumes that this active message id is only wired to here,
     i.e., all send dones are for us */
  event void LogSend.sendDone(message_t* msg, error_t result) {
    dbg("BVR-debug","LogSend.sendDone\n");
    if (result == SUCCESS) {
      stat_written++;
    } else {
      stat_send_done_failed++;
    }
    bufferPoolSetFree(&buffers,msg);
    return ;
  }
  
  task void LogLoggerStats() {
    message_t* msg_ptr;
    BVRLogMsgWrapper* log_msg;
    BVRLogMsg* log_ptr;
    uint8_t bp_status;
    error_t result;
    if (!LOG_SELF)
      return;
    atomic{      
        stat_self_log++;
        min_available_buffers = (min_available_buffers < bufferPoolGetNumberFree(&buffers))?
                                 min_available_buffers:bufferPoolGetNumberFree(&buffers);
        update_max_queued_send();
        result = bufferPoolGetFree(&buffers,&msg_ptr,&bp_status);
    }
    if (result == FAIL) {
      dbg("BVR-debug","Logger: could not get free buffer\n");
      stat_self_log_no_buffer++;
      return;
      //return FAIL;
    }
    log_msg = (BVRLogMsgWrapper*) &msg_ptr->data[0];
    log_ptr = (BVRLogMsg*) &log_msg->log_msg;

    log_msg->header.last_hop = call AMPacket.address();
    log_msg->header.seqno = (uint16_t)stat_received;

    log_ptr->type = LOG_LOGGER_STATS;

    log_ptr->logger_stats.free_pos = min_available_buffers;
    log_ptr->logger_stats.max_queue = max_queued_send;
    log_ptr->logger_stats.stat_received         = stat_received + stat_self_log - 1;
    log_ptr->logger_stats.stat_written          = stat_written;          
    log_ptr->logger_stats.stat_no_buffer        = stat_no_buffer;        
    log_ptr->logger_stats.stat_send_failed      = stat_send_failed;      
    log_ptr->logger_stats.stat_send_done_failed = stat_send_done_failed; 



    if (call LogSend.send(AM_BROADCAST_ADDR,msg_ptr,msg_size) != SUCCESS) {
      stat_send_failed++;
      dbg("BVR-debug","Logger: send failed, freeing the buffer\n"); 
      bufferPoolSetFree(&buffers,msg_ptr);
      //return FAIL;
    }
    //return SUCCESS;
  }
  
  
  
  event void SelfTimer.fired() {
    post LogLoggerStats();
    min_available_buffers = 255;
    max_queued_send = 0;
    return ;
  }

}
