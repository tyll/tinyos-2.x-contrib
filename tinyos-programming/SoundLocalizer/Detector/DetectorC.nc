#include "detector.h"

/**
 * "Loud sound" event detector.
 * <p>
 * The basic algorithm is to continuously sample the A/D channel for
 * the microphone until a sound above a fixed threshold is detected.
 * The sampling is performed using the low-level ATmega128 HAL
 * interface to reduce event detection latency and jitter.
 */
module DetectorC
{
  provides interface Detector;
  uses {
    interface Alarm<TMicro, uint32_t>;
    interface Leds;
    interface Resource as AdcResource;
    interface Atm128AdcSingle;
    interface MicaBusAdc as MicAdcChannel;
    interface SplitControl as Microphone;
  }
}
implementation {
  // The threshold for a loud sound (determined experimentally)
  enum { THRESHOLD = 768 };

  bool granted, started; // Status of start request

  void detect();
  task void stopMicrophone(), detectFailed();

  command void Detector.start(uint32_t t0, uint32_t dt) {
    atomic granted = started = FALSE;
    /* As we're using low-level HAL interfaces to access the microphones,
       we have to: 
       - explicitly power up the microphone
       - explicitly request the ADC via its Resource interface
       We schedule these two operations in parallel with the alarm for
       event detection. We'll check that everything started when the
       alarm fires. */
    call Alarm.startAt(t0, dt);
    call Microphone.start();
    call AdcResource.request();
  }

  event void AdcResource.granted() {
    atomic granted = TRUE; // Note when ADC granted
  }

  event void Microphone.startDone(error_t error) {
    atomic started = error == SUCCESS; // Note if microphone started
  }

  async event void Alarm.fired() {
    // It's time to detect a loud sound. If we didn't get the ADC or
    // turn on the microphone in time, report a failed event detection.
    atomic
      if (granted && started)
	{
	  call Leds.led1On();
	  detect();
	}
      else
	post detectFailed();
  }

  task void detectFailed() {
    call Leds.led0Toggle();
    signal Detector.done(FAIL);
  }

  void detect() {
    /* Obtain one A/D microphone sample using the ATmega128 ADC HAL.
       We set a lower prescaler (16) than the usual (64) to get an
       increased sampling rate. This reduces A/D precision (see the
       ATmega128 manual), but we're only really interested in the high
       order bits as we're doing a simple threshold detection. */
    call Atm128AdcSingle.getData(call MicAdcChannel.getChannel(),
				 ATM128_ADC_VREF_OFF, FALSE,
				 ATM128_ADC_PRESCALE_16);
  }

  async event void Atm128AdcSingle.dataReady(uint16_t data, bool precise) {
    /* If we're the current ADC owner: check ADC completion events to
       see if the microphone is above the threshold  */
    atomic
      if (granted)
	if (precise && data > THRESHOLD)
	  {
	    signal Detector.detected();
	    post stopMicrophone();
	  }
	else
	  detect();
  }

  task void stopMicrophone() {
    /* We're done. Power down the microphone, release the ADC and hand
       control back to SynchronizerC */
    call Leds.led1Off();
    atomic granted = FALSE; // Note that we're no longer the ADC owner
    call AdcResource.release();
    call Microphone.stop();
  }

  event void Microphone.stopDone(error_t error) {
    signal Detector.done(SUCCESS);
  }
}
