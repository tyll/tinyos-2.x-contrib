
/*
 * "Copyright (c) 2006 University of Southern California.
 * All rights reserved.
 *
 * Permission to use, copy, modify, and distribute this software and its
 * documentation for any purpose, without fee, and without written
 * agreement is hereby granted, provided that the above copyright
 * notice, the following two paragraphs and the author appear in all
 * copies of this software.
 *
 * IN NO EVENT SHALL THE UNIVERSITY OF SOUTHERN CALIFORNIA BE LIABLE TO
 * ANY PARTY FOR DIRECT, INDIRECT, SPECIAL, INCIDENTAL, OR CONSEQUENTIAL
 * DAMAGES ARISING OUT OF THE USE OF THIS SOFTWARE AND ITS
 * DOCUMENTATION, EVEN IF THE UNIVERSITY OF SOUTHERN CALIFORNIA HAS BEEN
 * ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 *
 * THE UNIVERSITY OF SOUTHERN CALIFORNIA SPECIFICALLY DISCLAIMS ANY
 * WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
 * MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.  THE SOFTWARE
 * PROVIDED HEREUNDER IS ON AN "AS IS" BASIS, AND THE UNIVERSITY OF
 * SOUTHERN CALIFORNIA HAS NO OBLIGATION TO PROVIDE MAINTENANCE,
 * SUPPORT, UPDATES, ENHANCEMENTS, OR MODIFICATIONS."
 *
 */

/*
 * @author Omprakash Gnawali
 * @author David Moss
 */

#include "LinkEstimator.h"
#include "Ctp.h"

module LinkEstimatorP {
  provides {
    interface Init;
    interface AMSend;
    interface Receive;
    interface LinkEstimator;
    interface Packet;
  }

  uses {
    interface AMSend as SubAMSend;
    interface AMPacket as SubAMPacket;
    interface Packet as SubPacket;
    interface Receive as SubReceive;
    interface LinkPacketMetadata;
    interface Random;
    interface CompareBit;
  }
}

implementation {

  // configure the link estimator and some constants
  enum {
    // if we don't know the link quality, we need to return a value so
    // large that it will not be used to form paths
    VERY_LARGE_EETX_VALUE = 0xFF,

  };
  
  // link estimation sequence, increment every time a beacon is sent
  uint8_t linkEstSeq = 0;
  

  /***************** Prototypes ****************/
  linkest_header_t* getHeader(message_t *m);
  
  linkest_footer_t* getFooter(message_t *m, uint8_t len);
  
  uint8_t addLinkEstHeaderAndFooter(message_t *msg, uint8_t len);
  
  
  /***************** Init Commands ****************/
  command error_t Init.init() {
    return SUCCESS;
  }


  /***************** LinkEstimator Commands ****************/
  /**
   * @return bi-directional link quality to the neighbor
   */
  command uint16_t LinkEstimator.getLinkQuality(am_addr_t neighbor) {
    return VERY_LARGE_EETX_VALUE;
  }

  /**
   * Insert the neighbor at any cost (if there is a room for it)
   * even if eviction of a perfectly fine neighbor is called for
   * @param neighbor the neighbor address to insert
   * @return SUCCESS if the neighbor was inserted.
   */
  command error_t LinkEstimator.insertNeighbor(am_addr_t neighbor) {
    return SUCCESS;
  }

  /** 
   * Pin a neighbor so that it does not get evicted
   * @param neighbor
   * @return SUCCSES if the neighbor was found and pinned
   */
  command error_t LinkEstimator.pinNeighbor(am_addr_t neighbor) {
    return FAIL;
  }

  /**
   * Unpin a neighbor
   * @param neighbor 
   * @return SUCCESS if the entry was found and unpinned
   */
  command error_t LinkEstimator.unpinNeighbor(am_addr_t neighbor) {
    return SUCCESS;
  }


  /** 
   * Called when an acknowledgement is received; sign of a successful
   * data transmission; to update forward link quality
   * @param neighbor
   * @return SUCCESS if the neighbor was found 
   */
  command error_t LinkEstimator.txAck(am_addr_t neighbor) {
    return SUCCESS;
  }

  /**
   * Called when an acknowledgement is not received; could be due to
   * data pkt or acknowledgement loss; to update forward link quality
   * @param neighbor
   * @return SUCCESS if the neighbor was found
   */
  command error_t LinkEstimator.txNoAck(am_addr_t neighbor) {
    return SUCCESS;
  }

  /**
   * Called when the parent changes; clear state about data-driven link quality
   * @param neighbor
   * @return SUCCESS if the neighbor was found
   */
  command error_t LinkEstimator.clearDLQ(am_addr_t neighbor) {
    return SUCCESS;
  }



  /***************** Packet Commands ****************/
  command void Packet.clear(message_t *msg) {
    call SubPacket.clear(msg);
  }

  /**
   * Subtract the space occupied by the link estimation
   * header and footer from the incoming payload size
   */
  command uint8_t Packet.payloadLength(message_t *msg) {
    linkest_header_t *hdr;
    hdr = getHeader(msg);
    
    return call SubPacket.payloadLength(msg)
      - sizeof(linkest_header_t)
      - sizeof(linkest_footer_t) * (NUM_ENTRIES_FLAG & hdr->flags);
  }

  /**
   * Account for the space used by header and footer while setting the payload 
   * length
   */
  command void Packet.setPayloadLength(message_t *msg, uint8_t len) {
    linkest_header_t *hdr;
    hdr = getHeader(msg);
    
    call SubPacket.setPayloadLength(msg,
                                    len
                                    + sizeof(linkest_header_t)
                                    + sizeof(linkest_footer_t)*(NUM_ENTRIES_FLAG & hdr->flags));
  }

  command uint8_t Packet.maxPayloadLength() {
    return call SubPacket.maxPayloadLength() - sizeof(linkest_header_t);
  }

  /**
   * Application payload pointer is just past the link estimation header
   */
  command void *Packet.getPayload(message_t *msg, uint8_t len) {
    void *payload = call SubPacket.getPayload(msg, len + sizeof(linkest_header_t));
    
    if (payload != NULL) {
      payload += sizeof(linkest_header_t);
    }
    
    return payload;
  }
  
  
  /***************** AMSend Commands ****************/
  /**
   * User of link estimator calls send here slap the header and footer before 
   * sending the message
   * @param addr
   * @param msg
   * @param len
   */
  command error_t AMSend.send(am_addr_t addr, message_t *msg, uint8_t len) {
    return call SubAMSend.send(addr, msg, addLinkEstHeaderAndFooter(msg, len));
  }
  
  command uint8_t AMSend.cancel(message_t *msg) {
    return call SubAMSend.cancel(msg);
  }

  command uint8_t AMSend.maxPayloadLength() {
    return call Packet.maxPayloadLength();
  }

  command void *AMSend.getPayload(message_t *msg, uint8_t len) {
    return call Packet.getPayload(msg, len);
  }

  
  /***************** SubAMSend Events ****************/
  event void SubAMSend.sendDone(message_t *msg, error_t error ) {
    signal AMSend.sendDone(msg, error);
  }
  

  /***************** SubReceive Events ****************/
  /** 
   * New messages are received here.
   * Update the neighbor table with the header and footer in the message
   * then signal the user of this component
   */
  event message_t *SubReceive.receive(message_t *msg,
                                      void *payload,
                                      uint8_t len) {
    return signal Receive.receive(msg,
                                  call Packet.getPayload(msg, call Packet.payloadLength(msg)),
                                  call Packet.payloadLength(msg));
  }

  /***************** Functions ****************/
  /**
   * Get the link estimation header in the packet
   */
  linkest_header_t* getHeader(message_t *m) {
    return (linkest_header_t*) call SubPacket.getPayload(m, sizeof(linkest_header_t));
  }

  /**
   * Get the link estimation footer (neighbor entries) in the packet
   */
  linkest_footer_t* getFooter(message_t *m, uint8_t len) {
    // To get a footer at offset "len", the payload must be len + sizeof large.
    return (linkest_footer_t*)(len + (uint8_t *) call Packet.getPayload(m,len + sizeof(linkest_footer_t)));
  }

  /** 
   * Add the link estimation header (seq no) and link estimation
   * footer (neighbor entries) in the packet. Call just before sending
   * the packet.
   */
  uint8_t addLinkEstHeaderAndFooter(message_t *msg, uint8_t len) {
    uint8_t newlen;
    linkest_header_t * ONE hdr;
    linkest_footer_t * ONE footer;
    
    hdr = getHeader(msg);
    footer = getFooter(msg, len);

    hdr->seq = linkEstSeq++;
    hdr->flags = 0;
    newlen = sizeof(linkest_header_t) + len;
    
    return newlen;
  }

}
