#!/usr/bin/env python

import re
import sys
import unittest
import random

from TOSSIM import Tossim
import SimxProbe

from simx.probe import Loader

# Tossim /must/ be initialized first -- doesn't matter if not used directly
Tossim([])
# Only load once, should be tested elsewhere :-)
loader = Loader('app.xml', SimxProbe)


#hack(s) to get unittest asserts
class _Check(unittest.TestCase):
    def runTest(self):
        pass

check = _Check()
# PST- beautiful, but perhaps too much magic
# allows direct use of assertEquals, etc. by importing them
for f in (x for x in dir(check) if re.match("(?:assert|fail)", x)):
    globals()[f] = getattr(check, f)


def test_shared1():
    # bind to same node
    a = loader.lookup("ProbeTestC$nx_struct_data").bind(1)
    b = loader.lookup("ProbeTestC$nx_struct_data").bind(1)

    assert a.buf is b.buf, "same buffers"
    assert a.shadow_buf is b.shadow_buf, "same shadow buffers"

    for i in xrange(0, a.count):
        b[i] = 42
        a[i] = i
        assertEquals(i, b[i])


def test_not_shared1():
    # bind to different nodes
    a = loader.lookup("ProbeTestC$nx_struct_data").bind(1)
    b = loader.lookup("ProbeTestC$nx_struct_data").bind(2)

    assert a.buf is not b.buf, "different buffers"
    assert a.shadow_buf is not b.buf, "different shadow buffers"

    for i in xrange(0, a.count):
        b[i] = 42
        a[i] = i
        assertEquals(42, b[i])


# how many times to run more advanced tests...
iters = 2000

# NX Struct tests

def shared_nx_struct_data():
    """
    Return a tuple of shared probes. The second is a
    nx_varied_struct_t rebinding.
    """
    return (loader.lookup("ProbeTestC$nx_struct_data").bind(1),
            loader.lookup("ProbeTestC$nx_struct_data",
                          ["", "nx_varied_struct_t"]).bind(1))
    
def test_types_struct_size():
    raw, fmt = shared_nx_struct_data()
    assertEquals(1+1+2+2+4+4, raw.count)

def test_types_struct_int8_read():
    raw, fmt = shared_nx_struct_data()
    for n in xrange(-128, 128):
        raw[0] = n & 0xff
        assertEquals(n, fmt["int8"])

def test_types_struct_int8_write():
    raw, fmt = shared_nx_struct_data()
    for n in xrange(-128, 128):
        fmt["int8"] = n
        assertEquals(n & 0xff, raw[0])

def test_types_struct_uint8_read():
    raw, fmt = shared_nx_struct_data()
    for n in xrange(0, 256):
        raw[1] = n
        assertEquals(n, fmt["uint8"])

def test_types_struct_uint8_write():
    raw, fmt = shared_nx_struct_data()
    for n in xrange(0, 256):
        fmt["uint8"] = n
        assertEquals(n, raw[1])

def test_types_struct_int16_read():
    raw, fmt = shared_nx_struct_data()
    for i in xrange(0, iters):
        n = random.randint(-0x7fff, 0x7ffe)
        raw[2] = (n >> 8) & 0xff
        raw[3] = n & 0xff
        assertEquals(n, fmt["int16"])

def test_types_struct_int16_write():
    raw, fmt = shared_nx_struct_data()
    for i in xrange(0, iters):
        n = random.randint(-0x7fff, 0x7ffe)
        fmt["int16"] = n
        assertEquals(n & 0xffff, raw[2]<<8 | raw[3])

def test_types_struct_uint16_read():
    raw, fmt = shared_nx_struct_data()
    for i in xrange(0, iters):
        n = random.randint(0, 0xffff)
        raw[4] = (n >> 8) & 0xff
        raw[5] = n & 0xff
        assertEquals(n, fmt["uint16"])

def test_types_struct_uint16_write():
    raw, fmt = shared_nx_struct_data()
    for i in xrange(0, iters):
        n = random.randint(0, 0xffff)
        fmt["uint16"] = n
        assertEquals(n, raw[4] << 8 | raw[5])

def test_types_struct_int32_read():
    raw, fmt = shared_nx_struct_data()
    for i in xrange(0, iters):
        n = random.randint(-0x7fffffff, 0x7ffffffe)
        raw[6] = (n >> 24) & 0xff
        raw[7] = (n >> 16) & 0xff
        raw[8] = (n >> 8) & 0xff
        raw[9] = n & 0xff
        assertEquals(n, fmt["int32"])

def test_types_struct_int32_write():
    raw, fmt = shared_nx_struct_data()
    for i in xrange(0, iters):
        n = random.randint(-0x7fffffff, 0x7ffffffe)
        fmt["int32"] = n
        assertEquals(n & 0xffffffff,
                     raw[6]<<24 | raw[7]<<16 | raw[8]<<8 | raw[9])

def test_types_struct_uint32_read():
    raw, fmt = shared_nx_struct_data()
    for i in xrange(0, iters):
        n = random.randint(0, 0xffffffff)
        raw[10] = (n >> 24) & 0xff
        raw[11] = (n >> 16) & 0xff
        raw[12] = (n >> 8) & 0xff
        raw[13] = n & 0xff
        assertEquals(n, fmt["uint32"])

def test_types_struct_uint32_write():
    raw, fmt = shared_nx_struct_data()
    for i in xrange(0, iters):
        n = random.randint(0, 0xffffffff)
        fmt["uint32"] = n
        assertEquals(n, raw[10]<<24 | raw[11]<<16 | raw[12]<<8 | raw[13])


# NX Union tests

def shared_nx_union_data():
    """
    Return a tuple of shared probes. The second is a
    nx_varied_struct_t rebinding.
    """
    return (loader.lookup("ProbeTestC$nx_union_data").bind(1),
            loader.lookup("ProbeTestC$nx_union_data",
                          ["", "nx_varied_union_t"]).bind(1))
    
def test_types_union_size():
    raw, fmt = shared_nx_union_data()
    assertEquals(4, raw.count)

def test_types_union_int8_read():
    raw, fmt = shared_nx_union_data()
    for n in xrange(-128, 128):
        raw[0] = n & 0xff
        assertEquals(n, fmt["int8"])

def test_types_union_int8_write():
    raw, fmt = shared_nx_union_data()
    for n in xrange(-128, 128):
        fmt["int8"] = n
        assertEquals(n & 0xff, raw[0])

def test_types_union_uint8_read():
    raw, fmt = shared_nx_union_data()
    for n in xrange(0, 256):
        raw[0] = n
        assertEquals(n, fmt["uint8"])

def test_types_union_uint8_write():
    raw, fmt = shared_nx_union_data()
    for n in xrange(0, 256):
        fmt["uint8"] = n
        assertEquals(n, raw[0])

def test_types_union_int16_read():
    raw, fmt = shared_nx_union_data()
    for i in xrange(0, iters):
        n = random.randint(-0x7fff, 0x7ffe)
        raw[0] = (n >> 8) & 0xff
        raw[1] = n & 0xff
        assertEquals(n, fmt["int16"])

def test_types_union_int16_write():
    raw, fmt = shared_nx_union_data()
    for i in xrange(0, iters):
        n = random.randint(-0x7fff, 0x7ffe)
        fmt["int16"] = n
        assertEquals(n & 0xffff, raw[0]<<8 | raw[1])

def test_types_union_uint16_read():
    raw, fmt = shared_nx_union_data()
    for i in xrange(0, iters):
        n = random.randint(0, 0xffff)
        raw[0] = (n >> 8) & 0xff
        raw[1] = n & 0xff
        assertEquals(n, fmt["uint16"])

def test_types_union_uint16_write():
    raw, fmt = shared_nx_union_data()
    for i in xrange(0, iters):
        n = random.randint(0, 0xffff)
        fmt["uint16"] = n
        assertEquals(n, raw[0] << 8 | raw[1])

def test_types_union_int32_read():
    raw, fmt = shared_nx_union_data()
    for i in xrange(0, iters):
        n = random.randint(-0x7fffffff, 0x7ffffffe)
        raw[0] = (n >> 24) & 0xff
        raw[1] = (n >> 16) & 0xff
        raw[2] = (n >> 8) & 0xff
        raw[3] = n & 0xff
        assertEquals(n, fmt["int32"])

def test_types_union_int32_write():
    raw, fmt = shared_nx_union_data()
    for i in xrange(0, iters):
        n = random.randint(-0x7fffffff, 0x7ffffffe)
        fmt["int32"] = n
        assertEquals(n & 0xffffffff,
                     raw[0]<<24 | raw[1]<<16 | raw[2]<<8 | raw[3])

def test_types_union_uint32_read():
    raw, fmt = shared_nx_union_data()
    for i in xrange(0, iters):
        n = random.randint(0, 0xffffffff)
        raw[0] = (n >> 24) & 0xff
        raw[1] = (n >> 16) & 0xff
        raw[2] = (n >> 8) & 0xff
        raw[3] = n & 0xff
        assertEquals(n, fmt["uint32"])

def test_types_union_uint32_write():
    raw, fmt = shared_nx_union_data()
    for i in xrange(0, iters):
        n = random.randint(0, 0xffffffff)
        fmt["uint32"] = n
        assertEquals(n, raw[0]<<24 | raw[1]<<16 | raw[2]<<8 | raw[3])
