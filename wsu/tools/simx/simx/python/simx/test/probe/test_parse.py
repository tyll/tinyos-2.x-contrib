"""
Some basic "dry" tests; testing is limited to non-fetch/get due to the
innability to modify the test buffers. Other parts of the probe
library should be testable, however. To save /lots/ of time running
the tests, the XML is only loaded once and is assumed to be working
(it should be tested in test_loader.py).
"""

from simx.probe import Loader
from simx.probe import ReplacementError, LookupError

class DummyProber(object):
    # PST- Gross hack to make up imaginary test buffer. For better or
    # worse (I tend to think the latter), python 2.5 does not have a
    # pure python way of creating real immutable buffers.
    def get_buffer(self, node, var): return " " * 4096
    def get_shadow_buffer(self, node, var, length): return " " * length
    def get_dirty_list(self, lst): return []


loader = Loader("MultihopOscilloscope_app.xml", DummyProber())


def looks_like_oscilloscope_t(probe):
    items = ["version", "interval", "id", "count", "readings"]
    return all(probe.get_item(x) for x in items)


def looks_like_message_t(probe):
    items = ["header", "metadata", "data", "footer"]
    return all(probe.get_item(x) for x in items)


def test_lookup1():
    probe_def = loader.lookup("MultihopOscilloscopeC$sendbuf")
    probe = probe_def.bind(1)
    assert looks_like_message_t(probe)
    assert not looks_like_oscilloscope_t(probe)

    
def test_cached_lookup1():
    probe_def1 = loader.lookup("MultihopOscilloscopeC$sendbuf")
    probe_def2 = loader.lookup("MultihopOscilloscopeC$sendbuf")
    assert probe_def1 is probe_def2

    
def test_cached_lookup2():
    probe_def1 = loader.lookup("MultihopOscilloscopeC$sendbuf",
                               ["[data]", "oscilloscope_t"])
    probe_def2 = loader.lookup("MultihopOscilloscopeC$sendbuf",
                               ["[data]", "oscilloscope_t"])
    assert probe_def1 is probe_def2


def test_cached_lookup_fail1():
    probe_def1 = loader.lookup("MultihopOscilloscopeC$sendbuf")
    probe_def2 = loader.lookup("MultihopOscilloscopeC$sendbuf",
                               ["[data]", "oscilloscope_t"])
    assert probe_def1 is not probe_def2


def test_cached_lookup_fail2():
    probe_def1 = loader.lookup("MultihopOscilloscopeC$sendbuf",
                               ["[data]", "oscilloscope_t"])
    probe_def2 = loader.lookup("MultihopOscilloscopeC$sendbuf",
                               ["", "oscilloscope_t"])
    assert probe_def1 is not probe_def2


def test_lookup_rebind_fail0():
    try:
        loader.lookup("doesnotexist")
        assert False, "exception should be raised"
    except LookupError, e:
        pass


def test_lookup_rebind_fail1():
    try:
        loader.lookup("MultihopOscilloscopeC$sendbuf",
                      ["[doesnotexist]", "oscilloscope_t"])
        assert False, "exception should be raised"
    except ReplacementError, e:
        pass


def test_lookup_rebind_fail2():
    try:
        loader.lookup("MultihopOscilloscopeC$sendbuf",
                      ["[data]", "doesnotexist"])
        assert False, "exception should be raised"
    except LookupError, e:
        pass


def test_lookup_rebind_member():
    probe_def = loader.lookup("MultihopOscilloscopeC$sendbuf",
                              ["[data]", "oscilloscope_t"])
    probe = probe_def.bind(1)
    assert looks_like_message_t(probe)
    assert looks_like_oscilloscope_t(probe['data'])


def test_lookup_rebind_index():
    probe_def = loader.lookup("MultihopOscilloscopeC$sendbuf",
                              ["[data][0]", "int8_t"],
                              ["[data][1]", "uint8_t"])
    probe = probe_def.bind(1)
    assert looks_like_message_t(probe)
     

def test_lookup_rebind_base():
    probe_def = loader.lookup("MultihopOscilloscopeC$sendbuf",
                              ["", "oscilloscope_t"])
    probe = probe_def.bind(1)
    assert not looks_like_message_t(probe)
    assert looks_like_oscilloscope_t(probe)
    

def test_lookup_rebind_order1():
    probe_def = loader.lookup("MultihopOscilloscopeC$sendbuf",
                              ["[data]", "oscilloscope_t"],
                              ["", "oscilloscope_t"])
    probe = probe_def.bind(1)
    assert not looks_like_message_t(probe)
    assert looks_like_oscilloscope_t(probe)


def test_lookup_rebind_order2():
    try:
        loader.lookup("MultihopOscilloscopeC$sendbuf",
                      ["", "oscilloscope_t"],
                      ["[data]", "oscilloscope_t"])
        assert False, "exception should have been raised"
    except ReplacementError, e:
        # rebinding happens sequentially, second rebind fails
        pass


def test_double_rebind1():
    # should be okay, nothing checks/cares
    probe_def = loader.lookup("MultihopOscilloscopeC$sendbuf",
                  ["[data]", "oscilloscope_t"],
                  ["[data]", "oscilloscope_t"])
    probe = probe_def.bind(1)
    assert looks_like_message_t(probe)
    assert looks_like_oscilloscope_t(probe["data"])


def test_double_rebind2():
    probe_def = loader.lookup("MultihopOscilloscopeC$sendbuf",
                  ["[data]", "oscilloscope_t"],
                  ["[data]", "uint8_t"])
    probe = probe_def.bind(1)
    assert looks_like_message_t(probe)
    assert not looks_like_oscilloscope_t(probe.get_item("data"))


def test_nested_rebind():
    probe_def = loader.lookup("MultihopOscilloscopeC$sendbuf",
                              ["[data]", "oscilloscope_t"],
                              ["[data][version]", "uint8_t"])    
    probe = probe_def.bind(1)
    assert looks_like_message_t(probe)
    assert looks_like_oscilloscope_t(probe.get_item("data"))
