from simx.base.testutil import import_assert_functions
import_assert_functions(globals())

import random, time, sys

from simx.sensor import SensorControl, SensorExtension
from simx.base import TossimBase, ChannelBridge

from TOSSIM import Tossim
from SimxPushback import Pushback

_tossim = Tossim([])
tossim = None
sensor = None

report = ChannelBridge()
#f = open("res.txt", "w")
_tossim.addChannel("SensorTest", report.get_writefile())
#_tossim.addChannel("SensorTest", f)
sensor = SensorControl(Pushback())
tossim = TossimBase(_tossim)
tossim.register_extension(SensorExtension(sensor))

def setUp():
    global sensor, tossim
#    tossim = TossimBase(_tossim)
#    tossim.register_extension(SensorExtension(sensor))

def sensor_readings_results():
    return """\
id=1 sensor=0 data=00101 count=0 err=00
DEBUG (1): error with sensor=1
id=2 sensor=0 data=00201 count=0 err=00
id=2 sensor=1 data=00211 count=0 err=00
id=1 sensor=0 data=00101 count=1 err=00
DEBUG (1): error with sensor=1
id=2 sensor=0 data=00201 count=1 err=00
id=1 sensor=0 data=00101 count=2 err=00
id=2 sensor=1 data=00211 count=1 err=00
DEBUG (1): error with sensor=1
id=2 sensor=0 data=00201 count=2 err=00
id=1 sensor=0 data=00101 count=3 err=00
DEBUG (1): error with sensor=1
id=2 sensor=0 data=00201 count=3 err=00
id=2 sensor=1 data=00211 count=2 err=00
id=1 sensor=0 data=00101 count=4 err=00
DEBUG (1): error with sensor=1
id=2 sensor=0 data=00201 count=4 err=00
id=1 sensor=0 data=00101 count=5 err=00
id=2 sensor=1 data=00211 count=3 err=00
DEBUG (1): error with sensor=1
id=2 sensor=0 data=00201 count=5 err=00
id=1 sensor=0 data=00101 count=6 err=00
DEBUG (1): error with sensor=1
id=2 sensor=0 data=00201 count=6 err=00
id=2 sensor=1 data=00211 count=4 err=00
id=1 sensor=0 data=00101 count=7 err=00
DEBUG (1): error with sensor=1\
""".split("\n")

def tedddst_sensor_readings():
    node1 = tossim[1]
    node1.connect_sensor(0, lambda *x: 101, 1)
    node1.turn_on(tossim.time())

    node2 = tossim[2]
    node2.connect_sensor(0, lambda *x: 201, 1)
    node2.connect_sensor(1, lambda *x: 211, 1)
    node2.turn_on(tossim.time() + tossim.seconds_as_ticks(0.1))

    expected = sensor_readings_results()
    seen = []

    end_time = tossim.time() + tossim.seconds_as_ticks(5)
    while tossim.time() <= end_time:
        tossim.runNextEvent()
        r = report.readline(True)
        if r:
            seen.append(r)

    yield assertEquals, len(expected), len(seen)
    for exp, act in zip(expected, seen):
        yield assertEquals, exp, act

    node1.turn_off()
    node2.turn_off()


def read_delay(mote_id, chan_id, start_time):
    return tossim.time() - start_time

def check_delay_exact(data_str, delay):
    assertEquals("data=%05d" % delay, data_str)

def check_delay_in(data_str, samples):
    assertTrue(data_str in ("data=%05d" % s for s in samples))

def check_delay_error(data_str, delay):
    assertEquals("error", data_str)

def run_sim(node, check_fn, expected_delay_fn, min_readings=8):
    readings = 0

    node.turn_on(tossim.time())
    end_time = tossim.time() + tossim.seconds_as_ticks(5)
    while tossim.time() <= end_time:
        tossim.runNextEvent()
        r = report.readline(True)
        if r and "sensor=0" in r:
            data_str = r.split()[2]
            readings += 1
            yield check_fn, data_str, expected_delay_fn()
        if r and "sensor=1" in r:
            pass

    node.turn_off()

    assertTrue(readings >= min_readings, "readings during period")


def test_sensor_timings_function():
    """
    Test function-generated values of delay.
    """
    # mutated!
    expected_delay_state = list(reversed(range(0, 70)))
    delay_state = list(expected_delay_state)
    
    def delay(mote_id, chan_id, start_time):
        next = delay_state.pop()
        return next

    node = tossim[0]
    node.connect_sensor(0, read_delay, delay)
    def q():
        next = expected_delay_state.pop()
        return next

    for x in run_sim(node, check_delay_exact, q):
#                     lambda: expected_delay_state.pop()):
        yield x


def test_sensor_timings_constant():
    """
    Test various valid fixed delays.
    """
    for delay in [0, 1, 10000]:
        node = tossim[0]
        node.connect_sensor(0, read_delay, delay)
        for x in run_sim(node, check_delay_exact, lambda: delay):
            yield x


def test_sensor_timings_sample():
    """
    Test delay based off of random-sample.
    """
    base_samples = random.sample(range(0, 10000), 40)

    for count in [1, 10, 20, 40]:
        samples = random.sample(base_samples, count)
        node = tossim[0]
        node.connect_sensor(0, read_delay, samples)
        for x in run_sim(node, check_delay_in, lambda: samples):
            yield x


def test_sensor_timings_error():
    # PST- this really should not be failing for the 2nd case now... overflow

    for invalid in [-1, tossim.seconds_as_ticks(10)]:
        node = tossim[0]
        node.connect_sensor(0, read_delay, invalid)
        for x in run_sim(node, check_delay_error, lambda: None):
            yield x
    
