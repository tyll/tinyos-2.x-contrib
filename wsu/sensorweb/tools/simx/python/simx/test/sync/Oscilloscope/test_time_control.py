from simx.base.testutil import import_assert_functions
import_assert_functions(globals())

import random, time

from TOSSIM import Tossim
from SimxSync import SimxSync

from simx.sync import TimeControl

_tossim = Tossim([])
_sync = SimxSync()
control = None


def advance_some_time():
    # advance time some each time
    boot_time = _tossim.time() + random.randint(17, 42)
    node = _tossim.getNode(0)
    node.bootAtTime(boot_time)
    while _tossim.time() < boot_time:
        _tossim.runNextEvent()


def setUp():
    global control
    control = TimeControl(_tossim, _sync)
    advance_some_time()


def test_advance_some_time():
    start = _tossim.time()
    advance_some_time()
    assert _tossim.time() > start


def test_basic_wrapper():
    yield assertEquals, _tossim.ticksPerSecond(), control.ticks_per_second()
    yield assertEquals, _tossim.time(), control.time()
    advance_some_time()
    yield assertEquals, _tossim.time(), control.time()


def test_to_sim_time():
    HUGE_INT = 0x7ffffffffffffffe
    time = control.time()
    tps = control.ticks_per_second()

    def hms(h, m, s, f=0):
        return (h * 3600 + m * 60 + s + f) * tps

    for count in xrange(0, 10):
        raw_time = random.randint(-HUGE_INT, HUGE_INT)
        yield assertSame, raw_time, control.to_sim_time(raw_time)

    def check(a, b, rel=None):
        assertEquals(a, control.to_sim_time(b, rel))

    # spaces and zeros
    yield check, time, "+"
    yield check, time, "+0"
    yield check, 0, ""
    yield check, 0, "0"
    yield check, 0, "00"
    yield check, 0, "   "
    yield assertRaises, ValueError, lambda: control.to_sim_time("++")

    # just fraction
    yield check, hms(0,0,0,0.5), ".5"
    yield check, time + hms(0,0,0,0.5), "+.5"
    yield check, hms(0,0,0,0.5), "0.5"
    yield check, time + hms(0,0,0,0.5), "+0.5"
    yield check, hms(0,0,0,0.5), ":.5"
    yield check, hms(0,0,0,0.5), "::.5"
    yield assertRaises, ValueError, lambda: control.to_sim_time(":::.5")
    yield assertRaises, ValueError, lambda: control.to_sim_time("-.5")

    # check relative
    yield check, 42 + hms(0,0,0,0.5), "+0.5", 42
    
    # seconds and trailing periods
    yield check, hms(0,0,1), "1"
    yield check, time + hms(0,0,1), "+1"
    yield check, hms(0,0,1), "1."
    yield assertRaises, ValueError, lambda: control.to_sim_time("1..")
    yield check, time + hms(0,0,1), "+1."
    yield assertRaises, ValueError, lambda: control.to_sim_time("-1")

    # minutes/seconds
    yield check, hms(0,1,2), "1:2"
    yield check, time + hms(0,1,2), "+1:2"
    yield check, hms(0,1,0), "1:"
    yield assertRaises, ValueError, lambda: control.to_sim_time("-1:")

    # hours/minutes/seconds
    yield check, hms(1,2,3), "1:2:3"
    yield check, time + hms(1,2,3), "+1:2:3"
    yield check, hms(1,0,0), "1::"
    yield check, hms(1,2,0), "1:2:"
    yield assertRaises, ValueError, lambda: control.to_sim_time("-1:2:")

    # everything
    yield check, hms(1,2,3,0.5), "1:2:3.5"
    yield check, time + hms(1,2,3,0.5), "+1:2:3.5"

    # obvious failures
    yield assertRaises, ValueError, lambda: control.to_sim_time("x")


def test_set_mul():
    for x in [-100, -1, 0, 1, 100]:
        control.set_clock_mul(x)
        yield assertEquals, x, control.get_clock_mul()


def test_time_sync():

    def run(mul, real_seconds=1):
        rw_start = time.time()
        control.set_clock_mul(mul)
        sim_seconds = real_seconds * mul
        end_time = control.time() + (sim_seconds * control.ticks_per_second())
        node = _tossim.getNode(1)
        node.bootAtTime(control.time())
        node.bootAtTime(end_time)
        while control.time() < end_time:
            control.run_sim()
        duration = time.time() - rw_start

        assertAlmostEqual(real_seconds, duration, 2)

    yield run, 0.5
    yield run, 1
    yield run, 2

