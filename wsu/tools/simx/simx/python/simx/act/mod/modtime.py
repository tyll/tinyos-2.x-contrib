"""
ModTime
"""

import logging

from simx.act.msg import TimeEvent
from simx.act.context import R

class ModTime(object):
    """
    SimX/Time bridge.
    """

    log = logging.getLogger(__name__)

    def __init__(self, reactor=None, time_control=None):
        self.reactor = reactor
        self.time_control = (time_control or
                             reactor.service.resolve("TimeControl"))

        self.time_control.on_start = self._on_start
        self.time_control.on_stop = self._on_stop

        
    def _on_start(self):
        """
        Simulation started event.
        """
        self.log.debug("Started")
        self._send_time_event(3)


    def _on_stop(self):
        """
        Simulation stopped event.
        """
        self.log.debug("Stopped")
        self._send_time_event(3)


    def _send_time_event(self, event_type):
        """
        Send a time event now.
        """
        event = TimeEvent.Msg()
        event.set_event_type(event_type)
        event.set_time(self.time_control.time())
        R.reply(event)


    def SET_CLOCK_MUL(self, clock_mul):
        """
        Set the clock multiplier, as a float.
        
        A false clock_mul causes the simulation to run as fast as
        possible.  Otherwise, clock_mul must be > 0.
        """
	self.log.info("SET_CLOCK_MUL: %s" % clock_mul)
        return self.time_control.set_clock_mul(clock_mul)
	#pass
    def GET_CLOCK_MUL(self):
        """
        Set the clock multiplier, as a float.
        
        A false clock_mul causes the simulation to run as fast as
        possible.  Otherwise, clock_mul must be > 0.
        """
        return self.time_control.get_clock_mul()
	#pass


    def RUN(self):
        """
        Start the simulation time.
        """
        self.time_control.run_forever()


    def RUN_UNTIL(self, time):
        """
        Start running the simulation until the specified time.
        """
        self.log.info("Running until: %s" % time)
        self.time_control.run_until(time)


    def STOP(self):
        """
        Stop the simulation.
        """
        self.time_control.stop()


    def QUERY(self):
        """
        Query the simulation time.
        """
        self._send_time_event(1)
