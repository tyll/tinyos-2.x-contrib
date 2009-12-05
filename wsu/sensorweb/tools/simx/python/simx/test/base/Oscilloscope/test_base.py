# hack(s) to get unittest asserts-
# allows direct use of assertEquals, etc. by importing them

from simx.base.testutil import import_assert_functions
import_assert_functions(globals())

import random

from TOSSIM import Tossim
from simx.base import TossimBase

_tossim = Tossim([])
tossim = None

def setUp():
    global tossim
    tossim = TossimBase(_tossim)


def test_no_cached_nodes():
    # cached nodes should initially be empty
    assertEquals([], tossim.cached_nodes())


def test_default_max_nodes():
    assertTrue(tossim.max_nodes() >= 1000, "funny max nodes")


def test_ticks():
    tps = _tossim.ticksPerSecond()
    yield assertEquals, tps, tossim.ticks_per_second()
    for n in range(-1, 2):
        yield assertEquals, n * tps, tossim.seconds_as_ticks(n)


def test_time_str():
    assertEquals(_tossim.timeStr(), tossim.time_str())


def test_node_access():
    for id in xrange(0, tossim.max_nodes()):
        node = tossim.get_node(id)
        assertEquals(id, node.id())


def test_node_range_guard1():
    for id in [-1, tossim.max_nodes()]:
        assertRaises(IndexError, tossim.get_node, id)


def test_node_cached():
    for count in xrange(0, 500):
        id = random.randint(0, tossim.max_nodes() - 1)
        assertSame(tossim[id], tossim[id])


def test_node_cached2():
    for count in xrange(0, 500):
        id1 = id2 = random.randint(0, tossim.max_nodes() - 1)
        while id2 == id1:
            id2 = random.randint(0, tossim.max_nodes() - 1)
        assertNotSame(tossim[id1], tossim[id2])


def test_getitem_iterable():
    def check_match(nodes, ids):
        assertEquals(ids, [node.id() for node in nodes])
        
    for count in xrange(0, 100):
        ids = random.sample(xrange(0, 1000), count)
        yield check_match, tossim.get_nodes(ids), ids
        yield check_match, tossim[ids], ids
        

def test_getitem_range():
    def check_match(nodes, ids):
        assertEquals(ids, [node.id() for node in nodes])

    # full
    yield check_match, tossim[:], range(0,1000)
    yield check_match, tossim[0:], range(0,1000)
    # off top-bound
    yield check_match, tossim[42:1462], range(42,1000)
    # single
    yield check_match, tossim[1:2], [1]
    # zero-size
    yield check_match, tossim[100:100], []
    yield check_match, tossim[100:20], []
    # from back
    yield check_match, tossim[100:-20], range(100, 1000-20)


def test_getitem_single():
    for count in xrange(0, 10):
        id = random.randint(0, 999)
        yield lambda _: assertSame(tossim.getNode(_), tossim[_]), id


def test_attribute_error():
    try:
        tossim.does_not_exist
        assertTrue(False, "should raise exception")
    except AttributeError, e:
        # should display loaded extensions, or something
        assertTrue("extensions=" in e.message)

