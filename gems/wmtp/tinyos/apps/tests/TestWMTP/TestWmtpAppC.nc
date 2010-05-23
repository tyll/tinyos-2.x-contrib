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
 * WMTP Test.
 *
 * This component tests the WMTP transport protocol and it's features.
 * The following tests are available:
 *
 *  Tests:
 *  Test case 1: Connectionless routing;
 *  Test case 2: Connection-oriented routing;
 *  Test case 3: Throttling.
 *  Test case 4: Flow control.
 *  Test case 5: Congestion control.
 *  Test case 6: Fairness.
 *  Test case 7: Basic Reliability.
 *  Test case 8: QoS.
 *  Test case 9: 6 node simulation.
 *  Test case 10: 6 node flow control simulation.
 *
 *  Extra:
 *  Test performance 1: TOSSIM.
 *  Test performance 2: Mote deployment.
 *
 * @author Luis D. Pedrosa <luis.pedrosa@tagus.ist.utl.pt>
 * @author Hugo Freire <hugo.freire@ist.utl.pt> (port to TinyOS 2.x)
**/

#ifndef TEST_CASE
#define TEST_CASE 8
#endif // #ifndef TEST_CASE

#ifndef TEST_CASE
#error TEST_CASE not defined!
#endif // #ifndef TEST_CASE

#ifndef TEST_PERFORMANCE
//#define TEST_PERFORMANCE 1
#endif // #ifndef TEST_PERFORMANCE

#if (TEST_PERFORMANCE == 2)
#include "StorageVolumes.h"
#endif // (TEST_PERFORMANCE == 2)

#define WmtpTestApplicationID 0
#define WmtpPerformanceLoggerApplicationID 1

configuration TestWmtpAppC {
} implementation {
    components MainC;
#if (TEST_CASE == 1)
    components TestWmtpConnectionlessRoutingP as TestWmtpP;
#elif (TEST_CASE == 2) // #if (TEST_CASE == 1)    
    components TestWmtpConnectionOrientedRoutingP as TestWmtpP;
#elif (TEST_CASE == 3) // #if (TEST_CASE == 2)
    components TestWmtpThrottlingP as TestWmtpP;
#elif (TEST_CASE == 4) // #if (TEST_CASE == 3)    
    components TestWmtpFlowCtrlP as TestWmtpP;
#elif (TEST_CASE == 5) // #if (TEST_CASE == 4)
    components TestWmtpCongestionCtrlP as TestWmtpP;
#elif (TEST_CASE == 6) // #if (TEST_CASE == 5)    
    components TestWmtpFairnessP as TestWmtpP;
#elif (TEST_CASE == 7) // #if (TEST_CASE == 6)   
    components TestWmtpReliabilityP as TestWmtpP;
#elif (TEST_CASE == 8) // #if (TEST_CASE == 7)    
    components TestWmtpQoSP as TestWmtpP;
#elif (TEST_CASE == 9) // #if (TEST_CASE == 8)
    components TestWmtp6NodeSimP as TestWmtpP;
#elif (TEST_CASE == 10) // #if (TEST_CASE == 9)
    components TestWmtp6NodeFlowCtrlSimP as TestWmtpP;
#endif // #if (TEST_CASE == 10)
    TestWmtpP -> MainC.Boot;

    components new TimerMilliC() as Timer;
    TestWmtpP.Timer -> Timer;

    components LedsC;
    TestWmtpP.Leds  -> LedsC;

    components WmtpC;
    TestWmtpP.WmtpControl -> WmtpC.StdControl;
    TestWmtpP.WmtpConnectionManager -> WmtpC.WmtpConnectionManager[WmtpTestApplicationID];
    TestWmtpP.WmtpSendMsg -> WmtpC.WmtpSendMsg[WmtpTestApplicationID];
    TestWmtpP.WmtpReceiveMsg -> WmtpC.WmtpReceiveMsg[WmtpTestApplicationID];

		TestWmtpP.WmtpCoreMonitor -> WmtpC.WmtpCoreMonitor;

#if (TEST_PERFORMANCE == 1)
    components TestWmtpPerformanceReporterP;
    TestWmtpPerformanceReporterP -> MainC.Boot;
    MainC.SoftwareInit -> TestWmtpPerformanceReporterP;

    components new TimerMilliC() as TimerPerformance;
    TestWmtpPerformanceReporterP.Timer -> TimerPerformance;

    TestWmtpPerformanceReporterP -> WmtpC.WmtpCoreMonitor;
    
#elif (TEST_PERFORMANCE == 2)// #if (TEST_PERFORMANCE == 1)
    components TestWmtpPerformanceLoggerP;
    TestWmtpPerformanceLoggerP -> MainC.Boot;
    MainC.SoftwareInit -> TestWmtpPerformanceLoggerP;

    components new TimerMilliC() as TimerLogger, new TimerMilliC() as TimerLoggerSender;
    TestWmtpPerformanceLoggerP.LogTimer -> TimerLogger;
    TestWmtpPerformanceLoggerP.SendTimer -> TimerLoggerSender;

    TestWmtpPerformanceLoggerP.WmtpConnectionManager -> WmtpC.WmtpConnectionManager[WmtpPerformanceLoggerApplicationID];
    TestWmtpPerformanceLoggerP.WmtpSendMsg -> WmtpC.WmtpSendMsg[WmtpPerformanceLoggerApplicationID];
    TestWmtpPerformanceLoggerP.WmtpReceiveMsg -> WmtpC.WmtpReceiveMsg[WmtpPerformanceLoggerApplicationID];
    TestWmtpPerformanceLoggerP -> WmtpC.WmtpCoreMonitor;

    TestWmtpPerformanceLoggerP.Leds  -> LedsC;

    components new LogStorageC(VOLUME_TESTWMTP, FALSE);
    TestWmtpPerformanceLoggerP.LogWrite -> LogStorageC;
    TestWmtpPerformanceLoggerP.LogRead -> LogStorageC;

    components SerialActiveMessageC;
    TestWmtpPerformanceLoggerP.SerialControl -> SerialActiveMessageC;
    TestWmtpPerformanceLoggerP.SerialSend -> SerialActiveMessageC.AMSend[AM_EVENTMSG];

    TestWmtpP.LoggerControl -> TestWmtpPerformanceLoggerP.StdControl;
#endif // #if (TEST_PERFORMANCE == 2)
}
