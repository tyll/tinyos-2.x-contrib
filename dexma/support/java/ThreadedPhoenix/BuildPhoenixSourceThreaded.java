/* 
 * "Copyright (c) 2008 Dexma Sensors, S.L.  
 * All rights reserved.
 *
 * Permission to use, copy, modify, and distribute this software and its
 * documentation for any purpose, without fee, and without written agreement is
 * hereby granted, provided that the above copyright notice, the following
 * two paragraphs and the author appear in all copies of this software.
 * 
 * IN NO EVENT SHALL DEXMA SENSORS SL BE LIABLE TO ANY PARTY FOR
 * DIRECT, INDIRECT, SPECIAL, INCIDENTAL, OR CONSEQUENTIAL DAMAGES ARISING OUT
 * OF THE USE OF THIS SOFTWARE AND ITS DOCUMENTATION, EVEN IF DEXMA SENSORS SL 
 * HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 * DEXMA SENSORS SL SPECIFICALLY DISCLAIMS ANY WARRANTIES,
 * INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY
 * AND FITNESS FOR A PARTICULAR PURPOSE.  THE SOFTWARE PROVIDED HEREUNDER IS
 * ON AN "AS IS" BASIS, AND DEXMA SENSORS SL HAS NO OBLIGATION TO
 * PROVIDE MAINTENANCE, SUPPORT, UPDATES, ENHANCEMENTS, OR MODIFICATIONS."
 */


package net.tinyos.packet;

import net.tinyos.util.Messenger;

public class BuildPhoenixSourceThreaded extends BuildSource {

	public static PhoenixSourceThreaded makePhoenix(String name,
			Messenger messages, Integer numThreads) {
		PacketSource source = makePacketSource(name);
		if (source == null) {
			return null;
		}
		return new PhoenixSourceThreaded(source, messages, numThreads);
	}
	
	public static PhoenixSourceThreaded makePhoenix(Messenger messages, Integer numThreads) {
		PacketSource source = makePacketSource();
		if (source == null) {
		    return null;
		}
		return new PhoenixSourceThreaded(source, messages, numThreads);
	}

}
