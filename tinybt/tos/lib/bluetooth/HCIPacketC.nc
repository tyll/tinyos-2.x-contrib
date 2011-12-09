/**
 *
 * $Rev:: 112         $:  Revision of last commit
 * $Author$:  Author of last commit
 * $Date$:  Date of last commit
 *
 **/
/*
  HCIPacket interface collects bytes from an Ericsson ROK 101 007 modules
  and provides a packet-oriented 
  Copyright (C) 2002 Martin Leopold <leopold@diku.dk>

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
#ifndef BT_BYTE_QUEUE_SIZE
#define BT_BYTE_QUEUE_SIZE 240
#endif
configuration HCIPacketC {
     provides interface HCIPacket;
}
implementation {
  components HCIPacketM,
    PlatformBluetoothC,
    new PointerQueueC(uint8_t,BT_BYTE_QUEUE_SIZE), LedsC;
  components new TimerMilliC() as Timer0;
  HCIPacket = HCIPacketM;
  HCIPacketM -> PlatformBluetoothC.UartStream;
  HCIPacketM -> PlatformBluetoothC.UartByte;
  HCIPacketM -> PlatformBluetoothC.UartStdControl;
  HCIPacketM -> PlatformBluetoothC.DeviceControl;
  HCIPacketM -> PlatformBluetoothC.UartCTS;
  HCIPacketM -> PlatformBluetoothC.UartRTS;
  HCIPacketM -> LedsC.Leds;
  HCIPacketM.ByteQueue -> PointerQueueC;
  HCIPacketM.Timer -> Timer0;
}
