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
 * This component implements an adaptation layer for traditional TinyOS
 * applications which enables them to use WMTP features without modifying
 * their implementation.
 *
 * @author Luis D. Pedrosa <luis.pedrosa@tagus.ist.utl.pt>
 * @author Hugo Freire <hugo.freire@ist.utl.pt> (port to TinyOS 2.x)
**/

#include "Wmtp.h"

#define USE_CONNECTIONLESS 1
#define USE_CONNECTIONORIENTED 2
#define USE_PACKETSINK 3
#define USE_SINKID 4

#ifndef CONNECTION_TYPE
#define CONNECTION_TYPE USE_CONNECTIONLESS
//#define CONNECTION_TYPE USE_CONNECTIONORIENTED
#endif // #ifndef CONNECTION_TYPE

#ifndef SERVICE_TYPE
//#define SERVICE_TYPE PACKETSINK
//#define SERVICE_TYPE SINKID
#endif // #ifndef CONNECTION_TYPE

module WmtpAdapterP {
    provides {
        interface SplitControl;
        interface AMSend[am_id_t id];
        interface Receive[am_id_t id];
    }
    uses {
        interface WmtpSendMsg;
        interface WmtpReceiveMsg;
        interface WmtpConnectionManager;
        interface StdControl as WmtpControl;
        interface AMPacket;
        interface Packet;
    }
} implementation {
    WmtpConnectionSpecification_t *ConnectionID = NULL;
    message_t *Message = NULL;
    WmtpPayload_t WmtpPayload;
    uint8_t payloadLen;
#ifdef WMTP_USETHROTTLING
    uint8_t clearToSend = TRUE;
#endif // #ifdef WMTP_USETHROTTLING

    command error_t SplitControl.start() {
        static WmtpServiceSpecification_t SS;
        error_t error;

        error = call WmtpControl.start();

#if (CONNECTION_TYPE == USE_CONNECTIONLESS)
        SS.Connectionless = TRUE;
        SS.ConnectionOriented = FALSE;
#elif (CONNECTION_TYPE == USE_CONNECTIONORIENTED) // #if (CONNECTION_TYPE == USE_CONNECTIONLESS)   
        SS.Connectionless = FALSE;
        SS.ConnectionOriented = TRUE;
#endif // #if (CONNECTION_TYPE == USE_CONNECTIONORIENTED)   
        SS.ServiceType = WMTP_SERVICETYPE_PACKETSINK;

        call WmtpConnectionManager.RegisterService( &SS );
        signal SplitControl.startDone(error);

        return SUCCESS;
    }

    command error_t SplitControl.stop() {
        error_t error;

        error = call WmtpControl.stop();
        signal SplitControl.stopDone(error);
    }

    task void sendTask() {

#ifdef WMTP_USETHROTTLING
//		clearToSend = FALSE;
#endif // #ifdef WMTP_USETHROTTLING

        signal AMSend.sendDone[call AMPacket.type(Message)](Message, call WmtpSendMsg.Send(ConnectionID, payloadLen, &WmtpPayload) );
        Message = NULL;
    }

    command error_t AMSend.send[am_id_t id](am_addr_t addr, message_t* msg, uint8_t len) {
        Message = msg;
        payloadLen = len;
        memcpy(&WmtpPayload, msg->data, len);

        if (ConnectionID == NULL) {
            WmtpConnectionSpecification_t *CS;

            if ( call WmtpConnectionManager.GetNewConnectionSpecification( &CS ) != SUCCESS )
                return FAIL;

// Connection
#if (CONNECTION_TYPE == USE_CONNECTIONLESS)
#ifdef WMTP_USEDECREMENTADDRESSROUTER
            CS->PathSpecification.PathType = WMTP_PATHTYPE_DECREMENTADDRESS;
#endif // #ifdef WMTP_USEDECREMENTADDRESSROUTER
#elif (CONNECTION_TYPE == USE_CONNECTIONORIENTED) // #if (CONNECTION_TYPE == USE_CONNECTIONLESS)
#ifdef WMTP_USESOURCEROUTEDCONNECTIONS
            CS->PathSpecification.PathType = WMTP_PATHTYPE_SOURCEROUTEDCONNECTION;
            CS->PathSpecification.PathData.SourceRoutedConnection.ServiceSpecification.ServiceType = WMTP_SERVICETYPE_SINKID;
            CS->PathSpecification.PathData.SourceRoutedConnection.ServiceSpecification.ServiceData.SinkID.Value = addr;
            CS->PathSpecification.PathData.SourceRoutedConnection.NumHops = 1;
            CS->PathSpecification.PathData.SourceRoutedConnection.Hops[0] = addr;
#endif // #ifdef WMTP_USESOURCEROUTEDCONNECTIONS
#endif // #if (CONNECTION_TYPE == CONNECTIONORIENTED)

// Modules
#ifdef WMTP_USEQUEUEAVAILABILITYSHAPER
//			CS->FeatureSpecification.QueueAvailabilityShaper.Active = TRUE;
#endif // #ifdef WMTP_USEQUEUEAVAILABILITYSHAPER
#ifdef WMTP_USETHROTTLING
//			CS->FeatureSpecification.Throttling.Period = 1;
#endif // #ifdef WMTP_USETHROTTLING
#ifdef WMTP_USEFLOWCONTROL
//			CS->FeatureSpecification.FlowControl.RemotePeriod = 1;
#endif // #ifdef WMTP_USEFLOWCONTROL
#ifdef WMTP_USECONGESTIONCONTROL
//			CS->FeatureSpecification.CongestionControl.Active = TRUE;
#endif // #ifdef WMTP_USECONGESTIONCONTROL
#ifdef WMTP_USEFAIRNESS
//      CS->FeatureSpecification.Fairness.SinkID = 0;
//      CS->FeatureSpecification.Fairness.Weight = 1;
#endif // #ifdef WMTP_USEFAIRNESS
#ifdef WMTP_USEWMTPRELIABILITY
//				CS->FeatureSpecification.ReliabilityHandlerID = WMTP_RELIABILITYHANDLER_WMTPRELIABILITY;
#endif // #ifdef WMTP_USEWMTPRELIABILITY
#ifdef WMTP_USESTATISTICALQOSINDICATOR
//			CS->QoSSpecification.MaxDelay = 1000;
//      CS->QoSSpecification.MaxPeriod = 150;
//      CS->QoSSpecification.PreferredPeriod = 150;
#endif // #ifdef WMTP_USESTATISTICALQOSINDICATOR

            return call WmtpConnectionManager.OpenConnection(CS);

        }	else {

#ifdef WMTP_USETHROTTLING
//			if ( clearToSend == FALSE )
//				return FAIL;
#endif // #ifdef WMTP_USETHROTTLING			

            if ( post sendTask() != SUCCESS )
                return FAIL;

        }

        return SUCCESS;
    }

    command error_t AMSend.cancel[am_id_t id](message_t* msg) {
        // Dummy command
        return SUCCESS;
    }

    command uint8_t AMSend.maxPayloadLength[am_id_t id]() {
        return WMTP_MAXPAYLOADSIZE;
    }

    command void* AMSend.getPayload[am_id_t id](message_t* msg, uint8_t len) {
        return call Packet.getPayload( msg, len );
    }

    event error_t WmtpConnectionManager.ConnectionOpened(WmtpConnectionSpecification_t *ConnectionSpecification) {
        ConnectionID = ConnectionSpecification;

        signal AMSend.sendDone[call AMPacket.type(Message)](Message, call WmtpSendMsg.Send(ConnectionID, payloadLen, &WmtpPayload) );
        Message = NULL;

        return SUCCESS;
    }

    event error_t WmtpConnectionManager.ConnectionReconfigured( WmtpConnectionSpecification_t *ConnectionSpecification ) {
        return SUCCESS;
    }

    event error_t WmtpConnectionManager.ConnectionClosed( WmtpConnectionSpecification_t *ConnectionSpecification ) {
        return SUCCESS;
    }

    event error_t WmtpSendMsg.ClearToSend( WmtpConnectionSpecification_t *ConnectionSpecification ) {

#ifdef WMTP_USETHROTTLING
//		clearToSend = TRUE;
#endif // #ifdef WMTP_USETHROTTLING

        return SUCCESS;
    }

    event WmtpPayload_t *WmtpReceiveMsg.Receive( WmtpConnectionSpecification_t *ConnectionSpecification, uint8_t Length, WmtpPayload_t *Msg ) {
        message_t message;

        call AMPacket.setDestination( &message, TOS_NODE_ID );
        call AMPacket.setSource( &message, 1 ); // get id from source node
        call AMPacket.setType( &message, 6 ); // get am_id_t
        call AMPacket.setGroup( &message, TOS_AM_GROUP );
        call Packet.setPayloadLength( &message, Length );

        memcpy( &message.data, Msg, Length );

        signal Receive.receive[6](&message, message.data, Length); // get am_id_t

        return Msg;
    }

default event message_t* Receive.receive[am_id_t id](message_t* msg, void* payload, uint8_t len) {
        return msg;
    }

default event void AMSend.sendDone[uint8_t id](message_t* msg, error_t err) {
        return;
    }
}