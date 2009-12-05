from simx.base.testutil import import_assert_functions
import_assert_functions(globals())

from simx.base import TossimBase
from simx.base import Node

from TOSSIM import Tossim
_tossim = Tossim([])

tossim = None
a = None
b = None
c = None
def setUp():
    global tossim, a, b, c

    # base
    tossim = TossimBase(_tossim)

    # fetch unlinked nodes
    def unlink_all(x):
        for other in x.neighbors():
            x.unlink_both(other)

    a, b, c = tossim[[0, 1, 2]]
    for x in [a, b, c]:
        unlink_all(x)
        assertEquals([], list(a.neighbors()))


def test_node_attribute_error():
    node = tossim[0]
    try:
        node.does_not_exist
        assertTrue(False, "should raise exception")
    except AttributeError, e:
        assertTrue("extensions=" in e.message,
                   "extensions= in %s" % e.message)


# PST- due to overflow bugs in Tossim (and that there is no way to
# clear the noise traces) each test that uses noise trace readings
# works on its own discrete node.

# NODE 0
def test_build_noise_model_bad():
    # ValueError if not enough readings
    node = tossim[0]
    yield assertRaises, ValueError, node.create_noise_model
 
    # still not enough
    for count in xrange(0, Node.MIN_TRACE_SIZE - 1):
        node.add_noise_trace_reading(0)

    yield assertRaises, ValueError, node.create_noise_model


# NODE 1
def test_build_noise_model_ok():
    # enough readings
    node = tossim[1]
    for count in xrange(0, Node.MIN_TRACE_SIZE):
        node.add_noise_trace_reading(0)
    yield assertNotRaises, node.create_noise_model


# NODE 2
def test_flat_floor_ok():
    node = tossim[2]
    yield assertNotRaises, node.use_flat_noise_floor
    yield assertNotRaises, node.create_noise_model


# NODE 3
def test_flat_floor_bad():
    # RuntimeError if if already has traces
    node = tossim[3]
    node.add_noise_trace_reading(0)
    yield assertRaises, RuntimeError, node.use_flat_noise_floor, 0


# linking tests


def test_link_bad():
    yield assertEquals, None, a.get_link(b)
    # None value
    yield assertRaises, ValueError, a.link, b, None
    # can't link to self
    yield assertRaises, ValueError, a.link, a, 100
    yield assertEquals, None, a.get_link(b)


def test_link():
    for n in [127, 1, 0, -1, -128]:
        a.link(b, n)
        a.unlink(c)
        yield assertEquals, n, a.get_link(b)
        yield assertEquals, None, a.get_link(c)
        yield assertEquals, [b], list(a.neighbors())
        yield assertEquals, [(b, n)], list(a.links())
        yield assertEquals, None, b.get_link(a)
        yield assertEquals, None, c.get_link(a)
        a.link(c, n)
        yield assertEquals, n, a.get_link(b)
        yield assertEquals, n, a.get_link(c)
        yield assertEquals, sorted([b, c]), sorted(list(a.neighbors()))
        yield assertEquals, sorted([(b, n), (c, n)]), sorted(list(a.links()))
        yield assertEquals, None, b.get_link(a)
        yield assertEquals, None, c.get_link(a)


def test_link_both():
    for n in [127, 1, 0, -1, -128]:
        a.link_both(b, n)
        yield assertEquals, n, a.get_link(b)
        yield assertEquals, n, b.get_link(a)


def test_unlink():
    a.link(b, 1)
    b.unlink(a) # hah, wrong way!
    yield assertEquals, 1, a.get_link(b)
    a.unlink(b)
    yield assertEquals, None, a.get_link(b)


def test_unlink_both():
    a.link_both(b, 1)
    a.unlink_both(b)
    yield assertEquals, None, a.get_link(b)
    yield assertEquals, None, b.get_link(a)
