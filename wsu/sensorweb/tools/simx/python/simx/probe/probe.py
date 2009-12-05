"""
Python side of actual Probe access.

Probes require a C extension to create the memory-backed buffer
objects. Once the buffer objects are created they can be examined
and/or manipulated directly. Access is directly linked with the
underlying Tossim data.

Unlike the ProbeDef'inition counter-parts, Probe objects are designed
to be as lightweight as possible. Thus, they shed all non-essential
information and types are directly represented with pack'ing
strings. (Probe objects still require a good bit of memory to maintain
complex hierarchies and each Probe is backed by at least one buffer object).

PST- does the above restriction of being "lightweight as possible"
detract from anything useful?
"""

import struct
from warnings import warn

from simx import json as simplejson

# An error on probe creation will be raised if a bind is performed on
# a mote with a value >= MAX_NODE_COUNT.
MAX_NODE_COUNT = 1000

def init(prober):
    """
    Initialize probe environment. This MUST be called before trying to
    create or use probes.

    WARN:: The Tossim MUST also be initialized prior to Probe creation.
    """
    global PROBER
    if PROBER is not NoProbeLibraryLoaded:
        raise RuntimeError("Probe.init() can only be called once")
    
    if prober:
        PROBER = CachingProber(prober)


class _NoProbeLibraryLoaded(object):
    """
    Basic class used for reporting errors when the probe environment
    is used without being initialized.
    """
    def get_buffer(self, *opts):
        raise RuntimeError("Probe environment not initialized.")
    def get_shadow_buffer(self, *opts):
        raise RuntimeError("Probe environment not initialized.")
    def get_dirty_list(self, *opts):
        raise RuntimeError("Probe environment not initialized.")

NoProbeLibraryLoaded = _NoProbeLibraryLoaded()

# Prober back-end (globally modified by init)
PROBER = NoProbeLibraryLoaded


class CachingProber(object):
    """
    Creating a caching wrapper around a prober.
    """

    def __init__(self, prober):
        self.prober = prober

        # Ideally these would be a weak-reference hashes. However, 'buffers'
        # are not valid referants for weakrefs (in Python 2.5, at least).
        # of {(node, Probe) => Buffer}
        self.probe_buffers = {}
        self.shadow_buffers = {}

        # pass-through
        self.get_dirty_list = prober.get_dirty_list
    
    def get_buffer(self, node, var):
        key = (node, var)
        buf = self.probe_buffers.get(key)
        if buf is None:
            buf = self.prober.get_buffer(node, var)
            self.probe_buffers[key] = buf
        return buf

    def get_shadow_buffer(self, node, var, len):
        key = (node, var)
        buf = self.shadow_buffers.get(key)
        if buf is None:
            buf = self.prober.get_shadow_buffer(node, var, len)
            self.shadow_buffers[key] = buf
        return buf


class Probe(object):

    # PST- memo slot can be used for extending Probe
    __slots__ = ['node', 'pack',
                 'offset', 'size',
                 'buf', 'shadow_buf',
                 '_memo']

    def __init__(self, node=-1, var=None, offset=-1, size=-1, pack='', **kws):
        # PST: kws ingored now... should be taken into account.
        assert node >= 0 and node < MAX_NODE_COUNT
        assert pack is not None and len(pack) > 0
        assert var is not None
        assert offset >= 0
        assert size >= 0

        self._memo = None

        self.node = node
        self.pack = pack
        self.offset = offset
        self.size = size

        try:
            packed_size = struct.calcsize(pack)
        except struct.error, e:
            raise struct.error("%s: '%s'" % (e, pack))

        self.buf = PROBER.get_buffer(node, var)

        # PST: needs to release buffer(s)?

        # PST- should alert to cases when wrong-sized packing used for
        # primitives (but won't help with byteorder).
        if size != packed_size:
            raise ValueError(
                "Probe size (%d) differs from packed size (%d)" %
                (size, packed_size))

        buflen = len(self.buf)
        #print "buflen:"
        #self._print_buffer(self.buf)
        if offset + packed_size > buflen:
            raise ValueError(
                "Out-of-bounds: offset(%d) + pack(%d:%s) > buffer(%d)" %
                (offset, packed_size, pack, buflen))

        self.shadow_buf = PROBER.get_shadow_buffer(node, var, buflen)
        assert len(self.shadow_buf) == len(self.buf), "buffer size mismatch"

        # shadow buffer is initial in-sync
        self.synchronize()
        #print "buflen:"
        #self._print_buffer(self.buf)

    @staticmethod
    def synchronize_all(probes):
        """
        Given a list of Probes, return the Probes that are "dirty". Dirty
        probes are the probes whose buffer contents differ from the
        contents of the shadow buffers, as shadow buffers are used to
        store the last synchronized state of the buffers.
        
        The also synchronizes the shadow buffers; that is, if called
        twice in a row, the 2nd invocation will always return an empty
        list. This operation is atomic. That is, if an Exception is
        raised, no change are made to the supplied Probes.
        """
        return PROBER.get_dirty_list(probes)

    def synchronize(self):
        """
        Synchronizes the shadow buffer with the primary buffer.

        Returns true if the shadow buffer needed to be
        synchronized. This is inneficient to do manually for a
        collection of probes; see Probe.synchronize_all.
        """
        return bool(PROBER.get_dirty_list([self]))

    def attrs(self):
        return {
            'offset': self.offset, 'pack': self.pack,
            'buf': self.buf, 'shadow_buf': self.shadow_buf
            }

    def str_attrs(self):
        """
        Attributes which are displayed with __str__ conversion.
        """
        attr = self.attrs()
        attr.update({"buf": len(self.buf),
                     "shadow_buf": self.shadow_buf is not None})
        return attr
    
    def dup(self, **opts):
        """
        Creates a duplicate object using **opts for overwriting.
        """
        attrs = self.attrs()
        attrs.update(opts)
        return self.__class__(**attrs)

    def __str__(self):
        """
        Display according to str_attrs.
        """
        return str(self.str_attrs())

    def get(self):
        """
        If a primitive, returns associated data.

        Complex objects should return themselves.
        """
        #print "pack", self.pack,"buf", self.buf,"offset",self.offset
        return struct.unpack_from(self.pack, self.buf, self.offset)[0]

    def set(self, value):
        """
        If a primitive, assigns data.

        Complex objects should raise a ValueError.
        """
        struct.pack_into(self.pack, self.buf, self.offset, value)

    def get_item(self, id=None):
        """
        Returns the item for id if and only if such an element
        exists. This is a form of __getitem__ that does not raise an
        exception and does not unwrap primitives.
        """
        return None

    def to_json(self):
        """
        Returns JSON representing the current structure and data
        """
        raise NotImplementedError("Subclass should implement")

    def print_buf(self):
        print "Buffer:"
        self._print_buffer(self.buf)

    def print_shadow_buf(self):
        print "Shadow Buffer:"
        self._print_buffer(self.shadow_buf)

    def _print_buffer(self, buffer):
        for i in xrange(0, len(buffer)):
            print "%02x" % ord(buffer[i]),
            if (i + 1) % 16 == 0:
                print
        print

    class DefaultMemo(dict):
        pass

    def memo(self, value=None):
        """
        Returns the memo object creating it if needed.
        
        If value is not supplied the new memo value is an object that
        allows property assignment.
        """
        if self._memo is None:
            self._memo = value or Probe.DefaultMemo()
        return self._memo


class ProbeArray(Probe):

    __slots__ = ['count', 'elements']

    def __init__(self, count=None, elements=None, **args):
        Probe.__init__(self, **args)

        assert elements is not None and hasattr(elements, "__iter__")
        # def's can have zero-size, but can only probe a sized array
        assert count is not None and count > 0
        # and make sure there isn't a liar...
        assert count == len(elements)

        self.count = count
        self.elements = elements

    def __getitem__(self, index):
        return self.elements[index].get()

    def __setitem__(self, index, value):
        return self.elements[index].set(value)

    def attrs(self):
        attrs = Probe.attrs(self)
        attrs.update({"count": self.count, "elements": self.elements})
        return attrs

    def str_attrs(self):
        attrs = Probe.str_attrs(self)
        element_count = (len(self.elements)
                         if self.elements is not None else None)
        attrs.update({"count": self.count, "elements(#)": element_count})
        return attrs

    def get(self):
        return self

    def set(self, value):
        raise ValueError("Complex structures may not be assigned directly")

    def get_item(self, index):
        if index >= 0 and index < self.count:
            return self.elements[index]


class ProbeStruct(Probe):

    __slots__ = ['members']

    def __init__(self, members=None, **args):
        Probe.__init__(self, **args)

        assert members is not None and hasattr(members, "__getitem__")
        self.members = members

    def __getitem__(self, key):
        return self.members[key].get()

    def __setitem__(self, key, value):
        return self.members[key].set(value)

    def attrs(self):
        attrs = Probe.attrs(self)
        attrs.update({"members": self.members})
        return attrs

    def str_attrs(self):
        attrs = Probe.str_attrs(self)
        attrs.update({"members": ",".join(self.members.keys())})
        return attrs

    def get(self):
        return self

    def set(self, value):
        raise ValueError("Complex structures may not be assigned directly")

    def get_item(self, key):
        return self.members.get(key)

