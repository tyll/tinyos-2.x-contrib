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
 * Implementation of basic onewire device-type specific device instance manager. 
 * Up to maxDevices can be supported at once. If more are attached to the bus, they will not be addressable.
 * 
 * @author Doug Carlson <carlson@cs.jhu.edu>
 * @modified 6/16/10
 */
generic module OneWireDeviceInstanceManagerP(uint8_t maxDevices) {
  provides {
    interface OneWireDeviceInstanceManager;
  }
  uses {
    interface OneWireDeviceType;
    interface OneWireDeviceMapper;
  }
} 
implementation {
  uint8_t numDevices;
  onewire_t devices[maxDevices];
  onewire_t curDevice; 

  command uint8_t OneWireDeviceInstanceManager.numDevices() {
    return numDevices;
  }

  command onewire_t OneWireDeviceInstanceManager.getDevice(uint8_t deviceIndex) {
    return devices[deviceIndex];
  }

  command error_t OneWireDeviceInstanceManager.setDevice(onewire_t id) {
    curDevice = id;
    return SUCCESS;
  }

  command onewire_t OneWireDeviceInstanceManager.currentDevice() {
    return curDevice;
  }

  command error_t OneWireDeviceInstanceManager.refresh() {
    return call OneWireDeviceMapper.refresh();
  }

  task void checkDevicesTask() {
    int k;
    onewire_t cur;
    bool devicesChanged = FALSE;
    uint8_t lastNumDevices = numDevices;

    numDevices = 0;
    
    for (k=0; k < call OneWireDeviceMapper.numDevices() && numDevices < MAX_ONEWIRE_DEVICES_PER_TYPE; k++) {
      cur = call OneWireDeviceMapper.getDevice(k);
      //printf("Checking %llx: %x\n\r", cur.id, call OneWireDeviceType.isOfType(cur));
      if (call OneWireDeviceType.isOfType(cur)) {
        if (devices[numDevices].id != cur.id) {
          devicesChanged = TRUE;
        }
        devices[numDevices++] = cur;
      }
    }
    devicesChanged = devicesChanged || (numDevices != lastNumDevices);

    signal OneWireDeviceInstanceManager.refreshDone(SUCCESS, devicesChanged);
  } 

  event void OneWireDeviceMapper.refreshDone(error_t result, bool devicesChanged) {
//    printf("OWDM.refreshDone %x %x\n\r", result, devicesChanged);
    if (devicesChanged && result == SUCCESS) {
      post checkDevicesTask();
    }
    else {
      signal OneWireDeviceInstanceManager.refreshDone(result, FALSE);
    }
  }
}
