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

#ifndef __WMTPMSGS_H__
#define __WMTPMSGS_H__

// WMTP AM Message types.
enum {
	AM_WMTPMSG = 7,
};

// Local part types.
enum {
	WMTP_LOCALPART_CONGCTRL        = 0,
	WMTP_LOCALPART_FAIRNESS        = 1,
	WMTP_LOCALPART_WMTPRELIABILITY = 2,
	WMTP_LOCALPART_SRCROUTEDCONN   = 3,
	WMTP_LOCALPART_CONN            = 255,
};

// Connection part types.
enum {
	WMTP_CONNPART_WMTPRELIABILITY = 0,
	WMTP_CONNPART_CONFIG          = 252,
	WMTP_CONNPART_CLOSE           = 253,
	WMTP_CONNPART_DATA            = 254,
	WMTP_CONNPART_LAST            = 255,
};

// Configuration part types.
enum {
	WMTP_CONFPART_QUEUEAVAILABILITYSHAPER = 0,
	WMTP_CONFPART_THROTTLING              = 1,
	WMTP_CONFPART_FLOWCTRL                = 2,
	WMTP_CONFPART_CONGCTRL                = 3,
	WMTP_CONFPART_FAIRNESS                = 4,
	WMTP_CONFPART_WMTPRELIABILITY         = 5,
	WMTP_CONFPART_LAST                    = 255,
};

// Service types.
enum {
	WMTP_SERVICETYPE_PACKETSINK = 0,
	WMTP_SERVICETYPE_SINKID     = 1,
};

enum {
	WMTP_FEATURECONFIG_MAXSIZE = 9,
};

// WmtpSinkIDServiceSpecificationData.
typedef struct WmtpSinkIDServiceSpecificationData {
	uint8_t Reserved:1;
	uint8_t SinkID:7;
} __attribute__ ((packed)) WmtpSinkIDServiceSpecificationData_t;

// WmtpServiceSpecificationData.
typedef struct WmtpServiceSpecificationData {
	uint8_t Type;
	char Data[0];
} __attribute__ ((packed)) WmtpServiceSpecificationData_t;

// WMTP AM Message structures.
// WmtpFlowCtrlConfigurationPart.
typedef struct WmtpFlowCtrlConfigurationPart {
	uint16_t Period;
} __attribute__ ((packed)) WmtpFlowCtrlConfigurationPart_t;

// WmtpFairnessConfigurationPart.
typedef struct WmtpFairnessConfigurationPart {
	uint8_t Reserved:1;
	uint8_t SinkID:7;
	uint8_t Weight;
} __attribute__ ((packed)) WmtpFairnessConfigurationPart_t;

// WmtpConfigurationPart.
typedef struct WmtpConfigurationPart {
	uint8_t Type;
	char Data[0];
} __attribute__ ((packed)) WmtpConfigurationPart_t;

// WmtpDataConnectionPart.
typedef struct WmtpDataConnectionPart {
	uint8_t PayloadSize;
	char PayloadData[0];
} __attribute__ ((packed)) WmtpDataConnectionPart_t;

// WmtpReliabilityConnectionPart.
typedef struct WmtpReliabilityConnectionPart {
	uint16_t OrigAddr;
	uint16_t PacketID:15;
} __attribute__ ((packed)) WmtpReliabilityConnectionPart_t;

// WmtpTagRouterData.
typedef struct WmtpTagRouterData {
	uint8_t Tag;
} __attribute__ ((packed)) WmtpTagRouterData_t;

// WmtpConnectionPart.
typedef struct WmtpConnectionPart {
	uint8_t Type;
	char Data[0];
} __attribute__ ((packed)) WmtpConnectionPart_t;

// WmtpConnectionLocalPart.
typedef struct WmtpConnectionLocalPart {
	uint8_t RouterType;
	char RouterData[0];
	WmtpConnectionPart_t ConnectionParts[0];
} __attribute__ ((packed)) WmtpConnectionLocalPart_t;

// WmtpCongCtrlLocalPart.
typedef struct WmtpCongCtrlLocalPart {
	uint8_t Reserved:7;
	uint8_t CNBit:1;
} __attribute__ ((packed)) WmtpCongCtrlLocalPart_t;

// WmtpFairnessLocalPart.
typedef struct WmtpFairnessLocalPart {
	uint8_t LastSink:1;
	uint8_t SinkID:7;
	// This period is calculated by multiplying the nodes outgoing period
	// for this sink, multiplied by the total weight of all connections
	// going to said sink. It is similar to the throughput per unit weight.
	uint16_t NormalizedPeriod;
	// The address of the node that originated the constraint.
	uint16_t LimitingNode;
} __attribute__ ((packed)) WmtpFairnessLocalPart_t;

// WmtpReliabilityLocalPart.
typedef struct WmtpReliabilityLocalPart {
	uint16_t OrigAddr;
	uint8_t LastPacket:1;
	uint16_t PacketID:15;
} __attribute__ ((packed)) WmtpReliabilityLocalPart_t;

// WmtpSrcRoutedConnLocalPart.
typedef struct WmtpSrcRoutedConnLocalPart {
	uint16_t NextHop;
	uint8_t NextTag;

	uint16_t QoSMaxDelay;
	uint16_t QoSMaxPeriod;
	uint16_t QoSPreferredPeriod;
	uint16_t QoSAccumulatedDelay;

	uint8_t NumHops;
	uint16_t Hops[0];
	char ConfigurationData[0];
	char ServiceSpecificationData[0];
} __attribute__ ((packed)) WmtpSrcRoutedConnLocalPart_t;

// WmtpLocalPart.
typedef struct WmtpLocalPart {
	uint8_t Type;
	char Data[0];
} __attribute__ ((packed)) WmtpLocalPart_t;

// WmtpMsg.
typedef struct WmtpMsg {
	uint16_t SrcAddr;
	WmtpLocalPart_t LocalParts[0];
} __attribute__ ((packed)) WmtpMsg_t;

#endif // #define __WMTPMSGS_H__
