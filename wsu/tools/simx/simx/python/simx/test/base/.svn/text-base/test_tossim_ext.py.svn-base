from simx.base.testutil import import_assert_functions
import_assert_functions(globals())

from simx.base import TossimBase, Extension


TICKS_PER_SECOND = 42

class _TestNode():
    def __init__(self, id): self._id = id
    def id(self): return self._id

class _TestTossim():
    def ticksPerSecond(self): return TICKS_PER_SECOND
    def getNode(self, id): return _TestNode(id)
    def radio(self): return None


tossim = None
def setUp():
    global tossim
    tossim = TossimBase(_TestTossim())


class TestExtensionA(Extension):

    class Mixin(object):
        def alt_node_id(self):
            return self.id()

    def __init__(self):
        Extension.__init__(self, extension_name="extension_a")

    def decorate_node_class(self, node_class):
        Extension.mixin(node_class, TestExtensionA.Mixin)


class TestExtensionB(Extension):

    def __init__(self):
        Extension.__init__(self, extension_name="extension_b")

    def decorate_node(self, node):
        node.property_b = "property_b"


class TestExtensionC(Extension):

    class Mixin(object):
        def method_c(self):
            return "method_c"

    def __init__(self):
        Extension.__init__(self, extension_name="extension_c")
    
    def decorate_tossim_class(self, tossim_class):
        Extension.mixin(tossim_class, TestExtensionC.Mixin)
        tossim_class.property_c = "property_c"


def test_tossim_extension():
    tossim.register_extension(TestExtensionC())

    yield assertEquals, ["extension_c"], tossim.extension_names()
    yield assertEquals, "property_c", tossim.property_c
    yield assertEquals, "method_c", tossim.method_c()

    yield assertRaises, RuntimeError, \
        lambda: tossim.register_extension(TestExtensionC())

    node0 = tossim[0]
    tossim.register_extension(TestExtensionA())
    tossim.register_extension(TestExtensionB())
    node1 = tossim[1]

    yield assertEquals, 0, node0.alt_node_id()
    yield assertEquals, 1, node1.alt_node_id()

    yield assertEquals, "property_b", node0.property_b
    yield assertEquals, "property_b", node1.property_b
