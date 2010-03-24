#ifndef BCP_H
#define BCP_H

#include "AM.h"
#include <message.h>

/**
 * PKT_NORMAL: Indicates that a BCP packet contains source-originated data.
 * PKT_NULL: Indicates that a BCP packet was dropped, and a subsequent virtual
 *           packet was eventually forwarded.
 */
enum{
  PKT_NORMAL = 1,
  PKT_NULL   = 2
};

/*
 * The number of times the ForwardingEngine will try to
 * transmit a packet before giving up if the link layer
 * supports acknowledgments. If the link layer does
 * not support acknowledgments it sends the packet once.
 */
enum {
  BEACON_TIME        = 5000,  // Milliseconds
  FAST_BEACON_TIME   = 35,    // Milliseconds
  LOG_UPDATE_TIME    = 1000,  // Milliseconds
  REROUTE_TIME       = 50,   // Milliseconds
  MAX_RETX_ATTEMPTS  = 5,    // Maximum retransmit count per link
  ROUTING_TABLE_SIZE = 0x30,  // Max Neighbor Count
  FORWARDING_QUEUE_SIZE = 12, // Maximum forwarding queue size
  SNOOP_QUEUE_SIZE   = 0x5,   // Maximum snoop queue size
  MAX_FWD_DLY        = 40,    // Milliseconds of delay to forward per delay packet
  FWD_DLY_PKT_COUNT  = 20,    // Number of estimated packet xmission times to wait between delayPackets
  LINK_EST_ALPHA     = 9,     // Decay parameter. 9 = 90% weight of previous rate Estimation
  LINK_LOSS_ALPHA    = 90,    // Decay parameter. 90 = 90% weight of previous link loss Estimate
  LINK_LOSS_V        = 2,    // V Value used to weight link losses in Lyapunov Calculation
  PER_HOP_MAC_DLY    = 10     // Typical per-hop MAC delay of successful transmission on Tmote Sky 
};

enum {
    // AM types:
    AM_BCP_BEACON  = 0x90,
    AM_BCP_DATA    = 0x91,
    AM_BCP_DELAY   = 0x92
};

/*
 * The network header that the ForwardingEngine introduces.
 */
typedef nx_struct {
  nx_uint32_t         bcpDelay;          // Delay experienced by this packet
  nx_uint16_t         bcpBackpressure;   // Node backpressure measurement for neighbors
  nx_uint16_t         nhBackpressure;    // Next hop Backpressure, used by STLE, overheard by neighbors
  nx_uint16_t         txCount;           // Total transmission count experienced by the packet
  nx_uint16_t         hdrChecksum;       // Checksum over origin, hopCount, and originSeqNo
  nx_am_addr_t        origin;
  nx_uint8_t          hopCount;          // End-to-end hop count experienced by the packet
  nx_uint8_t          originSeqNo;
  nx_uint8_t          pktType;           // PKT_NORMAL | PKT_NULL
  nx_uint8_t          nodeTxCount;       // Incremented every tx by this node, to determine bursts for STLE
  nx_am_addr_t        burstNotifyAddr;   // In the event of a burst link available detect, set neighbor addr, else set self addr
} bcp_data_header_t;

/*
 * The network header that the Beacons use.
 */
typedef nx_struct {
  nx_uint16_t         bcpBackpressure;
} bcp_beacon_header_t;

/*
 * The network header that delay packets use.
 */
typedef nx_struct {
  nx_uint32_t bcpTransferDelay;
  nx_uint32_t bcpBackpressure; 
  nx_uint8_t  delaySeqNo;
  nx_uint8_t  avgHopCount;      // Exponental moving average of hop count seen by this node
} bcp_delay_header_t;

/*
 * Defines used to determine the source of packets within
 *  the forwarding queue.  
 */
enum {
    LOCAL_SEND = 0x1,
    FORWARD    = 0x2,
};

/*
 * An element in the ForwardingEngine send queue.
 * The client field keeps track of which send client 
 * submitted the packet or if the packet is being forwarded
 * from another node (client == 255). Retries keeps track
 * of how many times the packet has been transmitted.
 */
typedef struct {
  uint32_t bcpArrivalDelay;
  uint32_t arrivalTime;
  uint32_t firstTxTime;
  uint32_t lastTxTime;
  uint8_t  source;
  message_t * ONE_NOK msg;
  uint8_t  txCount;
} fe_queue_entry_t;

/**
 * This structure is used by the routing engine to store
 *  the routing table.
 */
typedef struct {
  uint16_t  backpressure;
  uint16_t  linkPacketTxTime; // Exponential moving average in 100US units
  uint16_t  linkETX;          // Exponential moving average of ETX (in 100ths of expected transmissions)
  uint8_t   lastTxNoStreakID;  // Used to detect bursts of 3 successful receptions from a neighbor
  uint8_t   txNoStreakCount;  // Used to detect bursts of 3 successful receptions from a neighbor
  am_addr_t neighbor;
  bool      isBurstyNow;      // Indicates whether the neighbor has notified of current "goodness" of link
} routing_table_entry;

/**
 * This structure is used to track the last
 *  <source, packetID, hopCount> triplet received
 *  from a given neighbor.
 */
typedef struct{
  am_addr_t neighbor;
  am_addr_t origin;
  uint8_t   originSeqNo;
  uint8_t   hopCount;
} latestForwarded_table_entry;

#endif /* BCP_H */
