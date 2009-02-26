#include "detector.h"

module SynchronizerC
{
  uses {
    interface Boot;
    interface SplitControl as RadioControl;
    interface Leds;
    interface Receive as RCoordination;
    interface Receive as RDetection;
    interface AMSend as SDetection;
    interface Counter<TMicro, uint32_t>;
    interface Timer<TMilli> as VotingTimer;
    interface Stats;
    interface Detector;
  }
}
implementation {
  // Local times are shifted right by TIME_SHIFT before being passed
  // to statistical package to reduce value ranges and avoid overflow problems
  enum { TIME_SHIFT = 4 };

  uint16_t lastCount; // Sequence number in last coordination message
  uint32_t t0; // Local time first coordination message received
  uint32_t localSampleTime; // Local time at which sampling should start
  norace uint32_t localDetectTime; // Local time at which event detected
  uint32_t detectTime; // Global time at which event detected

  message_t msg; // Detection message buffer for voting
  bool msgInUse;

  void scheduleSampling(uint32_t sampleTime);

  uint32_t now() {
    return call Counter.get() >> TIME_SHIFT;
  }

  event void Boot.booted() {
    // At boot time, start the radio and await coordination messages
    call RadioControl.start();
  }

  event void RadioControl.startDone(error_t error) { 
    if (error != SUCCESS)
      call Leds.led0On();
  }

  event message_t *RCoordination.receive(message_t *m, void *payload, uint8_t len) {
    // Note arrival time. If a future version of TinyOS includes an
    // arrival timestamp, that could be used instead.
    uint32_t arrivalTime = now();

    if (len == sizeof(coordination_msg_t)) // Validate received message
      {
	coordination_msg_t *cmsg = payload;

	// If we were voting, or this looks like a new coordination
	// message sequence, start a new time synchronization / event
	// detection process 
	if (call VotingTimer.isRunning() || cmsg->count < lastCount)
	  {
	    t0 = arrivalTime;
	    call VotingTimer.stop();
	    call Stats.reset();
	  }
	lastCount = cmsg->count;

	call Leds.led2Toggle();
	/* The statistics module accumulates pairs of 
	     coordination message sequence numbers
	   and
	     local time
	   The local time is relative to the arrival of the first 
	   coordination message, to reduce the range of values handled
	   by the statistics module.
	   Because the coordination messages are sent at regular intervals,
	   the coordination message sequence numbers serve as the
	   specification of global time.

	   A "real" implementation of time synchronization would perform
	   more advanced statistical analysis on these samples (e.g.
	   sample validation, outlier rejection, checking correlation) */
	call Stats.data(cmsg->count, arrivalTime - t0);

	/* If the current global time (cmsg->count) is close to the
           global sampling time (cmsg->sample_at), start the event
	   detection process. We leave enough time to warmup the sensor
	   plus a cushion of 2 global time units. */
	if (cmsg->count >=
	    cmsg->sample_at - (MICROPHONE_WARMUP / cmsg->interval) - 3)
	  scheduleSampling(cmsg->sample_at);
      }
    
    return m;
  }

  // Get ready to detect an event starting at global time sampleTime
  void scheduleSampling(uint32_t sampleTime) {
    call Leds.led2Off();
    // We only agree to sample if we got enough coordination messages
    // to synchronize time properly
    if (call Stats.count() >= MIN_SAMPLES)
      {
	localSampleTime = call Stats.estimateY(sampleTime);
	// Stop the radio to avoid radio activity from interfering with
	// the precision of the event detection process
	call RadioControl.stop();
      }
  }

  event void RadioControl.stopDone(error_t error) {
    // Once the radio is stopped, schedule event detection
    call Detector.start(t0 << TIME_SHIFT, localSampleTime << TIME_SHIFT);
  }

  async event void Detector.detected() {
    // Note the precise time at which the event is detected. Actual
    // event detection processing is in Detector.done (which runs in
    // task context, unlike Detector.detected).
    localDetectTime = now();
  }

  event void Detector.done(error_t ok) {
    // If event detection was successful, convert local detection time to
    // a global time, and start broadcasting our detection reports
    if (ok == SUCCESS)
      {
	detectTime = 100000 * call Stats.estimateX(localDetectTime - t0);
	call VotingTimer.startPeriodic(VOTING_INTERVAL);
	call Leds.led2On(); // Assume we're closest
      }
    call RadioControl.start();
  }

  event void VotingTimer.fired() {
    // Simply build and broadcast a detection message
    detection_msg_t *dmsg = call SDetection.getPayload(&msg, sizeof *dmsg);

    if (!msgInUse && dmsg)
      {
	float intercept = call Stats.estimateY(0);
	float slope = call Stats.estimateY(1) - intercept;

	dmsg->id = TOS_NODE_ID;
	dmsg->time = detectTime;
	/* Debugging information */
	dmsg->intercept = intercept;
	dmsg->slope = slope;
	dmsg->t0 = t0;
	dmsg->localSampleTime = localSampleTime;
	dmsg->localDetectTime = localDetectTime - t0;

	if (call SDetection.send(AM_BROADCAST_ADDR, &msg, sizeof *dmsg) == SUCCESS)
	  msgInUse = TRUE;
      }
  }

  event void SDetection.sendDone(message_t *m, error_t error) {
    if (m == &msg)
      msgInUse = FALSE;
  }

  event message_t* RDetection.receive(message_t *m, void* payload, uint8_t len) {
    if (len == sizeof(detection_msg_t)) // Validate received message
      {
	detection_msg_t *dmsg = payload;

	// Voting logic: if received message indicates global detection time
	// earlier than ours, switch off our LED and stop broadcasting
	if (dmsg->time < detectTime)
	  {
	    call Leds.led2Off();
	    call VotingTimer.stop();
	  }
      }
    
    return m;
  }

  async event void Counter.overflow() { }
}
