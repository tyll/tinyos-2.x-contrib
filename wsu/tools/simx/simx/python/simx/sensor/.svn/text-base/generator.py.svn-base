"""
Misc. SimxSensor generators.
"""

import math
import random

class Generator(object):

    @staticmethod
    def sine(tossim,
             period=1, amplitude=1, phase=0, offset=0,
             min_value=0, max_value=None):
        """
        Returns a sine wave function based on the supplied parameters.
        
        The result of the function is a function of the event time,
        with the specified period, amplitude, phase and offset which
        is constrained by min and max. period is in fractional
        seconds, phase is in radians. If min or max are None, they are
        ignored.
        
        The generated sine wave function evaluates to an integer.
        """
        two_pi = 2.0 * math.pi
        tps = tossim.ticksPerSecond()
        if max_value is not None and min_value > max_value:
            raise ValueError("min (%d) > max (%d)" %
                             (min_value, max_value))

        def callback(mote_id, chan_id, sim_time):
            "SimxSensor callback"
            ftime = float(sim_time) / tps
            radians = (ftime / period) * two_pi + phase
            value = math.sin(radians) * amplitude + offset
            if min_value is not None and value < min_value:
                value = min
            if max_value is not None and value > max_value:
                value = max
            return long(value)

        return callback


    @staticmethod
    def random(tossim, min_value=0, max_value=0xffff):
        """
        Returns a sensor function which simply returns a random
        integer in the range [min_value, max_value].
        """
        def callback(mote_id, chan_id, sim_time):
            "SimxSensor callback"
            return long(random.randint(min_value, max_value))

        return callback
