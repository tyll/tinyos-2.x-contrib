from time import sleep

FOREVER = 2 ** 63


class Remote(object):
    """
    Wrapper to control TossymSync and running events.
    """

    __slots__ = ['tossim', 'sync', 'on_start', 'on_stop',
                 'is_running', 'stop_time', 'event',
                 'clock_mul']

    def __init__(self, tossim, tossim_sync, tossim_event):
        self.tossim = tossim
        self.sync = tossim_sync
        self.event = tossim_event

        self.clock_mul = tossim_sync.getClockMul() # 0 means run unbounded
        self.is_running = False
        self.stop_time = 0

        self.on_start = lambda: None
        self.on_stop = lambda: None

        self.run_forever()


    def to_sim_time(self, time_str):
        """
        Convert string of hh:mm:ss.fract into tossim time units.

        If the string starts with a +, adds relative to the current
        sim time.
        """
        # PST-- is there a cleaner way?
        if isinstance(time_str, (int, long)):
            return time_str

        tps = self.tossim.ticksPerSecond()
        t = 0

        # relative time?
        if time_str[0] == "+":
            time_str = time_str[1:]
            t = self.tossim.time()

        # can't combine below, imagine when fractional part not
        # supplied
        fract_split = time_str.split(".", 1)
        if len(fract_split) > 1:
            t += int(float("." + fract_split[1]) * tps)

        # 0 to 3 (hh:mm:ss) components supported
        hms_split = fract_split[0].split(":")
        for part, mul in zip(reversed(hms_split),
                             [1*tps, 60*tps, 3600*tps]):
            t += int(part) * mul

        return t

    
    def set_clock_mul(self, clock_mul):
        """
        Set the clock multipler, as a float.

        If clock_mul is <= 0 the simulation will "run at full speed".
        """
        self.sync.setClockMul(float(clock_mul))
        self.clock_mul = self.sync.getClockMul()
	return self.clock_mul
            
    def get_clock_mul(self):
        """
        Get the clock multiplier, as a float.
        
        Returns 0 if the clock multiplier is being ignored.
        """
        return 0 if not self.clock_mul else self.sync.getClockMul()


    def run_until(self, time):
        """
        Run until the specified simulation time.

        The time is parsed as with to_sim_time.
        """
        # every re-start should resync to world-time
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
        Start/continue simulation.
        """
        self.run_until(0)


    def stop(self):
        """
        Stop the simulation.
        """
        self.sync.setStopAt(-1)
        self.is_running = False
        self.on_stop()


    def time(self):
        """
        Current simulation time.
        """
        return self.tossim.time()


    def run_sim(self):
        """
        Run (or don't run) a simulation cycle based on state.
        """
        res = self.sync.runNextEventInTime()
        if res == -1: # "at stop time"
            if self.is_running:
                # transitioned to non-running
                self.stop()
            else:
                # minimize CPU-thrashing while stopped
                sleep(0.0005)

        return res
