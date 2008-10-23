// ex: set tabstop=2 shiftwidth=2 expandtab syn=c:
// $Id$
                                    
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
 * Authors:  Rodrigo Fonseca        
 * Date Last Modified: 2005/05/26
 */

/** Interface to the logger. These commands are called by the application at
 *  the relevant points to allow for logging of the different aspects of the
 *  NoGeo. 
 *  See also: Logging.h
 */ 
 
includes LinkEstimator;
includes BVR;

interface Logger {
  /* Packets */
  command error_t LogSendBeacon(uint8_t seqno);
  command error_t LogReceiveBeacon(uint8_t seqno, uint16_t from);
  command error_t LogSendRootBeacon(uint8_t seqno, uint8_t hopcount);
  command error_t LogReceiveRootBeacon(uint8_t seqno, uint8_t id, uint16_t last_hop, uint8_t hopcount, uint8_t quality);
  command error_t LogSendLinkInfo();
  command error_t LogReceiveLinkInfo();
  command error_t LogSendAppMsg(uint8_t id, uint16_t to, uint8_t mode, uint8_t fallback_thresh, Coordinates* dest);
  command error_t LogReceiveAppMsg(uint8_t id, uint8_t result);
  /* State */
  /* In LinkEstimatorM */
  command error_t LogAddLink(LinkNeighbor* n);
  command error_t LogChangeLink(LinkNeighbor* n);
  command error_t LogDropLink(uint16_t addr);
  /* In NeighborTable */
  command error_t LogAddNeighbor(CoordinateTableEntry * ce);
  command error_t LogUpdateNeighbor(CoordinateTableEntry * ce);
  command error_t LogDropNeighbor(uint16_t addr);
  /* in NoGeo */
  command error_t LogUpdateCoordinates(Coordinates* coords, CoordsParents *parents); 
  command error_t LogUpdateCoordinate(uint8_t beacon, uint8_t hopcount, uint16_t parent, uint8_t combined_quality);
  /* in CBRouter */
  command error_t LogRouteReport(uint8_t status, uint16_t id, uint16_t origin_addr, uint16_t dest_addr, uint8_t hopcount, Coordinates* coords, Coordinates* my_coords);
  /* in UARTLoggerComm */
  command error_t LogUARTCommStats(     
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
     uint16_t stat_send_original_total);

  command error_t LogLRXPkt(uint8_t type,
    uint16_t sender, uint16_t sender_session_id, uint8_t sender_msg_id,
    uint16_t receiver, uint16_t receiver_session_id, uint8_t receiver_msg_id,
    uint8_t ctrl, uint8_t blockNum, uint8_t subCtrl, uint8_t state);
  command error_t LogLRXXfer(uint8_t type,
    uint16_t sender, uint16_t receiver,
    uint16_t session_id, uint8_t msg_id, uint8_t numofBlock,
    uint8_t success, uint8_t state);
  
  /* Simple Debug: I know, it's not general, but should be fine for some quick thing */
  command error_t LogDebug(uint8_t type, uint16_t arg1, uint16_t arg2, uint16_t arg3);
  /*Retransmit Test*/
  command error_t LogRetransmitReport(
    uint8_t status, 
    uint16_t id, 
    uint16_t origin_addr, 
    uint16_t dest_addr, 
    uint8_t hopcount, 
    uint16_t next_hop,
    uint8_t retransmit_count);


}
