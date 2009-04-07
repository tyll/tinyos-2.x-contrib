/// $Id$

/*
 * Copyright (c) 2004-2005 Crossbow Technology, Inc.  All rights reserved.
 *
 * Permission to use, copy, modify, and distribute this software and its
 * documentation for any purpose, without fee, and without written agreement is
 * hereby granted, provided that the above copyright notice, the following
 * two paragraphs and the author appear in all copies of this software.
 * 
 * IN NO EVENT SHALL CROSSBOW TECHNOLOGY OR ANY OF ITS LICENSORS BE LIABLE TO 
 * ANY PARTY FOR DIRECT, INDIRECT, SPECIAL, INCIDENTAL, OR CONSEQUENTIAL 
 * DAMAGES ARISING OUT OF THE USE OF THIS SOFTWARE AND ITS DOCUMENTATION, EVEN
 * IF CROSSBOW OR ITS LICENSOR HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH 
 * DAMAGE. 
 *
 * CROSSBOW TECHNOLOGY AND ITS LICENSORS SPECIFICALLY DISCLAIM ALL WARRANTIES,
 * INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY 
 * AND FITNESS FOR A PARTICULAR PURPOSE. THE SOFTWARE PROVIDED HEREUNDER IS 
 * ON AN "AS IS" BASIS, AND NEITHER CROSSBOW NOR ANY LICENSOR HAS ANY 
 * OBLIGATION TO PROVIDE MAINTENANCE, SUPPORT, UPDATES, ENHANCEMENTS, OR 
 * MODIFICATIONS.
 */
/**
 * @author Martin Turon <mturon@xbow.com>
 * @author David Gay
 */

/**
 * The M16c/62p uart ports.
 *
 * @author Henrik Makitaavola
 */
configuration HplM16c62pUartC
{
  provides
  {
    interface StdControl as Uart0TxControl;
    interface StdControl as Uart0RxControl;
    interface HplM16c62pUart as HplUart0;
    
    interface StdControl as Uart1TxControl;
    interface StdControl as Uart1RxControl;
    interface HplM16c62pUart as HplUart1;

    interface StdControl as Uart2TxControl;
    interface StdControl as Uart2RxControl;
    interface HplM16c62pUart as HplUart2;
  }
}
implementation
{
  components
      HplM16c62pGeneralIOC as IOs,
      HplM16c62pUartInterruptP as Irqs,
      McuSleepC,
      new HplM16c62pUartP(0,
                          (uint16_t)&U0TB.BYTE.U0TBL,
                          (uint16_t)&U0RB.BYTE.U0RBL,
                          (uint16_t)&U0BRG,
                          (uint16_t)&U0MR.BYTE,
                          (uint16_t)&U0C0.BYTE,
                          (uint16_t)&U0C1.BYTE,
                          (uint16_t)&S0TIC.BYTE,
                          (uint16_t)&S0RIC.BYTE) as HplUart0P,
      new HplM16c62pUartP(1,
                          (uint16_t)&U1TB.BYTE.U1TBL,
                          (uint16_t)&U1RB.BYTE.U1RBL,
                          (uint16_t)&U1BRG,
                          (uint16_t)&U1MR.BYTE,
                          (uint16_t)&U1C0.BYTE,
                          (uint16_t)&U1C1.BYTE,
                          (uint16_t)&S1TIC.BYTE,
                          (uint16_t)&S1RIC.BYTE) as HplUart1P,
      new HplM16c62pUartP(2,
                          (uint16_t)&U2TB.BYTE.U2TBL,
                          (uint16_t)&U2RB.BYTE.U2RBL,
                          (uint16_t)&U2BRG,
                          (uint16_t)&U2MR.BYTE,
                          (uint16_t)&U2C0.BYTE,
                          (uint16_t)&U2C1.BYTE,
                          (uint16_t)&S2TIC.BYTE,
                          (uint16_t)&S2RIC.BYTE) as HplUart2P;
  
  Uart0TxControl = HplUart0P.UartTxControl;
  Uart0RxControl = HplUart0P.UartRxControl;
  HplUart0 = HplUart0P.HplUart;
  HplUart0P.TxIO -> IOs.PortP63;
  HplUart0P.RxIO -> IOs.PortP62;
  HplUart0P.Irq -> Irqs.Uart0;
  HplUart0P.McuPowerState -> McuSleepC;

  Uart1TxControl = HplUart1P.UartTxControl;
  Uart1RxControl = HplUart1P.UartRxControl;
  HplUart1 = HplUart1P.HplUart;
  HplUart1P.TxIO -> IOs.PortP67;
  HplUart1P.RxIO -> IOs.PortP66;
  HplUart1P.Irq -> Irqs.Uart1;
  HplUart1P.McuPowerState -> McuSleepC;
  
  Uart2TxControl = HplUart2P.UartTxControl;
  Uart2RxControl = HplUart2P.UartRxControl;
  HplUart2 = HplUart2P.HplUart;
  HplUart2P.TxIO -> IOs.PortP70;
  HplUart2P.RxIO -> IOs.PortP71;
  HplUart2P.Irq -> Irqs.Uart2;
  HplUart2P.McuPowerState -> McuSleepC;
  
  //HplAtm128UartP.Atm128Calibrate -> PlatformC;
  
  components MainC;
  MainC.SoftwareInit -> HplUart0P.UartInit;
  MainC.SoftwareInit -> HplUart1P.UartInit;
  MainC.SoftwareInit -> HplUart2P.UartInit;
  
}
