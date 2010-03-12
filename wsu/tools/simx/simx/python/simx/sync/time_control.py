import types
from time import sleep


class TimeControl(object):
    """
    Wrapper to control SimxSync and event execution.

    The big advantage over using SimxSync directly is that this class
    provides a nice interface and supporting structure to run the
    simulation in a multiple of real-world time.

    This class just controls the simulation time; it does absolutely
    no event processing.
    """

    def __init__(self, tossim, tossim_sync):
        """
        tossim       -- Tossim / simx.base.TossimBase
        tossim_sync  -- SimxSync
        """
        self.sync = tossim_sync

        self._time_fn = tossim.time
        self._ticks_per_second = tossim.ticksPerSecond()

        self.is_running = False
        self.stop_time = 0

        self.on_start = lambda: None
        self.on_stop = lambda: None

        self.run_forever()


    def time(self):
        """
        Returns the current simulation time.
        """
        return self._time_fn()


    def ticks_per_second(self):
        """
        Returns the number of simulations ticks per second.
        """
        return self._ticks_per_second


    def to_sim_time(self, time_str, base_time=None):
        """
        Convert string of hh:mm:ss.fract into tossim time units.

        If the string starts with a +, adds relative to base_time or,
        if not supplied, the current sim time. Raise a ValueError if
        given a non-comformant time_str.
        """
        # if time_str is a number, just return it
        if isinstance(time_str, (types.IntType, types.LongType)):
            return time_str

        tps = self._ticks_per_second
        t = 0

        # be accommodating of extra spaces
        time_str = time_str.replace(" ", "")

        # relative time?
        if time_str and time_str[0] == "+":
            time_str = time_str[1:]
            if base_time is not None:
                t = base_time
            else:
                t = self.time()

        # can't combine below, imagine when fractional part not
        # supplied
        frac_split = time_str.split(".", 1)
        if len(frac_split) > 1:
            try:
                frac_value = float("." + (frac_split[1] or "0"))
                if frac_value < 0:
                    raise ValueError
                t += int(frac_value * tps)
            except ValueError, e:
                raise ValueError("invalid time: '%s'" % time_str)

        try:
            # 0 to 3 (hh:mm:ss) components supported
            hms_split = frac_split[0].split(":")
            if len(hms_split) > 3:
                raise ValueError

            for part, mul in zip(reversed(hms_split),
                                 [1*tps, 60*tps, 3600*tps]):
                segment = int(part or 0) * mul
                if segment < 0:
                    raise ValueError
                t += segment

        except ValueError, e:
            raise ValueError("invalid time: '%s'" % time_str)

        return t

    
    def set_clock_mul(self, clock_mul):
        """
        Set the clock multipler, as a float.

        If clock_mul is <= 0 the simulation will run at full speed;
        that is, no real-world synchronization will be performed. The
        new clock multiplier (which may be different than the
        requested multiplier) is returned.
        """
        self.sync.setClockMul(clock_mul)
        return self.get_clock_mul()

            
    def get_clock_mul(self):
        """
        Returns the clock multiplier, as a float.
        """
        return self.sync.getClockMul()


    def run_until(self, time):
        """
        Run until the specified simulation time.

        The time is parsed as with to_sim_time. A false value of time
        will remove all stop limits.
        """
        # Every re-start needs to resync to world-time (prevent drift)
        self.sync.synchronize()

        if not time:
            self.sync.setStopAt(0)
        else:
            sim_time = self.to_sim_time(time)
            self.sync.setStopAt(sim_time)

        self.is_running = True
        self.on_start()


    def run_forever(self):
        """
        Start/continue simulation and run it forever.
        """
        self.run_until(None)


    def stop(self):
        """
        Stop the simulation.
        """
        self.sync.setStopAt(-1)
        self.is_running = False
        self.on_stop()


    def run_sim(self):
        """
        Run (or don't run) a simulation cycle based on state.

        Returns -1 if there are no events to process and at the
        stop-limit; 0 if there are no events to process (and not at
        the stop-limit); >= 1 if there are events to process (implies
        not at the stop-limit).
        """
        res = self.sync.runNextEventInTime()
        if res == -1: # "at stop time"
            if self.is_running:
                # transitioned to non-running
                self.stop()
            else:
                # Minimize CPU-thrashing while stopped; this allows
                # run_sim to be executed in a tight loop externally.
                sleep(0.0005)

        return res
