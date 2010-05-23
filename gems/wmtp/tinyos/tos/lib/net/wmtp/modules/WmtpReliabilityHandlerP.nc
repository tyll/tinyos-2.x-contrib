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
 * WMTP Reliability handler.
 *
 * This component implements the WMTP reliability feature. This features uses
 * the reliable transmission hook to retransmit lost packets for connection
 * oriented and connection-less data alike.
 *
 * @author Luis D. Pedrosa <luis.pedrosa@tagus.ist.utl.pt>
 * @author Hugo Freire <hugo.freire@ist.utl.pt> (port to TinyOS 2.x)
**/

#include "Wmtp.h"

//#define FAST_RETRANSMIT
#define PACKET_RETRANSMIT_TIMEOUT 1024
#define MAX_PACKET_TRANSMITS 100
#define LOCAL_PART_MAX_PACKETS 3

module WmtpReliabilityHandlerP {
    provides {
        interface Init;
        interface StdControl;
        interface WmtpFeatureConfigurationHandler;
    }
    uses {
        interface WmtpLocalManagementDataHandler;
        interface WmtpConnectionManagementDataHandler;
        interface WmtpTrafficShaper;
        interface WmtpReliableTransmissionHook;
        interface WmtpPacketScratchPadHook;
        //interface Time;
        //interface TimeUtil;
        //interface AbsoluteTimer;
        interface Timer<TMilli>;

        interface Queue<WmtpQueueElement_t *> as CoreQueue;
    }
} implementation {
    WmtpReliabilityLocalPart_t WmtpReliabilityLocalPart[LOCAL_PART_MAX_PACKETS];
    uint16_t NewPacketID;


    /**
     * Initializes the module.
    **/

    command error_t Init.init() {
        unsigned char i;

        NewPacketID = 0;

        for ( i = 0; i < LOCAL_PART_MAX_PACKETS; i++ ) {
            WmtpReliabilityLocalPart[i].OrigAddr = AM_BROADCAST_ADDR;
            WmtpReliabilityLocalPart[i].LastPacket = 1;
            WmtpReliabilityLocalPart[i].PacketID = 0;
        }

        return SUCCESS;
    }


    command error_t StdControl.start() {
        // Broadcast empty set.
        WmtpReliabilityLocalPart[0].OrigAddr = AM_BROADCAST_ADDR;
        WmtpReliabilityLocalPart[0].PacketID = 0;
        WmtpReliabilityLocalPart[0].LastPacket = 1;
        call WmtpLocalManagementDataHandler.GenerateHeader( &(WmtpReliabilityLocalPart[0]), sizeof( WmtpReliabilityLocalPart_t ), FALSE );

        return SUCCESS;
    }


    command error_t StdControl.stop() {
        call WmtpLocalManagementDataHandler.GenerateHeader( NULL, 0, FALSE );

        return SUCCESS;
    }


    command error_t WmtpFeatureConfigurationHandler.InitializeConfiguration( WmtpConnectionSpecification_t *ConnectionSpecification ) {
        ConnectionSpecification->FeatureSpecification.ReliabilityHandlerID = WMTP_RELIABILITYHANDLER_NONE;

        return SUCCESS;
    }


    command error_t WmtpFeatureConfigurationHandler.GenerateConfigurationData( WmtpConnectionSpecification_t *ConnectionSpecification, void *ConfigurationData, uint8_t *ConfigurationDataSize ) {
        if ( ConnectionSpecification &&
                ConnectionSpecification->FeatureSpecification.ReliabilityHandlerID == WMTP_RELIABILITYHANDLER_WMTPRELIABILITY ) {
            *ConfigurationDataSize = 0;

            return SUCCESS;
        } else {
            return FAIL;
        }
    }


    command error_t WmtpFeatureConfigurationHandler.HandleConfigurationData( void *ConfigurationData, uint8_t *ConfigurationDataSize, WmtpConnectionSpecification_t *ConnectionSpecification ) {
        ConnectionSpecification->FeatureSpecification.ReliabilityHandlerID = WMTP_RELIABILITYHANDLER_WMTPRELIABILITY;

        *ConfigurationDataSize = 0;

        return SUCCESS;
    }


    command error_t WmtpFeatureConfigurationHandler.GetConfigurationDataSize( void *ConfigurationData, uint8_t *ConfigurationDataSize ) {
        *ConfigurationDataSize = 0;

        return SUCCESS;
    }


    WmtpQueueElement_t *getPacketByID( uint16_t OrigAddr, uint16_t PacketID ) {
        WmtpQueueElement_t *QE;
        WmtpReliabilityConnectionPart_t *WmtpReliabilityConnectionPart;
        uint8_t e = 0;

        if ( OrigAddr == AM_BROADCAST_ADDR )
            return NULL;

        // Check if the core queue is empty.
        if ( ! call CoreQueue.empty() ) {
            do {
                QE = call CoreQueue.element( e++ );
                if ( QE->ConnectionSpecification &&
                        QE->ConnectionSpecification->FeatureSpecification.ReliabilityHandlerID == WMTP_RELIABILITYHANDLER_WMTPRELIABILITY &&
                        (call WmtpConnectionManagementDataHandler.GetHeader( QE, (void *) &WmtpReliabilityConnectionPart )) == SUCCESS &&
                        WmtpReliabilityConnectionPart->OrigAddr == OrigAddr &&
                        WmtpReliabilityConnectionPart->PacketID == PacketID ) {
                    return QE;
                }
            } while ( e < call CoreQueue.size() );

            return NULL;
        } else {
            return NULL;
        }
    }


    signed char comparePacketIDs( uint16_t OrigAddr1, uint16_t PacketID1, uint16_t OrigAddr2, uint16_t PacketID2 ) {
        if ( OrigAddr1 < OrigAddr2 )
            return -1;
        else if ( OrigAddr1 > OrigAddr2 )
            return 1;
        else if ( PacketID1 < PacketID2 )
            return -1;
        else if ( PacketID1 > PacketID2 )
            return 1;
        else
            return 0;
    }


    WmtpQueueElement_t *findSucceedingPacket( uint16_t PreOrigAddr, uint16_t PrePacketID, uint16_t LimitOrigAddr, uint16_t LimitPacketID ) {
        WmtpQueueElement_t *QE, *succeedingQE = NULL;
        uint16_t succeedingOrigAddr = 0, succeedingPacketID = 0;
        WmtpReliabilityConnectionPart_t *WmtpReliabilityConnectionPart;
        uint8_t e = 0;

        // Check if the core queue is empty.
        if ( ! call CoreQueue.empty() ) {
            do {
                QE = call CoreQueue.element( e++ );
                // Check if the packet uses WMTP reliability.
                if ( QE->ConnectionSpecification &&
                        QE->ConnectionSpecification->FeatureSpecification.ReliabilityHandlerID == WMTP_RELIABILITYHANDLER_WMTPRELIABILITY &&
                        (call WmtpConnectionManagementDataHandler.GetHeader( QE, (void *) &WmtpReliabilityConnectionPart )) == SUCCESS ) {
                    // Check if a predecessor is specified.
                    if ( PreOrigAddr == AM_BROADCAST_ADDR ) {
                        // No predecessor, find packet with lowest id.
                        if ( succeedingQE == NULL ||
                                comparePacketIDs( WmtpReliabilityConnectionPart->OrigAddr,
                                                  WmtpReliabilityConnectionPart->PacketID,
                                                  succeedingOrigAddr, succeedingPacketID ) < 0 ) {
                            succeedingQE = QE;
                            succeedingOrigAddr = WmtpReliabilityConnectionPart->OrigAddr;
                            succeedingPacketID = WmtpReliabilityConnectionPart->PacketID;
                        }
                    } else {
                        // Predecessor specified, find the packet with the lowest id that is larger than the predecessor's.
                        if ( comparePacketIDs( WmtpReliabilityConnectionPart->OrigAddr,
                                               WmtpReliabilityConnectionPart->PacketID,
                                               PreOrigAddr, PrePacketID ) > 0 &&
                                ( succeedingQE == NULL ||
                                  comparePacketIDs( WmtpReliabilityConnectionPart->OrigAddr,
                                                    WmtpReliabilityConnectionPart->PacketID,
                                                    succeedingOrigAddr, succeedingPacketID ) < 0 ) ) {
                            succeedingQE = QE;
                            succeedingOrigAddr = WmtpReliabilityConnectionPart->OrigAddr;
                            succeedingPacketID = WmtpReliabilityConnectionPart->PacketID;
                        }
                    }
                }
            } while ( e < call CoreQueue.size() );

            // Check if limiting id is respected.
            if ( LimitOrigAddr == AM_BROADCAST_ADDR ||
                    comparePacketIDs( succeedingOrigAddr, succeedingPacketID,
                                      LimitOrigAddr, LimitPacketID ) < 0 )
                return succeedingQE;
            else
                return NULL;
        } else {
            return NULL;
        }
    }


    void generateLocalManagementDataFromID( uint16_t OrigAddr, uint16_t PacketID ) {
        WmtpQueueElement_t *QE;
        WmtpReliabilityConnectionPart_t *WmtpReliabilityConnectionPart;
        unsigned char curPacket = 0;
        uint8_t e = 0;

        call WmtpLocalManagementDataHandler.GenerateHeader( NULL, 0, FALSE );

        dbg( "WMTP", "WmtpReliabilityHandlerP: Generating local management data from [%d,%d]:\n", OrigAddr, PacketID );

        dbg( "WMTP", "WmtpReliabilityHandlerP:    Calculating first packet.\n" );
        WmtpReliabilityLocalPart[curPacket].OrigAddr = AM_BROADCAST_ADDR;
        WmtpReliabilityLocalPart[curPacket].PacketID = 0;
        WmtpReliabilityLocalPart[curPacket].LastPacket = 0;

        // Check if a start point is specified.
        if ( OrigAddr != AM_BROADCAST_ADDR ) {
            // Iterate through the core queue searching for the packet with the
            // highest id that is lesser than or equal to the start point.

            // Check if the core queue is empty.
            if ( ! call CoreQueue.empty() ) {
                do {
                    QE = call CoreQueue.element( e++ );
                    // Check if the packet uses WMTP reliability.
                    if ( QE->ConnectionSpecification &&
                            QE->ConnectionSpecification->FeatureSpecification.ReliabilityHandlerID == WMTP_RELIABILITYHANDLER_WMTPRELIABILITY &&
                            (call WmtpConnectionManagementDataHandler.GetHeader( QE, (void *) &WmtpReliabilityConnectionPart )) == SUCCESS ) {
                        // Find the packet with the highestest id that is lesser or equal to the starting point's.
                        if ( comparePacketIDs( WmtpReliabilityConnectionPart->OrigAddr,
                                               WmtpReliabilityConnectionPart->PacketID,
                                               OrigAddr, PacketID ) <= 0 &&
                                ( WmtpReliabilityLocalPart[curPacket].OrigAddr == AM_BROADCAST_ADDR ||
                                  comparePacketIDs( WmtpReliabilityConnectionPart->OrigAddr,
                                                    WmtpReliabilityConnectionPart->PacketID,
                                                    WmtpReliabilityLocalPart[curPacket].OrigAddr,
                                                    WmtpReliabilityLocalPart[curPacket].PacketID ) > 0 ) ) {
                            WmtpReliabilityLocalPart[curPacket].OrigAddr = WmtpReliabilityConnectionPart->OrigAddr;
                            WmtpReliabilityLocalPart[curPacket].PacketID = WmtpReliabilityConnectionPart->PacketID;
                        }
                    }
                } while ( e < call CoreQueue.size() );

                // Check if no packets found lesser than or equal to the starting point.
                if ( WmtpReliabilityLocalPart[curPacket].OrigAddr == AM_BROADCAST_ADDR ) {
                    // Find a successor.
                    QE = findSucceedingPacket( OrigAddr, PacketID, AM_BROADCAST_ADDR, 0 );
                    if ( QE != NULL ) {
                        call WmtpConnectionManagementDataHandler.GetHeader( QE, (void *) &WmtpReliabilityConnectionPart );
                        WmtpReliabilityLocalPart[curPacket].OrigAddr = WmtpReliabilityConnectionPart->OrigAddr;
                        WmtpReliabilityLocalPart[curPacket].PacketID = WmtpReliabilityConnectionPart->PacketID;
                    }
                }
            }
        }

        dbg( "WMTP",
             "WmtpReliabilityHandlerP:    Packet: [%d,%d]:\n",
             WmtpReliabilityLocalPart[curPacket].OrigAddr,
             WmtpReliabilityLocalPart[curPacket].PacketID );
        curPacket++;

        dbg( "WMTP", "WmtpReliabilityHandlerP:    Appending consecutive packets.\n" );
        // Append consecutive ids until the max is reached or the local part is full.
        do {
            QE = findSucceedingPacket( WmtpReliabilityLocalPart[curPacket - 1].OrigAddr,
                                       WmtpReliabilityLocalPart[curPacket - 1].PacketID,
                                       AM_BROADCAST_ADDR, 0 );
            if ( QE != NULL ) {
                call WmtpConnectionManagementDataHandler.GetHeader( QE, (void *) &WmtpReliabilityConnectionPart );
                WmtpReliabilityLocalPart[curPacket].OrigAddr = WmtpReliabilityConnectionPart->OrigAddr;
                WmtpReliabilityLocalPart[curPacket].PacketID = WmtpReliabilityConnectionPart->PacketID;
                dbg( "WMTP",
                     "WmtpReliabilityHandlerP:    Packet: [%d,%d]:\n",
                     WmtpReliabilityLocalPart[curPacket].OrigAddr,
                     WmtpReliabilityLocalPart[curPacket].PacketID );
                WmtpReliabilityLocalPart[curPacket++].LastPacket = 0;
            } else if ( WmtpReliabilityLocalPart[curPacket - 1].OrigAddr != AM_BROADCAST_ADDR ) {
                WmtpReliabilityLocalPart[curPacket].OrigAddr = AM_BROADCAST_ADDR;
                WmtpReliabilityLocalPart[curPacket].PacketID = 0;
                dbg( "WMTP",
                     "WmtpReliabilityHandlerP:    Packet: [%d,%d]:\n",
                     WmtpReliabilityLocalPart[curPacket].OrigAddr,
                     WmtpReliabilityLocalPart[curPacket].PacketID );
                WmtpReliabilityLocalPart[curPacket++].LastPacket = 0;
            }
        } while ( curPacket < LOCAL_PART_MAX_PACKETS && QE != NULL );

        // Restart appending ids from the bottom, if their is room left and
        // local part hasn't started from the bottom already
        if ( curPacket < LOCAL_PART_MAX_PACKETS &&
                WmtpReliabilityLocalPart[0].OrigAddr != AM_BROADCAST_ADDR ) {
            dbg( "WMTP", "WmtpReliabilityHandlerP:    Restarting appending from the bottom.\n" );

            do {
                QE = findSucceedingPacket( WmtpReliabilityLocalPart[curPacket - 1].OrigAddr,
                                           WmtpReliabilityLocalPart[curPacket - 1].PacketID,
                                           WmtpReliabilityLocalPart[0].OrigAddr, WmtpReliabilityLocalPart[0].PacketID );
                if ( QE != NULL ) {
                    call WmtpConnectionManagementDataHandler.GetHeader( QE, (void *) &WmtpReliabilityConnectionPart );
                    WmtpReliabilityLocalPart[curPacket].OrigAddr = WmtpReliabilityConnectionPart->OrigAddr;
                    WmtpReliabilityLocalPart[curPacket].PacketID = WmtpReliabilityConnectionPart->PacketID;
                    dbg( "WMTP",
                         "WmtpReliabilityHandlerP:    Packet: [%d,%d]:\n",
                         WmtpReliabilityLocalPart[curPacket].OrigAddr,
                         WmtpReliabilityLocalPart[curPacket].PacketID );
                    WmtpReliabilityLocalPart[curPacket++].LastPacket = 0;
                }
            } while ( curPacket < LOCAL_PART_MAX_PACKETS && QE != NULL );
        }

        WmtpReliabilityLocalPart[curPacket - 1].LastPacket = 1;

        call WmtpLocalManagementDataHandler.GenerateHeader( &(WmtpReliabilityLocalPart[0]), curPacket * sizeof( WmtpReliabilityLocalPart_t ), FALSE );
    }


    void regenerateCurrentLocalManagementData() {
        generateLocalManagementDataFromID( WmtpReliabilityLocalPart[0].OrigAddr, WmtpReliabilityLocalPart[0].PacketID );
    }


    void generateNextLocalManagementData() {
        uint8_t lastPacket;

        // Iterate through all packets specified in header until we reach the last.
        for ( lastPacket = 0;
                WmtpReliabilityLocalPart[lastPacket].LastPacket == 0 && lastPacket < LOCAL_PART_MAX_PACKETS;
                lastPacket++ );

        generateLocalManagementDataFromID( WmtpReliabilityLocalPart[lastPacket].OrigAddr, WmtpReliabilityLocalPart[lastPacket].PacketID );
    }


    void processTimers() {
        WmtpQueueElement_t *QE;
        uint32_t curTime = call Timer.getNow();
        uint32_t *nextTimer = NULL;
        uint8_t state, e = 0;

        // Iterate through the core queue.

        // Check if the core queue is empty.
        if ( ! call CoreQueue.empty() ) {
            do {
                QE = call CoreQueue.element( e++ );
                // Check if the queue element has WMTP reliability, hasn't been ACKed, is inactive and has an expired timeout timer.
                if ( QE->ConnectionSpecification &&
                        QE->ConnectionSpecification->FeatureSpecification.ReliabilityHandlerID == WMTP_RELIABILITYHANDLER_WMTPRELIABILITY &&
                        (! (call WmtpPacketScratchPadHook.GetPacketScratchPad( QE ))->WmtpReliability.NextHopAcked) &&
                        (call WmtpTrafficShaper.GetPacketState( QE, &state )) == SUCCESS &&
                        state == FALSE &&
                        curTime >= (call WmtpPacketScratchPadHook.GetPacketScratchPad( QE ))->WmtpReliability.TimeOutTime ) {
                    // Restart the packet.
                    dbg( "WMTP", "WmtpReliabilityHandlerP: Packet timed out. Starting packet for retransmission.\n" );
                    call WmtpTrafficShaper.StartPacket( QE );
                }
            } while ( e < call CoreQueue.size() );
        }

        // Cancel any previous timer.
        call Timer.stop();

        // Iterate through the core queue.

        // Check if the core queue is empty.
        if ( ! call CoreQueue.empty() ) {
            e = 0;
            do {
                QE = call CoreQueue.element( e++ );
                // Check if the queue element has WMTP reliability, hasn't been ACKed, is inactive and has a pending wake up timer.
                if ( QE->ConnectionSpecification &&
                        QE->ConnectionSpecification->FeatureSpecification.ReliabilityHandlerID == WMTP_RELIABILITYHANDLER_WMTPRELIABILITY &&
                        (! (call WmtpPacketScratchPadHook.GetPacketScratchPad( QE ))->WmtpReliability.NextHopAcked) &&
                        (call WmtpTrafficShaper.GetPacketState( QE, &state )) == SUCCESS &&
                        state == FALSE &&
                        curTime < (call WmtpPacketScratchPadHook.GetPacketScratchPad( QE ))->WmtpReliability.TimeOutTime ) {
                    // Check if the next timer has already been defined.
                    if ( nextTimer == NULL ) {
                        // Define it.
                        nextTimer = &((call WmtpPacketScratchPadHook.GetPacketScratchPad( QE ))->WmtpReliability.TimeOutTime);
                    } else {
                        // Check if we've found a new timer that's earlier.
                        if ( *nextTimer > (call WmtpPacketScratchPadHook.GetPacketScratchPad( QE ))->WmtpReliability.TimeOutTime )
                            nextTimer = &((call WmtpPacketScratchPadHook.GetPacketScratchPad( QE ))->WmtpReliability.TimeOutTime);
                    }
                }
            } while ( e < call CoreQueue.size() );

            // Check if a next timer was found.
            if ( nextTimer != NULL )
                call Timer.startOneShot( *nextTimer - call Timer.getNow() );
            else
                dbg( "WMTP", "WmtpReliabilityHandlerP: No timeout timers left.\n" );
        }
    }


    event error_t WmtpLocalManagementDataHandler.HeaderBroadcasted() {
        generateNextLocalManagementData();

        return SUCCESS;
    }


    event error_t WmtpLocalManagementDataHandler.HandleHeader( uint16_t SourceAddress, void *HeaderData, uint8_t *HeaderDataSize ) {
        WmtpReliabilityLocalPart_t *receivedWmtpReliabilityLocalPart = HeaderData;
        WmtpReliabilityConnectionPart_t *WmtpReliabilityConnectionPart;
        WmtpQueueElement_t *QE;
        uint8_t droppedPackets = FALSE, e = 0;

        dbg( "WMTP", "WmtpReliabilityHandlerP: Received local management data from %d:\n", SourceAddress );

        // Iterate through all packets specified in header.
        while ( TRUE ) {
            QE = getPacketByID( receivedWmtpReliabilityLocalPart->OrigAddr, receivedWmtpReliabilityLocalPart->PacketID );
            if ( QE != NULL && SourceAddress == QE->NextHop ) {
                dbg( "WMTP",
                     "WmtpReliabilityHandlerP:    Packet [%d,%d] ACKed.\n",
                     receivedWmtpReliabilityLocalPart->OrigAddr,
                     receivedWmtpReliabilityLocalPart->PacketID );
                (call WmtpPacketScratchPadHook.GetPacketScratchPad( QE ))->WmtpReliability.NextHopAcked = TRUE;

                if ( (call WmtpPacketScratchPadHook.GetPacketScratchPad( QE ))->WmtpReliability.PrevHopDropped ||
                        (call WmtpPacketScratchPadHook.GetPacketScratchPad( QE ))->WmtpReliability.PrevHop == TOS_NODE_ID ) {
                    dbg( "WMTP",
                         "WmtpReliabilityHandlerP:    Dropping packet [%d,%d].\n",
                         receivedWmtpReliabilityLocalPart->OrigAddr,
                         receivedWmtpReliabilityLocalPart->PacketID );
                    call WmtpReliableTransmissionHook.DropPacket( QE );
                    droppedPackets = TRUE;
                }
            } else {
                dbg( "WMTP",
                     "WmtpReliabilityHandlerP:    Packet [%d,%d] available.\n",
                     receivedWmtpReliabilityLocalPart->OrigAddr,
                     receivedWmtpReliabilityLocalPart->PacketID );
            }

            if ( receivedWmtpReliabilityLocalPart->LastPacket != 0 )
                break;

            receivedWmtpReliabilityLocalPart = (WmtpReliabilityLocalPart_t *) (((uint8_t *) receivedWmtpReliabilityLocalPart) + sizeof( WmtpReliabilityLocalPart_t ));
        }

        *HeaderDataSize = (((uint8_t *) receivedWmtpReliabilityLocalPart) - ((uint8_t *) HeaderData)) + sizeof( WmtpReliabilityLocalPart_t );

        // Iterate through all core queue elements.

        // Check if the core queue is empty.
        if ( ! call CoreQueue.empty() ) {
            do {
                uint8_t dropPacket = FALSE;

                QE = call CoreQueue.element( e++ );
                // Check if the queue element has WMTP reliability and either
                // the header came from its previous hop or it came from its
                // next hop and the packet has already been sent at least once
                // but not ACKed.
                if ( QE->ConnectionSpecification &&
                        QE->ConnectionSpecification->FeatureSpecification.ReliabilityHandlerID == WMTP_RELIABILITYHANDLER_WMTPRELIABILITY &&
                        (call WmtpConnectionManagementDataHandler.GetHeader( QE, (void *) &WmtpReliabilityConnectionPart )) == SUCCESS &&
                        ((call WmtpPacketScratchPadHook.GetPacketScratchPad( QE ))->WmtpReliability.PrevHop == SourceAddress ||
#ifdef FAST_RETRANSMIT
                         (QE->NextHop == SourceAddress &&
                          (call WmtpPacketScratchPadHook.GetPacketScratchPad( QE ))->WmtpReliability.NumTimesSent > 0 &&
                          (! (call WmtpPacketScratchPadHook.GetPacketScratchPad( QE ))->WmtpReliability.NextHopAcked) )
#else // #ifdef FAST_RETRANSMIT
                         FALSE
#endif // #ifdef FAST_RETRANSMIT #else
                        ) ) {
                    // Iterate through all packets specified in header in search for one that precedes or matches the queue element.
                    for ( receivedWmtpReliabilityLocalPart = HeaderData;
                            receivedWmtpReliabilityLocalPart->LastPacket == 0 &&
                            receivedWmtpReliabilityLocalPart->OrigAddr != AM_BROADCAST_ADDR &&
                            comparePacketIDs( receivedWmtpReliabilityLocalPart->OrigAddr, receivedWmtpReliabilityLocalPart->PacketID,
                                              WmtpReliabilityConnectionPart->OrigAddr, WmtpReliabilityConnectionPart->PacketID ) > 0;
                            receivedWmtpReliabilityLocalPart = (WmtpReliabilityLocalPart_t *) (((uint8_t *) receivedWmtpReliabilityLocalPart) + sizeof( WmtpReliabilityLocalPart_t )) );
                    // Check if we haven't reached the end of the set or found a match.
                    // Also check for the special situation where there are no packets.
                    if ( (receivedWmtpReliabilityLocalPart->LastPacket == 0 &&
                            comparePacketIDs( receivedWmtpReliabilityLocalPart->OrigAddr, receivedWmtpReliabilityLocalPart->PacketID,
                                              WmtpReliabilityConnectionPart->OrigAddr, WmtpReliabilityConnectionPart->PacketID ) != 0) ||
                            (receivedWmtpReliabilityLocalPart == HeaderData &&
                             receivedWmtpReliabilityLocalPart->OrigAddr == AM_BROADCAST_ADDR &&
                             receivedWmtpReliabilityLocalPart->LastPacket == 1 ) ) {
                        // Continue iterating in search for a packet that succeeds or matches the queue element.
                        if ( receivedWmtpReliabilityLocalPart->LastPacket == 0 ) {
                            for ( receivedWmtpReliabilityLocalPart = (WmtpReliabilityLocalPart_t *) (((uint8_t *) receivedWmtpReliabilityLocalPart) + sizeof( WmtpReliabilityLocalPart_t ));
                                    receivedWmtpReliabilityLocalPart->LastPacket == 0 &&
                                    receivedWmtpReliabilityLocalPart->OrigAddr != AM_BROADCAST_ADDR &&
                                    comparePacketIDs( receivedWmtpReliabilityLocalPart->OrigAddr, receivedWmtpReliabilityLocalPart->PacketID,
                                                      WmtpReliabilityConnectionPart->OrigAddr, WmtpReliabilityConnectionPart->PacketID ) < 0;
                                    receivedWmtpReliabilityLocalPart = (WmtpReliabilityLocalPart_t *) (((uint8_t *) receivedWmtpReliabilityLocalPart) + sizeof( WmtpReliabilityLocalPart_t )) );
                        }
                        // Check if we didn't find any matching packet.
                        if ( receivedWmtpReliabilityLocalPart->OrigAddr == AM_BROADCAST_ADDR ||
                                comparePacketIDs( receivedWmtpReliabilityLocalPart->OrigAddr, receivedWmtpReliabilityLocalPart->PacketID,
                                                  WmtpReliabilityConnectionPart->OrigAddr, WmtpReliabilityConnectionPart->PacketID ) > 0 ) {
                            // Check if the header came from the previous hop (packet dropped).
                            if ( (call WmtpPacketScratchPadHook.GetPacketScratchPad( QE ))->WmtpReliability.PrevHop == SourceAddress ) {
                                dbg( "WMTP",
                                     "WmtpReliabilityHandlerP: Node %d dropped packet [%d,%d].\n",
                                     SourceAddress,
                                     WmtpReliabilityConnectionPart->OrigAddr,
                                     WmtpReliabilityConnectionPart->PacketID );
                                (call WmtpPacketScratchPadHook.GetPacketScratchPad( QE ))->WmtpReliability.PrevHopDropped = TRUE;

                                if ( (call WmtpPacketScratchPadHook.GetPacketScratchPad( QE ))->WmtpReliability.NextHopAcked ||
                                        QE->NextHop == TOS_NODE_ID ) {
                                    dbg( "WMTP",
                                         "WmtpReliabilityHandlerP: Dropping packet [%d,%d].\n",
                                         WmtpReliabilityConnectionPart->OrigAddr,
                                         WmtpReliabilityConnectionPart->PacketID );
                                    dropPacket = TRUE;
                                }
                            }
#ifdef FAST_RETRANSMIT
                            // Check if the header came from the next hop and the packet has already been sent at least once but not ACKed.
                            if ( QE->NextHop == SourceAddress &&
                                    (call WmtpPacketScratchPadHook.GetPacketScratchPad( QE ))->WmtpReliability.NumTimesSent > 0 &&
                                    (! (call WmtpPacketScratchPadHook.GetPacketScratchPad( QE ))->WmtpReliability.NextHopAcked) ) {
                                dbg( "WMTP",
                                     "WmtpReliabilityHandlerP: Node %d hasn't received packet [%d,%d]. Resending.\n",
                                     SourceAddress,
                                     WmtpReliabilityConnectionPart->OrigAddr,
                                     WmtpReliabilityConnectionPart->PacketID );

                                call WmtpTrafficShaper.StartPacket( QE );
                            }
#endif // #ifdef FAST_RETRANSMIT
                        }
                    }
                }

                if ( dropPacket ) {

                    call WmtpReliableTransmissionHook.DropPacket( QE );
                    droppedPackets = TRUE;

                    if ( e == 1 ) {
                        e = 0;
                    }
                    if ( call CoreQueue.empty() )
                        break;
                }
            } while ( e < call CoreQueue.size() );
        }

        if ( droppedPackets )
            regenerateCurrentLocalManagementData();

        return SUCCESS;
    }


    event error_t WmtpConnectionManagementDataHandler.GenerateHeader( WmtpConnectionSpecification_t *ConnectionSpecification, WmtpQueueElement_t *Packet, void *HeaderData, uint8_t *HeaderDataSize ) {
        if ( ConnectionSpecification &&
                ConnectionSpecification->FeatureSpecification.ReliabilityHandlerID == WMTP_RELIABILITYHANDLER_WMTPRELIABILITY ) {
            WmtpReliabilityConnectionPart_t *WmtpReliabilityConnectionPart = HeaderData;
            // Generate the header.
            dbg( "WMTP",
                 "WmtpReliabilityHandlerP: Generating connection management data for packet [%d,%d].\n",
                 TOS_NODE_ID,
                 NewPacketID );
            WmtpReliabilityConnectionPart->OrigAddr = TOS_NODE_ID;
            WmtpReliabilityConnectionPart->PacketID = NewPacketID++;
            *HeaderDataSize = sizeof( WmtpReliabilityConnectionPart_t );
            // Initialize packet scratch pad.
            (call WmtpPacketScratchPadHook.GetPacketScratchPad( Packet ))->WmtpReliability.PrevHop = TOS_NODE_ID;
            (call WmtpPacketScratchPadHook.GetPacketScratchPad( Packet ))->WmtpReliability.NumTimesSent = 0;
            (call WmtpPacketScratchPadHook.GetPacketScratchPad( Packet ))->WmtpReliability.TimeOutTime = call Timer.getNow();
            (call WmtpPacketScratchPadHook.GetPacketScratchPad( Packet ))->WmtpReliability.NextHopAcked = FALSE;
            (call WmtpPacketScratchPadHook.GetPacketScratchPad( Packet ))->WmtpReliability.PrevHopDropped = FALSE;

            return SUCCESS;
        } else {
            return FAIL;
        }
    }


    event error_t WmtpConnectionManagementDataHandler.HandleHeader( uint16_t PreviousHop, WmtpConnectionSpecification_t *ConnectionSpecification, WmtpQueueElement_t *Packet, void *HeaderData, uint8_t *HeaderDataSize ) {
        dbg( "WMTP",
             "WmtpReliabilityHandlerP: Received packet [%d,%d].\n",
             ((WmtpReliabilityConnectionPart_t *) HeaderData)->OrigAddr,
             ((WmtpReliabilityConnectionPart_t *) HeaderData)->PacketID );
        // Calculate header size.
        *HeaderDataSize = sizeof( WmtpReliabilityConnectionPart_t );
        // Initialize packet scratch pad.
        (call WmtpPacketScratchPadHook.GetPacketScratchPad( Packet ))->WmtpReliability.PrevHop = PreviousHop;
        (call WmtpPacketScratchPadHook.GetPacketScratchPad( Packet ))->WmtpReliability.NumTimesSent = 0;
        (call WmtpPacketScratchPadHook.GetPacketScratchPad( Packet ))->WmtpReliability.TimeOutTime = call Timer.getNow();
        (call WmtpPacketScratchPadHook.GetPacketScratchPad( Packet ))->WmtpReliability.NextHopAcked = FALSE;
        (call WmtpPacketScratchPadHook.GetPacketScratchPad( Packet ))->WmtpReliability.PrevHopDropped = FALSE;

        return SUCCESS;
    }


    event error_t WmtpTrafficShaper.NewPacket( WmtpQueueElement_t *Packet ) {
        regenerateCurrentLocalManagementData();

        return SUCCESS;
    }


    event error_t WmtpTrafficShaper.SendingPacket( WmtpQueueElement_t *Packet ) {
        return SUCCESS;
    }
    event error_t WmtpTrafficShaper.DroppingPacket( WmtpQueueElement_t *Packet ) {
        return SUCCESS;
    }
    event error_t WmtpTrafficShaper.ConnectionOpened( WmtpConnectionSpecification_t *ConnectionSpecification ) {
        return SUCCESS;
    }
    event error_t WmtpTrafficShaper.ConnectionClosed( WmtpConnectionSpecification_t *ConnectionSpecification ) {
        return SUCCESS;
    }
    event error_t WmtpTrafficShaper.ConnectionReconfigured( WmtpConnectionSpecification_t *ConnectionSpecification ) {
        return SUCCESS;
    }


    event error_t WmtpReliableTransmissionHook.SendingPacket( WmtpQueueElement_t *Packet, uint8_t *DropPacket ) {
        // Check if the packet hasn't been retransmitted to many times.
        if ( ++((call WmtpPacketScratchPadHook.GetPacketScratchPad( Packet ))->WmtpReliability.NumTimesSent) < MAX_PACKET_TRANSMITS ) {
            call WmtpTrafficShaper.StopPacket( Packet );

            (call WmtpPacketScratchPadHook.GetPacketScratchPad( Packet ))->WmtpReliability.TimeOutTime = call Timer.getNow() + PACKET_RETRANSMIT_TIMEOUT;
            processTimers();

            *DropPacket = FALSE;
        } else {
            *DropPacket = TRUE;
        }

        return SUCCESS;
    }


    event error_t WmtpReliableTransmissionHook.DeliveringPacket( WmtpQueueElement_t *Packet, uint8_t *DropPacket ) {
        *DropPacket = FALSE;

        return SUCCESS;
    }


    event error_t WmtpReliableTransmissionHook.PacketUnroutable( WmtpQueueElement_t *Packet, uint8_t *DropPacket ) {
        *DropPacket = FALSE;

        return SUCCESS;
    }


    event uint8_t WmtpReliableTransmissionHook.IsPacketRepeated( WmtpQueueElement_t *Packet ) {
        WmtpQueueElement_t *QE;
        WmtpReliabilityConnectionPart_t *WmtpReliabilityConnectionPart;
        uint16_t OrigAddr, PacketID;
        uint8_t e = 0;

        if ( (call WmtpConnectionManagementDataHandler.GetHeader( Packet, (void *) &WmtpReliabilityConnectionPart )) == SUCCESS ) {
            OrigAddr = WmtpReliabilityConnectionPart->OrigAddr;
            PacketID = WmtpReliabilityConnectionPart->PacketID;

            // Check if the core queue is empty.
            if ( ! call CoreQueue.empty() ) {
                do {
                    QE = call CoreQueue.element( e++ );
                    if ( QE->ConnectionSpecification &&
                            QE->ConnectionSpecification->FeatureSpecification.ReliabilityHandlerID == WMTP_RELIABILITYHANDLER_WMTPRELIABILITY &&
                            (call WmtpConnectionManagementDataHandler.GetHeader( QE, (void *) &WmtpReliabilityConnectionPart )) == SUCCESS &&
                            WmtpReliabilityConnectionPart->OrigAddr == OrigAddr &&
                            WmtpReliabilityConnectionPart->PacketID == PacketID ) {
                        dbg( "WMTP", "WmtpReliabilityHandlerP: Found repeated packet.\n" );

                        return TRUE;
                    }
                } while ( e < call CoreQueue.size() );
            }
        } else {
            dbg( "WMTP", "WmtpReliabilityHandlerP: Packet doesn't have WMTP reliability connection headers. Considered repeated.\n" );

            return TRUE;
        }

        return FALSE;
    }


    event void Timer.fired() {
        dbg( "WMTP", "WmtpReliabilityHandlerP: Timer fired. Processing timers.\n" );

        processTimers();
    }
}
