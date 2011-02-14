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
/**
 * Basic device instance manager component, intended for use with a single device-type.
 * This will be wired automatically if the driver uses the OneWireBusClientC component.
 * maxDevices determines the maximum number of onewire devices which can be managed by this component.
 * If this number is exceeded, some devices may no longer be addressable.
 *
 * @author Doug Carlson <carlson@cs.jhu.edu>
 * @modified 6/16/10 first revision
 */
generic configuration OneWireDeviceInstanceManagerC(uint8_t maxDevices) {
  provides {
    interface OneWireDeviceInstanceManager;
  }
  uses {
    interface OneWireDeviceMapper;
    interface OneWireDeviceType;
  }
} 
implementation {
  components new OneWireDeviceInstanceManagerP(maxDevices);
  OneWireDeviceInstanceManager = OneWireDeviceInstanceManagerP;
  
  OneWireDeviceInstanceManagerP.OneWireDeviceMapper = OneWireDeviceMapper;
  OneWireDeviceInstanceManagerP.OneWireDeviceType = OneWireDeviceType;  
}
