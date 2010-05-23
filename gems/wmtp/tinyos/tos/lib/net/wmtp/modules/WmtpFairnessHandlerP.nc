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
 * WMTP Fairness handler.
 *
 * This component implements the fairness feature. This features uses local
 * management data as well as a traffic shaper to establish weighted fairness.
 *
 * @author Luis D. Pedrosa <luis.pedrosa@tagus.ist.utl.pt>
 * @author Hugo Freire <hugo.freire@ist.utl.pt> (port to TinyOS 2.x)
**/

#include "Wmtp.h"

#define MAX_SINKS 1
#define NEW_LOCAL_PERIOD_WEIGHT 10
#define CONNECTION_TIMER_MULTIPLYING_FACTOR 0.80
#define REMOTE_NORMALIZED_PERIOD_VALIDITY ((uint32_t) 60 * 1024)

module WmtpFairnessHandlerP {
    provides {
        interface Init;
        interface StdControl;
        interface WmtpFeatureConfigurationHandler;
    }
    uses {
        interface WmtpLocalManagementDataHandler;
        interface WmtpTrafficShaper;
        interface WmtpConnectionScratchPadHook;
        interface WmtpCoreMonitor;
        //interface Time;
        //interface TimeUtil;
        //interface AbsoluteTimer;
        interface Timer<TMilli>;

        interface Queue<WmtpConnectionSpecification_t *> as OpenConnectionsQueue;
    }
} implementation {
    WmtpFairnessLocalPart_t FairnessLocalPart[MAX_SINKS];
    struct {
        uint8_t active;
        uint8_t sinkID;
        uint16_t totalWeight;
        uint8_t firstPacketSent;
        uint32_t lastPacketSentTime;
        // Measured local period (not normalized).
        uint16_t localPeriod;
        // Highest remote normalized period.
        uint16_t remoteNode;
        uint16_t remoteNormalizedPeriod;
        uint32_t validTime;
    } fairnessTable[MAX_SINKS];
    static uint8_t processingConnections;


    uint8_t getFairnessTableLine( uint8_t sinkID ) {
        unsigned char i;

        for ( i = 0; i < MAX_SINKS; i++ )
            if ( fairnessTable[i].active &&
                    fairnessTable[i].sinkID == sinkID )
                return i;

        for ( i = 0; i < MAX_SINKS; i++ ) {
            if ( ! fairnessTable[i].active ) {
                fairnessTable[i].active = TRUE;
                fairnessTable[i].sinkID = sinkID;
                fairnessTable[i].totalWeight = 0;
                fairnessTable[i].firstPacketSent = FALSE;
                fairnessTable[i].localPeriod = 0;
                fairnessTable[i].remoteNormalizedPeriod = 0;
                fairnessTable[i].remoteNode = AM_BROADCAST_ADDR;

                return i;
            }
        }

        return i;
    }


    void generateLocalManagementData() {
        unsigned char i, curSink;

        call WmtpLocalManagementDataHandler.GenerateHeader( NULL, 0, FALSE );

        for ( i = 0, curSink = 0; i < MAX_SINKS; i++ ) {
            if ( fairnessTable[i].active ) {
                FairnessLocalPart[curSink].LastSink = 0;
                FairnessLocalPart[curSink].SinkID = fairnessTable[i].sinkID;

                if ( fairnessTable[i].localPeriod * fairnessTable[i].totalWeight >= fairnessTable[i].remoteNormalizedPeriod ) {
                    FairnessLocalPart[curSink].NormalizedPeriod = fairnessTable[i].localPeriod * fairnessTable[i].totalWeight;
                    FairnessLocalPart[curSink].LimitingNode = TOS_NODE_ID;
                } else {
                    FairnessLocalPart[curSink].NormalizedPeriod = fairnessTable[i].remoteNormalizedPeriod;
                    FairnessLocalPart[curSink].LimitingNode = fairnessTable[i].remoteNode;
                }

                curSink++;
            }
        }

        if ( curSink > 0 ) {
            FairnessLocalPart[curSink - 1].LastSink = 1;

            call WmtpLocalManagementDataHandler.GenerateHeader( &(FairnessLocalPart[0]), curSink * sizeof( WmtpFairnessLocalPart_t ), FALSE );
        }
    }


    /**
     * Initializes the module.
    **/

    command error_t Init.init() {
        unsigned char i;
        uint32_t curTime = call Timer.getNow();

        processingConnections = FALSE;

        for ( i = 0; i < MAX_SINKS; i++ ) {
            fairnessTable[i].active = FALSE;
            fairnessTable[i].sinkID = 0;
            fairnessTable[i].totalWeight = 0;
            fairnessTable[i].firstPacketSent = FALSE;
            fairnessTable[i].lastPacketSentTime = curTime;
            fairnessTable[i].localPeriod = 0;
            fairnessTable[i].remoteNode = AM_BROADCAST_ADDR;
            fairnessTable[i].remoteNormalizedPeriod = 0;
            fairnessTable[i].validTime = curTime;

            FairnessLocalPart[i].LastSink = 1;
            FairnessLocalPart[i].SinkID = 0;
            FairnessLocalPart[i].NormalizedPeriod = 0;
            FairnessLocalPart[i].LimitingNode = AM_BROADCAST_ADDR;
        }

        return SUCCESS;
    }


    command error_t StdControl.start() {
        return SUCCESS;
    }


    command error_t StdControl.stop() {
        call WmtpLocalManagementDataHandler.GenerateHeader( NULL, 0, FALSE );

        return SUCCESS;
    }


    command error_t WmtpFeatureConfigurationHandler.InitializeConfiguration( WmtpConnectionSpecification_t *ConnectionSpecification ) {
        ConnectionSpecification->FeatureSpecification.Fairness.SinkID = 0;
        ConnectionSpecification->FeatureSpecification.Fairness.Weight = 0;

        return SUCCESS;
    }


    command error_t WmtpFeatureConfigurationHandler.GenerateConfigurationData( WmtpConnectionSpecification_t *ConnectionSpecification, void *ConfigurationData, uint8_t *ConfigurationDataSize ) {
        if ( ConnectionSpecification &&
                ConnectionSpecification->FeatureSpecification.Fairness.Weight > 0 ) {
            WmtpFairnessConfigurationPart_t *FairnessConfigurationPart = ConfigurationData;

            FairnessConfigurationPart->SinkID = ConnectionSpecification->FeatureSpecification.Fairness.SinkID;
            FairnessConfigurationPart->Weight = ConnectionSpecification->FeatureSpecification.Fairness.Weight;

            *ConfigurationDataSize = sizeof( WmtpFairnessConfigurationPart_t );

            return SUCCESS;
        } else {
            return FAIL;
        }
    }


    command error_t WmtpFeatureConfigurationHandler.HandleConfigurationData( void *ConfigurationData, uint8_t *ConfigurationDataSize, WmtpConnectionSpecification_t *ConnectionSpecification ) {
        WmtpFairnessConfigurationPart_t *FairnessConfigurationPart = ConfigurationData;

        ConnectionSpecification->FeatureSpecification.Fairness.SinkID = FairnessConfigurationPart->SinkID;
        ConnectionSpecification->FeatureSpecification.Fairness.Weight = FairnessConfigurationPart->Weight;

        *ConfigurationDataSize = sizeof( WmtpFairnessConfigurationPart_t );

        return SUCCESS;
    }


    command error_t WmtpFeatureConfigurationHandler.GetConfigurationDataSize( void *ConfigurationData, uint8_t *ConfigurationDataSize ) {
        *ConfigurationDataSize = sizeof( WmtpFairnessConfigurationPart_t );

        return SUCCESS;
    }


    void processConnections() {
        WmtpConnectionSpecification_t *i;
        uint32_t curTime = call Timer.getNow();
        uint32_t *nextTimer = NULL;
        uint8_t state;
        uint8_t e = 0;

        processingConnections = TRUE;

        // Iterate through all open connections.

        if ( ! call OpenConnectionsQueue.empty() ) {
            do {
                i = call OpenConnectionsQueue.element( e++ );
                // Check if the connection has fairness, is local, is inactive and has an expired wake up timer.
                if ( i->FeatureSpecification.Fairness.Weight > 0 &&
                        i->IsLocal &&
                        call WmtpTrafficShaper.GetConnectionState( i, &state ) == SUCCESS &&
                        state == FALSE &&
                        curTime >= (call WmtpConnectionScratchPadHook.GetConnectionScratchPad( i ))->Fairness.WakeUpTime ) {
                    // Restart the connection.
                    dbg( "WMTP", "WmtpFairnessHandlerP: Connection wake up timer expired. Starting connection.\n" );
                    call WmtpTrafficShaper.StartConnection( i );
                }

            } while ( e < call OpenConnectionsQueue.size() );
        }

        // Cancel any previous timer.
        call Timer.stop();

        // Iterate through all open connections.

        if ( ! call OpenConnectionsQueue.empty() ) {
            e = 0;
            do {
                i = call OpenConnectionsQueue.element( e++ );
                // Check if the connection has fairness, is local, is inactive and has a pending wake up timer.
                if ( i->FeatureSpecification.Fairness.Weight > 0 &&
                        i->IsLocal &&
                        call WmtpTrafficShaper.GetConnectionState( i, &state ) == SUCCESS &&
                        state == FALSE &&
                        curTime < (call WmtpConnectionScratchPadHook.GetConnectionScratchPad( i ))->Fairness.WakeUpTime ) {
                    // Check if the next timer has already been defined.
                    if ( nextTimer == NULL ) {
                        // Define it.
                        nextTimer = &((call WmtpConnectionScratchPadHook.GetConnectionScratchPad( i ))->Fairness.WakeUpTime);
                    } else {
                        // Check if we've found a new timer that's earlier.
                        if ( *nextTimer > (call WmtpConnectionScratchPadHook.GetConnectionScratchPad( i ))->Fairness.WakeUpTime )
                            nextTimer = &((call WmtpConnectionScratchPadHook.GetConnectionScratchPad( i ))->Fairness.WakeUpTime);
                    }
                }

            } while ( e < call OpenConnectionsQueue.size() );

            // Check if a next timer was found.
            if ( nextTimer != NULL )
                call Timer.startOneShot( *nextTimer - call Timer.getNow() );
            else
                dbg( "WMTP", "WmtpFairnessHandlerP: No wake up timers left.\n" );
        }

        processingConnections = FALSE;
    }


    event error_t WmtpLocalManagementDataHandler.HeaderBroadcasted() {
        uint8_t i;

        dbg( "WMTP", "WmtpFairnessHandlerP: Broadcasting local management data:\n" );

        for ( i = 0; i < MAX_SINKS; i++ ) {
            if ( fairnessTable[i].active ) {
                if ( fairnessTable[i].localPeriod * fairnessTable[i].totalWeight >= fairnessTable[i].remoteNormalizedPeriod ) {
                    dbg( "WMTP",
                         "WmtpFairnessHandlerP:    SID: %d, NP: %d, LN: %d\n",
                         fairnessTable[i].sinkID,
                         fairnessTable[i].localPeriod * fairnessTable[i].totalWeight,
                         TOS_NODE_ID );
                } else {
                    dbg( "WMTP",
                         "WmtpFairnessHandlerP:    SID: %d, NP: %d, LN: %d\n",
                         fairnessTable[i].sinkID,
                         fairnessTable[i].remoteNormalizedPeriod,
                         fairnessTable[i].remoteNode );
                }
            }
        }
        return SUCCESS;
    }


    event error_t WmtpLocalManagementDataHandler.HandleHeader( uint16_t SourceAddress, void *HeaderData, uint8_t *HeaderDataSize ) {
        WmtpFairnessLocalPart_t *receivedFairnessLocalPart = HeaderData;
        uint32_t curTime = call Timer.getNow();
        uint32_t validTime = curTime + REMOTE_NORMALIZED_PERIOD_VALIDITY;

        // Iterate through all sinks specified in header.
        while ( TRUE ) {
            // Ignore periods that are limited by ourselves.
            if ( receivedFairnessLocalPart->LimitingNode != TOS_NODE_ID ) {
                uint8_t ftl = getFairnessTableLine( receivedFairnessLocalPart->SinkID );
                // Update the remote period cache if the new value is higher
                // than the previous one or is limited by the same node or if
                // the old value has expired.
                if ( receivedFairnessLocalPart->NormalizedPeriod >= fairnessTable[ftl].remoteNormalizedPeriod ||
                        receivedFairnessLocalPart->LimitingNode == fairnessTable[ftl].remoteNode ||
                        fairnessTable[ftl].validTime < curTime ) {
                    dbg( "WMTP", "WmtpFairnessHandlerP: Replacing remote normalized period to %d, limited by %d.\n", receivedFairnessLocalPart->NormalizedPeriod, receivedFairnessLocalPart->LimitingNode );

                    fairnessTable[ftl].remoteNormalizedPeriod = receivedFairnessLocalPart->NormalizedPeriod;
                    fairnessTable[ftl].remoteNode = receivedFairnessLocalPart->LimitingNode;
                    //TODO: Expire old remote data.
                    fairnessTable[ftl].validTime = validTime;
                }
            }

            if ( receivedFairnessLocalPart->LastSink != 0 )
                break;

            receivedFairnessLocalPart = (WmtpFairnessLocalPart_t *) (((uint8_t *) receivedFairnessLocalPart) + sizeof( WmtpFairnessLocalPart_t ));
        }

        generateLocalManagementData();

        *HeaderDataSize = (((uint8_t *) receivedFairnessLocalPart) - ((uint8_t *) HeaderData)) + sizeof( WmtpFairnessLocalPart_t );

        return SUCCESS;
    }


    event error_t WmtpTrafficShaper.NewPacket( WmtpQueueElement_t *Packet ) {
        if ( Packet &&
                Packet->ConnectionSpecification &&
                Packet->ConnectionSpecification->FeatureSpecification.Fairness.Weight > 0 &&
                Packet->ConnectionSpecification->IsLocal ) {
            uint8_t ftl = getFairnessTableLine( Packet->ConnectionSpecification->FeatureSpecification.Fairness.SinkID );

            if ( ftl < MAX_SINKS ) {
                dbg( "WMTP", "WmtpFairnessHandlerP: Packet generated with fairness. Stopping local connection.\n" );
                call WmtpTrafficShaper.StopConnection( Packet->ConnectionSpecification );

                dbg( "WMTP", "WmtpFairnessHandlerP: Reseting timer on local connection.\n" );
                if ( fairnessTable[ftl].localPeriod * fairnessTable[ftl].totalWeight >= fairnessTable[ftl].remoteNormalizedPeriod ) {
                    (call WmtpConnectionScratchPadHook.GetConnectionScratchPad( Packet->ConnectionSpecification ))->Fairness.WakeUpTime =
                        call Timer.getNow() + fairnessTable[ftl].localPeriod *
                        fairnessTable[ftl].totalWeight /
                        Packet->ConnectionSpecification->FeatureSpecification.Fairness.Weight *
                        CONNECTION_TIMER_MULTIPLYING_FACTOR;
                } else {
                    (call WmtpConnectionScratchPadHook.GetConnectionScratchPad( Packet->ConnectionSpecification ))->Fairness.WakeUpTime =
                        call Timer.getNow() + fairnessTable[ftl].remoteNormalizedPeriod /
                        Packet->ConnectionSpecification->FeatureSpecification.Fairness.Weight *
                        CONNECTION_TIMER_MULTIPLYING_FACTOR;
                }

                if ( ! processingConnections )
                    processConnections();
            }

            return SUCCESS;
        } else {
            return FAIL;
        }
    }


    event error_t WmtpTrafficShaper.SendingPacket( WmtpQueueElement_t *Packet ) {
        return SUCCESS;
    }


    event error_t WmtpTrafficShaper.DroppingPacket( WmtpQueueElement_t *Packet ) {
        if ( Packet &&
                Packet->ConnectionSpecification &&
                Packet->ConnectionSpecification->FeatureSpecification.Fairness.Weight > 0 ) {
            uint8_t ftl = getFairnessTableLine( Packet->ConnectionSpecification->FeatureSpecification.Fairness.SinkID );
            uint32_t curTime = call Timer.getNow();

            dbg( "WMTP", "WmtpFairnessHandlerP: Sending packet on connection with fairness. Updating local period.\n" );
            if ( ftl < MAX_SINKS ) {
                if ( fairnessTable[ftl].firstPacketSent ) {
                    if ( fairnessTable[ftl].localPeriod != 0 ) {
                        fairnessTable[ftl].localPeriod =
                            (fairnessTable[ftl].localPeriod * (100 - NEW_LOCAL_PERIOD_WEIGHT) +
                             (curTime - fairnessTable[ftl].lastPacketSentTime ) *
                             NEW_LOCAL_PERIOD_WEIGHT) / 100;
                    } else {
                        fairnessTable[ftl].localPeriod = curTime - fairnessTable[ftl].lastPacketSentTime;
                    }

                    dbg( "WMTP", "WmtpFairnessHandlerP: New local period: %d.\n", fairnessTable[ftl].localPeriod );
                } else {
                    fairnessTable[ftl].firstPacketSent = TRUE;
                }
                fairnessTable[ftl].lastPacketSentTime = curTime;

                generateLocalManagementData();
            }

            return SUCCESS;
        } else {
            return FAIL;
        }
    }


    event error_t WmtpTrafficShaper.ConnectionOpened( WmtpConnectionSpecification_t *ConnectionSpecification ) {
        if ( ConnectionSpecification &&
                ConnectionSpecification->FeatureSpecification.Fairness.Weight > 0 ) {
            uint8_t ftl = getFairnessTableLine( ConnectionSpecification->FeatureSpecification.Fairness.SinkID );

            dbg( "WMTP", "WmtpFairnessHandlerP: Got new connection with fairness.\n" );

            // Initialize the connection scratch pad.
            if ( ConnectionSpecification->IsLocal )
                (call WmtpConnectionScratchPadHook.GetConnectionScratchPad( ConnectionSpecification ))->Fairness.WakeUpTime = call Timer.getNow();

            // Update the total weight.
            if ( ftl < MAX_SINKS ) {
                fairnessTable[ftl].totalWeight += ConnectionSpecification->FeatureSpecification.Fairness.Weight;

                generateLocalManagementData();
            }

            return SUCCESS;
        } else {
            return FAIL;
        }
    }


    event error_t WmtpTrafficShaper.ConnectionClosed( WmtpConnectionSpecification_t *ConnectionSpecification ) {
        if ( ConnectionSpecification &&
                ConnectionSpecification->FeatureSpecification.Fairness.Weight > 0 ) {
            uint8_t ftl = getFairnessTableLine( ConnectionSpecification->FeatureSpecification.Fairness.SinkID );

            dbg( "WMTP", "WmtpFairnessHandlerP: Got new connection with fairness.\n" );

            // Update the total weight.
            if ( ftl < MAX_SINKS ) {
                fairnessTable[ftl].totalWeight -= ConnectionSpecification->FeatureSpecification.Fairness.Weight;

                generateLocalManagementData();
            }

            return SUCCESS;
        } else {
            return FAIL;
        }
    }


    event error_t WmtpTrafficShaper.ConnectionReconfigured( WmtpConnectionSpecification_t *ConnectionSpecification ) {
        if ( ConnectionSpecification ) {
            WmtpConnectionSpecification_t *i;
            uint8_t ftl = getFairnessTableLine( ConnectionSpecification->FeatureSpecification.Fairness.SinkID );
            uint8_t e = 0;

            dbg( "WMTP", "WmtpFairnessHandlerP: Connection reconfigured, recalculating total weight for sink %d.\n", ConnectionSpecification->FeatureSpecification.Fairness.SinkID );

            // Recalculate the total weight.
            if ( ftl < MAX_SINKS ) {
                fairnessTable[ftl].totalWeight = 0;

                // Iterate through all open connections.

                if ( ! call OpenConnectionsQueue.empty() ) {
                    do {
                        i = call OpenConnectionsQueue.element( e++ );
                        // Check if the connection is associated to this particular sink.
                        if ( i->FeatureSpecification.Fairness.SinkID == ConnectionSpecification->FeatureSpecification.Fairness.SinkID )
                            fairnessTable[ftl].totalWeight += i->FeatureSpecification.Fairness.Weight;

                    } while ( e < call OpenConnectionsQueue.size() );
                }

                generateLocalManagementData();
            }

            return SUCCESS;
        } else {
            return FAIL;
        }
    }


    event void Timer.fired() {
        dbg( "WMTP", "WmtpFairnessHandlerP: Timer fired. Processing connections.\n" );

        processConnections();
    }


    event error_t WmtpCoreMonitor.ServiceRegistered( WmtpServiceSpecification_t *ServiceSpecification ) {
        // Check if a packet sink was registered.
        if ( ServiceSpecification->ServiceType == WMTP_SERVICETYPE_SINKID ) {
            dbg( "WMTP", "WmtpFairnessHandlerP: Found local sink: %d.\n", ServiceSpecification->ServiceData.SinkID.Value );

            // Reserve a line in the fairness table.
            getFairnessTableLine( ServiceSpecification->ServiceData.SinkID.Value );

            generateLocalManagementData();
        }

        return SUCCESS;
    }


    event error_t WmtpCoreMonitor.ServiceCanceled( WmtpServiceSpecification_t *ServiceSpecification ) {
        // Check if a packet sink was canceled.
        if ( ServiceSpecification->ServiceType == WMTP_SERVICETYPE_SINKID ) {
            uint8_t ftl;

            dbg( "WMTP", "WmtpFairnessHandlerP: Lost local sink: %d.\n", ServiceSpecification->ServiceData.SinkID.Value );

            // Get the corresponding line in the fairness table.
            ftl = getFairnessTableLine( ServiceSpecification->ServiceData.SinkID.Value );
            // Delete the line.
            fairnessTable[ftl].active = FALSE;

            generateLocalManagementData();
        }

        return SUCCESS;
    }


    event error_t WmtpCoreMonitor.ConnectionOpened( WmtpConnectionSpecification_t *ConnectionSpecification ) {
        return SUCCESS;
    }
    event error_t WmtpCoreMonitor.ConnectionClosed( WmtpConnectionSpecification_t *ConnectionSpecification ) {
        return SUCCESS;
    }
    event error_t WmtpCoreMonitor.GeneratedPacket( WmtpQueueElement_t *Packet ) {
        return SUCCESS;
    }
    event error_t WmtpCoreMonitor.ReceivedPacket( WmtpQueueElement_t *Packet ) {
        return SUCCESS;
    }
    event error_t WmtpCoreMonitor.DeliveringPacket( WmtpQueueElement_t *Packet ) {
        return SUCCESS;
    }
    event error_t WmtpCoreMonitor.SendingPacket( WmtpQueueElement_t *Packet ) {
        return SUCCESS;
    }
    event error_t WmtpCoreMonitor.DroppingPacket( WmtpQueueElement_t *Packet ) {
        return SUCCESS;
    }
    event error_t WmtpCoreMonitor.ReceivedWmtpMsg() {
        return SUCCESS;
    }
    event error_t WmtpCoreMonitor.SendingWmtpMsg() {
        return SUCCESS;
    }
    event error_t WmtpCoreMonitor.SentWmtpMsg() {
        return SUCCESS;
    }
}
