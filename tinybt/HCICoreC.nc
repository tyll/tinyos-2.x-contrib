/**
 *
 * $Rev:: 112         $:  Revision of last commit
 * $Author$:  Author of last commit
 * $Date$:  Date of last commit
 *
 **/
/*
 * Copyright (C) 2002
 *
 *  This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
 *
 * Authors:     Martin Leopold (leopold@diku.dk)
 *    Date:     Dec 2002
 */

#include "btpackets.h"
#ifndef BT_PACKET_QUEUE_SIZE
#define BT_PACKET_QUEUE_SIZE 6
#endif
configuration HCICoreC {
  provides interface Bluetooth;
}
implementation
{
  components HCICoreM, HCIPacketC, PlatformBluetoothC, 
  new PointerQueueC(gen_pkt,BT_PACKET_QUEUE_SIZE) as SendQueueC,
  new PointerQueueC(gen_pkt,BT_PACKET_QUEUE_SIZE) as RecvQueueC, LedsC;
  //components new TimerMilliC() as Timer;
  Bluetooth = HCICoreM.Bluetooth;
  HCICoreM.HCIPacket -> HCIPacketC;
  HCICoreM.BluetoothVendor -> PlatformBluetoothC;
  HCICoreM -> LedsC.Leds;
  //HCICoreM.Timer0 -> Timer;
  HCICoreM.SendQueue -> SendQueueC;
  HCICoreM.RecvQueue -> RecvQueueC;
}
