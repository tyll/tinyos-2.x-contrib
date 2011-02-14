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
 *
 * @author Doug Carlson <carlson@cs.jhu.edu>
 */
#include "OneWire.h"
#include <stdio.h>

module TestP {
  uses {
    interface Boot;
    interface Leds;
    
    interface Timer<TMilli> as StopTimer;

    interface Timer<TMilli> as Ds1825ReadTimer;
    interface Timer<TMilli> as Ds1825RefreshTimer;
    
    interface Timer<TMilli> as DummyReadTimer;
    interface Timer<TMilli> as DummyRefreshTimer;

    interface Read<int16_t> as Ds1825Read;
    interface Read<int16_t> as DummyRead;

    interface OneWireDeviceInstanceManager as Ds1825Dim;
    interface OneWireDeviceInstanceManager as DummyDim;
  
    interface Random;
  }
}

implementation {
  enum{
    S_INIT=0,
    S_IDLE=1,
    S_READING=2,
    S_DONE=3,
  };
  enum{
    TEST_INTERVAL = 1024,
  };
  #define STOP_INTERVAL 7372800L

  uint8_t state = S_INIT;
  uint8_t readCount = 0;

  event void Boot.booted() {
    call Ds1825RefreshTimer.startOneShot(call Random.rand16() % TEST_INTERVAL);
    call Ds1825ReadTimer.startOneShot(call Random.rand16() % TEST_INTERVAL);
    call DummyRefreshTimer.startOneShot(call Random.rand16() % TEST_INTERVAL);
    call DummyReadTimer.startOneShot(call Random.rand16() % TEST_INTERVAL);
    call StopTimer.startOneShot(STOP_INTERVAL);
  }
 
  event void StopTimer.fired() {
    printf("STOP EVERYTHING!\n\r");
    state = S_DONE;
  }

  event void Ds1825RefreshTimer.fired() {
    printf("Ds1825RefreshTimer.fired\n\r");
    call Ds1825Dim.refresh();
  }

  event void Ds1825ReadTimer.fired() {
    printf("Ds1825ReadTimer.fired\n\r");
    if (call Ds1825Dim.numDevices() > 0) {
      call Ds1825Dim.setDevice( call Ds1825Dim.getDevice( call Random.rand16() % call Ds1825Dim.numDevices()));
      if (call Ds1825Read.read() != SUCCESS) {
        if (state != S_DONE) { 
          call Ds1825ReadTimer.startOneShot(call Random.rand16() %TEST_INTERVAL);
        }
      }
    } 
    else if (state != S_DONE) {
      call DummyReadTimer.startOneShot(call Random.rand16() % TEST_INTERVAL);
    }
  }

  event void Ds1825Read.readDone(error_t result, int16_t val) {
    printf("TestP Ds1825Read.readDone %x [[%x]] from %llx\n\r", result, val, (call Ds1825Dim.currentDevice()).id);
    if (state != S_DONE) {
      call Ds1825ReadTimer.startOneShot(call Random.rand16() % TEST_INTERVAL);
    }
  }
  
  event void Ds1825Dim.refreshDone(error_t result, bool devicesChanged) {
    uint8_t i;
    printf("TestP Ds1825DIM.refreshDone %x %x: ", result, devicesChanged);
    for (i = 0; i < call Ds1825Dim.numDevices(); i++) {
      printf("%llx ", (call Ds1825Dim.getDevice(i)).id);
    }
    printf("\n\r");
    if (state != S_DONE) {
      call Ds1825RefreshTimer.startOneShot(call Random.rand16() % TEST_INTERVAL);
    }
  }


  event void DummyRefreshTimer.fired() {
    printf("DummyRefreshTimer.fired\n\r");
    call DummyDim.refresh();
  }

  event void DummyReadTimer.fired() {
    printf("DummyReadTimer.fired\n\r");
    if (call DummyDim.numDevices() > 0) {
      call DummyDim.setDevice( call DummyDim.getDevice( call Random.rand16() % call DummyDim.numDevices()));
      if (call DummyRead.read() != SUCCESS) {
        if (state != S_DONE) {
          call DummyReadTimer.startOneShot(call Random.rand16() %TEST_INTERVAL);
        }
      }
    }
    else if (state != S_DONE) {
      call DummyReadTimer.startOneShot(call Random.rand16() % TEST_INTERVAL);
    }
  }

  event void DummyRead.readDone(error_t result, int16_t val) {
    printf("TestP DummyRead.readDone %x %x from %llx\n\r", result, val, (call DummyDim.currentDevice()).id);
    if (state != S_DONE) {
      call DummyReadTimer.startOneShot(call Random.rand16() % TEST_INTERVAL);
    }
  }
  
  event void DummyDim.refreshDone(error_t result, bool devicesChanged) {
    uint8_t i;
    printf("TestP DummyDIM.refreshDone %x %x: ", result, devicesChanged);
    for (i = 0; i < call DummyDim.numDevices(); i++) {
      printf("%llx ", (call DummyDim.getDevice(i)).id);
    }
    printf("\n\r");
    if (state != S_DONE) {
      call DummyRefreshTimer.startOneShot(call Random.rand16() % TEST_INTERVAL);
    }
  }
  
}
