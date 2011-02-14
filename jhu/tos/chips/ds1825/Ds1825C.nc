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
 * Wiring for DS 1825 driver.
 * This wires together:
 * <ul>
 *   <li> Ds1825P: the actual driver code</li>
 *   <li> Ds1825TypeP: code to identify instances of DS1825's on the bus by ID</li>
 *   <li> A new OneWireBusClientC and associated interfaces: to let the driver interact with the bus correctly. </li>
 * </ul>
 * Future onewire drivers should look basically like this. The user
 * application can look for new devices by calling the
 * OneWireDeviceInstanceManager.refresh() command. It then uses
 * OneWireDeviceInstanceManager.setDevice(id) to select the device to
 * be read. It then calls the Read.Read() command exposed here, which
 * will obtain a lock on the bus and perform the necessary
 * communications to read the temperature. After this, it will release
 * the bus and signal ReadDone.
 *
 * @author Doug Carlson <carlson@cs.jhu.edu>
 * @modified 6/16/10 initial revision
 */

configuration Ds1825C {
  provides {
    interface OneWireDeviceInstanceManager;
    interface Read<int16_t>;
  } 
} 
implementation {
  components new TimerMilliC();

  //device-type specific code 
  components Ds1825P,
    Ds1825TypeP;

  OneWireDeviceInstanceManager = OneWireBusClientC.OneWireDeviceInstanceManager;
  Read = Ds1825P.Read;

  //wire device-type specific code to bus interfaces for resource, master, and device instance manager.
  //this will be mainly boilerplate 
  //TODO: this should be a parameter or at least a compiler flag
  components new OneWireBusClientC(5);
  Ds1825P.Resource -> OneWireBusClientC.Resource;
  Ds1825P.OneWireMaster -> OneWireBusClientC.OneWireMaster;
  Ds1825P.OneWireDeviceInstanceManager -> OneWireBusClientC.OneWireDeviceInstanceManager;

  Ds1825P.Timer -> TimerMilliC;
 
  //wire device-type identifier into client
  OneWireBusClientC.OneWireDeviceType -> Ds1825TypeP;
}
