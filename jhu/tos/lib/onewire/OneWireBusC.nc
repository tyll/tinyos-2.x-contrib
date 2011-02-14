/* Copyright (c) 2010 Johns Hopkins University.
*  All rights reserved.
*
*  Permission to use, copy, modify, and distribute this software and its
*  documentation for any purpose, without fee, and without written
*  agreement is hereby granted, provided that the above copyright
*  notice, the (updated) modification history and the author appear in
*  all copies of this source code.
*
*  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS `AS IS'
*  AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
*  IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
*  ARE DISCLAIMED.  IN NO EVENT SHALL THE COPYRIGHT HOLDERS OR CONTRIBUTORS
*  BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
*  CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, LOSS OF USE, DATA,
*  OR PROFITS) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
*  CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
*  ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF
*  THE POSSIBILITY OF SUCH DAMAGE.
*/

/*
 * Exposes onewire communication primitives, resource for locking bus, and device discovery.
 * Components using this SHOULD observe the same usage rules specified in BasicOneWireBusC.
 * This wires the device-mapper into the Resource and OneWireMaster interfaces necessary for proper locking of the bus when discovery and device-specific operations both occur.
 *
 * @author Doug Carlson <carlson@cs.jhu.edu>
 * @modified 6/16/10
 */
configuration OneWireBusC {
  provides {
    interface OneWireMaster;
    interface Resource[uint8_t clientId];
    interface OneWireDeviceMapper;
  }
} implementation {
  enum {
    MAPPER_CLIENT_ID = unique(ONEWIRE_CLIENT),
  };

  components OneWireDeviceMapperC,
    BasicOneWireBusC;
  
  OneWireMaster = BasicOneWireBusC.OneWireMaster;
  Resource = BasicOneWireBusC.Resource;
    
  OneWireDeviceMapper = OneWireDeviceMapperC;
  
  OneWireDeviceMapperC.OneWireMaster -> BasicOneWireBusC.OneWireMaster;
  OneWireDeviceMapperC.Resource -> BasicOneWireBusC.Resource[MAPPER_CLIENT_ID];
}
