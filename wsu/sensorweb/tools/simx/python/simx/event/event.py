from warnings import warn
from collections import deque
import bisect

class PriorityQueue:
  """
  [Questionable] PQ implementation.
  """
  
  def __init__(self):
    self.dq = deque()
  
  def insert(self, item):
    l = list(self.dq)
    bisect.insort(l, item)
    self.dq = deque(l)
  
  def peek(self):
    return self.dq[0]
  
  def dequeue(self):
    return self.dq.popleft()
  
  def empty(self):
    return len(self.dq) == 0


class Manager:
  """
  Schedule events to run at a specific time.
  """

  def __init__(self, tossim):
    """
    t is a Tossim object.
    """
    self.t = tossim
    self.events = PriorityQueue()
    p = self.t.newPacket()
    p.setType(0xFF)
    p.setData("")
    p.setDestination(0xFFF0)
    self.p = p

  
  def to_sim_time(self, time):
    """
    Convert time to simulation time.

    If time is a float, it represents fractional seconds. Otherwise
    time is take as a Tossim 'tick' and coerced to a long.
    """
    if isinstance(time, float):
      return long(time * self.t.ticksPerSecond())
    else:
      return long(time)


  def process_until(self, time):
    """
    Process all events up to the specified simulation time.

    Returns the number of events processed.
    """
    processed_count = 0

    while not self.events.empty():
      evt_time, evt = self.events.peek()
      if evt_time > time:
        break
      processed_count += 1
      self.events.dequeue()
      evt(self.t)

    return processed_count


  def process(self):
    """
    Process all events up to the current simulation time.
   
    Returns the number of events processed.
    """
    return self.process_until(self.t.time())


  # This will cause a TOSSIM event to occur and this trigger
  # whatever TOSSIM event stepper to break at an appropriate time.
  def add_tossim_event(self, time):
    self.p.deliver(999, time)


  def run_at(self, time, callback, force_run=True):
    """
    Schedule callback to execute at a specific simulation time.

    callback is passed a single argument, the TOSSIM object. If
    force_run is a true value then an event will be scheduled for
    immediate execution, even if the time is in the past. Otherwise a
    warning is generated.

    True is returned iff an event is scheduled.
    """
    time = self.to_sim_time(time)
    if time < self.t.time():
      if force_run:
        time = self.t.time()
      else:
        warn(ValueError("events can not be scheduled in the past"))
        return False

    self.add_tossim_event(time)
    self.events.insert((time, callback))
    return True


  def run_periodic(self, time, interval, callback):
    """
    Schedule callback to run at time and then again at each interval.

    The callback task can stop futher execution by throwing
    StopIteration.  The interval is always exact according to
    simulation time.
    """
    interval = self.to_sim_time(interval)

    def _wrap(t):
      try:
        callback(t)
      except StopIteration:
        pass
      else:
        self.run_at(t.time() + interval, _wrap)

    self.run_at(time, _wrap)


  def boot_at(self, node, sim_time, callback):
    """
    Boot a node a specific sim_time and invoke a callback.

    The callback may be invoked *slightly after* the actual boot
    sim_time, but it will never be invoked before. callback is passed
    two arguments: the TOSSIM object and the TOSSIM.Node object. It is
    an error if sim_time is in the past.
    """
    sim_time = self.to_sim_time(sim_time)
    node.bootAtTime(sim_time)
    self.run_at(sim_time + 10, lambda t: callback(t, node))
