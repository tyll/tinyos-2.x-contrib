/*
  PlatformBluetoothC interfaces with the Platform's Bluetooth
  Copyright (C) 2009 Lee Seng Jea <sengjea@nus.edu.sg>

  This program is free software; you can redistribute it and/or modify
  it under the terms of the GNU General Public License as published by
  the Free Software Foundation; either version 2 of the License, or
  (at your option) any later version.

  This program is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  GNU General Public License for more details.

  You should have received a copy of the GNU General Public License
  along with this program; if not, write to the Free Software
  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
*/

/**
 * @author Lee Seng Jea <sengjea@nus.edu.sg>
 */


configuration PlatformBluetoothC
{
  provides interface SplitControl as DeviceControl;
  provides interface BluetoothVendor;
  provides interface StdControl as UartStdControl;
  provides interface UartByte;
  provides interface UartStream;
  provides interface GpioInterrupt as UartCTS;
  //provides interface GeneralIO as UartCTS;// For development Purposes only
  provides interface GeneralIO as UartRTS; 
}
implementation
{
  components Atm128Uart1C as Uart;
  components PlatformBluetoothP, MotePlatformC, MainC, HplAtm128GeneralIOC as IO, LatchC;
  components new TimerMilliC() as BusyTimer;
  components new Atm128GpioInterruptC() as UartCTSInterrupt, HplAtm128InterruptC;
  UartByte = Uart;
  UartStream = Uart;
  UartStdControl = Uart;
  UartCTS = UartCTSInterrupt;
  UartCTSInterrupt.Atm128Interrupt -> HplAtm128InterruptC.Int5;
  UartRTS = IO.PortD4;
  //UartCTS = IO.PortE5;
  DeviceControl = PlatformBluetoothP;
  PlatformBluetoothP.BTPower -> LatchC.BTPower;
  PlatformBluetoothP.BTReset -> LatchC.BTReset;
  PlatformBluetoothP.Boot -> MainC;
  PlatformBluetoothP.Timer -> BusyTimer;
  BluetoothVendor = PlatformBluetoothP.BluetoothVendor;
}

