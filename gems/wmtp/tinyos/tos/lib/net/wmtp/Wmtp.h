/*
 * WMTP - Wireless Modular Transport Protocol
 *
 * Copyright (c) 2008 Luis D. Pedrosa and IT - Instituto de Telecomunicacoes
 *
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public
 * License as published by the Free Software Foundation; either
 * version 2.1 of the License, or (at your option) any later version.
 *
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
 * Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public
 * License along with this library; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
 *
 * Address:
 * Instituto Superior Tecnico - Taguspark Campus
 * Av. Prof. Dr. Cavaco Silva, 2744-016 Porto Salvo
 *
 * E-Mail:
 * luis.pedrosa@tagus.ist.utl.pt
 */

/**
 * WMTP Protocol.
 *
 * This component implements the WMTP transport protocol.
 *
 * @author Luis D. Pedrosa <luis.pedrosa@tagus.ist.utl.pt>
 * @author Hugo Freire <hugo.freire@ist.utl.pt> (port to TinyOS 2.x) 
**/

#ifndef __WMTP_H__
#define __WMTP_H__

#include "WmtpMsgs.h"
#include <stdio.h>
#include "AM.h"
//#include "TosTime.h"

// TagRouter
#define MAX_TAG_ASSOCIATIONS 10

#define NUM_QOS_CONNECTIONS 4
#define NUM_REGISTERED_SERVICES 2
// Core
#define NUM_CONNECTION_SPECIFICATIONS 10
#define NUM_QUEUE_ELEMENTS 10
#define LOCAL_MANAGEMENT_DATA_PERIOD 1024
#define QOS_RESERVATION_TREE_MAX_DEPTH 8
#define QOS_RESERVATION_TREE_SHORTEST_DELAY_MIN_DEPTH 2
#define NUM_LOCAL_MANAGEMENT_DATA_HANDLERS (WMTP_LOCALPART_SRCROUTEDCONN + 1)
#define NUM_CONN_MANAGEMENT_DATA_HANDLERS (WMTP_CONNPART_WMTPRELIABILITY + 1)
#define NUM_FEATURE_CONFIGURATION_HANDLERS (WMTP_CONFPART_WMTPRELIABILITY + 1)
// Features
#define WMTP_USEQUEUEAVAILABILITYSHAPER
#define WMTP_USETHROTTLING
#define WMTP_USEFLOWCONTROL
#define WMTP_USECONGESTIONCONTROL
#define WMTP_USEFAIRNESS
#define WMTP_USEWMTPRELIABILITY
// Routers and Connection Establishment Handlers
//#define WMTP_USETOSMULTIHOPROUTER
#define WMTP_USEDECREMENTADDRESSROUTER
#define WMTP_USESOURCEROUTEDCONNECTIONS
// Service Specifications
#define WMTP_USEPACKETSINKSERVICESPECIFICATION
#define WMTP_USESINKIDSERVICESPECIFICATION
// QoS Indicators
#define WMTP_USESTATISTICALQOSINDICATOR
// Dependencies
#ifdef WMTP_USESOURCEROUTEDCONNECTIONS
#define WMTP_USETAGROUTER 
#endif // #ifdef WMTP_USESOURCEROUTEDCONNECTIONS
#ifdef WMTP_USEDECREMENTADDRESSROUTER
#define NUM_PENDING_CONNECTION_REQUESTS 4
#endif // #ifdef WMTP_USEDECREMENTADDRESSROUTER

typedef uint8_t WmtpApplicationID_t;

typedef struct {

	WmtpApplicationID_t ApplicationID;

	uint8_t Connectionless;
	uint8_t ConnectionOriented;

	uint8_t ServiceType;

	union {
#ifdef WMTP_USEPACKETSINKSERVICESPECIFICATION
		struct {
		} PacketSink;
#endif // #ifdef WMTP_USEPACKETSINKSERVICESPECIFICATION
#ifdef WMTP_USESINKIDSERVICESPECIFICATION
		struct {
			uint8_t Value;
		} SinkID;
#endif // #ifdef WMTP_USESINKIDSERVICESPECIFICATION
	} ServiceData;
} WmtpServiceSpecification_t;


enum {
#ifdef WMTP_USESOURCEROUTEDCONNECTIONS
	WMTP_PATHTYPE_SOURCEROUTEDCONNECTION = 0,
#endif // #ifdef WMTP_USESOURCEROUTEDCONNECTIONS
#ifdef WMTP_USETOSMULTIHOPROUTER
	WMTP_PATHTYPE_TOSMULTIHOP = 1,
#endif // #ifdef WMTP_USETOSMULTIHOPROUTER
#ifdef WMTP_USEDECREMENTADDRESSROUTER
	WMTP_PATHTYPE_DECREMENTADDRESS = 2,
#endif // #ifdef WMTP_USEDECREMENTADDRESSROUTER
#if defined( WMTP_USETOSMULTIHOPROUTER )
	WMTP_PATHTYPE_DEFAULT = WMTP_PATHTYPE_TOSMULTIHOP,
#elif defined( WMTP_USESOURCEROUTEDCONNECTIONS )
	WMTP_PATHTYPE_DEFAULT = WMTP_PATHTYPE_SOURCEROUTEDCONNECTION,
#elif defined( WMTP_USEDECREMENTADDRESSROUTER )
	WMTP_PATHTYPE_DEFAULT = WMTP_PATHTYPE_DECREMENTADDRESS,
#endif

};
#ifdef WMTP_USESOURCEROUTEDCONNECTIONS
enum {
	WMTP_SOURCEROUTEDCONNECTION_MAXHOPS = 5,
};
#endif // #ifdef WMTP_USESOURCEROUTEDCONNECTIONS
typedef struct {
	uint8_t PathType;

	union {
#ifdef WMTP_USESOURCEROUTEDCONNECTIONS
		struct {
			WmtpServiceSpecification_t ServiceSpecification;
			uint8_t NumHops; 
			uint16_t Hops[WMTP_SOURCEROUTEDCONNECTION_MAXHOPS]; 
		} SourceRoutedConnection;
#endif // #ifdef WMTP_USESOURCEROUTEDCONNECTIONS
#ifdef WMTP_USETOSMULTIHOPROUTER
		struct {
		} TOSMultihop;
#endif // #ifdef WMTP_USETOSMULTIHOPROUTER
#ifdef WMTP_USEDECREMENTADDRESSROUTER
		struct {
		} DecrementAddressRouter;
#endif // #ifdef WMTP_USEDECREMENTADDRESSROUTER
	} PathData;
} WmtpPathSpecification_t;


enum {
#ifdef WMTP_USEWMTPRELIABILITY
	WMTP_RELIABILITYHANDLER_WMTPRELIABILITY = 0,
#endif // #ifdef WMTP_USEWMTPRELIABILITY
	WMTP_RELIABILITYHANDLER_NONE = 255,
};
typedef struct {
#ifdef WMTP_USEQUEUEAVAILABILITYSHAPER
	struct {
		uint8_t Active;
	} QueueAvailabilityShaper;
#endif // #ifdef WMTP_USEQUEUEAVAILABILITYSHAPER
#ifdef WMTP_USETHROTTLING
	struct {
		// The minimum packet period.
		// Set to 0 to deactivate throttling.
		uint16_t Period;
	} Throttling;
#endif // #ifdef WMTP_USETHROTTLING
#ifdef WMTP_USEFLOWCONTROL
	struct {
		// Minimum packet periods.
		// Set to 0 to deactivate flow control.
		// Local period is set by remote node.
		uint16_t LocalPeriod;
		// Remote period is set by local node.
		uint16_t RemotePeriod;
	} FlowControl;
#endif // #ifdef WMTP_USEFLOWCONTROL
#ifdef WMTP_USECONGESTIONCONTROL
	struct {
		uint8_t Active;
	} CongestionControl;
#endif // #ifdef WMTP_USECONGESTIONCONTROL
#ifdef WMTP_USEFAIRNESS
	struct {
		uint8_t SinkID:7;
		// Set to 0 to deactivate fairness.
		uint8_t Weight;
	} Fairness;
#endif // #ifdef WMTP_USEFAIRNESS

	uint8_t ReliabilityHandlerID;
	union {
#ifdef WMTP_USEWMTPRELIABILITY
		struct {
		} WmtpReliability;
#endif // #ifdef WMTP_USEWMTPRELIABILITY
	} Reliability;
} WmtpFeatureSpecification_t;


typedef struct {
	// Maximum end-to-end delay. Set to 0 to deactivate delay constraints.
	uint16_t MaxDelay;
	// Maximum sending period. Set to 0 to deactivate throughput constraints.
	uint16_t MaxPeriod;
	// Preferred sending period.
	uint16_t PreferredPeriod;
} WmtpQoSSpecification_t;


#if defined( WMTP_USETAGROUTER ) || defined( WMTP_USETOSMULTIHOPROUTER ) || defined( WMTP_USEDECREMENTADDRESSROUTER )
enum {
#ifdef WMTP_USETAGROUTER
	WMTP_ROUTERTYPE_TAGROUTER = 0,
#endif // #ifdef WMTP_USETAGROUTER
#ifdef WMTP_USETOSMULTIHOPROUTER
	WMTP_ROUTERTYPE_TOSMULTIHOP = 1,
#endif // #ifdef WMTP_USETOSMULTIHOPROUTER
#ifdef WMTP_USEDECREMENTADDRESSROUTER
	WMTP_ROUTERTYPE_DECREMENTADDRESSROUTER = 2,
#endif // #ifdef WMTP_USEDECREMENTADDRESSROUTER
};
#endif // #if defined( WMTP_USETAGROUTER ) || defined( WMTP_USETOSMULTIHOPROUTER ) || defined( WMTP_USEDECREMENTADDRESSROUTER )
typedef struct {
	uint8_t RouterType;

	union {
#ifdef WMTP_USETAGROUTER
		struct {
			uint8_t OutgoingTag;
		} TagRouter;
#endif // #ifdef WMTP_USETAGROUTER
#ifdef WMTP_USETOSMULTIHOPROUTER
		struct {
		} TOSMultihop;
#endif // #ifdef WMTP_USETOSMULTIHOPROUTER
#ifdef WMTP_USEDECREMENTADDRESSROUTER
		struct {
		} DecrementAddressRouter;
#endif // #ifdef WMTP_USEDECREMENTADDRESSROUTER
	} RouterData;
} WmtpRouterSpecification_t;


typedef union {
#ifdef WMTP_USETHROTTLING
	struct {
		uint32_t WakeUpTime;
	} Throttling;
#endif // #ifdef WMTP_USETHROTTLING
#ifdef WMTP_USEFLOWCONTROL
	struct {
		uint32_t WakeUpTime;
	} FlowControl;
#endif // #ifdef WMTP_USEFLOWCONTROL
#ifdef WMTP_USEFAIRNESS
	struct {
		uint32_t WakeUpTime;
	} Fairness;
#endif // #ifdef WMTP_USEFAIRNESS
} WmtpConnectionScratchPad_t;


enum {
	WMTP_QOSPRIORITY_NONE = 255,
};
struct WmtpQueueElement_t;
typedef struct {

	WmtpPathSpecification_t PathSpecification;
	WmtpFeatureSpecification_t FeatureSpecification;
	WmtpQoSSpecification_t QoSSpecification;
	WmtpRouterSpecification_t RouterSpecification;

	uint8_t IsLocal;
	uint8_t IsConnectionOriented;
	uint8_t IsTemporary;
	WmtpApplicationID_t ApplicationID;

	uint8_t TrafficShaperState[((uniqueCount( "WmtpTrafficShaper" ) - 1) / 8) + 1];

	WmtpConnectionScratchPad_t ScratchPad[uniqueCount( "WMTPConnectionScratchPad" )];

	uint8_t QoSPriority;
	struct WmtpQueueElement_t *QoSReservedQueueElement;
} WmtpConnectionSpecification_t;


typedef union {
#ifdef WMTP_USEWMTPRELIABILITY
	struct {
		uint16_t PrevHop;
		uint8_t NumTimesSent;
		uint32_t TimeOutTime;
		uint8_t NextHopAcked;
		uint8_t PrevHopDropped;
	} WmtpReliability;
#endif // #ifdef WMTP_USEWMTPRELIABILITY
} WmtpPacketScratchPad_t;


#define WMTP_MAXCONNECTIONPARTS 5
#define WMTP_MAXCONNECTIONLOCALPARTSIZE TOSH_DATA_LENGTH
typedef struct WmtpQueueElement_t {

	WmtpConnectionSpecification_t *ConnectionSpecification;
	uint16_t NextHop;

	uint8_t TrafficShaperState[((uniqueCount( "WmtpTrafficShaper" ) - 1) / 8) + 1];

	WmtpPacketScratchPad_t ScratchPad[uniqueCount( "WMTPPacketScratchPad" )];

	uint8_t NumConnectionParts;
	WmtpConnectionPart_t *ConnectionParts[WMTP_MAXCONNECTIONPARTS];
	// Contains the routing data, any connection parts, as well as the payload.
	uint8_t ConnectionLocalPartSize;
	uint8_t ConnectionLocalPart[WMTP_MAXCONNECTIONLOCALPARTSIZE];
} WmtpQueueElement_t;


#define WMTP_MAXPAYLOADSIZE 25
typedef struct {
	char Data[WMTP_MAXPAYLOADSIZE];
} WmtpPayload_t;

typedef struct {
		uint16_t PreviousAddress;
    uint8_t PreviousTag;
    uint16_t NextAddress;
    uint8_t NextTag;

    WmtpConnectionSpecification_t *ConnectionSpecification;

    uint32_t UsageTimeOut;
    //tos_time_t TimeOutTime;
    uint32_t TimeOutTime;
    bool Activated;
} TagAssociation_t;

#endif // #define __WMTP_H__
