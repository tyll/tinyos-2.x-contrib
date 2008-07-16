/*
 * "Copyright (c) 2008 The Regents of the University  of California.
 * All rights reserved."
 *
 * Permission to use, copy, modify, and distribute this software and its
 * documentation for any purpose, without fee, and without written agreement is
 * hereby granted, provided that the above copyright notice, the following
 * two paragraphs and the author appear in all copies of this software.
 *
 * IN NO EVENT SHALL THE UNIVERSITY OF CALIFORNIA BE LIABLE TO ANY PARTY FOR
 * DIRECT, INDIRECT, SPECIAL, INCIDENTAL, OR CONSEQUENTIAL DAMAGES ARISING OUT
 * OF THE USE OF THIS SOFTWARE AND ITS DOCUMENTATION, EVEN IF THE UNIVERSITY OF
 * CALIFORNIA HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 *
 * THE UNIVERSITY OF CALIFORNIA SPECIFICALLY DISCLAIMS ANY WARRANTIES,
 * INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY
 * AND FITNESS FOR A PARTICULAR PURPOSE.  THE SOFTWARE PROVIDED HEREUNDER IS
 * ON AN "AS IS" BASIS, AND THE UNIVERSITY OF CALIFORNIA HAS NO OBLIGATION TO
 * PROVIDE MAINTENANCE, SUPPORT, UPDATES, ENHANCEMENTS, OR MODIFICATIONS."
 *
 */

/*
 * This is not the interface applications want to use.  They probably
 * want to use UDPClientC or UDPServerC.
 *
 * This component provides parameterized send and receive interfaces
 * which take care of the UDP checksum.
 *
 */

configuration UDPC {
  provides {
    interface SplitControl;
    interface UDPReceive[uint16_t port];
    interface UDPSend[uint16_t port];
    interface BufferPool;
    interface BasicPacket;
    interface UDPPacket;
  }
  
} implementation {
  components UDPP, IPDispatchC, IPAddressC;


  SplitControl = IPDispatchC;
  UDPReceive   = UDPP;
  UDPSend      = UDPP;
  BufferPool   = UDPP;
  BasicPacket  = UDPP;
  UDPPacket    = UDPP;

  UDPP.IPAddress  -> IPAddressC;
  UDPP.SubSend    -> IPDispatchC.IPSend[IANA_UDP];
  UDPP.SubReceive -> IPDispatchC.IPReceive[IANA_UDP];
  UDPP.SubPacket  -> IPDispatchC.BasicPacket;
  UDPP.SubBufPool -> IPDispatchC.BufferPool[IANA_UDP];
}
