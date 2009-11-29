/*
 * IMPORTANT: READ BEFORE DOWNLOADING, COPYING, INSTALLING OR USING.  By
 * downloading, copying, installing or using the software you agree to
 * this license.  If you do not agree to this license, do not download,
 * install, copy or use the software.
 *
 * Copyright (c) 2006-2008 Vrije Universiteit Amsterdam and
 * Development Laboratories (DevLab), Eindhoven, the Netherlands.
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 * - Redistributions of source code must retain the above copyright
 *   notice, this list of conditions, the author, and the following
 *   disclaimer.
 * - Redistributions in binary form must reproduce the above copyright
 *   notice, this list of conditions, the author, and the following disclaimer
 *   in the documentation and/or other materials provided with the
 *   distribution.
 * - Neither the name of the Vrije Universiteit Amsterdam, nor the name of
 *   DevLab, nor the names of their contributors may be used to endorse or
 *   promote products derived from this software without specific prior
 *   written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 * ``AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
 * FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL VRIJE
 * UNIVERSITEIT AMSTERDAM, DEVLAB, OR THEIR CONTRIBUTORS BE LIABLE FOR
 * ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
 * STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
 * OF THE POSSIBILITY OF SUCH DAMAGE.
 *
 * Authors: Konrad Iwanicki
 * CVS id: $Id$
 */
#include "HierarchicalClusteringDemo.h"



/**
 * The configuration for the hierarchical clustering demo application.
 *
 * @author Konrad Iwanicki &lt;iwanicki@few.vu.nl&gt;
 */
configuration HierarchicalClusteringDemoAppC {
}
implementation {

    // --------------------------- Components -----------------------------
    // General-purpose software components.
    components HierarchicalClusteringDemoP as AppC;

    components MainC;

    components RandomMlcgC as RandomC;

    components new GenericPoolOfMessagesC(CONF_APP_MAINTENANCE_MESSAGE_POOL_SIZE)
            as MaintenanceMessagePoolC;
    components new GenericPoolOfMessagesC(CONF_APP_ROUTING_MESSAGE_POOL_SIZE)
            as RoutingMessagePoolC;
    components new GenericQueueC(
            hcdemo_fqueue_entry_t, CONF_APP_ROUTING_MESSAGE_POOL_SIZE)
            as RoutingMessageQueueC;
    components new TimerMilliC() as RoutingMessageTimerC;

    components new GenericQueueC(
            hcdemo_serial_queue_entry_t, CONF_APP_MAX_ROUTING_FLOWS_FOR_STATS_QUEUE)
            as SerialSendQueueC;
    components new GenericPoolOfMessagesC(CONF_APP_ROUTING_STATS_MESSAGE_POOL_SIZE)
            as SerialSendMessagePoolC;


    // Hardware components except communication stacks.
    components LedsC;
    components new TimerMilliC() as RoutingLEDSTimerC;


#ifdef TOSSIM
#ifdef __SIM_KI__H__
    components new TimerMilliC() as TOSSIMRouteRequestPollTimerP;
#endif
#endif


    // Radio communication stacks.
    components ActiveMessageC as RadioC;
#ifdef HC_DEMO_USE_LPL
    // Using low-power listening.

#if (defined(PLATFORM_MICA)) || (defined(PLATFORM_MICA2))
    components CC1000CsmaRadioC as LplRadioC;
#elif (defined(PLATFORM_MICAZ)) || (defined(PLATFORM_TELOSB))
    components CC2420ActiveMessageC as LplRadioC;
#else
    #error Unknown low-power listening component for the selected platform!
#endif

#else
    // No low-power listening is being used.
#endif

    components new AMSenderC(HCDEMO_ROUTING_MSG) as RoutingSenderC,
            new AMReceiverC(HCDEMO_ROUTING_MSG) as RoutingReceiverC;

#if defined(CH_MAINTPROT_PERIODIC_HIERARHICAL_BEACONING)
    // 1. periodic hierarchical beaconing.
    components new AMSenderC(HCDEMO_PHB_BEACON_MSG) as BeaconSenderC,
            new AMReceiverC(HCDEMO_PHB_BEACON_MSG) as BeaconReceiverC;

    components new TrafficStatsAMSendC() as TrafficStatsAMSendWholeStackC;
    components new TrafficStatsReceiveC() as TrafficStatsReceiveWholeStackC;

    components new SequencingC() as SequencingC;

    components LinkEstimatorC;

    components new TrafficStatsAMSendC() as TrafficStatsAMSendCHProtocolOnlyC;
    components new TrafficStatsReceiveC() as TrafficStatsReceiveCHProtocolOnlyC;

    components PeriodicHierarchicalBeaconingC as CHMaintenanceEngineC;

#elif defined(CH_MAINTPROT_PERIODIC_HIERARHICAL_DISTANCE_VECTOR)
    // 2. periodic hierarchical beaconing.
    components new AMSenderC(HCDEMO_PHDV_HEARTBEAT_MSG) as HeartbeatSenderC,
            new AMReceiverC(HCDEMO_PHDV_HEARTBEAT_MSG) as HeartbeatReceiverC;

    components new TrafficStatsAMSendC() as TrafficStatsAMSendWholeStackC;
    components new TrafficStatsReceiveC() as TrafficStatsReceiveWholeStackC;

    components new SequencingC() as SequencingC;

    components LinkEstimatorC;

    components new TrafficStatsAMSendC() as TrafficStatsAMSendCHProtocolOnlyC;
    components new TrafficStatsReceiveC() as TrafficStatsReceiveCHProtocolOnlyC;

    components PeriodicHierarchicalDistanceVectorC as CHMaintenanceEngineC;

#elif defined(CH_MAINTPROT_HYBRID_BEACONING_AND_DISTANCE_VECTOR)
    // 3. the hybrid maintenance protocol.
    components new AMSenderC(HCDEMO_HYBRID_BEACON_MSG) as BeaconSenderC,
            new AMReceiverC(HCDEMO_HYBRID_BEACON_MSG) as BeaconReceiverC;

    components new TrafficStatsAMSendC() as TrafficStatsAMSendWholeBeaconingStackC;
    components new TrafficStatsReceiveC() as TrafficStatsReceiveWholeBeaconingStackC;

    components new TrafficStatsAMSendC() as TrafficStatsAMSendCHBeaconingProtocolOnlyC;
    components new TrafficStatsReceiveC() as TrafficStatsReceiveCHBeaconingProtocolOnlyC;

    components new AMSenderC(HCDEMO_HYBRID_HEARTBEAT_MSG) as HeartbeatSenderC,
            new AMReceiverC(HCDEMO_HYBRID_HEARTBEAT_MSG) as HeartbeatReceiverC;

    components new TrafficStatsAMSendC() as TrafficStatsAMSendWholeHeartbeatStackC;
    components new TrafficStatsReceiveC() as TrafficStatsReceiveWholeHeartbeatStackC;

    components new SequencingC() as SequencingC;

    components LinkEstimatorC;

    components new TrafficStatsAMSendC() as TrafficStatsAMSendCHHeartbeatProtocolOnlyC;
    components new TrafficStatsReceiveC() as TrafficStatsReceiveCHHeartbeatProtocolOnlyC;

    components HybridBeaconingAndPeriodicDistanceVectorC as CHMaintenanceEngineC;

#else
#error Undefined cluster hierarchy maintenance protocol!
#endif



    // Serial communication stack for statistics.
    components SerialActiveMessageC as SerialC;

    components HierarchicalClusteringDemoSerialMediatorP as SerialMediatorC;
    components HierarchicalClusteringDemoStatsP as SerialStatsC;

    components new TrafficStatsContainerC() as WholeProtocolStackStatsC;
    components new TrafficStatsContainerC() as CHProtocolOnlyStatsC;



    // ----------------------------- Wirings ------------------------------
    // Initialization and functional wirings.
    AppC.Boot -> MainC;

    AppC.RandomInit -> RandomC;
    AppC.Random -> RandomC;

    AppC.MaintenanceMessagePoolInit -> MaintenanceMessagePoolC;
    AppC.RoutingMessagePoolInit -> RoutingMessagePoolC;
    AppC.RoutingMessagePool -> RoutingMessagePoolC;
    AppC.RoutingMessageQueue -> RoutingMessageQueueC;
    AppC.RoutingMessageTimer -> RoutingMessageTimerC;

    AppC.RoutingStatsMessagePoolInit -> SerialSendMessagePoolC;
    AppC.RoutingStatsMessagePool -> SerialSendMessagePoolC;

    AppC.SequencingInit -> SequencingC;

    AppC.LEInit -> LinkEstimatorC;
    AppC.LEConfig -> LinkEstimatorC;
    AppC.LEControl -> LinkEstimatorC;

    AppC.CHEngineInit -> CHMaintenanceEngineC;
    AppC.CHEngineConfig -> CHMaintenanceEngineC;
    AppC.CHEngineControl -> CHMaintenanceEngineC;

    AppC.ClusterHierarchy -> CHMaintenanceEngineC;
    AppC.MessageLabel -> CHMaintenanceEngineC;

    AppC.RadioControl -> RadioC;
#ifdef HC_DEMO_USE_LPL
    AppC.RadioLPL -> LplRadioC;
#endif

    AppC.RoutingPacket -> RoutingSenderC;
    AppC.RoutingAMPacket -> RoutingSenderC;
    AppC.RoutingSend -> RoutingSenderC;
    AppC.RoutingReceive -> RoutingReceiverC;
    AppC.RoutingAcks -> RoutingSenderC;

    AppC.SerialControl -> SerialC;
    AppC.StatsReporting -> SerialStatsC;

    AppC.LEDs -> LedsC;
    AppC.RoutingLEDSTimer -> RoutingLEDSTimerC;


    LinkEstimatorC.SubSequencing -> SequencingC;
    LinkEstimatorC.SubSequencingPacket -> SequencingC;


    CHMaintenanceEngineC.NeighborTable -> LinkEstimatorC;
    CHMaintenanceEngineC.NeighborTableIter -> LinkEstimatorC;

    CHMaintenanceEngineC.MessagePool -> MaintenanceMessagePoolC;

    CHMaintenanceEngineC.Random -> RandomC;



    // Radio communication stacks.

#if defined(CH_MAINTPROT_PERIODIC_HIERARHICAL_BEACONING)
    // 1. periodic hierarchical beaconing.
    TrafficStatsAMSendWholeStackC.SubAMSend -> BeaconSenderC;
    TrafficStatsAMSendWholeStackC.SubPacket -> BeaconSenderC;
    TrafficStatsAMSendWholeStackC.StatsContainer ->
        WholeProtocolStackStatsC.OutgoingTrafficStats;
    TrafficStatsReceiveWholeStackC.SubReceive -> BeaconReceiverC;
    TrafficStatsReceiveWholeStackC.StatsContainer ->
        WholeProtocolStackStatsC.IncomingTrafficStats;

    SequencingC.SubReceive -> TrafficStatsReceiveWholeStackC;
    SequencingC.SubAMSend -> TrafficStatsAMSendWholeStackC;
    SequencingC.SubPacket -> TrafficStatsAMSendWholeStackC;
    SequencingC.SubAMPacket -> BeaconSenderC;

    LinkEstimatorC.SubSnoopAndReceive -> SequencingC.Receive;
    LinkEstimatorC.SubAMSend -> SequencingC.AMSend;
    LinkEstimatorC.SubPacket -> SequencingC.Packet;
    LinkEstimatorC.SubAMPacket -> SequencingC.AMPacket;

    TrafficStatsAMSendCHProtocolOnlyC.SubAMSend -> LinkEstimatorC;
    TrafficStatsAMSendCHProtocolOnlyC.SubPacket -> LinkEstimatorC;
    TrafficStatsAMSendCHProtocolOnlyC.StatsContainer ->
        CHProtocolOnlyStatsC.OutgoingTrafficStats;
    TrafficStatsReceiveCHProtocolOnlyC.SubReceive -> LinkEstimatorC;
    TrafficStatsReceiveCHProtocolOnlyC.StatsContainer ->
        CHProtocolOnlyStatsC.IncomingTrafficStats;

    CHMaintenanceEngineC.BeaconPacket -> TrafficStatsAMSendCHProtocolOnlyC;
    CHMaintenanceEngineC.BeaconAMPacket -> LinkEstimatorC;
    CHMaintenanceEngineC.BeaconReceive -> TrafficStatsReceiveCHProtocolOnlyC;
    CHMaintenanceEngineC.BeaconSend -> TrafficStatsAMSendCHProtocolOnlyC;

#elif defined(CH_MAINTPROT_PERIODIC_HIERARHICAL_DISTANCE_VECTOR)
    // 2. periodic hierarchical distance-vector.
    TrafficStatsAMSendWholeStackC.SubAMSend -> HeartbeatSenderC;
    TrafficStatsAMSendWholeStackC.SubPacket -> HeartbeatSenderC;
    TrafficStatsAMSendWholeStackC.StatsContainer ->
        WholeProtocolStackStatsC.OutgoingTrafficStats;
    TrafficStatsReceiveWholeStackC.SubReceive -> HeartbeatReceiverC;
    TrafficStatsReceiveWholeStackC.StatsContainer ->
        WholeProtocolStackStatsC.IncomingTrafficStats;

    SequencingC.SubReceive -> TrafficStatsReceiveWholeStackC;
    SequencingC.SubAMSend -> TrafficStatsAMSendWholeStackC;
    SequencingC.SubPacket -> TrafficStatsAMSendWholeStackC;
    SequencingC.SubAMPacket -> HeartbeatSenderC;

    LinkEstimatorC.SubSnoopAndReceive -> SequencingC.Receive;
    LinkEstimatorC.SubAMSend -> SequencingC.AMSend;
    LinkEstimatorC.SubPacket -> SequencingC.Packet;
    LinkEstimatorC.SubAMPacket -> SequencingC.AMPacket;

    TrafficStatsAMSendCHProtocolOnlyC.SubAMSend -> LinkEstimatorC;
    TrafficStatsAMSendCHProtocolOnlyC.SubPacket -> LinkEstimatorC;
    TrafficStatsAMSendCHProtocolOnlyC.StatsContainer ->
        CHProtocolOnlyStatsC.OutgoingTrafficStats;
    TrafficStatsReceiveCHProtocolOnlyC.SubReceive -> LinkEstimatorC;
    TrafficStatsReceiveCHProtocolOnlyC.StatsContainer ->
        CHProtocolOnlyStatsC.IncomingTrafficStats;

    CHMaintenanceEngineC.HeartbeatPacket -> TrafficStatsAMSendCHProtocolOnlyC;
    CHMaintenanceEngineC.HeartbeatAMPacket -> LinkEstimatorC;
    CHMaintenanceEngineC.HeartbeatReceive -> TrafficStatsReceiveCHProtocolOnlyC;
    CHMaintenanceEngineC.HeartbeatSend -> TrafficStatsAMSendCHProtocolOnlyC;

#elif defined(CH_MAINTPROT_HYBRID_BEACONING_AND_DISTANCE_VECTOR)
    // 3. the hybrid maintenance protocol.
    //   a. beaconing stack
    TrafficStatsAMSendWholeBeaconingStackC.SubAMSend -> BeaconSenderC;
    TrafficStatsAMSendWholeBeaconingStackC.SubPacket -> BeaconSenderC;
    TrafficStatsAMSendWholeBeaconingStackC.StatsContainer ->
        WholeProtocolStackStatsC.OutgoingTrafficStats;
    TrafficStatsReceiveWholeBeaconingStackC.SubReceive -> BeaconReceiverC;
    TrafficStatsReceiveWholeBeaconingStackC.StatsContainer ->
        WholeProtocolStackStatsC.IncomingTrafficStats;

    TrafficStatsAMSendCHBeaconingProtocolOnlyC.SubAMSend ->
        TrafficStatsAMSendWholeBeaconingStackC;
    TrafficStatsAMSendCHBeaconingProtocolOnlyC.SubPacket ->
        TrafficStatsAMSendWholeBeaconingStackC;
    TrafficStatsAMSendCHBeaconingProtocolOnlyC.StatsContainer ->
        CHProtocolOnlyStatsC.OutgoingTrafficStats;
    TrafficStatsReceiveCHBeaconingProtocolOnlyC.SubReceive ->
        TrafficStatsReceiveWholeBeaconingStackC;
    TrafficStatsReceiveCHBeaconingProtocolOnlyC.StatsContainer ->
        CHProtocolOnlyStatsC.IncomingTrafficStats;

    CHMaintenanceEngineC.BeaconPacket -> TrafficStatsAMSendCHBeaconingProtocolOnlyC;
    CHMaintenanceEngineC.BeaconAMPacket -> BeaconSenderC;
    CHMaintenanceEngineC.BeaconReceive -> TrafficStatsReceiveCHBeaconingProtocolOnlyC;
    CHMaintenanceEngineC.BeaconSend -> TrafficStatsAMSendCHBeaconingProtocolOnlyC;

    //   b. heartbeat stack
    TrafficStatsAMSendWholeHeartbeatStackC.SubAMSend -> HeartbeatSenderC;
    TrafficStatsAMSendWholeHeartbeatStackC.SubPacket -> HeartbeatSenderC;
    TrafficStatsAMSendWholeHeartbeatStackC.StatsContainer ->
        WholeProtocolStackStatsC.OutgoingTrafficStats;
    TrafficStatsReceiveWholeHeartbeatStackC.SubReceive -> HeartbeatReceiverC;
    TrafficStatsReceiveWholeHeartbeatStackC.StatsContainer ->
        WholeProtocolStackStatsC.IncomingTrafficStats;

    SequencingC.SubReceive -> TrafficStatsReceiveWholeHeartbeatStackC;
    SequencingC.SubAMSend -> TrafficStatsAMSendWholeHeartbeatStackC;
    SequencingC.SubPacket -> TrafficStatsAMSendWholeHeartbeatStackC;
    SequencingC.SubAMPacket -> HeartbeatSenderC;

    LinkEstimatorC.SubSnoopAndReceive -> SequencingC.Receive;
    LinkEstimatorC.SubAMSend -> SequencingC.AMSend;
    LinkEstimatorC.SubPacket -> SequencingC.Packet;
    LinkEstimatorC.SubAMPacket -> SequencingC.AMPacket;

    TrafficStatsAMSendCHHeartbeatProtocolOnlyC.SubAMSend -> LinkEstimatorC;
    TrafficStatsAMSendCHHeartbeatProtocolOnlyC.SubPacket -> LinkEstimatorC;
    TrafficStatsAMSendCHHeartbeatProtocolOnlyC.StatsContainer ->
        CHProtocolOnlyStatsC.OutgoingTrafficStats;
    TrafficStatsReceiveCHHeartbeatProtocolOnlyC.SubReceive -> LinkEstimatorC;
    TrafficStatsReceiveCHHeartbeatProtocolOnlyC.StatsContainer ->
        CHProtocolOnlyStatsC.IncomingTrafficStats;

    CHMaintenanceEngineC.HeartbeatPacket -> TrafficStatsAMSendCHHeartbeatProtocolOnlyC;
    CHMaintenanceEngineC.HeartbeatAMPacket -> LinkEstimatorC;
    CHMaintenanceEngineC.HeartbeatReceive -> TrafficStatsReceiveCHHeartbeatProtocolOnlyC;
    CHMaintenanceEngineC.HeartbeatSend -> TrafficStatsAMSendCHHeartbeatProtocolOnlyC;

#else
#error Undefined cluster hierarchy maintenance protocol!
#endif



    // Serial communication stack for statistics.
    SerialMediatorC.MsgQueue -> SerialSendQueueC;
    SerialMediatorC.SubAMSend -> SerialC.AMSend;

    AppC.RoutingStatsPacket -> SerialC;
    AppC.RoutingStatsSend ->
        SerialMediatorC.AMSend[AM_NX_HCDEMO_ROUTING_STEP_MSG_T];
    AppC.RoutingRequestReceive ->
        SerialC.Receive[AM_NX_HCDEMO_ROUTING_REQUEST_MSG_T];

    SerialStatsC.SerialPacket -> SerialC;
    SerialStatsC.SerialTrafficStatsSend ->
        SerialMediatorC.AMSend[AM_CH_STATS_REPORT_TRAFFIC_MSG];
    SerialStatsC.SerialLEStatsSend ->
        SerialMediatorC.AMSend[AM_CH_STATS_REPORT_LE_MSG];
    SerialStatsC.SerialCHStatsSend ->
        SerialMediatorC.AMSend[AM_CH_STATS_REPORT_AREAHIER_MSG];

    SerialStatsC.NeighborTable -> LinkEstimatorC;
    SerialStatsC.NeighborTableIter -> LinkEstimatorC;

    SerialStatsC.ClusterHierarchy -> CHMaintenanceEngineC.ClusterHierarchy;
    SerialStatsC.CHMsgLabel -> CHMaintenanceEngineC.MsgLabel;

    SerialStatsC.LETossimStats -> LinkEstimatorC;
    SerialStatsC.CHTossimStats -> CHMaintenanceEngineC;
    SerialStatsC.ProtocolOnlyOutgoingTrafficStats ->
        CHProtocolOnlyStatsC.OutgoingTrafficStats;
    SerialStatsC.ProtocolOnlyIncomingTrafficStats ->
        CHProtocolOnlyStatsC.IncomingTrafficStats;
    SerialStatsC.WholeStackOutgoingTrafficStats ->
        WholeProtocolStackStatsC.OutgoingTrafficStats;
    SerialStatsC.WholeStackIncomingTrafficStats ->
        WholeProtocolStackStatsC.IncomingTrafficStats;

#ifdef TOSSIM
#ifdef __SIM_KI__H__
    AppC.TOSSIMRouteRequestPollTimer -> TOSSIMRouteRequestPollTimerP;
#endif
#endif

}
