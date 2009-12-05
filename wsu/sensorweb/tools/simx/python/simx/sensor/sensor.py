"""
Sensor control module.
"""

import random, types


class SensorError(RuntimeError):
    """
    Small wrapper for 'SensorErrors'
    """

    def __init__(self, message, suppressed=False):
        RuntimeError.__init__(self)
        self.message = message
        self.suppressed = suppressed
    
    def __str__(self):
        if self.suppressed:
            fmt = "%s\n" + \
                "     WARNING: THIS ERROR WILL BE SUPPRESSED IN THE FUTURE"
        else:
            fmt = "%s"
        
        return fmt % self.message


def stub_read(mote_id, chan_id, read_start_time):
    """
    A stub to return nothing of interest; well, a value that is more
    easily picked up as "invalid".
    """
    return -1

def stub_read_delay(mote_id, chan_id, read_start_time):
    """
    Stub that just returns an invalid read delay; this should trigger
    a sensor error in the nesC component of SimxSensor.
    """
    return -1

STUB_INFO = (stub_read, stub_read_delay)


class SensorControl(object):
    """
    Manages the Pushback interconnect for sensors.

    Sensor inputs must be configured before they can be used.
    """

    def __init__(self, pushback=None, suppress=True):
        """
        If the suppress is true, then channel disconnect errors will
        only be raised once per mote-channel pair. (This does not
        suppress other kinds of errors that may occur from the
        callbacks).
        """
        assert pushback is not None
        self.mapping = {} # of (mote_id, channel_id) => func
        self.suppress = suppress
        self.suppress_mapping = {}

        self.pre={}
        self.count={}
        self.interval = 1
        # return value is channel delay
        pushback.addPythonPushback("sensor.read_delay(llK)l", "(llK)",
                                   self._pushback_read_delay)

        # return value is sensor reading
        pushback.addPythonPushback("sensor.read(llK)l", "(llK)",
                                   self._pushback_read)


    def connect(self, mote_id, chan_id, read_func, delay, interval):
        """
        Connect a channel on a mote to a specific function.

        If there is an existing connection it will be replaced.

        read_func should take 3 parameters: the mote id, the channel id,
        and the read start time (in tossim ticks). func should return
        an integer for the sensor reading.

        NOTE: read_func is executed at the exact tossim tick that the data
        should be made available via Read.done (after the delay). That
        is, the delay applied is current_sim_time -
        read_start_time. Thus, because of the delay, it is possible
        that different different sensors readings may if using
        mutable/shared state between the callbacks.

        delay may be a function taking 3 parameters, as per read_func
        or it may a single integral type or a list of integral
        types. If it is a single integral type it is used as a fixed
        delay, if it is a list of integral types it is used as a
        sample population from which a random delay will be selected
        and, if it is is a function it is invoked.

        NOTE: The delay function is executed as soon as a sensor
        reading is requested. That is, during the invocation of delay,
        read start time is the same as the current simulation time.
        """
        key = (mote_id, chan_id)
        
        if isinstance(delay, (types.IntType, types.LongType)):
            delay_func = lambda *x: delay
        elif hasattr(delay, "__iter__"):
            delay_func = lambda *x: random.sample(delay, 1)[0]
        else:
            delay_func = delay

        self.mapping[key] = (read_func, delay_func)
        self.pre[key] = 0
        self.count[key] = 0
        self.interval = interval


    def get_channel_info(self, mote_id, chan_id):
        """
        Returns the channel info in the form (read_func, delay_func)
        or raises an exception. If error suppression is enabled
        read_func and delay_func may be stub functions.
        """
        key = (mote_id, chan_id)
        try:
            return self.mapping[key]
        except KeyError:
            if key in self.suppress_mapping:
                # suppress this error, but use stubs
                return STUB_INFO

            if self.suppress:
                self.suppress_mapping[key] = True
            
            raise SensorError(
                "Not connected: mote=%d chan=%d" % (mote_id, chan_id),
                self.suppress)


    def _pushback_read_delay(self, mote_id, chan_id, read_start_time):
        """
        Invoked when a read delay query occurs.
        """
        _, delay_func = self.get_channel_info(mote_id, chan_id)
        cnt = self.count[(mote_id,chan_id)]
        pv = self.pre[(mote_id,chan_id)]
        cnt=cnt+1;
        #print cnt,"\n"
        ret = delay_func(mote_id, chan_id, read_start_time)
        if(cnt == self.interval):
             #print cnt,"aa\n"
             cnt = 0
             self.pre[(mote_id,chan_id)] = ret
        else:
             ret = pv

        self.count[(mote_id,chan_id)] = cnt;

        
        return ret


    def _pushback_read(self, mote_id, chan_id, read_start_time):
        """
        Invoked when a reading is due.
        """
        read_func, _ = self.get_channel_info(mote_id, chan_id)
        cnt = self.count[(mote_id,chan_id)]
        pv = self.pre[(mote_id,chan_id)]
        cnt=cnt+1;
        #print cnt,"\n"
        ret = read_func(mote_id, chan_id, read_start_time)
        if(cnt == self.interval):
             #print cnt,"bb\n"
             cnt = 0
             self.pre[(mote_id,chan_id)] = ret
        else:
             ret = pv
        self.count[(mote_id,chan_id)] = cnt;
        return ret

        
