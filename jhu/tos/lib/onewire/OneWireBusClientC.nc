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
/** Generic configuration to handle wiring for shared resource/shared
 * interfaces. The usage is roughly similar to the AMSenderC.
 * Device-type drivers SHOULD use a new instance of OneWireBusClientC
 * for all interactions with the bus. They SHOULD associate a
 * OneWireDeviceType with their OneWireBusClientC, which will allow
 * them to be notified when new device instances are present.  The
 * parameter indicates the maximum number of onewire devices of this
 * type which will ever be attached to the bus. Setting this to a low
 * value will save some RAM space, but will cause some devices to be
 * unaddressable if this limit is exceeded.
 *
 * @author Doug Carlson <carlson@cs.jhu.edu>
 * @modified 6/16/10
 */


generic configuration OneWireBusClientC(uint8_t maxDevices) {
  provides {
    interface OneWireMaster;
    interface Resource;
    interface OneWireDeviceInstanceManager;
  }
  uses {
    interface OneWireDeviceType;
  }
} 
implementation{
  components OneWireBusC,
    new OneWireDeviceInstanceManagerC(maxDevices);

  Resource = OneWireBusC.Resource[unique(ONEWIRE_CLIENT)];
  OneWireMaster = OneWireBusC.OneWireMaster;
  OneWireDeviceInstanceManager = OneWireDeviceInstanceManagerC;

  OneWireDeviceInstanceManagerC.OneWireDeviceType = OneWireDeviceType;
  OneWireDeviceInstanceManagerC.OneWireDeviceMapper -> OneWireBusC.OneWireDeviceMapper;
}
