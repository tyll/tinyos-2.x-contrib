"""
Test 'RadioRedirect'
"""

from simx.base.testutil import import_assert_functions
import_assert_functions(globals())

from simx.base import TossimBase
from simx.base import Node

from TOSSIM import Tossim
_tossim = Tossim([])

tossim = None
radio = None
a = None
b = None
c = None
def setUp():
    global tossim, radio, a, b, c

    # base
    tossim = TossimBase(_tossim)
    radio = tossim.radio()

    # fetch unlinked nodes
    def unlink_all(x):
        for other in x.neighbors():
            x.unlink_both(other)

    a, b, c = tossim[[0, 1, 2]]
    for x in [a, b, c]:
        unlink_all(x)
        assertEquals([], list(a.neighbors()))


# threshold not in early 2.x
#def test_threshold():
#    radio.set_threshold(-42)
#    yield assertEquals, -42, radio.threshold()
#    radio.set_threshold(17)
#    yield assertEquals, 17, radio.threshold()


def test_link():
    for n in [127, 1, 0, -1, -128]:
        radio.add(a.id(), b.id(), n)
        radio.remove(a.id(), c.id())
        yield assertEquals, n, a.get_link(b)
        yield assertEquals, None, a.get_link(c)
        yield assertEquals, [b], list(a.neighbors())
        yield assertEquals, [(b, n)], list(a.links())
        yield assertEquals, None, b.get_link(a)
        yield assertEquals, None, c.get_link(a)
        radio.add(a.id(), c.id(), n)
        yield assertEquals, n, a.get_link(b)
        yield assertEquals, n, a.get_link(c)
        yield assertEquals, sorted([b, c]), sorted(list(a.neighbors()))
        yield assertEquals, sorted([(b, n), (c, n)]), sorted(list(a.links()))
        yield assertEquals, None, b.get_link(a)
        yield assertEquals, None, c.get_link(a)


def test_link_both():
    for n in [127, 1, 0, -1, -128]:
        radio.add(a.id(), b.id(), n)
        radio.add(b.id(), a.id(), n)
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
