import sys

# callback to suppress channel/error
SUPPRESS_FN = lambda id, chan, time: 0
SUPPRESS_MSG = "\n    WARNING: THIS ERROR WILL BE SUPPRESSED IN THE FUTURE"

class LedControl (object):
    """
    Manages the Pushback interconnect for sensors.

    Sensor inputs must be configured before they can be used.
    """

    def __init__ (self, pushback=None, suppress=True):
        assert pushback is not None
        self.mapping = {} # of mote_id: fn

        pushback.addPythonPushback("leds.set(lb)b", "(lb)",
                                   self._set)


    def _set (self, mote_id, led_state):
        led_str = ""
        for n in range(0, 8):
            if led_state & (2 ** n):
                led_str += "X"
            else:
                led_str += "_"

        #print "MOTE (%d) LED (%d): %s" % (mote_id, led_state, led_str);
