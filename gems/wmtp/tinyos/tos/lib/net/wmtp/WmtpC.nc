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

configuration WmtpC {
    provides {
        interface StdControl;
        interface WmtpConnectionManager[uint8_t ApplicationID];
        interface WmtpSendMsg[uint8_t ApplicationID];
        interface WmtpReceiveMsg[uint8_t ApplicationID];
        interface WmtpCoreMonitor;
    }
} implementation {
    components WmtpCoreP,
#ifdef WMTP_USEQUEUEAVAILABILITYSHAPER
    WmtpQueueAvailabilityShaperP,
#endif // #ifdef WMTP_USEQUEUEAVAILABILITYSHAPER
#ifdef WMTP_USETHROTTLING
    WmtpThrottlingHandlerP,
#endif // #ifdef WMTP_USETHROTTLING
#ifdef WMTP_USEFLOWCONTROL
    WmtpFlowControlHandlerP,
#endif // #ifdef WMTP_USEFLOWCONTROL
#ifdef WMTP_USECONGESTIONCONTROL
    WmtpCongestionControlHandlerP,
#endif // #ifdef WMTP_USECONGESTIONCONTROL
#ifdef WMTP_USEFAIRNESS
    WmtpFairnessHandlerP,
#endif // #ifdef WMTP_USEFAIRNESS
#ifdef WMTP_USEWMTPRELIABILITY
    WmtpReliabilityHandlerP,
#endif // #ifdef WMTP_USEWMTPRELIABILITY
#ifdef WMTP_USETOSMULTIHOPROUTER
    WmtpTOSMultihopRouterP,
    MultiHopLEPSM,
#endif // #ifdef WMTP_USETOSMULTIHOPROUTER
#ifdef WMTP_USEDECREMENTADDRESSROUTER
    WmtpDecrementAddressRouterP,
#endif // #ifdef WMTP_USEDECREMENTADDRESSROUTER
#ifdef WMTP_USESOURCEROUTEDCONNECTIONS
    WmtpSourceRoutedConnectionEstablishmentHandlerP,
#endif // #ifdef WMTP_USESOURCEROUTEDCONNECTIONS
#ifdef WMTP_USETAGROUTER
    WmtpTagRouterP,
#endif // #ifdef WMTP_USETAGROUTER
#ifdef WMTP_USEPACKETSINKSERVICESPECIFICATION
    WmtpPacketSinkServiceSpecificationHandlerP,
#endif // #ifdef WMTP_USEPACKETSINKSERVICESPECIFICATION
#ifdef WMTP_USESINKIDSERVICESPECIFICATION
    WmtpSinkIDServiceSpecificationHandlerP,
#endif // #ifdef WMTP_USESINKIDSERVICESPECIFICATION
#ifdef WMTP_USESTATISTICALQOSINDICATOR
    WmtpStatisticalQoSIndicatorP,
#endif // #ifdef WMTP_USESTATISTICALQOSINDICATOR

    //SendDelayP,
    new TimerMilliC() as DelayTimer,
    //TimerC, SimpleTime;
    new AMSenderC(AM_WMTPMSG),
    //new AMReceiverC(AM_WMTPMSG),
    new AMSnoopingReceiverC(AM_WMTPMSG),
    ActiveMessageC,
    new TimerMilliC() as CoreTimer,
    LocalTimeMilliC,
    new QueueC(WmtpConnectionSpecification_t *, NUM_CONNECTION_SPECIFICATIONS) as IdleConnectionsQueueC,
    new QueueC(WmtpConnectionSpecification_t *, NUM_CONNECTION_SPECIFICATIONS) as OpenConnectionsQueueC,
    new QueueC(WmtpServiceSpecification_t *, NUM_REGISTERED_SERVICES) as RegisteredServicesQueueC,
    new QueueC(WmtpConnectionSpecification_t *, NUM_QOS_CONNECTIONS) as ReservedQoSConnectionsQueueC,
    new QueueC(WmtpQueueElement_t *, NUM_QUEUE_ELEMENTS) as IdleQueueElementsQueueC,
    new QueueC(WmtpQueueElement_t *, NUM_QUEUE_ELEMENTS) as CoreQueueC,

    new PoolC(WmtpConnectionSpecification_t, NUM_CONNECTION_SPECIFICATIONS) as IdleConnectionsPoolC,
    new PoolC(WmtpQueueElement_t, NUM_QUEUE_ELEMENTS) as IdleQueueElementsPoolC,

    MainC;
    MainC.SoftwareInit -> WmtpCoreP.Init;
    WmtpCoreP.Boot -> MainC;
    StdControl = WmtpCoreP;
    WmtpConnectionManager = WmtpCoreP.WmtpConnectionManager;
    WmtpSendMsg = WmtpCoreP.WmtpSendMsg;
    WmtpReceiveMsg = WmtpCoreP.WmtpReceiveMsg;
    WmtpCoreMonitor = WmtpCoreP.WmtpCoreMonitor;


#ifdef WMTP_USESOURCEROUTEDCONNECTIONS
    components new QueueC(WmtpConnectionSpecification_t *, NUM_PENDING_CONNECTION_REQUESTS) as PendingSourceRoutedConnectionRequestsQueueC;
    WmtpCoreP.WmtpConnectionEstablishmentHandler[WMTP_PATHTYPE_SOURCEROUTEDCONNECTION] <- WmtpSourceRoutedConnectionEstablishmentHandlerP;
    WmtpSourceRoutedConnectionEstablishmentHandlerP.WmtpTagRouter -> WmtpTagRouterP;
    WmtpCoreP.WmtpLocalManagementDataHandler[WMTP_LOCALPART_SRCROUTEDCONN] <- WmtpSourceRoutedConnectionEstablishmentHandlerP;
    WmtpSourceRoutedConnectionEstablishmentHandlerP.PendingConnectionRequestsQueue -> PendingSourceRoutedConnectionRequestsQueueC;
#endif // #ifdef WMTP_USESOURCEROUTEDCONNECTIONS

#ifdef WMTP_USEPACKETSINKSERVICESPECIFICATION
    WmtpCoreP.WmtpServiceSpecificationDataHandler[WMTP_SERVICETYPE_PACKETSINK] -> WmtpPacketSinkServiceSpecificationHandlerP;
#endif // #ifdef WMTP_USEPACKETSINKSERVICESPECIFICATION

#ifdef WMTP_USESINKIDSERVICESPECIFICATION
    WmtpCoreP.WmtpServiceSpecificationDataHandler[WMTP_SERVICETYPE_SINKID] -> WmtpSinkIDServiceSpecificationHandlerP;
#endif // #ifdef WMTP_USESINKIDSERVICESPECIFICATION

#ifdef WMTP_USETAGROUTER
    components new TimerMilliC() as TagRouterTimer,
    new QueueC(TagAssociation_t *, MAX_TAG_ASSOCIATIONS) as IdleTagAssociationsQueueC,
    new QueueC(TagAssociation_t *, MAX_TAG_ASSOCIATIONS) as ActiveTagAssociationsQueueC;
    WmtpCoreP.ComponentInit -> WmtpTagRouterP;
    WmtpCoreP.WmtpMultihopRouter[WMTP_ROUTERTYPE_TAGROUTER] -> WmtpTagRouterP;
    WmtpTagRouterP.Timer -> TagRouterTimer;
    WmtpTagRouterP.IdleTagAssociationsQueue -> IdleTagAssociationsQueueC;
    WmtpTagRouterP.ActiveTagAssociationsQueue -> ActiveTagAssociationsQueueC;
#endif // #ifdef WMTP_USETAGROUTER

#ifdef WMTP_USETOSMULTIHOPROUTER
    WmtpCoreP.ComponentControl -> WmtpTOSMultihopRouterP;
    WmtpCoreP.WmtpConnectionEstablishmentHandler[WMTP_PATHTYPE_TOSMULTIHOP] <- WmtpTOSMultihopRouterP;
    WmtpCoreP.WmtpMultihopRouter[WMTP_ROUTERTYPE_TOSMULTIHOP] -> WmtpTOSMultihopRouterP;
    WmtpTOSMultihopRouterP.MultiHopRouterControl -> MultiHopLEPSM;
    WmtpTOSMultihopRouterP.RouteControl -> MultiHopLEPSM;
    MultiHopLEPSM.Timer -> TimerC.Timer[unique("Timer")];
    MultiHopLEPSM.ReceiveMsg -> RComm.ReceiveMsg[AM_MULTIHOPMSG];
    MultiHopLEPSM.SendMsg -> SComm.SendMsg[AM_MULTIHOPMSG];
#endif // #ifdef WMTP_USETOSMULTIHOPROUTER

#ifdef WMTP_USEQUEUEAVAILABILITYSHAPER
    WmtpCoreP.ComponentInit -> WmtpQueueAvailabilityShaperP;
    WmtpCoreP.WmtpFeatureConfigurationHandler[WMTP_CONFPART_QUEUEAVAILABILITYSHAPER] -> WmtpQueueAvailabilityShaperP;
    WmtpCoreP.WmtpTrafficShaper[unique( "WmtpTrafficShaper" )] <- WmtpQueueAvailabilityShaperP;
    WmtpCoreP.WmtpCoreMonitor <- WmtpQueueAvailabilityShaperP;
    WmtpQueueAvailabilityShaperP.OpenConnectionsQueue -> OpenConnectionsQueueC;
#endif // #ifdef WMTP_USEQUEUEAVAILABILITYSHAPER

#ifdef WMTP_USETHROTTLING
    components new TimerMilliC() as ThrottlingTimer;
    WmtpCoreP.ComponentInit -> WmtpThrottlingHandlerP;
    WmtpCoreP.WmtpFeatureConfigurationHandler[WMTP_CONFPART_THROTTLING] -> WmtpThrottlingHandlerP;
    WmtpCoreP.WmtpTrafficShaper[unique( "WmtpTrafficShaper" )] <- WmtpThrottlingHandlerP;
    WmtpCoreP.WmtpConnectionScratchPadHook[unique( "WMTPConnectionScratchPad" )] <- WmtpThrottlingHandlerP;
    WmtpThrottlingHandlerP.Timer -> ThrottlingTimer;
    WmtpThrottlingHandlerP.OpenConnectionsQueue -> OpenConnectionsQueueC;
#endif // #ifdef WMTP_USETHROTTLING

#ifdef WMTP_USEFLOWCONTROL
    components new TimerMilliC() as FlowControlTimer;
    WmtpCoreP.ComponentInit -> WmtpFlowControlHandlerP;
    WmtpCoreP.WmtpFeatureConfigurationHandler[WMTP_CONFPART_FLOWCTRL] -> WmtpFlowControlHandlerP;
    WmtpCoreP.WmtpTrafficShaper[unique( "WmtpTrafficShaper" )] <- WmtpFlowControlHandlerP;
    WmtpCoreP.WmtpConnectionScratchPadHook[unique( "WMTPConnectionScratchPad" )] <- WmtpFlowControlHandlerP;
    WmtpFlowControlHandlerP.Timer -> FlowControlTimer;
    WmtpFlowControlHandlerP.OpenConnectionsQueue -> OpenConnectionsQueueC;
#endif // #ifdef WMTP_USEFLOWCONTROL

#ifdef WMTP_USECONGESTIONCONTROL
    WmtpCoreP.ComponentControl -> WmtpCongestionControlHandlerP;
    WmtpCoreP.ComponentInit -> WmtpCongestionControlHandlerP;
    WmtpCoreP.WmtpFeatureConfigurationHandler[WMTP_CONFPART_CONGCTRL] -> WmtpCongestionControlHandlerP;
    WmtpCoreP.WmtpLocalManagementDataHandler[WMTP_LOCALPART_CONGCTRL] <- WmtpCongestionControlHandlerP;
    WmtpCoreP.WmtpTrafficShaper[unique( "WmtpTrafficShaper" )] <- WmtpCongestionControlHandlerP;
    WmtpCoreP.WmtpCoreMonitor <- WmtpCongestionControlHandlerP;
    WmtpCongestionControlHandlerP.LocalTime -> LocalTimeMilliC;
    WmtpCongestionControlHandlerP.OpenConnectionsQueue -> OpenConnectionsQueueC;
    WmtpCongestionControlHandlerP.CoreQueue -> CoreQueueC;
#endif // #ifdef WMTP_USECONGESTIONCONTROL

#ifdef WMTP_USEFAIRNESS
    components new TimerMilliC() as FairnessTimer;
    WmtpCoreP.ComponentControl -> WmtpFairnessHandlerP;
    WmtpCoreP.ComponentInit -> WmtpFairnessHandlerP;
    WmtpCoreP.WmtpFeatureConfigurationHandler[WMTP_CONFPART_FAIRNESS] -> WmtpFairnessHandlerP;
    WmtpCoreP.WmtpLocalManagementDataHandler[WMTP_LOCALPART_FAIRNESS] <- WmtpFairnessHandlerP;
    WmtpCoreP.WmtpTrafficShaper[unique( "WmtpTrafficShaper" )] <- WmtpFairnessHandlerP;
    WmtpCoreP.WmtpConnectionScratchPadHook[unique( "WMTPConnectionScratchPad" )] <- WmtpFairnessHandlerP;
    WmtpCoreP.WmtpCoreMonitor <- WmtpFairnessHandlerP;
    WmtpFairnessHandlerP.Timer -> FairnessTimer;
    WmtpFairnessHandlerP.OpenConnectionsQueue -> OpenConnectionsQueueC;
#endif // #ifdef WMTP_USEFAIRNESS

#ifdef WMTP_USEWMTPRELIABILITY
    components new TimerMilliC() as ReliabilityTimer;
    WmtpCoreP.ComponentControl -> WmtpReliabilityHandlerP;
    WmtpCoreP.ComponentInit -> WmtpReliabilityHandlerP;
    WmtpCoreP.WmtpFeatureConfigurationHandler[WMTP_CONFPART_WMTPRELIABILITY] -> WmtpReliabilityHandlerP;
    WmtpCoreP.WmtpLocalManagementDataHandler[WMTP_LOCALPART_WMTPRELIABILITY] <- WmtpReliabilityHandlerP;
    WmtpCoreP.WmtpConnectionManagementDataHandler[WMTP_CONNPART_WMTPRELIABILITY] <- WmtpReliabilityHandlerP;
    WmtpCoreP.WmtpTrafficShaper[unique( "WmtpTrafficShaper" )] <- WmtpReliabilityHandlerP;
    WmtpCoreP.WmtpReliableTransmissionHook[WMTP_RELIABILITYHANDLER_WMTPRELIABILITY] <- WmtpReliabilityHandlerP;
    WmtpCoreP.WmtpPacketScratchPadHook[unique( "WMTPPacketScratchPad" )] <- WmtpReliabilityHandlerP;
    WmtpReliabilityHandlerP.Timer -> ReliabilityTimer;
    WmtpReliabilityHandlerP.CoreQueue -> CoreQueueC;
#endif // #ifdef WMTP_USEWMTPRELIABILITY

#ifdef WMTP_USEDECREMENTADDRESSROUTER
    components new QueueC(WmtpConnectionSpecification_t *, NUM_PENDING_CONNECTION_REQUESTS) as PendingDecrementAddressConnectionRequestsQueueC;
    WmtpCoreP.ComponentInit -> WmtpDecrementAddressRouterP;
    WmtpCoreP.WmtpConnectionEstablishmentHandler[WMTP_PATHTYPE_DECREMENTADDRESS] <- WmtpDecrementAddressRouterP;
    WmtpCoreP.WmtpMultihopRouter[WMTP_ROUTERTYPE_DECREMENTADDRESSROUTER] -> WmtpDecrementAddressRouterP;
    WmtpDecrementAddressRouterP.RegisteredServicesQueue -> RegisteredServicesQueueC;
    WmtpDecrementAddressRouterP.PendingConnectionRequestsQueue -> PendingDecrementAddressConnectionRequestsQueueC;
#endif // #ifdef WMTP_USEDECREMENTADDRESSROUTER

#ifdef WMTP_USESTATISTICALQOSINDICATOR
    WmtpCoreP.ComponentControl -> WmtpStatisticalQoSIndicatorP;
    WmtpCoreP.WmtpLinkLayerQoSIndicator -> WmtpStatisticalQoSIndicatorP;
    WmtpCoreP.WmtpCoreMonitor <- WmtpStatisticalQoSIndicatorP;
    WmtpStatisticalQoSIndicatorP.LocalTime -> LocalTimeMilliC;
#endif // #ifdef WMTP_USESTATISTICALQOSINDICATOR

    WmtpCoreP.LocalManagementDataTimer -> CoreTimer;
    WmtpCoreP.SendWmtpMsg -> AMSenderC;
    //WmtpCoreP.SendWmtpMsg -> SendDelayP.InSendMsg;
    //SendDelayP.OutSendMsg -> AMSenderC;
    //SendDelayP.Timer -> DelayTimer;
    WmtpCoreP.PacketWmtpMsg -> AMSnoopingReceiverC;
    WmtpCoreP.AMPacket -> AMSnoopingReceiverC;
    WmtpCoreP.ReceiveWmtpMsg -> AMSnoopingReceiverC;
    WmtpCoreP.RadioControl -> ActiveMessageC;
    WmtpCoreP.OpenConnectionsQueue -> OpenConnectionsQueueC;
    WmtpCoreP.RegisteredServicesQueue -> RegisteredServicesQueueC;
    WmtpCoreP.ReservedQoSConnectionsQueue -> ReservedQoSConnectionsQueueC;
    WmtpCoreP.CoreQueue -> CoreQueueC;
    WmtpCoreP.IdleConnectionsPool -> IdleConnectionsPoolC;
    WmtpCoreP.IdleQueueElementsPool -> IdleQueueElementsPoolC;
}
