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

#include "Wmtp.h"
#include "WmtpMsgs.h"

module WmtpCoreP {
    provides {
        interface Init;
        interface StdControl;

        interface WmtpConnectionManager[uint8_t ApplicationID];
        interface WmtpSendMsg[uint8_t ApplicationID];
        interface WmtpReceiveMsg[uint8_t ApplicationID];

        interface WmtpConnectionManagementDataHandler[uint8_t HandlerID];
        interface WmtpLocalManagementDataHandler[uint8_t HandlerID];
        interface WmtpTrafficShaper[uint8_t HandlerID];
        interface WmtpReliableTransmissionHook[uint8_t HandlerID];
        interface WmtpPacketScratchPadHook[uint8_t HandlerID];
        interface WmtpConnectionScratchPadHook[uint8_t HandlerID];
        interface WmtpConnectionEstablishmentHandler[uint8_t HandlerID];
        interface WmtpCoreMonitor;
    }
    uses {
        interface Boot;

        interface StdControl as ComponentControl;
        interface Init as ComponentInit;

        interface WmtpFeatureConfigurationHandler[uint8_t HandlerID];
        interface WmtpServiceSpecificationDataHandler[uint8_t HandlerID];
        interface WmtpMultihopRouter[uint8_t HandlerID];
        interface WmtpLinkLayerQoSIndicator;

        interface Timer<TMilli> as LocalManagementDataTimer;

        interface AMSend as SendWmtpMsg;
        interface Receive as ReceiveWmtpMsg;
        interface Packet as PacketWmtpMsg;
        interface AMPacket;
        interface SplitControl as RadioControl;

        //interface Queue<WmtpConnectionSpecification_t *> as IdleConnectionsQueue;
        interface Queue<WmtpConnectionSpecification_t *> as OpenConnectionsQueue;
        interface Queue<WmtpServiceSpecification_t *> as RegisteredServicesQueue;
        interface Queue<WmtpConnectionSpecification_t *> as ReservedQoSConnectionsQueue;
        //interface Queue<WmtpQueueElement_t *> as IdleQueueElementsQueue;
        interface Queue<WmtpQueueElement_t *> as CoreQueue;

        interface Pool<WmtpConnectionSpecification_t> as IdleConnectionsPool;
        interface Pool<WmtpQueueElement_t> as IdleQueueElementsPool;
    }
} implementation {
    //WmtpConnectionSpecification_t ConnectionSpecificationBuffers[NUM_CONNECTION_SPECIFICATIONS];
    //WmtpQueueElement_t QueueElementBuffers[NUM_QUEUE_ELEMENTS];
    uint8_t numQoSReservedQueueElements;
    void *localManagementHeaderData[NUM_LOCAL_MANAGEMENT_DATA_HANDLERS];
    uint8_t localManagementHeaderDataSize[NUM_LOCAL_MANAGEMENT_DATA_HANDLERS];
    uint8_t currentLocalManagementHeader;
    //uint32_t localManagementDataNextSendTime;
    uint32_t localManagementDataNextSendTime;
    uint8_t QoSReservationTree[((1<<QOS_RESERVATION_TREE_MAX_DEPTH) - 1) / 8 + 1];
    uint8_t sendTaskPosted;
    message_t sendMsgBuffer;
    uint8_t sendingMsg;
    WmtpPayload_t rcvdPayloadBuffer;
    WmtpPayload_t *rcvdPayloadPtr;


    /**
     * Initializes the module.
    **/

    void RemoveFromQueue(WmtpQueueElement_t *QueueElement);

    command error_t Init.init() {
        unsigned char i;

        dbg( "WMTP", "WmtpCoreP: Initializing WMTP core.\n" );

        //for ( i = 0; i < NUM_CONNECTION_SPECIFICATIONS; i++ )
        //	call IdleConnectionsQueue.enqueue( &ConnectionSpecificationBuffers[i] );

        //for ( i = 0; i < NUM_QUEUE_ELEMENTS; i++ ) {
        //LinkedLists_insertElementBeginning( &idleQueueElements, &(QueueElementBuffers[i].element) );
        //call IdleQueueElementsQueue.enqueue( &QueueElementBuffers[i] );
        //}
        numQoSReservedQueueElements = 0;

        for ( i = 0; i < NUM_LOCAL_MANAGEMENT_DATA_HANDLERS; i++ ) {
            localManagementHeaderData[i] = NULL;
            localManagementHeaderDataSize[i] = 0;
        }
        currentLocalManagementHeader = 0;

        for ( i = 0; i < ((1<<QOS_RESERVATION_TREE_MAX_DEPTH) - 1) / 8 + 1; i++ )
            QoSReservationTree[i] = 0;

        sendTaskPosted = FALSE;

        rcvdPayloadPtr = &rcvdPayloadBuffer;

        dbg( "WMTP", "WmtpCoreP: Initializing WMTP components.\n" );

        return call ComponentInit.init();
    }


    event void Boot.booted() {
        call RadioControl.start();
    }

    command error_t StdControl.start() {

        dbg( "WMTP", "WmtpCoreP: Starting WMTP core.\n" );

        localManagementDataNextSendTime = call LocalManagementDataTimer.getNow() + LOCAL_MANAGEMENT_DATA_PERIOD;
        //result = ecombine3(
        //	call LocalManagementDataTimer.set( localManagementDataNextSendTime ),
        //	call CommControl.setPromiscuous( TRUE ),
        //	result );
        call LocalManagementDataTimer.startOneShot( LOCAL_MANAGEMENT_DATA_PERIOD );

        dbg( "WMTP", "WmtpCoreP: Starting WMTP components.\n" );

        return call ComponentControl.start();
    }


    command error_t StdControl.stop() {

        dbg( "WMTP", "WmtpCoreP: Stopping WMTP core.\n" );
        call LocalManagementDataTimer.stop();

        dbg( "WMTP", "WmtpCoreP: Stopping WMTP components.\n" );

        return call ComponentControl.stop();
    }

    event void RadioControl.startDone(error_t err) {
        if (err != SUCCESS) {
            call RadioControl.start();
            return;
        }
    }


    event void RadioControl.stopDone(error_t err) {}

    char *dbgTOSMsg( message_t *msg ) {
        unsigned char i = 0;
        static char b[100];
        char *p = b;
        uint8_t length = call PacketWmtpMsg.payloadLength( msg );
        for ( i = 0; i < length; i++ ) {
            snprintf( p, 100, " %03d", msg->data[i] );
            p += 4;
        }
        return b;
    }


    void RemoveFromQueue( WmtpQueueElement_t *QueueElement ) {
        WmtpQueueElement_t *ptr;
        uint8_t i = 0;

        ptr = call CoreQueue.dequeue();
        if ( call CoreQueue.empty() ) return;

        for (; i < call CoreQueue.size() ; i++) {
            if ( ptr == QueueElement ) {
                for (; i < call CoreQueue.size() ; i++) {
                    ptr = call CoreQueue.dequeue();
                    call CoreQueue.enqueue( ptr );
                }
                return;
            }

            call CoreQueue.enqueue( ptr );
            ptr = call CoreQueue.dequeue();
        }

        call CoreQueue.enqueue( ptr );
    }

    void UnreserveQoSConnection( WmtpConnectionSpecification_t *ConnectionSpecification ) {
        WmtpConnectionSpecification_t *ptr;
        uint8_t i = 0;

        ptr = call ReservedQoSConnectionsQueue.dequeue();
        if ( call ReservedQoSConnectionsQueue.empty() ) return;

        for (; i < call ReservedQoSConnectionsQueue.size() ; i++) {
            if ( ptr == ConnectionSpecification ) {
                for (; i < call ReservedQoSConnectionsQueue.size() ; i++) {
                    ptr = call ReservedQoSConnectionsQueue.dequeue();
                    call ReservedQoSConnectionsQueue.enqueue( ptr );
                }
                return;
            }

            call ReservedQoSConnectionsQueue.enqueue( ptr );
            ptr = call ReservedQoSConnectionsQueue.dequeue();
        }
        call ReservedQoSConnectionsQueue.enqueue( ptr );
    }

    error_t IsServiceRegistered( WmtpServiceSpecification_t *ServiceSpecification ) {
        WmtpServiceSpecification_t *ptr;
        uint8_t i = 0;

        for (; i < call RegisteredServicesQueue.size(); i++ ) {
            ptr = call RegisteredServicesQueue.element( i );

            if ( ptr == ServiceSpecification ) return TRUE;
        }

        return FALSE;
    }


    void UnregisterService( WmtpServiceSpecification_t *ServiceSpecification ) {
        WmtpServiceSpecification_t *ptr;
        uint8_t i = 0;

        ptr = call RegisteredServicesQueue.dequeue();
        if ( call RegisteredServicesQueue.empty() ) return;

        for (;  i < call RegisteredServicesQueue.size() ; i++) {
            if ( ptr == ServiceSpecification ) {
                for (; i < call RegisteredServicesQueue.size() ; i++) {
                    ptr = call RegisteredServicesQueue.dequeue();
                    call RegisteredServicesQueue.enqueue( ptr );
                }
                return;
            }

            call RegisteredServicesQueue.enqueue( ptr );
            ptr = call RegisteredServicesQueue.dequeue();
        }
        call RegisteredServicesQueue.enqueue( ptr );
    }

    error_t IsConnectionOpened( WmtpConnectionSpecification_t *ConnectionSpecification ) {
        WmtpConnectionSpecification_t *ptr;
        uint8_t i = 0;

        for (; i < call OpenConnectionsQueue.size(); i++ ) {
            ptr = call OpenConnectionsQueue.element( i );

            if ( ptr == ConnectionSpecification ) return TRUE;
        }

        return FALSE;
    }

    void CloseConnection( WmtpConnectionSpecification_t *ConnectionSpecification ) {
        WmtpConnectionSpecification_t *ptr;
        uint8_t i = 0;

        ptr = call OpenConnectionsQueue.dequeue();
        if ( call OpenConnectionsQueue.empty() ) return;

        for (;  i < call OpenConnectionsQueue.size() ; i++) {
            if ( ptr == ConnectionSpecification ) {
                for (; i < call OpenConnectionsQueue.size() ; i++) {
                    ptr = call OpenConnectionsQueue.dequeue();
                    call OpenConnectionsQueue.enqueue( ptr );
                }
                return;
            }

            call OpenConnectionsQueue.enqueue( ptr );
            ptr = call OpenConnectionsQueue.dequeue();
        }
        call OpenConnectionsQueue.enqueue( ptr );
    }

    uint8_t IsConnectionClearToSend( WmtpConnectionSpecification_t *ConnectionSpecification ) {
        unsigned char i;

        if ( uniqueCount( "WmtpTrafficShaper" ) == 0 )
            return TRUE;

        for ( i = 0; i < (uniqueCount( "WmtpTrafficShaper" ) - 1) / 8; i++ )
            if ( ConnectionSpecification->TrafficShaperState[i] != 0xFF )
                return FALSE;
        if ( uniqueCount( "WmtpTrafficShaper" ) % 8 == 0 &&
                ConnectionSpecification->TrafficShaperState[(uniqueCount( "WmtpTrafficShaper" ) - 1) / 8] != 0xFF )
            return FALSE;
        if ( uniqueCount( "WmtpTrafficShaper" ) % 8 != 0 &&
                ConnectionSpecification->TrafficShaperState[(uniqueCount( "WmtpTrafficShaper" ) - 1) / 8] != ((1<<(uniqueCount( "WmtpTrafficShaper" ) % 8)) - 1) )
            return FALSE;

        return TRUE;
    }


    uint8_t IsPacketClearToSend( WmtpQueueElement_t * queueElement ) {
        unsigned char i;

        if ( uniqueCount( "WmtpTrafficShaper" ) == 0 )
            return TRUE;

        for ( i = 0; i < (uniqueCount( "WmtpTrafficShaper" ) - 1) / 8; i++ )
            if ( queueElement->TrafficShaperState[i] != 0xFF )
                return FALSE;
        if ( uniqueCount( "WmtpTrafficShaper" ) % 8 == 0 &&
                queueElement->TrafficShaperState[(uniqueCount( "WmtpTrafficShaper" ) - 1) / 8] != 0xFF )
            return FALSE;
        if ( uniqueCount( "WmtpTrafficShaper" ) % 8 != 0 &&
                queueElement->TrafficShaperState[(uniqueCount( "WmtpTrafficShaper" ) - 1) / 8] != ((1<<(uniqueCount( "WmtpTrafficShaper" ) % 8)) - 1) )
            return FALSE;

        return TRUE;
    }


    error_t GetNewConnectionSpecification( WmtpConnectionSpecification_t **ConnectionSpecification ) {
        //if ( ! call IdleConnectionsQueue.empty() ) {
        if ( ! call IdleConnectionsPool.empty() ) {
            unsigned char i;

            //*ConnectionSpecification = LinkedLists_removeFirstElement( &idleConnectionSpecifications );
            //*ConnectionSpecification = call IdleConnectionsQueue.dequeue();
            *ConnectionSpecification = call IdleConnectionsPool.get();

            (*ConnectionSpecification)->PathSpecification.PathType = WMTP_PATHTYPE_DEFAULT;
            (*ConnectionSpecification)->QoSSpecification.MaxDelay = 0;
            (*ConnectionSpecification)->QoSSpecification.MaxPeriod = 0;
            (*ConnectionSpecification)->QoSPriority = WMTP_QOSPRIORITY_NONE;
            (*ConnectionSpecification)->QoSReservedQueueElement = NULL;
            (*ConnectionSpecification)->IsTemporary = FALSE;

            if ( uniqueCount( "WmtpTrafficShaper" ) > 0 ) {
                for ( i = 0; i < (uniqueCount( "WmtpTrafficShaper" ) - 1) / 8; i++ )
                    (*ConnectionSpecification)->TrafficShaperState[i] = 0xFF;
                if ( uniqueCount( "WmtpTrafficShaper" ) % 8 == 0 )
                    (*ConnectionSpecification)->TrafficShaperState[(uniqueCount( "WmtpTrafficShaper" ) - 1) / 8] = 0xFF;
                if ( uniqueCount( "WmtpTrafficShaper" ) % 8 != 0 )
                    (*ConnectionSpecification)->TrafficShaperState[(uniqueCount( "WmtpTrafficShaper" ) - 1) / 8] = ((1<<(uniqueCount( "WmtpTrafficShaper" ) % 8)) - 1);
            }

            for ( i = 0; i < NUM_FEATURE_CONFIGURATION_HANDLERS; i++ )
                call WmtpFeatureConfigurationHandler.InitializeConfiguration[i]( *ConnectionSpecification );

            return SUCCESS;
        } else {
            return FAIL;
        }
    }


    error_t DestroyConnectionSpecification( WmtpConnectionSpecification_t *ConnectionSpecification ) {
        //LinkedLists_insertElementBeginning( &idleConnectionSpecifications, &(ConnectionSpecification->element) );
        //call IdleConnectionsQueue.enqueue( ConnectionSpecification );
        call IdleConnectionsPool.put( ConnectionSpecification );

        return SUCCESS;
    }


    WmtpQueueElement_t *getNewQueueElement( WmtpConnectionSpecification_t *ConnectionSpecification ) {
        WmtpQueueElement_t *queueElement = NULL;
        unsigned char i;

        if ( ConnectionSpecification &&
                ConnectionSpecification->QoSReservedQueueElement ) {
            queueElement = ConnectionSpecification->QoSReservedQueueElement;

            ConnectionSpecification->QoSReservedQueueElement = NULL;
            //} else if ( ! call IdleQueueElementsQueue.empty() ) {
        } else if ( ! call IdleQueueElementsPool.empty() ) {
            //queueElement = LinkedLists_removeFirstElement( &idleQueueElements );
            //queueElement = call IdleQueueElementsQueue.dequeue();
            queueElement = call IdleQueueElementsPool.get();
        }

        if ( queueElement ) {
            queueElement->ConnectionSpecification = ConnectionSpecification;
            queueElement->NextHop = AM_BROADCAST_ADDR;
            queueElement->NumConnectionParts = 0;
            queueElement->ConnectionLocalPartSize = 0;

            for ( i = 0; i < WMTP_MAXCONNECTIONPARTS; i++ )
                queueElement->ConnectionParts[i] = NULL;

            if ( uniqueCount( "WmtpTrafficShaper" ) > 0 ) {
                for ( i = 0; i < (uniqueCount( "WmtpTrafficShaper" ) - 1) / 8; i++ )
                    queueElement->TrafficShaperState[i] = 0xFF;
                if ( uniqueCount( "WmtpTrafficShaper" ) % 8 == 0 )
                    queueElement->TrafficShaperState[(uniqueCount( "WmtpTrafficShaper" ) - 1) / 8] = 0xFF;
                if ( uniqueCount( "WmtpTrafficShaper" ) % 8 != 0 )
                    queueElement->TrafficShaperState[(uniqueCount( "WmtpTrafficShaper" ) - 1) / 8] = ((1<<(uniqueCount( "WmtpTrafficShaper" ) % 8)) - 1);
            }

            return queueElement;
        } else {
            return NULL;
        }
    }


    void destroyQueueElement( WmtpQueueElement_t *QueueElement ) {
        if ( QueueElement->ConnectionSpecification &&
                QueueElement->ConnectionSpecification->IsTemporary ) {
            DestroyConnectionSpecification( QueueElement->ConnectionSpecification );

            //LinkedLists_insertElementBeginning( &idleQueueElements, &(QueueElement->element) );
            //call IdleQueueElementsQueue.enqueue( QueueElement );
            call IdleQueueElementsPool.put( QueueElement );
        } else if ( QueueElement->ConnectionSpecification &&
                    QueueElement->ConnectionSpecification->QoSPriority != WMTP_QOSPRIORITY_NONE &&
                    QueueElement->ConnectionSpecification->QoSReservedQueueElement == NULL ) {
            QueueElement->ConnectionSpecification->QoSReservedQueueElement = QueueElement;
        } else {
            //LinkedLists_insertElementBeginning( &idleQueueElements, &(QueueElement->element) );
            //call IdleQueueElementsQueue.enqueue( QueueElement );
            call IdleQueueElementsPool.put( QueueElement );
        }
    }


    task void sendTask() {
        sendTaskPosted = FALSE;

        // Check if we're not already sending a message.
        if ( ! sendingMsg ) {
            WmtpMsg_t *wmtpMsg = (WmtpMsg_t *) sendMsgBuffer.data;
            WmtpLocalPart_t *localPart = &(wmtpMsg->LocalParts[0]);
            WmtpQueueElement_t *queueElement = NULL;
            uint32_t curTime = call LocalManagementDataTimer.getNow();

            dbg( "WMTP", "WmtpCoreP: Sending WmtpMsg:\n" );

            // Check if the core queue is empty.
            if ( ! call CoreQueue.empty() ) {
                WmtpQueueElement_t *QE;
                uint8_t e = 0;
                // Find the highest priority queue element that is ready to send.
                do {
                    QE = call CoreQueue.element( e++ );
                    // Ignore bogus packets or packets that are not clear to send.
                    if ( (QE->NextHop != TOS_NODE_ID) &&
                            (QE->NextHop != AM_BROADCAST_ADDR) &&
                            IsPacketClearToSend( QE ) ) {
                        if ( queueElement == NULL ) {
                            queueElement = QE;
                        } else {
                            // Check if the current packet has a higher priority than the candidate.
                            if ( QE->ConnectionSpecification != NULL &&
                                    QE->ConnectionSpecification->QoSPriority != WMTP_QOSPRIORITY_NONE ) {
                                if ( queueElement->ConnectionSpecification == NULL ||
                                        queueElement->ConnectionSpecification->QoSPriority == WMTP_QOSPRIORITY_NONE ) {
                                    queueElement = QE;
                                } else if ( QE->ConnectionSpecification->QoSPriority < queueElement->ConnectionSpecification->QoSPriority ) {
                                    queueElement = QE;
                                }
                            }
                        }
                    }
                } while ( e < call CoreQueue.size() );
                // Check if a queue element that is clear to send was not found.
                if ( queueElement == NULL )
                    dbg( "WMTP", "WmtpCoreP:    Core queue has no active packets.\n" );
            } else {
                dbg( "WMTP", "WmtpCoreP:    Core queue is empty.\n" );
            }

            // Check if we don't have any connection data and it's too early to broadcast local parts.
            if ( queueElement == NULL ) {
                if ( curTime < localManagementDataNextSendTime ) {
                    dbg( "WMTP", "WmtpCoreP:    No connection data available and too early to broadcast local parts. Nothing to send.\n" );
                    return;
                } else {
                    dbg( "WMTP", "WmtpCoreP:    No connection data available. Broadcasting local parts.\n" );
                }
            }
            // Reset local management data timer.
            call LocalManagementDataTimer.stop();
            localManagementDataNextSendTime = call LocalManagementDataTimer.getNow() + LOCAL_MANAGEMENT_DATA_PERIOD;
            call LocalManagementDataTimer.startOneShot( LOCAL_MANAGEMENT_DATA_PERIOD );

            dbg( "WMTP", "WmtpCoreP:    Generating outgoing WMTP message.\n" );

            // Start filling in WMTP message.
            wmtpMsg->SrcAddr = TOS_NODE_ID;
            // Append local parts.
            if ( NUM_LOCAL_MANAGEMENT_DATA_HANDLERS > 0 ) {
                uint8_t connectionLocalPartSize = (queueElement != NULL) ?
                                                  offsetof( WmtpLocalPart_t, Data ) + queueElement->ConnectionLocalPartSize : 0;
                uint8_t previousLocalManagementHeader = currentLocalManagementHeader;
                // Find the first local part that will fit.
                do {
                    if ( localManagementHeaderData[currentLocalManagementHeader] != NULL &&
                            offsetof( WmtpMsg_t, LocalParts ) +
                            offsetof( WmtpLocalPart_t, Data ) +
                            localManagementHeaderDataSize[currentLocalManagementHeader] +
                            connectionLocalPartSize <= TOSH_DATA_LENGTH )
                        break;
                    if ( ++currentLocalManagementHeader >= NUM_LOCAL_MANAGEMENT_DATA_HANDLERS )
                        currentLocalManagementHeader = 0;
                } while ( currentLocalManagementHeader != previousLocalManagementHeader );
                // Check if a suitable local part was found.
                if ( localManagementHeaderData[currentLocalManagementHeader] != NULL &&
                        offsetof( WmtpMsg_t, LocalParts ) +
                        offsetof( WmtpLocalPart_t, Data ) +
                        localManagementHeaderDataSize[currentLocalManagementHeader] +
                        connectionLocalPartSize <= TOSH_DATA_LENGTH ) {
                    previousLocalManagementHeader = currentLocalManagementHeader;
                    // Append as many consecutive local parts as can fit.
                    do {
                        if ( localManagementHeaderData[currentLocalManagementHeader] != NULL ) {
                            dbg( "WMTP", "WmtpCoreP:       Appending local part (type = %d, size = %d).\n",
                                 currentLocalManagementHeader, localManagementHeaderDataSize[currentLocalManagementHeader] );
                            localPart->Type = currentLocalManagementHeader;
                            memcpy( &(localPart->Data[0]), localManagementHeaderData[currentLocalManagementHeader], localManagementHeaderDataSize[currentLocalManagementHeader] );
                            // Calculate the beginning of the next local part from the size of this one.
                            localPart = (WmtpLocalPart_t *) (((uint8_t *) localPart) +
                                                             offsetof( WmtpLocalPart_t, Data ) + localManagementHeaderDataSize[currentLocalManagementHeader]);
                            dbg( "WMTP", "WmtpCoreP:       Signaling local management data handler.\n" );
                            signal WmtpLocalManagementDataHandler.HeaderBroadcasted[currentLocalManagementHeader]();
                        }
                        if ( ++currentLocalManagementHeader >= NUM_LOCAL_MANAGEMENT_DATA_HANDLERS )
                            currentLocalManagementHeader = 0;
                    } while ( currentLocalManagementHeader != previousLocalManagementHeader &&
                              (((uint8_t *) localPart) - ((uint8_t *) wmtpMsg)) +
                              offsetof( WmtpLocalPart_t, Data ) +
                              localManagementHeaderDataSize[currentLocalManagementHeader] +
                              connectionLocalPartSize <= TOSH_DATA_LENGTH );
                }
            }

            // Append connection local part.
            if ( queueElement != NULL ) {
                unsigned char i;
                uint8_t dropPacket = TRUE;

                dbg( "WMTP", "WmtpCoreP:       Appending connection local part (size = %d).\n", queueElement->ConnectionLocalPartSize );
                localPart->Type = WMTP_LOCALPART_CONN;
                memcpy( &(localPart->Data[0]), &(queueElement->ConnectionLocalPart[0]), queueElement->ConnectionLocalPartSize );
                // Calculate the beginning of the next local part from the size of this connection local part.
                localPart = (WmtpLocalPart_t *) (((uint8_t *) localPart) +
                                                 offsetof( WmtpLocalPart_t, Data ) + queueElement->ConnectionLocalPartSize);

                // Signal traffic shapers.
                dbg( "WMTP", "WmtpCoreP:    Signaling traffic shapers.\n" );
                for ( i = 0; i < uniqueCount( "WmtpTrafficShaper" ); i++ )
                    signal WmtpTrafficShaper.SendingPacket[i]( queueElement );

                if ( queueElement->ConnectionSpecification ) {
                    // Signal the reliability module.
                    dbg( "WMTP", "WmtpCoreP:    Signaling the reliability module %d.\n", queueElement->ConnectionSpecification->FeatureSpecification.ReliabilityHandlerID );
                    if ( signal WmtpReliableTransmissionHook.SendingPacket[queueElement->ConnectionSpecification->FeatureSpecification.ReliabilityHandlerID]( queueElement, &dropPacket ) == FAIL ) {
                        dbg( "WMTP", "WmtpCoreP:    Reliability module failed. Dropping data from queue.\n" );
                        dropPacket = TRUE;
                    } else if ( dropPacket ) {
                        dbg( "WMTP", "WmtpCoreP:    Reliability module flagged packet as droppable. Dropping data from queue.\n" );
                    } else {
                        dbg( "WMTP", "WmtpCoreP:    Reliability module flagged packet as non-droppable. Holding data in queue.\n" );
                    }

                    if ( dropPacket ) {
                        // Remove the data from the queue.
                        //LinkedLists_removeElement( &coreQueue, &(queueElement->element) );
                        RemoveFromQueue( queueElement );
                        destroyQueueElement( queueElement );

                        // Signal traffic shapers.
                        dbg( "WMTP", "WmtpCoreP:    Signaling traffic shapers.\n" );
                        for ( i = 0; i < uniqueCount( "WmtpTrafficShaper" ); i++ )
                            signal WmtpTrafficShaper.DroppingPacket[i]( queueElement );
                        // Signal core monitors.
                        dbg( "WMTP", "WmtpCoreP:    Signaling core monitors.\n" );
                        signal WmtpCoreMonitor.DroppingPacket( queueElement );
                    }
                } else {
                    // Remove the data from the queue.
                    //LinkedLists_removeElement( &coreQueue, &(queueElement->element) );
                    RemoveFromQueue( queueElement );
                    destroyQueueElement( queueElement );

                    // Signal traffic shapers.
                    dbg( "WMTP", "WmtpCoreP:    Signaling traffic shapers.\n" );
                    for ( i = 0; i < uniqueCount( "WmtpTrafficShaper" ); i++ )
                        signal WmtpTrafficShaper.DroppingPacket[i]( queueElement );
                    // Signal core monitors.
                    dbg( "WMTP", "WmtpCoreP:    Signaling core monitors.\n" );
                    signal WmtpCoreMonitor.DroppingPacket( queueElement );
                }
            }

            // Check if any local parts were actually appended.
            if ( localPart != &(wmtpMsg->LocalParts[0]) ) {
                // Send the WMTP message.
                if ( call SendWmtpMsg.send(
                            (queueElement != NULL) ? queueElement->NextHop : AM_BROADCAST_ADDR,
                            &sendMsgBuffer,
                            ((uint8_t *) localPart) - ((uint8_t *) wmtpMsg) ) == SUCCESS ) {
                    sendingMsg = TRUE;

                    dbg( "WMTP", "WmtpCoreP:    Sending WMTP message to %d:%s. Signaling core monitors.\n", (queueElement != NULL) ? queueElement->NextHop : AM_BROADCAST_ADDR, dbgTOSMsg( &sendMsgBuffer ) );
                    if ( queueElement )
                        signal WmtpCoreMonitor.SendingPacket( queueElement );
                    signal WmtpCoreMonitor.SendingWmtpMsg();
                } else {
                    dbg( "WMTP", "WmtpCoreP:    Sending WMTP message to %d (size = %d) failed.\n",
                         (queueElement != NULL) ? queueElement->NextHop : AM_BROADCAST_ADDR,
                         ((uint8_t *) localPart) - ((uint8_t *) wmtpMsg) );
                }
            } else {
                dbg( "WMTP", "WmtpCoreP:    Nothing to send.\n" );
            }
        }
    }


    event void LocalManagementDataTimer.fired() {
        // Post the sending task.
        if ( (! sendTaskPosted) && (! sendingMsg) && (post sendTask() == SUCCESS) )
            sendTaskPosted = TRUE;
    }


    void enqueueData( WmtpQueueElement_t *queueElement ) {
        unsigned char i;

        dbg( "WMTP", "WmtpCoreP: Enqueueing data.\n" );

        // Check if the packet doesn't have reliability and is bogus data, queued only if the reliability module needs it.
        if ( (! queueElement->ConnectionSpecification) &&
                (queueElement->NextHop == TOS_NODE_ID || queueElement->NextHop == AM_BROADCAST_ADDR) ) {
            dbg( "WMTP", "WmtpCoreP: Found bogus data without reliability. Not enqueueing data.\n" );
            // Don't enqueue the data.
            destroyQueueElement( queueElement );
            return;
        }

        // Check if the packet is bogus data, queued only if the reliability module needs it.
        if ( queueElement->ConnectionSpecification &&
                (queueElement->NextHop == TOS_NODE_ID || queueElement->NextHop == AM_BROADCAST_ADDR) ) {
            uint8_t dropPacket = TRUE;

            if ( queueElement->NextHop == TOS_NODE_ID ) {
                // Signal the reliability module.
                dbg( "WMTP", "WmtpCoreP: Signaling reliability module %d with packet delivery.\n", queueElement->ConnectionSpecification->FeatureSpecification.ReliabilityHandlerID );
                if ( signal WmtpReliableTransmissionHook.DeliveringPacket[queueElement->ConnectionSpecification->FeatureSpecification.ReliabilityHandlerID]( queueElement, &dropPacket ) == FAIL ) {
                    dbg( "WMTP", "WmtpCoreP: Reliability module failed. Not enqueueing data.\n" );
                    dropPacket = TRUE;
                } else if ( dropPacket ) {
                    dbg( "WMTP", "WmtpCoreP: Reliability module flagged packet as droppable. Not enqueueing data.\n" );
                } else {
                    dbg( "WMTP", "WmtpCoreP:    Reliability module flagged packet as non-droppable. Enqueueing data.\n" );
                }
            } else if ( queueElement->NextHop == AM_BROADCAST_ADDR ) {
                // Signal the reliability module.
                dbg( "WMTP", "WmtpCoreP: Signaling reliability module %d with unroutable packet.\n", queueElement->ConnectionSpecification->FeatureSpecification.ReliabilityHandlerID );
                if ( signal WmtpReliableTransmissionHook.PacketUnroutable[queueElement->ConnectionSpecification->FeatureSpecification.ReliabilityHandlerID]( queueElement, &dropPacket ) == FAIL ) {
                    dbg( "WMTP", "WmtpCoreP: Reliability module failed. Not enqueueing data.\n" );
                    dropPacket = TRUE;
                } else if ( dropPacket ) {
                    dbg( "WMTP", "WmtpCoreP: Reliability module flagged packet as droppable. Not enqueueing data.\n" );
                } else {
                    dbg( "WMTP", "WmtpCoreP:    Reliability module flagged packet as non-droppable. Enqueueing data.\n" );
                }
            }

            if ( dropPacket ) {
                destroyQueueElement( queueElement );

                // Signal traffic shapers.
                dbg( "WMTP", "WmtpCoreP:    Signaling traffic shapers.\n" );
                for ( i = 0; i < uniqueCount( "WmtpTrafficShaper" ); i++ )
                    signal WmtpTrafficShaper.DroppingPacket[i]( queueElement );
                // Signal core monitors.
                dbg( "WMTP", "WmtpCoreP:    Signaling core monitors.\n" );
                signal WmtpCoreMonitor.DroppingPacket( queueElement );

                return;
            }
        }

        // Enqueue the data.
        //LinkedLists_insertElementEnd( &coreQueue, &(queueElement->element) );
        call CoreQueue.enqueue( queueElement );

        // Signal the traffic shapers.
        dbg( "WMTP", "WmtpCoreP: Signaling traffic shapers.\n" );
        for ( i = 0; i < uniqueCount( "WmtpTrafficShaper" ); i++ )
            signal WmtpTrafficShaper.NewPacket[i]( queueElement );

        // Post the sending task.
        if ( (! sendTaskPosted) && (! sendingMsg) && (post sendTask() == SUCCESS) )
            sendTaskPosted = TRUE;
    }


    event void SendWmtpMsg.sendDone( message_t *msg, error_t success ) {
        sendingMsg = FALSE;

        dbg( "WMTP", "WmtpCoreP: WMTP message sent. Signaling core monitors.\n" );
        signal WmtpCoreMonitor.SentWmtpMsg();

        if ( (! sendTaskPosted) && (post sendTask() == SUCCESS) )
            sendTaskPosted = TRUE;
    }


    error_t GenerateConnectionConfiguration( WmtpConnectionSpecification_t *ConnectionSpecification, void *ConfigurationData, uint8_t *ConfigurationDataSize ) {
        WmtpConfigurationPart_t *curConfigurationPart = ConfigurationData;
        unsigned char i;

        dbg( "WMTP", "WmtpCoreP: Generating connection configuration data.\n" );

        for ( i = 0; i < NUM_FEATURE_CONFIGURATION_HANDLERS; i++ ) {
            uint8_t partDataSize = 0;

            if ( call WmtpFeatureConfigurationHandler.GenerateConfigurationData[i]( ConnectionSpecification, &(curConfigurationPart->Data[0]), &partDataSize ) == SUCCESS ) {
                dbg( "WMTP", "WmtpCoreP:    Generated configuration part (type = %d, size = %d).\n", i, partDataSize );
                curConfigurationPart->Type = i;
                curConfigurationPart = (WmtpConfigurationPart_t *) (((uint8_t *) curConfigurationPart) + offsetof( WmtpConfigurationPart_t, Data ) + partDataSize);
            }
        }

        curConfigurationPart->Type = WMTP_CONFPART_LAST;
        *ConfigurationDataSize = (((uint8_t *) curConfigurationPart) - ((uint8_t *) ConfigurationData)) +
                                 offsetof( WmtpConfigurationPart_t, Data );

        dbg( "WMTP", "WmtpCoreP:    Done (total size = %d).\n", *ConfigurationDataSize );

        return SUCCESS;
    }


    error_t ConfigureConnection( void *ConfigurationData, uint8_t *ConfigurationDataSize, WmtpConnectionSpecification_t *ConnectionSpecification ) {
        WmtpConfigurationPart_t *curConfigurationPart = ConfigurationData;
        unsigned char i;

        dbg( "WMTP", "WmtpCoreP: Configuring connection. Initializing configuration.\n" );

        // Initialize the configuration.
        for ( i = 0; i < NUM_FEATURE_CONFIGURATION_HANDLERS; i++ )
            call WmtpFeatureConfigurationHandler.InitializeConfiguration[i]( ConnectionSpecification );

        // Iterate through configuration parts.
        while ( curConfigurationPart->Type != WMTP_CONFPART_LAST ) {
            uint8_t partDataSize = 0;

            dbg( "WMTP", "WmtpCoreP:    Found configuration part (type = %d). Signaling handler.\n", curConfigurationPart->Type );
            if ( call WmtpFeatureConfigurationHandler.HandleConfigurationData[curConfigurationPart->Type]( &(curConfigurationPart->Data[0]), &partDataSize, ConnectionSpecification ) != SUCCESS ) {
                dbg( "WMTP", "WmtpCoreP:    Feature configuration handler failed.\n" );
                return FAIL;
            } else {
                dbg( "WMTP", "WmtpCoreP:    Feature configuration data succesfully handled (size = %d).\n", partDataSize );
            }

            // Calculate the beginning of the next connection part from the size of the header.
            curConfigurationPart = (WmtpConfigurationPart_t *) (((uint8_t *) curConfigurationPart) +
                                   offsetof( WmtpConfigurationPart_t, Data ) + partDataSize);
        }

        *ConfigurationDataSize = (((uint8_t *) curConfigurationPart) - ((uint8_t *) ConfigurationData)) +
                                 offsetof( WmtpConfigurationPart_t, Data );

        dbg( "WMTP", "WmtpCoreP:    Done (total size = %d).\n", *ConfigurationDataSize );

        return SUCCESS;
    }


    uint8_t isQoSReservationNodeReserved( uint8_t level, uint8_t num ) {
        uint16_t i;

        if ( level <= QOS_RESERVATION_TREE_MAX_DEPTH &&
                num < 1<<level ) {
            for ( i = num * (1<<(QOS_RESERVATION_TREE_MAX_DEPTH - level));
                    i < (num + 1) * (1<<(QOS_RESERVATION_TREE_MAX_DEPTH - level));
                    i++ )
                if ( (QoSReservationTree[i / 8] & 1<<(i % 8)) == 0 )
                    return FALSE;

            return TRUE;
        } else {
            return FALSE;
        }
    }


    void reserveQoSReservationNode( uint8_t level, uint8_t num ) {
        uint16_t i;

        if ( level <= QOS_RESERVATION_TREE_MAX_DEPTH &&
                num < 1<<level )
            for ( i = num * (1<<(QOS_RESERVATION_TREE_MAX_DEPTH - level));
                    i < (num + 1) * (1<<(QOS_RESERVATION_TREE_MAX_DEPTH - level));
                    i++ )
                QoSReservationTree[i / 8] |= 1<<(i % 8);
    }


    void freeQoSReservationNode( uint8_t level, uint8_t num ) {
        uint16_t i;

        if ( level <= QOS_RESERVATION_TREE_MAX_DEPTH &&
                num < 1<<level )
            for ( i = num * (1<<(QOS_RESERVATION_TREE_MAX_DEPTH - level));
                    i < (num + 1) * (1<<(QOS_RESERVATION_TREE_MAX_DEPTH - level));
                    i++ )
                QoSReservationTree[i / 8] &= ~(1<<(i % 8));
    }


    event message_t *ReceiveWmtpMsg.receive( message_t *msg, void *payload, uint8_t len )  {
        WmtpMsg_t *rcvdWmtpMsg = (WmtpMsg_t *) msg->data;
        WmtpLocalPart_t *curLocalPart = &(rcvdWmtpMsg->LocalParts[0]);
        uint8_t dropPacket = FALSE;

        dbg( "WMTP", "WmtpCoreP: Received WMTP message:%s. Signaling core monitors.\n", dbgTOSMsg( msg ) );
        signal WmtpCoreMonitor.ReceivedWmtpMsg();

        dbg( "WMTP", "WmtpCoreP: Received WMTP message from %d. Parsing local parts:\n", rcvdWmtpMsg->SrcAddr );

        // Iterate through local parts.
        while ( ((uint8_t *) curLocalPart) - ((uint8_t *) rcvdWmtpMsg) < len ) {
            // Check if connection local part.
            if ( curLocalPart->Type == WMTP_LOCALPART_CONN ) {
                WmtpConnectionLocalPart_t *connectionLocalPart = (WmtpConnectionLocalPart_t *) &(curLocalPart->Data[0]);
                uint16_t nextAddr = AM_BROADCAST_ADDR;
                WmtpConnectionSpecification_t *connectionSpecification = NULL;
                WmtpQueueElement_t *queueElement = NULL;
                WmtpConnectionPart_t *curConnectionPart;
                uint8_t routerDataSize = 0;

                if ( call AMPacket.destination(msg) != TOS_NODE_ID ) {
                    dbg( "WMTP", "WmtpCoreP:    Found connection local part but the WmtpMsg was received promiscuously.\n" );
                    break;
                }

                dbg( "WMTP", "WmtpCoreP:    Found connection local part.\n" );

                // Call MultihopRouter handler.
                dbg( "WMTP", "WmtpCoreP:       Processing routing header (type = %d).\n", connectionLocalPart->RouterType );
                if ( call WmtpMultihopRouter.GetNextHop[connectionLocalPart->RouterType]( rcvdWmtpMsg->SrcAddr, connectionLocalPart->RouterData, &routerDataSize, &nextAddr, &connectionSpecification ) == SUCCESS ) {
                    dbg( "WMTP", "WmtpCoreP:       Next hop = %d, routing header size = %d, connection specified: %s. Parsing connections parts:\n", nextAddr, routerDataSize, (connectionSpecification != NULL) ? "yes" : "no" );
                } else {
                    dbg( "WMTP", "WmtpCoreP:       Multihop router failed. Packet will be dropped.\n" );
                    break;
                }

                // Get new queue element.
                queueElement = getNewQueueElement( connectionSpecification );
                if ( queueElement == NULL ) {
                    dbg( "WMTP", "WmtpCoreP:       Out of queue memory. Data dropped.\n" );
                    break;
                }
                queueElement->NextHop = nextAddr;
                queueElement->NumConnectionParts = 0;
                queueElement->ConnectionLocalPartSize = offsetof( WmtpConnectionLocalPart_t, RouterData ) + routerDataSize;
                memcpy( &(queueElement->ConnectionLocalPart[0]), connectionLocalPart, offsetof( WmtpConnectionLocalPart_t, RouterData ) + routerDataSize );

                // Iterate through connection parts.
                curConnectionPart = (WmtpConnectionPart_t *) ((uint8_t *) connectionLocalPart->RouterData) + routerDataSize;
                if ( ((uint8_t *) curConnectionPart) - ((uint8_t *) rcvdWmtpMsg) >= len ) {
                    dbg( "WMTP", "WmtpCoreP:       Connection local part ended unexpectedly. Packet will be dropped.\n" );
                    dropPacket = TRUE;
                }
                while ( ((uint8_t *) curConnectionPart) - ((uint8_t *) rcvdWmtpMsg) < len ) {
                    if ( queueElement->NumConnectionParts >= WMTP_MAXCONNECTIONPARTS ) {
                        dbg( "WMTP", "WmtpCoreP:       Too many connection parts. Packet will be dropped.\n" );
                        dropPacket = TRUE;
                        break;
                    }
                    queueElement->ConnectionParts[queueElement->NumConnectionParts++] = (WmtpConnectionPart_t *) &(queueElement->ConnectionLocalPart[queueElement->ConnectionLocalPartSize]);
                    memcpy( &(queueElement->ConnectionLocalPart[queueElement->ConnectionLocalPartSize]),
                            curConnectionPart,
                            offsetof( WmtpConnectionPart_t, Data ) );
                    queueElement->ConnectionLocalPartSize += offsetof( WmtpConnectionPart_t, Data );

                    // Check if configuration connection part.
                    if ( curConnectionPart->Type == WMTP_CONNPART_CONFIG ) {
                        uint8_t ConfigurationDataSize = 0;
                        uint8_t isReconfig = FALSE;

                        dbg( "WMTP", "WmtpCoreP:          Found configuration connection part.\n" );

                        if ( connectionSpecification == NULL ) {
                            if ( GetNewConnectionSpecification( &connectionSpecification ) != SUCCESS ) {
                                dbg( "WMTP", "WmtpCoreP:          Out of connection specification memory. Dropping packet.\n" );
                                dropPacket = TRUE;
                                break;
                            }

                            queueElement->ConnectionSpecification = connectionSpecification;
                            connectionSpecification->IsTemporary = TRUE;
                        } else {
                            isReconfig = TRUE;
                        }

                        if ( ConfigureConnection( &(curConnectionPart->Data[0]), &ConfigurationDataSize, connectionSpecification ) != SUCCESS ) {
                            dbg( "WMTP", "WmtpCoreP:          Configuration connection part handling failed. Dropping packet.\n" );
                            dropPacket = TRUE;
                            break;
                        }

                        if ( isReconfig ) {
                            unsigned char i;

                            // Signal the traffic shapers.
                            dbg( "WMTP", "WmtpCoreP:    Signaling traffic shapers.\n" );
                            for ( i = 0; i < uniqueCount( "WmtpTrafficShaper" ); i++ )
                                signal WmtpTrafficShaper.ConnectionReconfigured[i]( connectionSpecification );

                            if ( connectionSpecification->IsLocal ) {
                                // Signal the application.
                                dbg( "WMTP", "WmtpCoreP:    Signaling application %d.\n", connectionSpecification->ApplicationID );
                                signal WmtpConnectionManager.ConnectionReconfigured[connectionSpecification->ApplicationID]( connectionSpecification );
                            }
                        }

                        // Copy the connection part to the queue element.
                        memcpy( &(queueElement->ConnectionLocalPart[queueElement->ConnectionLocalPartSize]),
                                &(curConnectionPart->Data[0]),
                                ConfigurationDataSize );
                        queueElement->ConnectionLocalPartSize += ConfigurationDataSize;
                        // Calculate the beginning of the next connection part from the size of the header.
                        curConnectionPart = (WmtpConnectionPart_t *) (((uint8_t *) curConnectionPart) +
                                            offsetof( WmtpConnectionPart_t, Data ) + ConfigurationDataSize);
                    } else if ( curConnectionPart->Type == WMTP_CONNPART_DATA ||
                                curConnectionPart->Type == WMTP_CONNPART_LAST ||
                                curConnectionPart->Type == WMTP_CONNPART_CLOSE ) { // Check if data, last, or close connection part.
                        WmtpDataConnectionPart_t *dataConnectionPart = (WmtpDataConnectionPart_t *) curConnectionPart->Data;

                        if ( curConnectionPart->Type == WMTP_CONNPART_DATA ) {
                            dbg( "WMTP", "WmtpCoreP:          Found data connection part.\n" );

                            memcpy( &(queueElement->ConnectionLocalPart[queueElement->ConnectionLocalPartSize]),
                                    dataConnectionPart,
                                    offsetof( WmtpDataConnectionPart_t, PayloadData ) + dataConnectionPart->PayloadSize );
                            queueElement->ConnectionLocalPartSize += offsetof( WmtpDataConnectionPart_t, PayloadData ) + dataConnectionPart->PayloadSize;

                            // Calculate the beginning of the next local part from the size of this ConnectionLocalPart.
                            curLocalPart = (WmtpLocalPart_t *) (((uint8_t *) curLocalPart)
                                                                + (((uint8_t *) &(dataConnectionPart->PayloadData[dataConnectionPart->PayloadSize]))
                                                                   - ((uint8_t *) curLocalPart)));
                        } else {
                            if ( curConnectionPart->Type == WMTP_CONNPART_LAST ) {
                                dbg( "WMTP", "WmtpCoreP:          Found last connection part.\n" );
                            } else if ( curConnectionPart->Type == WMTP_CONNPART_CLOSE ) {
                                dbg( "WMTP", "WmtpCoreP:          Found close connection part.\n" );
                            }

                            // Calculate the beginning of the next local part from the size of this ConnectionLocalPart.
                            curLocalPart = (WmtpLocalPart_t *) (((uint8_t *) curLocalPart)
                                                                + (((uint8_t *) &(curConnectionPart->Data[0]))
                                                                   - ((uint8_t *) curLocalPart)));
                        }

                        // Check if the packet is repeated.
                        dbg( "WMTP", "WmtpCoreP:       Checking for repeated packets with reliability module.\n" );
                        if ( curConnectionPart->Type != WMTP_CONNPART_CLOSE &&
                                queueElement->ConnectionSpecification &&
                                (signal WmtpReliableTransmissionHook.IsPacketRepeated[queueElement->ConnectionSpecification->FeatureSpecification.ReliabilityHandlerID]( queueElement )) ) {
                            // Stop processing connection parts.
                            dbg( "WMTP", "WmtpCoreP:       Packet is repeated. Dropping data.\n" );
                            dbg( "WMTP", "WmtpCoreP:       Finished parsing connection parts.\n" );
                            break;
                        } else {
                            dbg( "WMTP", "WmtpCoreP:       Packet is not repeated.\n" );
                        }

                        // Check if the data is destined for local delivery.
                        if ( curConnectionPart->Type == WMTP_CONNPART_DATA &&
                                nextAddr == TOS_NODE_ID &&
                                connectionSpecification ) {
                            // Signal core monitors with the DeliveringPacket event.
                            dbg( "WMTP", "WmtpCoreP:    Signaling core monitors with the DeliveringPacket event.\n" );
                            signal WmtpCoreMonitor.DeliveringPacket( queueElement );

                            memcpy( rcvdPayloadPtr, dataConnectionPart->PayloadData, dataConnectionPart->PayloadSize );
                            // Deliver the data to the local application.
                            dbg( "WMTP", "WmtpCoreP:          Delivering data to application %d.\n", connectionSpecification->ApplicationID );
                            rcvdPayloadPtr = signal WmtpReceiveMsg.Receive[connectionSpecification->ApplicationID]( connectionSpecification, dataConnectionPart->PayloadSize, rcvdPayloadPtr );
                            dbg( "WMTP", "WmtpCoreP:          Data delivered to application %d.\n", connectionSpecification->ApplicationID );
                        }

                        // Enqueue the data.
                        enqueueData( queueElement );

                        // Signal core monitors with the ReceivedPacket event.
                        dbg( "WMTP", "WmtpCoreP:    Signaling core monitors with the ReceivedPacket event.\n" );
                        signal WmtpCoreMonitor.ReceivedPacket( queueElement );

                        if ( curConnectionPart->Type == WMTP_CONNPART_CLOSE &&
                                connectionSpecification != NULL &&
                                IsConnectionOpened( connectionSpecification ) ) {
                            unsigned char i;

                            dbg( "WMTP", "WmtpCoreP: Closing connection.\n" );

                            queueElement->ConnectionSpecification = NULL;

                            if ( connectionSpecification->QoSPriority != WMTP_QOSPRIORITY_NONE ) {
                                uint16_t n;

                                dbg( "WMTP", "WmtpCoreP:    Freeing QoS resources.\n" );

                                for ( n = 0; n < 1<<connectionSpecification->QoSPriority; n++ ) {
                                    if ( isQoSReservationNodeReserved( connectionSpecification->QoSPriority, n ) ) {
                                        connectionSpecification->QoSPriority = WMTP_QOSPRIORITY_NONE;
                                        freeQoSReservationNode( connectionSpecification->QoSPriority, n );

                                        if ( connectionSpecification->QoSReservedQueueElement ) {
                                            destroyQueueElement( connectionSpecification->QoSReservedQueueElement );
                                            connectionSpecification->QoSReservedQueueElement = NULL;
                                        }
                                        numQoSReservedQueueElements--;
                                    }
                                }
                            }

                            //LinkedLists_removeElement( &openConnections, &(connectionSpecification->element) );
                            CloseConnection( connectionSpecification );

                            // Signal the connection establishment handler.
                            signal WmtpConnectionEstablishmentHandler.ConnectionClosed[connectionSpecification->PathSpecification.PathType]( connectionSpecification );

                            // Signal the traffic shapers.
                            dbg( "WMTP", "WmtpCoreP:    Signaling traffic shapers.\n" );
                            for ( i = 0; i < uniqueCount( "WmtpTrafficShaper" ); i++ )
                                signal WmtpTrafficShaper.ConnectionClosed[i]( connectionSpecification );

                            // Signal the core monitors.
                            dbg( "WMTP", "WmtpCoreP:    Signaling core monitors.\n" );
                            signal WmtpCoreMonitor.ConnectionClosed( connectionSpecification );

                            if ( connectionSpecification->IsLocal ) {
                                // Signal the application.
                                dbg( "WMTP", "WmtpCoreP:    Signaling application %d.\n", connectionSpecification->ApplicationID );
                                signal WmtpConnectionManager.ConnectionClosed[connectionSpecification->ApplicationID]( connectionSpecification );
                            }

                            DestroyConnectionSpecification( connectionSpecification );
                        }

                        // The queue element was used.
                        queueElement = NULL;

                        // Stop processing connection parts.
                        dbg( "WMTP", "WmtpCoreP:       Finished parsing connection parts.\n" );
                        break;
                    } else {
                        uint8_t HeaderDataSize = 0;

                        dbg( "WMTP", "WmtpCoreP:          Found connection part (type = %d). Signaling handler.\n", curConnectionPart->Type );
                        if ( signal WmtpConnectionManagementDataHandler.HandleHeader[curConnectionPart->Type]( rcvdWmtpMsg->SrcAddr, connectionSpecification, queueElement, &(curConnectionPart->Data[0]), &HeaderDataSize ) != SUCCESS ) {
                            dbg( "WMTP", "WmtpCoreP:          Connection management data handler failed. Dropping packet.\n" );
                            dropPacket = TRUE;
                            break;
                        } else {
                            dbg( "WMTP", "WmtpCoreP:          Connection management data succesfully handled (size = %d).\n", HeaderDataSize );
                        }

                        // Copy the connection part to the queue element.
                        memcpy( &(queueElement->ConnectionLocalPart[queueElement->ConnectionLocalPartSize]),
                                &(curConnectionPart->Data[0]),
                                HeaderDataSize );
                        queueElement->ConnectionLocalPartSize += HeaderDataSize;
                        // Calculate the beginning of the next connection part from the size of the header.
                        curConnectionPart = (WmtpConnectionPart_t *) (((uint8_t *) curConnectionPart) +
                                            offsetof( WmtpConnectionPart_t, Data ) + HeaderDataSize);
                    }
                }
                // If the queue element was unused, return it to the idle list.
                if ( queueElement != NULL )
                    destroyQueueElement( queueElement );
                // Check if the packet should be dropped.
                if ( dropPacket )
                    break;
            } else {
                uint8_t HeaderDataSize = 0;

                dbg( "WMTP", "WmtpCoreP:    Found local part (type = %d). Signaling handler.\n", curLocalPart->Type );
                if ( signal WmtpLocalManagementDataHandler.HandleHeader[curLocalPart->Type]( rcvdWmtpMsg->SrcAddr, &(curLocalPart->Data[0]), &HeaderDataSize ) != SUCCESS ) {
                    dbg( "WMTP", "WmtpCoreP:    Local management data handler failed. dropping packet.\n" );
                    break;
                } else {
                    dbg( "WMTP", "WmtpCoreP:    Local management data succesfully handled (size = %d).\n", HeaderDataSize );
                }

                // Calculate the beginning of the next local part from the size of the header.
                curLocalPart = (WmtpLocalPart_t *) (((uint8_t *) curLocalPart) +
                                                    offsetof( WmtpLocalPart_t, Data ) + HeaderDataSize);
            }
        }

        dbg( "WMTP", "WmtpCoreP: Finished parsing local parts.\n" );

        return msg;
    }


    command error_t WmtpConnectionManager.RegisterService[uint8_t ApplicationID]( WmtpServiceSpecification_t *ServiceSpecification ) {
        // Check if the service specification is defined and if it is already registered.
        if ( ServiceSpecification && ! IsServiceRegistered( ServiceSpecification ) ) {
            // Save the application ID.
            ServiceSpecification->ApplicationID = ApplicationID;
            // Add the service.
            //LinkedLists_insertElementBeginning( &registeredServices, &(ServiceSpecification->element) );
            call RegisteredServicesQueue.enqueue( ServiceSpecification );

            dbg( "WMTP", "WmtpCoreP: Registered a new service for application %d. Signaling core monitors.\n", ApplicationID );
            signal WmtpCoreMonitor.ServiceRegistered( ServiceSpecification );

            return SUCCESS;
        } else {
            return FAIL;
        }
    }


    command error_t WmtpConnectionManager.CancelService[uint8_t ApplicationID]( WmtpServiceSpecification_t *ServiceSpecification ) {
        // Check if the service specification is defined and if it is already registered.
        if ( ServiceSpecification && IsServiceRegistered( ServiceSpecification ) ) {
            // Remove the service.
            //LinkedLists_removeElement( &registeredServices, &(ServiceSpecification->element) );
            UnregisterService( ServiceSpecification );

            dbg( "WMTP", "WmtpCoreP: Canceled a service for application %d. Signaling core monitors.\n", ApplicationID );
            signal WmtpCoreMonitor.ServiceCanceled( ServiceSpecification );

            return SUCCESS;
        } else {
            return FAIL;
        }
    }


    command error_t WmtpConnectionManager.GetNewConnectionSpecification[uint8_t ApplicationID]( WmtpConnectionSpecification_t **ConnectionSpecification ) {
        return GetNewConnectionSpecification( ConnectionSpecification );
    }


    command error_t WmtpConnectionManager.DestroyConnectionSpecification[uint8_t ApplicationID]( WmtpConnectionSpecification_t *ConnectionSpecification ) {
        return DestroyConnectionSpecification( ConnectionSpecification );
    }


    command error_t WmtpConnectionManager.OpenConnection[uint8_t ApplicationID]( WmtpConnectionSpecification_t *ConnectionSpecification ) {
        // Check if the connection specification is defined and if it is not already open.
        if ( ConnectionSpecification && ! IsConnectionOpened( ConnectionSpecification ) ) {
            // Save the application ID.
            ConnectionSpecification->ApplicationID = ApplicationID;

            dbg( "WMTP", "WmtpCoreP: Opening connection for application %d. Signaling connection establishment handler.\n", ApplicationID );

            return signal WmtpConnectionEstablishmentHandler.OpenConnection[ConnectionSpecification->PathSpecification.PathType]( ConnectionSpecification );
        } else {
            return FAIL;
        }
    }


    command error_t WmtpConnectionManager.ReconfigureConnection[uint8_t ApplicationID]( WmtpConnectionSpecification_t *ConnectionSpecification ) {
        // Check if the connection is local and is connection oriented.
        if ( ConnectionSpecification &&
                ConnectionSpecification->IsLocal &&
                ConnectionSpecification->IsConnectionOriented ) {
            //TODO: Check for local delivery.
            WmtpQueueElement_t *queueElement = getNewQueueElement( ConnectionSpecification );
            if ( queueElement != NULL ) {
                WmtpConnectionLocalPart_t *connectionLocalPart = (WmtpConnectionLocalPart_t *) &(queueElement->ConnectionLocalPart[0]);
                WmtpConnectionPart_t *curConnectionPart;
                uint8_t headerDataSize = 0;
                unsigned char i;

                dbg( "WMTP", "WmtpCoreP: Reconfiguring connection for application %d.\n", ApplicationID );

                connectionLocalPart->RouterType = ConnectionSpecification->RouterSpecification.RouterType;

                // Call MultihopRouter handler.
                //TODO: if local delivery, connection specification pointer will be changed.
                dbg( "WMTP", "WmtpCoreP:    Generating routing header (type = %d).\n", connectionLocalPart->RouterType );
                queueElement->NextHop = AM_BROADCAST_ADDR;
                if ( call WmtpMultihopRouter.GetNextHop[connectionLocalPart->RouterType]( TOS_NODE_ID, connectionLocalPart->RouterData, &headerDataSize, &(queueElement->NextHop), &ConnectionSpecification ) == SUCCESS ) {
                    dbg( "WMTP", "WmtpCoreP:    Next hop = %d.\n", queueElement->NextHop );
                } else {
                    dbg( "WMTP", "WmtpCoreP:    Multihop router failed. Packet rejected.\n" );
                    destroyQueueElement( queueElement );
                    return FAIL;
                }
                if ( queueElement->NextHop == AM_BROADCAST_ADDR ) {
                    dbg( "WMTP", "WmtpCoreP:    Multihop router didn't specify next hop. Packet rejected.\n" );
                    destroyQueueElement( queueElement );
                    return FAIL;
                }
                queueElement->ConnectionLocalPartSize = offsetof( WmtpConnectionLocalPart_t, RouterData ) + headerDataSize;
                curConnectionPart = (WmtpConnectionPart_t *) (((uint8_t *) &(connectionLocalPart->RouterData[0])) + headerDataSize);
                queueElement->NumConnectionParts = 0;

                headerDataSize = 0;
                if ( GenerateConnectionConfiguration( ConnectionSpecification, &(curConnectionPart->Data[0]), &headerDataSize ) == SUCCESS ) {
                    dbg( "WMTP", "WmtpCoreP:    Generated configuration connection part (size = %d).\n", headerDataSize );
                    if ( queueElement->NumConnectionParts >= WMTP_MAXCONNECTIONPARTS ) {
                        dbg( "WMTP", "WmtpCoreP:       Too many connection parts. Packet rejected.\n" );
                        destroyQueueElement( queueElement );
                        return FAIL;
                    }
                    queueElement->ConnectionParts[queueElement->NumConnectionParts++] = curConnectionPart;
                    curConnectionPart->Type = WMTP_CONNPART_CONFIG;
                    queueElement->ConnectionLocalPartSize += offsetof( WmtpConnectionPart_t, Data ) + headerDataSize;
                    curConnectionPart = (WmtpConnectionPart_t *) (((uint8_t *) curConnectionPart) + offsetof( WmtpConnectionPart_t, Data ) + headerDataSize);
                } else {
                    dbg( "WMTP", "WmtpCoreP:       Failed to generate configuration data.\n" );
                    destroyQueueElement( queueElement );
                    return FAIL;
                }

                for ( i = 0; i < NUM_CONN_MANAGEMENT_DATA_HANDLERS; i++ ) {
                    headerDataSize = 0;
                    if ( signal WmtpConnectionManagementDataHandler.GenerateHeader[i]( ConnectionSpecification, queueElement, &(curConnectionPart->Data[0]), &headerDataSize ) == SUCCESS ) {
                        dbg( "WMTP", "WmtpCoreP:    Generated connection part (type = %d, size = %d).\n", i, headerDataSize );
                        if ( queueElement->NumConnectionParts >= WMTP_MAXCONNECTIONPARTS ) {
                            dbg( "WMTP", "WmtpCoreP:       Too many connection parts. Packet rejected.\n" );
                            destroyQueueElement( queueElement );
                            return FAIL;
                        }
                        queueElement->ConnectionParts[queueElement->NumConnectionParts++] = curConnectionPart;
                        curConnectionPart->Type = i;
                        queueElement->ConnectionLocalPartSize += offsetof( WmtpConnectionPart_t, Data ) + headerDataSize;
                        curConnectionPart = (WmtpConnectionPart_t *) (((uint8_t *) curConnectionPart) + offsetof( WmtpConnectionPart_t, Data ) + headerDataSize);
                    }
                }

                if ( queueElement->NumConnectionParts >= WMTP_MAXCONNECTIONPARTS ) {
                    dbg( "WMTP", "WmtpCoreP:       Too many connection parts. Packet rejected.\n" );
                    destroyQueueElement( queueElement );
                    return FAIL;
                }
                queueElement->ConnectionParts[queueElement->NumConnectionParts++] = curConnectionPart;
                curConnectionPart->Type = WMTP_CONNPART_LAST;
                queueElement->ConnectionLocalPartSize += offsetof( WmtpConnectionPart_t, Data );

                // Enqueue the data.
                enqueueData( queueElement );

                // Signal the traffic shapers.
                dbg( "WMTP", "WmtpCoreP:    Signaling traffic shapers.\n" );
                for ( i = 0; i < uniqueCount( "WmtpTrafficShaper" ); i++ )
                    signal WmtpTrafficShaper.ConnectionReconfigured[i]( ConnectionSpecification );

                return SUCCESS;
            } else {
                dbg( "WMTP", "WmtpCoreP:    Out of queue memory.\n" );
                return FAIL;
            }
        } else {
            dbg( "WMTP", "WmtpCoreP:    Can not reconfigure a non-local or connectionless connection.\n" );
            return FAIL;
        }
    }


    uint8_t isQoSReservationNodeFree( uint8_t level, uint8_t num ) {
        uint16_t i;

        if ( level <= QOS_RESERVATION_TREE_MAX_DEPTH &&
                num < 1<<level ) {
            for ( i = num * (1<<(QOS_RESERVATION_TREE_MAX_DEPTH - level));
                    i < (num + 1) * (1<<(QOS_RESERVATION_TREE_MAX_DEPTH - level));
                    i++ )
                if ( QoSReservationTree[i / 8] & 1<<(i % 8) )
                    return FALSE;

            return TRUE;
        } else {
            return FALSE;
        }
    }


    command error_t WmtpConnectionManager.CloseConnection[uint8_t ApplicationID]( WmtpConnectionSpecification_t *ConnectionSpecification ) {
        // Check if the connection is local and is open.
        if ( ConnectionSpecification &&
                ConnectionSpecification->IsLocal &&
                IsConnectionOpened( ConnectionSpecification ) ) {
            unsigned char i;

            dbg( "WMTP", "WmtpCoreP: Closing connection for connection application %d.\n", ApplicationID );

            if ( ConnectionSpecification->IsConnectionOriented ) {
                WmtpQueueElement_t *queueElement = getNewQueueElement( ConnectionSpecification );

                if ( queueElement != NULL ) {
                    WmtpConnectionLocalPart_t *connectionLocalPart = (WmtpConnectionLocalPart_t *) &(queueElement->ConnectionLocalPart[0]);
                    WmtpConnectionPart_t *curConnectionPart;
                    uint8_t headerDataSize = 0;

                    connectionLocalPart->RouterType = ConnectionSpecification->RouterSpecification.RouterType;

                    // Call MultihopRouter handler.
                    //TODO: if local delivery, connection specification pointer will be changed.
                    dbg( "WMTP", "WmtpCoreP:    Generating routing header (type = %d).\n", connectionLocalPart->RouterType );
                    queueElement->NextHop = AM_BROADCAST_ADDR;
                    if ( call WmtpMultihopRouter.GetNextHop[connectionLocalPart->RouterType]( TOS_NODE_ID, connectionLocalPart->RouterData, &headerDataSize, &(queueElement->NextHop), &ConnectionSpecification ) == SUCCESS ) {
                        dbg( "WMTP", "WmtpCoreP:    Next hop = %d.\n", queueElement->NextHop );
                    } else {
                        dbg( "WMTP", "WmtpCoreP:    Multihop router failed. Packet rejected.\n" );
                        destroyQueueElement( queueElement );
                        return FAIL;
                    }
                    if ( queueElement->NextHop == AM_BROADCAST_ADDR ) {
                        dbg( "WMTP", "WmtpCoreP:    Multihop router didn't specify next hop. Packet rejected.\n" );
                        destroyQueueElement( queueElement );
                        return FAIL;
                    }
                    queueElement->ConnectionLocalPartSize = offsetof( WmtpConnectionLocalPart_t, RouterData ) + headerDataSize;
                    curConnectionPart = (WmtpConnectionPart_t *) (((uint8_t *) &(connectionLocalPart->RouterData[0])) + headerDataSize);
                    queueElement->NumConnectionParts = 0;

                    queueElement->ConnectionParts[queueElement->NumConnectionParts++] = curConnectionPart;
                    curConnectionPart->Type = WMTP_CONNPART_CLOSE;
                    queueElement->ConnectionLocalPartSize += offsetof( WmtpConnectionPart_t, Data );

                    queueElement->ConnectionSpecification = NULL;

                    // Enqueue the data.
                    enqueueData( queueElement );
                }

                if ( ConnectionSpecification->QoSPriority != WMTP_QOSPRIORITY_NONE ) {
                    uint16_t n;

                    dbg( "WMTP", "WmtpCoreP:    Freeing QoS resources.\n" );

                    for ( n = 0; n < 1<<ConnectionSpecification->QoSPriority; n++ ) {
                        if ( isQoSReservationNodeReserved( ConnectionSpecification->QoSPriority, n ) ) {
                            ConnectionSpecification->QoSPriority = WMTP_QOSPRIORITY_NONE;
                            freeQoSReservationNode( ConnectionSpecification->QoSPriority, n );

                            if ( ConnectionSpecification->QoSReservedQueueElement ) {
                                destroyQueueElement( ConnectionSpecification->QoSReservedQueueElement );
                                ConnectionSpecification->QoSReservedQueueElement = NULL;
                            }
                            numQoSReservedQueueElements--;
                        }
                    }
                }

                //LinkedLists_removeElement( &openConnections, &(ConnectionSpecification->element) );
                CloseConnection( ConnectionSpecification );

                // Signal the connection establishment handler.
                signal WmtpConnectionEstablishmentHandler.ConnectionClosed[ConnectionSpecification->PathSpecification.PathType]( ConnectionSpecification );

                // Signal the traffic shapers.
                dbg( "WMTP", "WmtpCoreP:    Signaling traffic shapers.\n" );
                for ( i = 0; i < uniqueCount( "WmtpTrafficShaper" ); i++ )
                    signal WmtpTrafficShaper.ConnectionClosed[i]( ConnectionSpecification );

                // Signal the core monitors.
                dbg( "WMTP", "WmtpCoreP:    Signaling core monitors.\n" );
                signal WmtpCoreMonitor.ConnectionClosed( ConnectionSpecification );

                DestroyConnectionSpecification( ConnectionSpecification );

                return SUCCESS;
            } else {
                dbg( "WMTP", "WmtpCoreP:    Out of queue memory.\n" );
                return FAIL;
            }
        } else {
            dbg( "WMTP", "WmtpCoreP:    Can not close a non-local or unopen connection.\n" );
            return FAIL;
        }
    }


    command error_t WmtpSendMsg.Send[uint8_t ApplicationID]( WmtpConnectionSpecification_t *ConnectionSpecification, uint8_t DataLength, WmtpPayload_t *Data ) {
        //TODO: Check for local delivery.
        WmtpQueueElement_t *queueElement;

        if ( DataLength > WMTP_MAXPAYLOADSIZE ) {
            dbg( "WMTP", "WmtpCoreP:    Data is too large. Application data rejected.\n" );
            return FAIL;
        }

        queueElement = getNewQueueElement( ConnectionSpecification );

        if ( queueElement != NULL ) {
            WmtpConnectionLocalPart_t *connectionLocalPart = (WmtpConnectionLocalPart_t *) &(queueElement->ConnectionLocalPart[0]);
            WmtpConnectionPart_t *curConnectionPart;
            WmtpDataConnectionPart_t *dataConnectionPart;
            uint8_t headerDataSize = 0;
            unsigned char i;

            dbg( "WMTP", "WmtpCoreP: Accepting message from application %d.\n", ApplicationID );

            connectionLocalPart->RouterType = ConnectionSpecification->RouterSpecification.RouterType;

            // Call MultihopRouter handler.
            //TODO: if local delivery, connection specification pointer will be changed.
            dbg( "WMTP", "WmtpCoreP:    Generating routing header (type = %d).\n", connectionLocalPart->RouterType );
            queueElement->NextHop = AM_BROADCAST_ADDR;
            if ( call WmtpMultihopRouter.GetNextHop[connectionLocalPart->RouterType]( TOS_NODE_ID, connectionLocalPart->RouterData, &headerDataSize, &(queueElement->NextHop), &ConnectionSpecification ) == SUCCESS ) {
                dbg( "WMTP", "WmtpCoreP:    Next hop = %d.\n", queueElement->NextHop );
            } else {
                dbg( "WMTP", "WmtpCoreP:    Multihop router failed. Application data rejected.\n" );
                destroyQueueElement( queueElement );
                return FAIL;
            }
            if ( queueElement->NextHop == AM_BROADCAST_ADDR ) {
                dbg( "WMTP", "WmtpCoreP:    Multihop router didn't specify next hop. Application data rejected.\n" );
                destroyQueueElement( queueElement );
                return FAIL;
            }
            queueElement->ConnectionLocalPartSize = offsetof( WmtpConnectionLocalPart_t, RouterData ) + headerDataSize;
            curConnectionPart = (WmtpConnectionPart_t *) (((uint8_t *) &(connectionLocalPart->RouterData[0])) + headerDataSize);
            queueElement->NumConnectionParts = 0;

            if ( ! ConnectionSpecification->IsConnectionOriented ) {
                headerDataSize = 0;
                if ( GenerateConnectionConfiguration( ConnectionSpecification, &(curConnectionPart->Data[0]), &headerDataSize ) == SUCCESS ) {
                    dbg( "WMTP", "WmtpCoreP:    Generated configuration connection part (size = %d).\n", headerDataSize );
                    if ( queueElement->NumConnectionParts >= WMTP_MAXCONNECTIONPARTS ) {
                        dbg( "WMTP", "WmtpCoreP:       Too many connection parts. Application data rejected.\n" );
                        destroyQueueElement( queueElement );
                        return FAIL;
                    }
                    queueElement->ConnectionParts[queueElement->NumConnectionParts++] = curConnectionPart;
                    curConnectionPart->Type = WMTP_CONNPART_CONFIG;
                    queueElement->ConnectionLocalPartSize += offsetof( WmtpConnectionPart_t, Data ) + headerDataSize;
                    curConnectionPart = (WmtpConnectionPart_t *) (((uint8_t *) curConnectionPart) + offsetof( WmtpConnectionPart_t, Data ) + headerDataSize);
                }
            }

            for ( i = 0; i < NUM_CONN_MANAGEMENT_DATA_HANDLERS; i++ ) {
                headerDataSize = 0;
                if ( signal WmtpConnectionManagementDataHandler.GenerateHeader[i]( ConnectionSpecification, queueElement, &(curConnectionPart->Data[0]), &headerDataSize ) == SUCCESS ) {
                    dbg( "WMTP", "WmtpCoreP:    Generated connection part (type = %d, size = %d).\n", i, headerDataSize );
                    if ( queueElement->NumConnectionParts >= WMTP_MAXCONNECTIONPARTS ) {
                        dbg( "WMTP", "WmtpCoreP:       Too many connection parts. Application data rejected.\n" );
                        destroyQueueElement( queueElement );
                        return FAIL;
                    }
                    queueElement->ConnectionParts[queueElement->NumConnectionParts++] = curConnectionPart;
                    curConnectionPart->Type = i;
                    queueElement->ConnectionLocalPartSize += offsetof( WmtpConnectionPart_t, Data ) + headerDataSize;
                    curConnectionPart = (WmtpConnectionPart_t *) (((uint8_t *) curConnectionPart) + offsetof( WmtpConnectionPart_t, Data ) + headerDataSize);
                }
            }

            if ( queueElement->NumConnectionParts >= WMTP_MAXCONNECTIONPARTS ) {
                dbg( "WMTP", "WmtpCoreP:       Too many connection parts. Application data rejected.\n" );
                destroyQueueElement( queueElement );
                return FAIL;
            }
            queueElement->ConnectionParts[queueElement->NumConnectionParts++] = curConnectionPart;
            curConnectionPart->Type = WMTP_CONNPART_DATA;
            queueElement->ConnectionLocalPartSize += offsetof( WmtpConnectionPart_t, Data );

            dataConnectionPart = (WmtpDataConnectionPart_t *) &(curConnectionPart->Data[0]);
            dataConnectionPart->PayloadSize = DataLength;
            memcpy( &(dataConnectionPart->PayloadData[0]), Data, DataLength );
            queueElement->ConnectionLocalPartSize += offsetof( WmtpDataConnectionPart_t, PayloadData ) + dataConnectionPart->PayloadSize;

            // Enqueue the data.
            enqueueData( queueElement );

            // Signal core monitors
            signal WmtpCoreMonitor.GeneratedPacket( queueElement );

            return SUCCESS;
        } else {
            dbg( "WMTP", "WmtpCoreP:    Out of queue memory. Application data rejected.\n" );
            return FAIL;
        }
    }


    command uint8_t WmtpSendMsg.IsClearToSend[uint8_t ApplicationID]( WmtpConnectionSpecification_t *ConnectionSpecification ) {
        return IsConnectionClearToSend( ConnectionSpecification );
    }


    command void *WmtpLocalManagementDataHandler.GenerateHeader[uint8_t HandlerID]( void *HeaderData, uint8_t HeaderDataSize, uint8_t SendNow ) {
        void *oldData = localManagementHeaderData[HandlerID];

        localManagementHeaderData[HandlerID] = HeaderData;
        localManagementHeaderDataSize[HandlerID] = (HeaderData != NULL) ? HeaderDataSize : 0;

        if ( HeaderData && SendNow ) {
            dbg( "WMTP", "WmtpCoreP: Got local management data (type = %d, size = %d) to send ASAP.\n", HandlerID, localManagementHeaderDataSize[HandlerID] );
            currentLocalManagementHeader = HandlerID;

            // Reset local management data timer.
            call LocalManagementDataTimer.stop();
            localManagementDataNextSendTime = call LocalManagementDataTimer.getNow();

            // Post the sending task.
            if ( (! sendTaskPosted) && (! sendingMsg) && (post sendTask() == SUCCESS) )
                sendTaskPosted = TRUE;
        } else {
            if ( HeaderData ) {
                dbg( "WMTP", "WmtpCoreP: Got local management data (type = %d, size = %d).\n", HandlerID, localManagementHeaderDataSize[HandlerID] );
            } else {
                dbg( "WMTP", "WmtpCoreP: Dropped local management data (type = %d).\n", HandlerID );
            }
        }

        return oldData;
    }


    command error_t WmtpConnectionManagementDataHandler.GetHeader[uint8_t HandlerID]( WmtpQueueElement_t *Packet, void **HeaderData ) {
        unsigned char i;

        if ( Packet != NULL ) {
            for ( i = 0; i < Packet->NumConnectionParts; i++ ) {
                if ( Packet->ConnectionParts[i]->Type == HandlerID ) {
                    if ( HeaderData )
                        *HeaderData = &(Packet->ConnectionParts[i]->Data[0]);
                    return SUCCESS;
                }
            }

            return FAIL;
        } else {
            return FAIL;
        }
    }


    command error_t WmtpTrafficShaper.StartPacket[uint8_t HandlerID]( WmtpQueueElement_t *Packet ) {
        if ( Packet != NULL ) {
            dbg( "WMTP", "WmtpCoreP: Starting packet for traffic shaper %d.\n", HandlerID );

            Packet->TrafficShaperState[HandlerID / 8] |= 1<<(HandlerID % 8);

            // Post the sending task.
            if ( (! sendTaskPosted) && (! sendingMsg) && IsPacketClearToSend( Packet ) && (post sendTask() == SUCCESS) )
                sendTaskPosted = TRUE;

            return SUCCESS;
        } else {
            return FAIL;
        }
    }


    command error_t WmtpTrafficShaper.StopPacket[uint8_t HandlerID]( WmtpQueueElement_t *Packet ) {
        if ( Packet != NULL ) {
            dbg( "WMTP", "WmtpCoreP: Stopping packet for traffic shaper %d.\n", HandlerID );

            Packet->TrafficShaperState[HandlerID / 8] &= ~(1<<(HandlerID % 8));

            return SUCCESS;
        } else {
            return FAIL;
        }
    }


    command error_t WmtpTrafficShaper.StartConnection[uint8_t HandlerID]( WmtpConnectionSpecification_t *ConnectionSpecification ) {
        if ( ConnectionSpecification != NULL ) {
            uint8_t wasConnectionClearToSend = FALSE;

            dbg( "WMTP", "WmtpCoreP: Starting connection for traffic shaper %d.\n", HandlerID );

            if ( ConnectionSpecification->IsLocal )
                wasConnectionClearToSend = IsConnectionClearToSend( ConnectionSpecification );

            ConnectionSpecification->TrafficShaperState[HandlerID / 8] |= 1<<(HandlerID % 8);

            if ( ConnectionSpecification->IsLocal &&
                    (! wasConnectionClearToSend) &&
                    IsConnectionClearToSend( ConnectionSpecification ) ) {
                dbg( "WMTP", "WmtpCoreP: Local connection became clear to send. Signaling application %d.\n", ConnectionSpecification->ApplicationID );
                signal WmtpSendMsg.ClearToSend[ConnectionSpecification->ApplicationID]( ConnectionSpecification );
            }

            return SUCCESS;
        } else {
            return FAIL;
        }
    }


    command error_t WmtpTrafficShaper.StopConnection[uint8_t HandlerID]( WmtpConnectionSpecification_t *ConnectionSpecification ) {
        if ( ConnectionSpecification != NULL ) {
            dbg( "WMTP", "WmtpCoreP: Stopping connection for traffic shaper %d.\n", HandlerID );

            ConnectionSpecification->TrafficShaperState[HandlerID / 8] &= ~(1<<(HandlerID % 8));

            return SUCCESS;
        } else {
            return FAIL;
        }
    }


    command error_t WmtpTrafficShaper.GetPacketState[uint8_t HandlerID]( WmtpQueueElement_t *Packet, uint8_t *State ) {
        if ( Packet != NULL ) {
            *State = (Packet->TrafficShaperState[HandlerID / 8] & 1<<(HandlerID % 8)) != 0 ? TRUE : FALSE;

            return SUCCESS;
        } else {
            return FAIL;
        }
    }


    command error_t WmtpTrafficShaper.GetConnectionState[uint8_t HandlerID]( WmtpConnectionSpecification_t *ConnectionSpecification, uint8_t *State ) {
        if ( ConnectionSpecification != NULL ) {
            *State = (ConnectionSpecification->TrafficShaperState[HandlerID / 8] & 1<<(HandlerID % 8)) != 0 ? TRUE : FALSE;

            return SUCCESS;
        } else {
            return FAIL;
        }
    }


    command error_t WmtpReliableTransmissionHook.DropPacket[uint8_t HandlerID]( WmtpQueueElement_t *Packet ) {
        if ( Packet != NULL &&
                Packet->ConnectionSpecification != NULL &&
                Packet->ConnectionSpecification->FeatureSpecification.ReliabilityHandlerID == HandlerID ) {
            unsigned char i;

            dbg( "WMTP", "WmtpCoreP: Dropping packet from queue for reliability module %d.\n", HandlerID );

            // Remove the data from the queue.
            //LinkedLists_removeElement( &coreQueue, &(Packet->element) );
            RemoveFromQueue( Packet );
            destroyQueueElement( Packet );

            // Signal traffic shapers.
            dbg( "WMTP", "WmtpCoreP:    Signaling traffic shapers.\n" );
            for ( i = 0; i < uniqueCount( "WmtpTrafficShaper" ); i++ )
                signal WmtpTrafficShaper.DroppingPacket[i]( Packet );
            // Signal core monitors.
            dbg( "WMTP", "WmtpCoreP:    Signaling core monitors.\n" );
            signal WmtpCoreMonitor.DroppingPacket( Packet );

            return SUCCESS;
        } else {
            return FAIL;
        }
    }


    command WmtpPacketScratchPad_t *WmtpPacketScratchPadHook.GetPacketScratchPad[uint8_t HandlerID]( WmtpQueueElement_t *Packet ) {
        return &(Packet->ScratchPad[HandlerID]);
    }


    command WmtpConnectionScratchPad_t *WmtpConnectionScratchPadHook.GetConnectionScratchPad[uint8_t HandlerID]( WmtpConnectionSpecification_t *ConnectionSpecification ) {
        return &(ConnectionSpecification->ScratchPad[HandlerID]);
    }


    command error_t WmtpConnectionEstablishmentHandler.GenerateServiceSpecificationData[uint8_t HandlerID]( WmtpServiceSpecification_t *ServiceSpecification, void *Data, uint8_t *DataSize ) {
        WmtpServiceSpecificationData_t *ServiceSpecificationData = Data;

        dbg( "WMTP", "WmtpCoreP: Generating service specification data for connection establishment handler %d (type = %d).\n", HandlerID, ServiceSpecification->ServiceType );

        if ( call WmtpServiceSpecificationDataHandler.GenerateServiceSpecificationData[ServiceSpecification->ServiceType]( ServiceSpecification, &(ServiceSpecificationData->Data[0]), DataSize ) == SUCCESS ) {
            dbg( "WMTP", "WmtpCoreP:    Service specification data successfuly generated (size = %d).\n", *DataSize );

            ServiceSpecificationData->Type = ServiceSpecification->ServiceType;
            *DataSize += offsetof( WmtpServiceSpecificationData_t, Data );

            return SUCCESS;
        } else {
            dbg( "WMTP", "WmtpCoreP:    Service specification data handler failed.\n", HandlerID );

            return FAIL;
        }
    }


    command error_t WmtpConnectionEstablishmentHandler.CheckServiceMatch[uint8_t HandlerID]( WmtpServiceSpecification_t *LocalService, uint8_t ConnectionOriented, void *RemoteData, uint8_t *RemoteDataSize, uint8_t *Match ) {
        WmtpServiceSpecificationData_t *ServiceSpecificationData = RemoteData;

        if ( LocalService->ServiceType == ServiceSpecificationData->Type ) {
            dbg( "WMTP", "WmtpCoreP: Matching service specification data for connection establishment handler %d (type = %d).\n", HandlerID, LocalService->ServiceType );

            if ( call WmtpServiceSpecificationDataHandler.CheckServiceMatch[ServiceSpecificationData->Type]( LocalService, &(ServiceSpecificationData->Data[0]), RemoteDataSize, Match ) == SUCCESS ) {
                *RemoteDataSize += offsetof( WmtpServiceSpecificationData_t, Data );

                if ( ! (((ConnectionOriented && LocalService->ConnectionOriented) ||
                         ((! ConnectionOriented) && LocalService->Connectionless))) )
                    *Match = FALSE;

                if ( *Match ) {
                    dbg( "WMTP", "WmtpCoreP: Services match.\n" );
                } else {
                    dbg( "WMTP", "WmtpCoreP: Services don't match.\n" );
                }

                return SUCCESS;
            } else {
                dbg( "WMTP", "WmtpCoreP: Service specification data handler failed.\n" );

                return FAIL;
            }
        } else {
            dbg( "WMTP", "WmtpCoreP: Service specification data doesn't match due to differing types. Calculating data size for connection establishment handler %d (type = %d).\n", HandlerID, ServiceSpecificationData->Type );

            if ( call WmtpServiceSpecificationDataHandler.GetServiceDataSize[ServiceSpecificationData->Type]( &(ServiceSpecificationData->Data[0]), RemoteDataSize ) == SUCCESS ) {
                *RemoteDataSize += offsetof( WmtpServiceSpecificationData_t, Data );

                *Match = FALSE;

                return SUCCESS;
            } else {
                dbg( "WMTP", "WmtpCoreP: Service specification data handler failed.\n" );

                return FAIL;
            }
        }
    }


    command error_t WmtpConnectionEstablishmentHandler.GetServiceDataSize[uint8_t HandlerID]( void *Data, uint8_t *DataSize ) {
        WmtpServiceSpecificationData_t *ServiceSpecificationData = Data;

        dbg( "WMTP", "WmtpCoreP: Calculating service specification data size for connection establishment handler %d (type = %d).\n", HandlerID, ServiceSpecificationData->Type );

        if ( call WmtpServiceSpecificationDataHandler.GetServiceDataSize[ServiceSpecificationData->Type]( &(ServiceSpecificationData->Data[0]), DataSize ) == SUCCESS ) {
            *DataSize += offsetof( WmtpServiceSpecificationData_t, Data );

            dbg( "WMTP", "WmtpCoreP: Done (size = %d).\n", *DataSize );

            return SUCCESS;
        } else {
            dbg( "WMTP", "WmtpCoreP: Service specification data handler failed.\n" );

            return FAIL;
        }
    }


    command error_t WmtpConnectionEstablishmentHandler.GetMatchingService[uint8_t HandlerID]( uint8_t ConnectionOriented, void *RemoteData, uint8_t *RemoteDataSize, WmtpServiceSpecification_t **LocalService ) {
        WmtpServiceSpecification_t *i;
        uint8_t Match;
        uint8_t e = 0;

        dbg( "WMTP", "WmtpCoreP: Searching for a matching service for connection establishment handler %d.\n", HandlerID );

        // Get registered services.

        // Check if there were any registered services.
        if ( ! call RegisteredServicesQueue.empty() ) {
            // Iterate through all services.
            do {
                i = call RegisteredServicesQueue.element( e++ );
                // Check if we found a matching service.
                if ( call WmtpConnectionEstablishmentHandler.CheckServiceMatch[HandlerID]( i, ConnectionOriented, RemoteData, RemoteDataSize, &Match ) == SUCCESS &&
                        Match ) {
                    *LocalService = i;

                    return SUCCESS;
                }

            } while ( e < call RegisteredServicesQueue.size() );
        }

        dbg( "WMTP", "WmtpCoreP: No matches found.\n" );

        return FAIL;
    }


    command error_t WmtpConnectionEstablishmentHandler.GetNewConnectionSpecification[uint8_t HandlerID]( WmtpConnectionSpecification_t **ConnectionSpecification ) {
        return GetNewConnectionSpecification( ConnectionSpecification );
    }


    command error_t WmtpConnectionEstablishmentHandler.DestroyConnectionSpecification[uint8_t HandlerID]( WmtpConnectionSpecification_t *ConnectionSpecification ) {
        return DestroyConnectionSpecification( ConnectionSpecification );
    }


    command error_t WmtpConnectionEstablishmentHandler.GenerateConnectionConfiguration[uint8_t HandlerID]( WmtpConnectionSpecification_t *ConnectionSpecification, void *ConfigurationData, uint8_t *ConfigurationDataSize ) {
        return GenerateConnectionConfiguration( ConnectionSpecification, ConfigurationData, ConfigurationDataSize );
    }


    command error_t WmtpConnectionEstablishmentHandler.ConfigureConnection[uint8_t HandlerID]( void *ConfigurationData, uint8_t *ConfigurationDataSize, WmtpConnectionSpecification_t *ConnectionSpecification ) {
        return ConfigureConnection( ConfigurationData, ConfigurationDataSize, ConnectionSpecification );
    }


    command error_t WmtpConnectionEstablishmentHandler.GetConfigurationSize[uint8_t HandlerID]( void *ConfigurationData, uint8_t *ConfigurationDataSize ) {
        WmtpConfigurationPart_t *curConfigurationPart = ConfigurationData;

        dbg( "WMTP", "WmtpCoreP: Calculating configuration data size for connection establishment handler %d.\n", HandlerID );

        // Iterate through configuration parts.
        while ( curConfigurationPart->Type != WMTP_CONFPART_LAST ) {
            uint8_t partDataSize = 0;

            dbg( "WMTP", "WmtpCoreP:    Found configuration part (type = %d). Signaling handler.\n", curConfigurationPart->Type );
            if ( call WmtpFeatureConfigurationHandler.GetConfigurationDataSize[curConfigurationPart->Type]( &(curConfigurationPart->Data[0]), &partDataSize ) != SUCCESS ) {
                dbg( "WMTP", "WmtpCoreP:    Feature configuration handler failed.\n" );
                return FAIL;
            } else {
                dbg( "WMTP", "WmtpCoreP:    Feature configuration data succesfully handled (size = %d).\n", partDataSize );
            }

            // Calculate the beginning of the next connection part from the size of the header.
            curConfigurationPart = (WmtpConfigurationPart_t *) (((uint8_t *) curConfigurationPart) +
                                   offsetof( WmtpConfigurationPart_t, Data ) + partDataSize);
        }

        *ConfigurationDataSize = (((uint8_t *) curConfigurationPart) - ((uint8_t *) ConfigurationData)) +
                                 offsetof( WmtpConfigurationPart_t, Data );

        dbg( "WMTP", "WmtpCoreP: Completed successfuly (total size = %d).\n", *ConfigurationDataSize );

        return SUCCESS;
    }


    command error_t WmtpConnectionEstablishmentHandler.AddLocalConnection[uint8_t HandlerID]( WmtpConnectionSpecification_t *ConnectionSpecification ) {
        if ( ConnectionSpecification != NULL ) {
            unsigned char i;

            ConnectionSpecification->IsLocal = TRUE;

            if ( ConnectionSpecification->QoSPriority != WMTP_QOSPRIORITY_NONE ) {
                //LinkedLists_removeElement( &reservedQoSConnections, &(ConnectionSpecification->element) );
                UnreserveQoSConnection( ConnectionSpecification );
            }

            //LinkedLists_insertElementBeginning( &openConnections, &(ConnectionSpecification->element) );
            call OpenConnectionsQueue.enqueue( ConnectionSpecification );

            dbg( "WMTP", "WmtpCoreP: Local connection opened.\n" );

            // Signal the traffic shapers.
            dbg( "WMTP", "WmtpCoreP:    Signaling traffic shapers.\n" );
            for ( i = 0; i < uniqueCount( "WmtpTrafficShaper" ); i++ )
                signal WmtpTrafficShaper.ConnectionOpened[i]( ConnectionSpecification );

            // Signal the core monitors.
            dbg( "WMTP", "WmtpCoreP:    Signaling core monitors.\n" );
            signal WmtpCoreMonitor.ConnectionOpened( ConnectionSpecification );

            // Signal the application.
            dbg( "WMTP", "WmtpCoreP:    Signaling application %d.\n", ConnectionSpecification->ApplicationID );
            signal WmtpConnectionManager.ConnectionOpened[ConnectionSpecification->ApplicationID]( ConnectionSpecification );
            return SUCCESS;
        } else {
            return FAIL;
        }
    }


    command error_t WmtpConnectionEstablishmentHandler.AddNonLocalConnection[uint8_t HandlerID]( WmtpConnectionSpecification_t *ConnectionSpecification ) {
        if ( ConnectionSpecification != NULL ) {
            unsigned char i;

            ConnectionSpecification->IsLocal = FALSE;

            if ( ConnectionSpecification->QoSPriority != WMTP_QOSPRIORITY_NONE ) {
                //LinkedLists_removeElement( &reservedQoSConnections, &(ConnectionSpecification->element) );
                UnreserveQoSConnection( ConnectionSpecification );
            }

            //LinkedLists_insertElementBeginning( &openConnections, &(ConnectionSpecification->element) );
            call OpenConnectionsQueue.enqueue( ConnectionSpecification );

            dbg( "WMTP", "WmtpCoreP: Non-local connection added.\n" );

            // Signal the traffic shapers.
            dbg( "WMTP", "WmtpCoreP:    Signaling traffic shapers.\n" );
            for ( i = 0; i < uniqueCount( "WmtpTrafficShaper" ); i++ )
                signal WmtpTrafficShaper.ConnectionOpened[i]( ConnectionSpecification );

            // Signal the core monitors.
            dbg( "WMTP", "WmtpCoreP:    Signaling core monitors.\n" );
            signal WmtpCoreMonitor.ConnectionOpened( ConnectionSpecification );

            return SUCCESS;
        } else {
            return FAIL;
        }
    }


    command error_t WmtpConnectionEstablishmentHandler.CloseConnection[uint8_t HandlerID]( WmtpConnectionSpecification_t *ConnectionSpecification ) {
        if ( ConnectionSpecification != NULL ) {
            unsigned char i;

            dbg( "WMTP", "WmtpCoreP: Closing connection for connection establishment handler %d.\n", HandlerID );

            if ( ConnectionSpecification->QoSPriority != WMTP_QOSPRIORITY_NONE ) {
                uint16_t n;

                dbg( "WMTP", "WmtpCoreP:    Freeing QoS resources.\n" );

                for ( n = 0; n < 1<<ConnectionSpecification->QoSPriority; n++ ) {
                    if ( isQoSReservationNodeReserved( ConnectionSpecification->QoSPriority, n ) ) {
                        ConnectionSpecification->QoSPriority = WMTP_QOSPRIORITY_NONE;
                        freeQoSReservationNode( ConnectionSpecification->QoSPriority, n );

                        if ( ConnectionSpecification->QoSReservedQueueElement ) {
                            destroyQueueElement( ConnectionSpecification->QoSReservedQueueElement );
                            ConnectionSpecification->QoSReservedQueueElement = NULL;
                        }
                        numQoSReservedQueueElements--;
                    }
                }
            }

            //LinkedLists_removeElement( &openConnections, &(ConnectionSpecification->element) );
            CloseConnection( ConnectionSpecification );

            // Signal the traffic shapers.
            dbg( "WMTP", "WmtpCoreP:    Signaling traffic shapers.\n" );
            for ( i = 0; i < uniqueCount( "WmtpTrafficShaper" ); i++ )
                signal WmtpTrafficShaper.ConnectionClosed[i]( ConnectionSpecification );

            // Signal the core monitors.
            dbg( "WMTP", "WmtpCoreP:    Signaling core monitors.\n" );
            signal WmtpCoreMonitor.ConnectionClosed( ConnectionSpecification );

            if ( ConnectionSpecification->IsLocal ) {
                // Signal the application.
                dbg( "WMTP", "WmtpCoreP:    Signaling application %d.\n", ConnectionSpecification->ApplicationID );
                signal WmtpConnectionManager.ConnectionClosed[ConnectionSpecification->ApplicationID]( ConnectionSpecification );
            }

            DestroyConnectionSpecification( ConnectionSpecification );

            return SUCCESS;
        } else {
            return FAIL;
        }
    }


    command error_t WmtpConnectionEstablishmentHandler.SendKeepAlive[uint8_t HandlerID]( WmtpConnectionSpecification_t *ConnectionSpecification ) {
        // Check if the connection is local.
        if ( ConnectionSpecification->IsLocal ) {
            //TODO: Check for local delivery.
            WmtpQueueElement_t *queueElement = getNewQueueElement( ConnectionSpecification );
            if ( queueElement != NULL ) {
                WmtpConnectionLocalPart_t *connectionLocalPart = (WmtpConnectionLocalPart_t *) &(queueElement->ConnectionLocalPart[0]);
                WmtpConnectionPart_t *curConnectionPart;
                uint8_t headerDataSize = 0;
                unsigned char i;

                dbg( "WMTP", "WmtpCoreP: Generating keep-alive message for connection establishment handler %d.\n", HandlerID );

                connectionLocalPart->RouterType = ConnectionSpecification->RouterSpecification.RouterType;

                // Call MultihopRouter handler.
                //TODO: if local delivery, connection specification pointer will be changed.
                dbg( "WMTP", "WmtpCoreP:    Generating routing header (type = %d).\n", connectionLocalPart->RouterType );
                queueElement->NextHop = AM_BROADCAST_ADDR;
                if ( call WmtpMultihopRouter.GetNextHop[connectionLocalPart->RouterType]( TOS_NODE_ID, connectionLocalPart->RouterData, &headerDataSize, &(queueElement->NextHop), &ConnectionSpecification ) == SUCCESS ) {
                    dbg( "WMTP", "WmtpCoreP:    Next hop = %d.\n", queueElement->NextHop );
                } else {
                    dbg( "WMTP", "WmtpCoreP:    Multihop router failed. Keep-alive rejected.\n" );
                    destroyQueueElement( queueElement );
                    return FAIL;
                }
                if ( queueElement->NextHop == AM_BROADCAST_ADDR ) {
                    dbg( "WMTP", "WmtpCoreP:    Multihop router didn't specify next hop. Keep-alive rejected.\n" );
                    destroyQueueElement( queueElement );
                    return FAIL;
                }
                queueElement->ConnectionLocalPartSize = offsetof( WmtpConnectionLocalPart_t, RouterData ) + headerDataSize;
                curConnectionPart = (WmtpConnectionPart_t *) (((uint8_t *) &(connectionLocalPart->RouterData[0])) + headerDataSize);
                queueElement->NumConnectionParts = 0;

                if ( ! ConnectionSpecification->IsConnectionOriented ) {
                    headerDataSize = 0;
                    if ( GenerateConnectionConfiguration( ConnectionSpecification, &(curConnectionPart->Data[0]), &headerDataSize ) == SUCCESS ) {
                        dbg( "WMTP", "WmtpCoreP:    Generated configuration connection part (size = %d).\n", headerDataSize );
                        if ( queueElement->NumConnectionParts >= WMTP_MAXCONNECTIONPARTS ) {
                            dbg( "WMTP", "WmtpCoreP:       Too many connection parts. Keep-alive rejected.\n" );
                            destroyQueueElement( queueElement );
                            return FAIL;
                        }
                        queueElement->ConnectionParts[queueElement->NumConnectionParts++] = curConnectionPart;
                        curConnectionPart->Type = WMTP_CONNPART_CONFIG;
                        queueElement->ConnectionLocalPartSize += offsetof( WmtpConnectionPart_t, Data ) + headerDataSize;
                        curConnectionPart = (WmtpConnectionPart_t *) (((uint8_t *) curConnectionPart) + offsetof( WmtpConnectionPart_t, Data ) + headerDataSize);
                    }
                }

                for ( i = 0; i < NUM_CONN_MANAGEMENT_DATA_HANDLERS; i++ ) {
                    headerDataSize = 0;
                    if ( signal WmtpConnectionManagementDataHandler.GenerateHeader[i]( ConnectionSpecification, queueElement, &(curConnectionPart->Data[0]), &headerDataSize ) == SUCCESS ) {
                        dbg( "WMTP", "WmtpCoreP:    Generated connection part (type = %d, size = %d).\n", i, headerDataSize );
                        if ( queueElement->NumConnectionParts >= WMTP_MAXCONNECTIONPARTS ) {
                            dbg( "WMTP", "WmtpCoreP:       Too many connection parts. Keep-alive rejected.\n" );
                            destroyQueueElement( queueElement );
                            return FAIL;
                        }
                        queueElement->ConnectionParts[queueElement->NumConnectionParts++] = curConnectionPart;
                        curConnectionPart->Type = i;
                        queueElement->ConnectionLocalPartSize += offsetof( WmtpConnectionPart_t, Data ) + headerDataSize;
                        curConnectionPart = (WmtpConnectionPart_t *) (((uint8_t *) curConnectionPart) + offsetof( WmtpConnectionPart_t, Data ) + headerDataSize);
                    }
                }

                if ( queueElement->NumConnectionParts >= WMTP_MAXCONNECTIONPARTS ) {
                    dbg( "WMTP", "WmtpCoreP:       Too many connection parts. Keep-alive rejected.\n" );
                    destroyQueueElement( queueElement );
                    return FAIL;
                }
                queueElement->ConnectionParts[queueElement->NumConnectionParts++] = curConnectionPart;
                curConnectionPart->Type = WMTP_CONNPART_LAST;
                queueElement->ConnectionLocalPartSize += offsetof( WmtpConnectionPart_t, Data );

                // Enqueue the data.
                enqueueData( queueElement );

                // Signal core monitors
                signal WmtpCoreMonitor.GeneratedPacket( queueElement );

                return SUCCESS;
            } else {
                dbg( "WMTP", "WmtpCoreP:    Out of queue memory. Keep-alive rejected.\n" );
                return FAIL;
            }
        } else {
            dbg( "WMTP", "WmtpCoreP:    Can not send a keep-alive on a non-local connection.\n" );
            return FAIL;
        }
    }


    command error_t WmtpConnectionEstablishmentHandler.GetQoSShortestDelay[uint8_t HandlerID]( uint16_t MinDelay, uint16_t *CalculatedDelay ) {
        uint8_t level;
        uint16_t n, maxSendDelay = call WmtpLinkLayerQoSIndicator.GetMaxSendDelay();

        dbg( "WMTP", "WmtpCoreP: Calculating QoS shortest delay for connection establishment handler %d (Max Send Delay = %d).\n", HandlerID, maxSendDelay );

        if ( maxSendDelay == 0 )
            return FAIL;

        if ( MinDelay >= 2 * maxSendDelay ) {
            for ( level = 0; level <= QOS_RESERVATION_TREE_MAX_DEPTH; level++ )
                if ( ((1<<level) + 1) * maxSendDelay <= MinDelay && ((1<<(level + 1)) + 1) * maxSendDelay > MinDelay )
                    break;

            if ( level < QOS_RESERVATION_TREE_SHORTEST_DELAY_MIN_DEPTH ) {
                dbg( "WMTP",
                     "WmtpCoreP: The requested minimum delay of %d maps into a level of %d but policy dictates a level of %d.\n",
                     MinDelay, level, QOS_RESERVATION_TREE_SHORTEST_DELAY_MIN_DEPTH );
                level = QOS_RESERVATION_TREE_SHORTEST_DELAY_MIN_DEPTH;
            } else if ( level > QOS_RESERVATION_TREE_MAX_DEPTH ) {
                dbg( "WMTP",
                     "WmtpCoreP: The requested minimum delay of %d is too large, going with the maximum level of %d.\n",
                     MinDelay, QOS_RESERVATION_TREE_MAX_DEPTH );
                level = QOS_RESERVATION_TREE_MAX_DEPTH;
            } else {
                dbg( "WMTP", "WmtpCoreP: The requested minimum delay of %d maps into a level of %d.\n", MinDelay, level );
            }
        } else {
            level = QOS_RESERVATION_TREE_SHORTEST_DELAY_MIN_DEPTH;
            dbg( "WMTP", "WmtpCoreP: The requested minimum delay of %d is unattainable. Policy dictates a level of %d.\n", MinDelay, level );
        }

        for ( ; level <= QOS_RESERVATION_TREE_MAX_DEPTH; level++ ) {
            for ( n = 0; n < 1<<level; n++ ) {
                if ( isQoSReservationNodeFree( level, n ) ) {
                    *CalculatedDelay = ((1<<level) + 1) * maxSendDelay;

                    dbg( "WMTP", "WmtpCoreP: Shortest available delay is at level %d (delay = %d).\n", level, *CalculatedDelay );

                    return SUCCESS;
                }
            }
        }

        dbg( "WMTP", "WmtpCoreP: No available slots left.\n" );

        return FAIL;
    }


    command error_t WmtpConnectionEstablishmentHandler.ReserveQoSResources[uint8_t HandlerID]( WmtpConnectionSpecification_t *ConnectionSpecification, uint16_t Delay ) {
        uint8_t level;
        uint16_t n, maxSendDelay = call WmtpLinkLayerQoSIndicator.GetMaxSendDelay();

        dbg( "WMTP", "WmtpCoreP: Reserving QoS resources for connection establishment handler %d (Max Send Delay = %d).\n", HandlerID, maxSendDelay );

        if ( maxSendDelay == 0 || Delay < 2 * maxSendDelay || numQoSReservedQueueElements >= NUM_QUEUE_ELEMENTS )
            return FAIL;

        for ( level = 0; level <= QOS_RESERVATION_TREE_MAX_DEPTH; level++ )
            if ( ((1<<level) + 1) * maxSendDelay <= Delay && ((1<<(level + 1)) + 1) * maxSendDelay > Delay )
                break;

        dbg( "WMTP", "WmtpCoreP: The requested delay of %d maps into a level of %d.\n", Delay, level );

        if ( level > QOS_RESERVATION_TREE_MAX_DEPTH )
            return FAIL;

        for ( n = 0; n < 1<<level; n++ ) {
            if ( isQoSReservationNodeFree( level, n ) ) {
                ConnectionSpecification->QoSPriority = level;
                reserveQoSReservationNode( level, n );

                dbg( "WMTP", "WmtpCoreP: Made a reservation at level %d, slot %d.\n", level, n );

                ConnectionSpecification->QoSReservedQueueElement = getNewQueueElement( NULL );
                numQoSReservedQueueElements++;

                //LinkedLists_insertElementBeginning( &reservedQoSConnections, &(ConnectionSpecification->element) );
                call ReservedQoSConnectionsQueue.enqueue( ConnectionSpecification );

                return SUCCESS;
            }
        }

        dbg( "WMTP", "WmtpCoreP: No available slots left.\n" );

        return FAIL;
    }


    command error_t WmtpConnectionEstablishmentHandler.FreeQoSResources[uint8_t HandlerID]( WmtpConnectionSpecification_t *ConnectionSpecification ) {
        uint16_t n;

        if ( ConnectionSpecification->QoSPriority == WMTP_QOSPRIORITY_NONE )
            return FAIL;

        dbg( "WMTP", "WmtpCoreP: Freeing QoS resources for connection establishment handler %d.\n", HandlerID );

        for ( n = 0; n < 1<<ConnectionSpecification->QoSPriority; n++ ) {
            if ( isQoSReservationNodeReserved( ConnectionSpecification->QoSPriority, n ) ) {
                ConnectionSpecification->QoSPriority = WMTP_QOSPRIORITY_NONE;
                freeQoSReservationNode( ConnectionSpecification->QoSPriority, n );

                if ( ConnectionSpecification->QoSReservedQueueElement ) {
                    destroyQueueElement( ConnectionSpecification->QoSReservedQueueElement );
                    ConnectionSpecification->QoSReservedQueueElement = NULL;
                }
                numQoSReservedQueueElements--;

                //LinkedLists_removeElement( &reservedQoSConnections, &(ConnectionSpecification->element) );
                UnreserveQoSConnection( ConnectionSpecification );

                return SUCCESS;
            }
        }

        dbg( "WMTP", "WmtpCoreP: Matching slot not found.\n" );

        return FAIL;
    }


    command uint8_t WmtpCoreMonitor.GetCoreQueueMaxSize() {
        return (call CoreQueue.maxSize() - numQoSReservedQueueElements);
    }


    command uint8_t WmtpCoreMonitor.GetCoreQueueAvailability() {
        return (call CoreQueue.maxSize() - call CoreQueue.size());
    }


default command error_t WmtpFeatureConfigurationHandler.InitializeConfiguration[uint8_t HandlerID]( WmtpConnectionSpecification_t *ConnectionSpecification ) {
        return FAIL;
    }
default command error_t WmtpFeatureConfigurationHandler.GenerateConfigurationData[uint8_t HandlerID]( WmtpConnectionSpecification_t *ConnectionSpecification, void *ConfigurationData, uint8_t *ConfigurationDataSize ) {
        return FAIL;
    }
default command error_t WmtpFeatureConfigurationHandler.HandleConfigurationData[uint8_t HandlerID]( void *ConfigurationData, uint8_t *ConfigurationDataSize, WmtpConnectionSpecification_t *ConnectionSpecification ) {
        return FAIL;
    }
default command error_t WmtpFeatureConfigurationHandler.GetConfigurationDataSize[uint8_t HandlerID]( void *ConfigurationData, uint8_t *ConfigurationDataSize ) {
        return FAIL;
    }
default command error_t WmtpServiceSpecificationDataHandler.CheckServiceMatch[uint8_t HandlerID]( WmtpServiceSpecification_t *LocalService, void *RemoteData, uint8_t *RemoteDataSize, uint8_t *Match ) {
        return FAIL;
    }
default command error_t WmtpServiceSpecificationDataHandler.GetServiceDataSize[uint8_t HandlerID]( void *Data, uint8_t *DataSize ) {
        return FAIL;
    }
default command error_t WmtpServiceSpecificationDataHandler.GenerateServiceSpecificationData[uint8_t HandlerID]( WmtpServiceSpecification_t *ServiceSpecification, void *Data, uint8_t *DataSize ) {
        return FAIL;
    }
default command error_t WmtpMultihopRouter.GetNextHop[uint8_t HandlerID]( uint16_t SourceAdress, void *RoutingData, uint8_t *RoutingDataSize, uint16_t *Address, WmtpConnectionSpecification_t **ConnectionSpecification ) {
        return FAIL;
    }
default event error_t WmtpConnectionManager.ConnectionOpened[uint8_t ApplicationID]( WmtpConnectionSpecification_t *ConnectionSpecification ) {
        return FAIL;
    }
default event error_t WmtpConnectionManager.ConnectionReconfigured[uint8_t ApplicationID]( WmtpConnectionSpecification_t *ConnectionSpecification ) {
        return FAIL;
    }
default event error_t WmtpConnectionManager.ConnectionClosed[uint8_t ApplicationID]( WmtpConnectionSpecification_t *ConnectionSpecification ) {
        return FAIL;
    }
default event error_t WmtpSendMsg.ClearToSend[uint8_t ApplicationID]( WmtpConnectionSpecification_t *ConnectionSpecification ) {
        return FALSE;
    }
default event WmtpPayload_t *WmtpReceiveMsg.Receive[uint8_t ApplicationID]( WmtpConnectionSpecification_t *ConnectionSpecification, uint8_t DataLength, WmtpPayload_t *Data ) {
        return Data;
    }
default event error_t WmtpConnectionEstablishmentHandler.OpenConnection[uint8_t HandlerID]( WmtpConnectionSpecification_t *ConnectionSpecification ) {
        return FAIL;
    }
default event error_t WmtpConnectionEstablishmentHandler.ConnectionClosed[uint8_t HandlerID]( WmtpConnectionSpecification_t *ConnectionSpecification ) {
        return FAIL;
    }
default event error_t WmtpTrafficShaper.NewPacket[uint8_t HandlerID]( WmtpQueueElement_t *Packet ) {
        return FAIL;
    }
default event error_t WmtpTrafficShaper.SendingPacket[uint8_t HandlerID]( WmtpQueueElement_t *Packet ) {
        return FAIL;
    }
default event error_t WmtpTrafficShaper.DroppingPacket[uint8_t HandlerID]( WmtpQueueElement_t *Packet ) {
        return FAIL;
    }
default event error_t WmtpTrafficShaper.ConnectionOpened[uint8_t HandlerID]( WmtpConnectionSpecification_t *ConnectionSpecification ) {
        return FAIL;
    }
default event error_t WmtpTrafficShaper.ConnectionClosed[uint8_t HandlerID]( WmtpConnectionSpecification_t *ConnectionSpecification ) {
        return FAIL;
    }
default event error_t WmtpTrafficShaper.ConnectionReconfigured[uint8_t HandlerID]( WmtpConnectionSpecification_t *ConnectionSpecification ) {
        return FAIL;
    }
default event error_t WmtpReliableTransmissionHook.SendingPacket[uint8_t HandlerID]( WmtpQueueElement_t *Packet, uint8_t *DropPacket ) {
        return FAIL;
    }
default event error_t WmtpReliableTransmissionHook.DeliveringPacket[uint8_t HandlerID]( WmtpQueueElement_t *Packet, uint8_t *DropPacket ) {
        return FAIL;
    }
default event error_t WmtpReliableTransmissionHook.PacketUnroutable[uint8_t HandlerID]( WmtpQueueElement_t *Packet, uint8_t *DropPacket ) {
        return FAIL;
    }
default event uint8_t WmtpReliableTransmissionHook.IsPacketRepeated[uint8_t HandlerID]( WmtpQueueElement_t *Packet ) {
        return FALSE;
    }
default event error_t WmtpLocalManagementDataHandler.HeaderBroadcasted[uint8_t HandlerID]() {
        return FAIL;
    }
default event error_t WmtpLocalManagementDataHandler.HandleHeader[uint8_t HandlerID]( uint16_t SourceAddress, void *HeaderData, uint8_t *HeaderDataSize ) {
        return FAIL;
    }
default event error_t WmtpConnectionManagementDataHandler.GenerateHeader[uint8_t HandlerID]( WmtpConnectionSpecification_t *ConnectionSpecification, WmtpQueueElement_t *Packet, void *HeaderData, uint8_t *HeaderDataSize ) {
        return FAIL;
    }
default event error_t WmtpConnectionManagementDataHandler.HandleHeader[uint8_t HandlerID]( uint16_t PreviousHop, WmtpConnectionSpecification_t *ConnectionSpecification, WmtpQueueElement_t *Packet, void *HeaderData, uint8_t *HeaderDataSize ) {
        return FAIL;
    }
default command uint16_t WmtpLinkLayerQoSIndicator.GetMaxSendDelay() {
        return 0;
    }
default event error_t WmtpCoreMonitor.ServiceRegistered( WmtpServiceSpecification_t *ServiceSpecification ) {
        return SUCCESS;
    }
default event error_t WmtpCoreMonitor.ServiceCanceled( WmtpServiceSpecification_t *ServiceSpecification ) {
        return SUCCESS;
    }
default event error_t WmtpCoreMonitor.ConnectionOpened( WmtpConnectionSpecification_t *ConnectionSpecification ) {
        return SUCCESS;
    }
default event error_t WmtpCoreMonitor.ConnectionClosed( WmtpConnectionSpecification_t *ConnectionSpecification ) {
        return SUCCESS;
    }
default event error_t WmtpCoreMonitor.GeneratedPacket( WmtpQueueElement_t *Packet ) {
        return SUCCESS;
    }
default event error_t WmtpCoreMonitor.ReceivedPacket( WmtpQueueElement_t *Packet ) {
        return SUCCESS;
    }
default event error_t WmtpCoreMonitor.DeliveringPacket( WmtpQueueElement_t *Packet ) {
        return SUCCESS;
    }
default event error_t WmtpCoreMonitor.SendingPacket( WmtpQueueElement_t *Packet ) {
        return SUCCESS;
    }
default event error_t WmtpCoreMonitor.DroppingPacket( WmtpQueueElement_t *Packet ) {
        return SUCCESS;
    }
default event error_t WmtpCoreMonitor.ReceivedWmtpMsg() {
        return SUCCESS;
    }
default event error_t WmtpCoreMonitor.SendingWmtpMsg() {
        return SUCCESS;
    }
default event error_t WmtpCoreMonitor.SentWmtpMsg() {
        return SUCCESS;
    }
}
