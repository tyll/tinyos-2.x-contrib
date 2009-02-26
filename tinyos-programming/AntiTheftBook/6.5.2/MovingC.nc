/*
 * Copyright (c) 2007-2009 Intel Corporation
 * All rights reserved.

 * This file is distributed under the terms in the attached INTEL-LICENS
 * file. If you do not find this file, a copy can be found by writing to
 * Intel Research Berkeley, 2150 Shattuck Avenue, Suite 1300, Berkeley, CA, 
 * 94704.  Attention:  Intel License Inquiry.
 */
#include "message.h"
#include "antitheft.h"

module MovingC {
  uses {
    interface Boot;
    interface Leds;
    interface Timer<TMilli> as TheftTimer;
    interface ReadStream<uint16_t> as Accel;
    interface SplitControl as CommControl;
    interface StdControl as CollectionControl;
    interface StdControl as DisseminationControl;
    interface Send as Theft;
    interface DisseminationValue<settings_t> as Settings;
    interface Mount;
    interface ConfigStorage;
  }
}
implementation {
  enum { ACCEL_INTERVAL = 256, /* Checking interval */
         ACCEL_PERIOD = 10000, /* uS -> 100Hz */
         ACCEL_NSAMPLES = 10,  /* 10 samples * 100Hz -> 0.1s */
         ACCEL_VARIANCE = 4 }; /* Determined experimentally */

  uint16_t accelSamples[ACCEL_NSAMPLES];
  message_t reportMsg; // The theft report message buffer
  bool sending;        // Don't try and send while a send is in progress
  settings_t settings;
  task void checkAcceleration();
  void reportTheft();

  event void Boot.booted() {
    settings.accelVariance = ACCEL_VARIANCE; // default settings
    settings.accelInterval = ACCEL_INTERVAL;
    call Mount.mount();
  }

  event void Mount.mountDone(error_t ok) {
    if (call ConfigStorage.valid())
      call ConfigStorage.read(0, &settings, sizeof settings);
    else
      call CommControl.start();
  }

  event void ConfigStorage.readDone(storage_addr_t addr, void* buf, storage_len_t len, 
  			            error_t error) {
    call CommControl.start();
  }

  event void CommControl.startDone(error_t ok) {
    // Start multi-hop routing and dissemination
    call CollectionControl.start();
    call DisseminationControl.start();
    // Start checks once communication stack is ready
    call TheftTimer.startPeriodic(settings.accelInterval);
  }

  event void CommControl.stopDone(error_t ok) { }

  event void TheftTimer.fired() {
    // Get 10 samples at 100Hz
    call Accel.postBuffer(accelSamples, ACCEL_NSAMPLES);
    call Accel.read(ACCEL_INTERVAL);
  }

  /* The acceleration read completed. Post the task to check for theft */
  event void Accel.readDone(error_t ok, uint32_t usActualPeriod) {
    if (ok == SUCCESS)
      post checkAcceleration();
  }

  /* Check if acceleration variance above threshold */
  task void checkAcceleration() {
    uint8_t i;
    uint32_t avg, variance;

    for (avg = 0, i = 0; i < ACCEL_NSAMPLES; i++) avg += accelSamples[i];
    avg /= ACCEL_NSAMPLES;
    for (variance = 0, i = 0; i < ACCEL_NSAMPLES; i++)
      variance += (int16_t)(accelSamples[i] - avg) * (int16_t)(accelSamples[i] - avg);

    if (variance > settings.accelVariance * ACCEL_NSAMPLES)
      {
	call Leds.led2On(); /* ALERT! ALERT! */
        reportTheft();
      }
    else
      call Leds.led2Off(); /* Don't leave LED permanently on */
  }

  event void Accel.bufferDone(error_t ok, uint16_t *buf, uint16_t count) { }

  void reportTheft() {
    theft_t *payload = call Theft.getPayload(&reportMsg, sizeof(theft_t));

    call Leds.led0Toggle();
    if (payload && !sending)
      { // We can send if we're  idle and the payload fits
        payload->who = TOS_NODE_ID; // Report that *we* are being stolen!
        // And send the report to the root
        if (call Theft.send(&reportMsg, sizeof(theft_t)) == SUCCESS)
	  sending = TRUE;
      }
  }

  event void Theft.sendDone(message_t *msg, error_t error) {
    sending = FALSE; // Our send completed
  }

  /* New settings received, update our local copy */
  event void Settings.changed() {
    settings = *call Settings.get();
    call ConfigStorage.write(0, &settings, sizeof settings);
  }

  event void ConfigStorage.writeDone(storage_addr_t addr, void* buf, storage_len_t len, 
  			             error_t error) {
    call ConfigStorage.commit();
  }

  event void ConfigStorage.commitDone(error_t error) {
    call TheftTimer.startPeriodic(settings.accelInterval);
  }
}
