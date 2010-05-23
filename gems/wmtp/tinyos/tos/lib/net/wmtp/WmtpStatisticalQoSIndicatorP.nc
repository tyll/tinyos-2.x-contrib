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
 * WMTP Statistical QoS Indicator.
 *
 * This component monitors the WMTP core to measure how long messages take to be
 * sent by the link layer. It then attempts to calculate statistically assured
 * QoS levels.
 *
 * @author Luis D. Pedrosa <luis.pedrosa@tagus.ist.utl.pt>
 * @author Hugo Freire <hugo.freire@ist.utl.pt> (port to TinyOS 2.x)
**/

#include "Wmtp.h"

#define NEW_AVG_WEIGHT 5
#define NEW_DEV_WEIGHT 5
#define DEV_MULTIPLIER 3

module WmtpStatisticalQoSIndicatorP {
    provides {
        interface Init;
        interface StdControl;
        interface WmtpLinkLayerQoSIndicator;
    }
    uses {
        interface WmtpCoreMonitor;
        //interface Time;
        //interface TimeUtil;
        interface LocalTime<TMilli>;
    }
} implementation {
    //uint32_t StartTime;
    uint32_t StartTime;
    uint16_t Avg;
    uint16_t Dev;
    uint16_t MaxSendDelay;


    /**
     * Initializes the module.
    **/

    command error_t Init.init() {
        Avg = 0;
        Dev = 0;
        MaxSendDelay = 0;

        return SUCCESS;
    }


    command error_t StdControl.start() {
        dbg( "WMTP", "WmtpStatisticalQoSIndicatorP: Data: Time;Delay;MaxSendDelay\n" );
        return SUCCESS;
    }


    command error_t StdControl.stop() {
        return SUCCESS;
    }


    command uint16_t WmtpLinkLayerQoSIndicator.GetMaxSendDelay() {
        return MaxSendDelay;
    }


    event error_t WmtpCoreMonitor.ServiceRegistered( WmtpServiceSpecification_t *ServiceSpecification ) {
        return SUCCESS;
    }
    event error_t WmtpCoreMonitor.ServiceCanceled( WmtpServiceSpecification_t *ServiceSpecification ) {
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
        StartTime = call LocalTime.get();

        return SUCCESS;
    }


    event error_t WmtpCoreMonitor.SentWmtpMsg() {
        //uint32_t curTime = call Time.get();
        uint32_t curTime = call LocalTime.get();
        //uint16_t delay = (uint16_t) call TimeUtil.low32( call TimeUtil.subtract( curTime, StartTime ) );
        uint16_t delay = (uint16_t) (curTime - StartTime);

        dbg( "WMTP", "WmtpStatisticalQoSIndicatorP: WmtpMsg sent. Delay = %d\n", delay );

        if ( Avg != 0 )
            Avg = ((100 - NEW_AVG_WEIGHT) * ((uint32_t) Avg) + NEW_AVG_WEIGHT * ((uint32_t) delay) + 50) / 100;
        else
            Avg = delay;
        Dev = ((100 - NEW_DEV_WEIGHT) * ((uint32_t) Dev) + NEW_DEV_WEIGHT * ((uint32_t) abs(delay - Avg)) + 50) / 100;
        MaxSendDelay = Avg + DEV_MULTIPLIER * Dev;

        dbg( "WMTP", "WmtpStatisticalQoSIndicatorP: Recalculated QoS metrics. MaxSendDelay = %d\n", MaxSendDelay );

        dbg( "WMTP", "WmtpStatisticalQoSIndicatorP: Data: %u;%u;%u;\n",
             curTime,
             delay,
             MaxSendDelay );

        return SUCCESS;
    }
}
