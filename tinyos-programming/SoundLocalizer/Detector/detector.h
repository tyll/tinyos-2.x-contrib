#ifndef DETECTOR_H
#define DETECTOR_H

typedef nx_struct coordination_msg {
  nx_uint16_t count, sample_at, interval;
} coordination_msg_t;

typedef nx_struct detection_msg {
  nx_uint16_t id;
  nx_uint32_t time;
  /* Debug information */
  nx_uint16_t intercept;
  nx_uint16_t slope;
  nx_uint32_t t0, localDetectTime, localSampleTime;
} detection_msg_t;

enum {
  AM_COORDINATION_MSG = 101,
  AM_DETECTION_MSG = 102,

  BEACON_INTERVAL = 128,
  SAMPLE_TIME = 48,
  MIN_SAMPLES = SAMPLE_TIME / 2,
  VOTING_INTERVAL = 2048,

  MICROPHONE_WARMUP = 1200
};

#endif
