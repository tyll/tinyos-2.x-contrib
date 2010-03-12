#ifndef TOSSIM
#error SimX/Sensor is only for use with TOSSIM
#else

#include <stdio.h>
/* one of these should have sim_event_t */
#include <sim_event_queue.h>
#include <sim_tossim.h>

/* sensor channels [0 .. LAST_CHANNEL] -- by default, 256 of them! */
#define LAST_CHANNEL ((uint8_t)-1)

module SimxSensorImpl32P {
  uses interface SimxPushback as Pushback;
  provides interface Read<uint32_t>[uint16_t chan];
}
implementation {

  typedef struct {
    bool reading;               /* event is queued? */
    sim_event_t read_evt;       /* TOSSIM event, event->data is channel_t* */
    sim_time_t read_start_time; /* time read started (passed to callback) */
    sim_time_t read_delay;      /* time required to read data */
  } channel_t;

  channel_t chan[LAST_CHANNEL+1] = {{0}};

  channel_t *get_chan(uint8_t channel) {
    return channel <= LAST_CHANNEL ? &chan[channel] : NULL;
  }

  /* Maximum value a read delay can be, in seconds. If a longer value
     is specified it will result in a FAIL'ed Read. */
  const int MAX_READ_DELAY = 10;

  const char *DBG_INFO = "SimxSensor_Info";
  const char *DBG_WARN = "SimxSensor_Warn";
  const char *DBG_ERROR = "SimxSensor";

  const char *SENSOR_READ = "sensor.read(llK)l";
  const char *READ_DELAY = "sensor.read_delay(llK)l";

  static int pushback(long *result, const char *name, ...) {
    va_list va;
    int err;
    long long_result;
    
    va_start(va, name);
    call Pushback.resetHack();
    err = call Pushback.pushLongVa(name, &long_result, va);
    va_end(va);

    if (result) {
      *result = long_result;
    }
    return err;
  }

  void read_done_evt(sim_event_t *e) {
    channel_t *ch = e->data;
    uint8_t channel = ch - chan;
    if (!ch) {
      //      dbg_clear(DBG_ERROR, "SimxSensor: channel out of range: "
      //                "node=%d channel=%d\n", sim_node(), channel);
      signal Read.readDone[channel](FAIL, -1);
    } else {
      long result;
      int err = pushback(&result, SENSOR_READ,
                         sim_node(), channel, ch->read_start_time);
      ch->reading = 0;
      if (err) {
        signal Read.readDone[channel](FAIL, result);
      } else {
        signal Read.readDone[channel](SUCCESS, result);
      }
    }
  }

  sim_event_t *evt_for_chan(channel_t* ch) {
    sim_event_t *evt = &ch->read_evt;
    evt->force = 0;
    evt->cancelled = 0;
    evt->data = ch;
    evt->handle = read_done_evt;
    evt->cleanup = sim_queue_cleanup_none;
    return evt;
  }

  /*
    Start a read on a given channel. This will start a TOSSIM event
    that will fire after the channel read delay.

    The read delay is queried through the Pushback inteface. When the
    read event completes (after the specified read delay) a pushback
    will be triggered. The result is returned via readDone.

    Read requests for the same channel can NOT be scheduled on top of
    eachother, that is, read will return EBUSY if a read event is
    pending. (Read access to multiple simultaneous channels is okay).
  */
  command error_t Read.read[uint16_t channel]() {
    channel_t *ch = get_chan(channel);
    if (NULL == ch) {
      //      dbg_clear(DBG_ERROR, "SimxSensor: channel out of range: "
      //                "node=%d channel=%d\n", sim_node(), channel);
      return FAIL;
    } else if (ch->reading) {
      //      dbg_clear(DBG_INFO, "SimxSensor: busy\n");
      return EBUSY;
    } else {
      long delay;
      int err = pushback(&delay, READ_DELAY, sim_node(), channel, sim_time());
      /*
      if (ch->read_delay > (MAX_READ_DELAY * sim_ticks_per_second())) {
        printf("suspiciously long read delay: %d\n", channel);
        return FAIL;
        }*/
      if (err || delay < 0) { // fail!
        //        dbg_clear(DBG_ERROR, "SimxSensor: error fetching read delay: "
        //                  "node=%d channel=%d\n", sim_node(), channel);
        return FAIL;
      }
      ch->read_delay = delay;
      ch->read_start_time = sim_time();
      ch->reading = 1;
    }
    {
      sim_event_t *evt = evt_for_chan(ch);
      evt->mote = sim_node();
      evt->time = sim_time() + ch->read_delay;
      sim_queue_insert(evt);
      return SUCCESS;
    }
  }

}

#endif
