from .probe import Probe, ProbeArray, ProbeStruct

from simx import json as simplejson

# Mapping of a "c name" onto a primitive. At the very least this makes
# the assumption that the compiler used to compile python and the nesC
# compiler aggree on the size of each type. (If the sizes do not match
# the error should be caught during Probe construction.)

# PST-- this should possibly take into account the "lesser systems";
# is there a reliable way to determine Python-nesC type mappings?
PRIMITIVES = {
    'unsigned char': 'B',
    'signed char': 'b',
    'unsigned short':'H',
    'short': 'h',
    'unsigned int': 'L', #H/2
    'int': 'i', #(TossimApp has this as 'L', why?) h/2
    'unsigned long': 'L',
    'long': 'l',
    'long long': 'q',
    'unsigned long long': 'Q',
    'float': 'f',
    'double': 'd', #f/4
    'char': 'c',
    # PST- this is very suspect, it might "work" on x86-64
    'pointer': 'L'
    }


class Definition():
    """
    A probe defintion is used to capture the important information
    about a variable/structure scheme for interaction with
    Tossim. Among other things this includes type information and
    memory offsets.

    Definitions are designed to make minimal distinction between
    declarations (variables), structural definitions (types), and
    typedefs insomuch as they are represented by the same structures.

    Variable definitions may be fully resolved and, in doing so, will
    also enable child definitions to be resolved.
    """

    __slots__ = ['var', 'var_offset', 'offset_bits', 'size']

    def __init__(self, var=None, var_offset=None, size=-1, offset_bits=None):
        assert type is not None
        assert size >= 0 # structs may have 0 size

        # Base TOSSIM variable-entry point (string) and offset in
        # bytes away from the start of the variable. These are both
        # set if a probe definition is fully resolved.
        self.var = var
        self.var_offset = var_offset

        # Offset in BITS from parent and total number of BYTES used.
        self.offset_bits = offset_bits
        self.size = size


    def attrs(self):
        """
        Attributes which survive clones (base must return a new dict).
        """
        return {
            "var": self.var, "var_offset": self.var_offset,
            "size": self.size, "offset_bits": self.offset_bits
            }


    def probe_attrs(self):
        """
        Attributes normalized to create Probe objects"
        """
        attrs = self.attrs()
        attrs['offset'] = attrs['var_offset']
        attrs['pack'] = self.pack_def()
        del attrs['var_offset']
        del attrs['offset_bits']
        return attrs


    def str_attrs(self):
        """
        Attributes which are displayed with __str__ conversion.
        """
        attrs = self.attrs()
        attrs['pack'] = self.pack_def()
        return attrs

    
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


    def norm_type(self, type):
        """
        Returns normalized type (de-references ProbeLink types).

        Raises a ValueError on an unresolved link.
        """
        if hasattr(type, "link"):
            linked = type.link
            if linked is None:
                raise ValueError("Unresolved link, ref=%s" % type.ref)
            return linked
        else:
            return type


    def pack_def(self):
        """
        Pack format to access the specific type.
        """
        raise NotImplementedError("Subclass must implement")


    def _check_var(self, var):
        var = var or self.var
        if not var:
            raise RuntimeError("Not variable-bound: %s" % str(self))
        return var


    def _replace(self, var=None, var_offset=0, level="", replace={}):
        """
        Common resolving stuff.

        If level matches a replace specification then a replace occurs
        (really just a directed resolve). Will return a (resolved,
        unused_replacements) or None.
        """
        if level in replace:
            # PST- stay side-effect free
            _replace = dict(replace)
            r = _replace.pop(level)
            #print "level: ",level,"r ",r.size,self.size
            if r.size > self.size:
                raise ValueError(
                    "Target (%s) exceeds level size (%s): %d > %d" %
                    (r, level, r, self.size))

            # Ensure some important data, such as offset bits, are
            # kept across a replace. (Could also likely keep a max
            # size).
            resolved_info = r._resolve(var, var_offset, level, _replace)
            if resolved_info:
                resolved, _ = resolved_info
                resolved.offset_bits = self.offset_bits
                return resolved_info


    def _resolve(self, var, var_offset, level, replace):
        """
        Walk the definition and resolve addresses into physical space
        using the stored offset information. In addition all
        ProbeLinks are resolved and, in the case where resolution
        fails, an exception is generated.

        During resolution the object schema may be greatly
        expanded. That is, each element in an array and each named
        field, etc, are themselves resolved.

        Replace is a mapping from "levels" to replacement probe
        definition objects. The replacement definitions must be able
        to fit inside the original definitions. Levels are in the form
        "[keyindex1][keyindex2]", etc with the first level being "".
        If a resolve uses a replacement then it should remove it from
        the replace structure.

        The return value is a tuple of (resolved_type,
        unused_replacements) where unused_replacements is in the same
        form as replace.

        Entirely new data structures are returned (free from the
        originals).
        """
        raise NotImplementedError("Subclass must implement")


    def resolve(self, var=None, var_offset=0, level="", replace={}):
        """
        Resolve a definition; see _resolve.
        
        Return is of (resolved_type, unused_replacements).
        """
        return self._resolve(var, var_offset, level, replace)


    def is_resolved(self):
        """
        True if it looks like this object is resolved

        This should not be called from within resolve and carries the
        implication that all children are also resolved.
        """
        return self.var_offset is not None


    def bind(self, node):
        """
        Bind to a specific node; returns a Probe object.

        The definition must already be resolved.
        """
        #print " self.probe_attrs(): ", self.probe_attrs()
        return Probe(node=node, **self.probe_attrs())
        

    def to_basic(self):
        """
        Convert the probe definition into a "simple"
        dict/list/primitive structure.
        """
        raise NotImplementedError("Subclass must implement")


    def to_json(self):
        """
        Return JSON representation of definition.
        """
        return simplejson.dumps(self.to_basic())


class Primitive(Definition):

    __slots__ = ['type', 'nx_type']

    def __init__(self, type=None, nx_type=False, **args):
        Definition.__init__(self, **args)
        self.type = type       # "cname"
        self.nx_type = nx_type # network type?


    def pack_def(self):
        try:
            base = PRIMITIVES.get(self.type)
            return ("!" + base) if self.nx_type else base
        except KeyError, e:
            raise KeyError("%s: invalid primitive (%s)" % (e, self.type))


    def attrs(self):
        attrs = Definition.attrs(self)
        attrs['type'] = self.type
        attrs['nx_type'] = self.nx_type
        return attrs


    def str_attrs(self):
        attrs = self.attrs()
        try:
            attrs['type'] = str(self.norm_type(self.type))
        except ValueError:
            attrs['type'] = "<unresolved>"
        return attrs


    def bind(self, node):
        attrs = self.probe_attrs()
        del attrs['type']
        del attrs['nx_type']
        return Probe(node=node, **attrs)

    
    def _resolve(self, var, var_offset, level, replace):
        var = self._check_var(var)

        def own():
            return (self.dup(var=var, var_offset=var_offset), replace)

        return self._replace(var, var_offset, level, replace) or own()

    
    def to_basic(self):
        return self.type


class Array(Definition):

    # PST- why is separate count kept again?
    __slots__ = ['count', 'element_type', 'elements']

    def __init__(self, count=-1, element_type=None, elements=None, **args):
        Definition.__init__(self, **args)
        # some arrays can be zero-sized
        assert count >= 0
#        assert elements is not None and count == len(elements)
        self.count = count
        self.element_type = element_type
        self.elements = elements


    def __getitem__(self, index):
        return self.elements[index]


    def attrs(self):
        attrs = Definition.attrs(self)
        attrs['count'] = self.count
        attrs['element_type'] = self.element_type
        attrs['elements'] = self.elements
        return attrs


    def str_attrs(self):
        attrs = Definition.str_attrs(self)
        attrs['element_type'] = str(self.norm_type(self.element_type))
        del attrs['elements']
        return attrs


    def pack_def(self):
        if self.count == 0:
            return ""

        norm_type = self.norm_type(self.element_type)
        pack = PRIMITIVES.get(norm_type.type)
        if pack:
            # made up of primitive types
            return str(self.count) + pack
        else:
            # contains other complex
            return str(self.count * norm_type.size) + "c"


    def _resolve(self, var, var_offset, level, replace):
        var = self._check_var(var)

        def own(_replace):
            if self.count == 0:
                # PST- what about root?
                return self.dup(elements=[])

            norm_type = self.norm_type(self.element_type)
            elm_size = self.size / self.count
            elements = []

            for i in xrange(0, self.count):
                next_level = level + "[%d]" % i
                offset = i * elm_size + var_offset
                # updates _replace
                r, _replace = norm_type._resolve(
                    var, offset, next_level, _replace)
                elements.append(r)

            return (self.dup(var=var, var_offset=var_offset,
                             elements=elements),
                    _replace)

        return self._replace(var, var_offset, level, replace) or own(replace)

        
    def bind(self, node):
        attrs = self.probe_attrs()
        attrs['elements'] = [e.bind(node) for e in self.elements]
        del attrs['element_type']
        return ProbeArray(node=node, **attrs)


    def to_basic(self):
        if self.count == 0:
            return []
        try:
            norm_type = self.norm_type(self.element_type)
        except ValueError:
            norm_type = Primitive("<invalid>", size=1)
        return {
            '$type': 'array',
            '$count': self.count,
            '$of': norm_type.to_basic()
            }


class Struct(Definition):

    __slots__ = ['members']

    def __init__(self, members=None, **args):
        Definition.__init__(self, **args)
        self.members = members or {}


    def __getitem__(self, key):
        return self.members[key]


    def attrs(self):
        attrs = Definition.attrs(self)
        attrs['members'] = self.members
        return attrs


    def str_attrs(self):
        attrs = Definition.str_attrs(self)
        attrs['members'] = ",".join(self.members.keys())
        return attrs


    def pack_def(self):
        return str(self.size) + "s"


    def _resolve(self, var, var_offset, level, replace):
        var = self._check_var(var)

        def own(_replace):
            members = {}

            for name, member in self.members.iteritems():
                if member.offset_bits is None:
                    raise ValueError("Required offset_bits missing " +
                                     "for member: " + name)

                byte_offset = member.offset_bits / 8
                if byte_offset + member.size > self.size:
                    raise ValueError("Overflow: %d > %d" %
                                     (byte_offset + member.size, self.size))

                # updates _replace
                members[name], _replace = member._resolve(
                    var, var_offset + byte_offset,
                    level + "[%s]" % name, _replace)

            return (self.dup(var=var, var_offset=var_offset, members=members),
                    _replace)

        return self._replace(var, var_offset, level, replace) or own(replace)


    def bind(self, node):
        attrs = self.probe_attrs()
        attrs['members'] = dict((n, v.bind(node))
                                for (n, v)
                                in self.members.iteritems())
        return ProbeStruct(node=node, **attrs)


    def to_basic(self):
#        res = dict((k, v.to_basic()) for k, v in self.members.iteritems())
        res = {}
        res['$type'] = 'struct'
        res['$members'] = [(k, v.to_basic()) for k, v
                           in self.members.iteritems()]
        return res
        

class Link(Definition):

    def __init__(self, type=None, **args):
        Definition.__init__(self, **args)
        if (not type or not hasattr(type, "link")):
            raise ValueError("Expecting ProbeLink (found=%s)" % repr(type))
        self.type = type


    def attrs(self):
        attrs = Definition.attrs(self)
        attrs['type'] = self.type
        return attrs


    def str_attrs(self):
        attrs = self.attrs()
        try:
            attrs['type'] = str(self.norm_type(self.type))
        except ValueError:
            attrs['type'] = "<unresolved>"
        return attrs


    def __getitem__(self, key_index):
        self.norm_type(self.type)[key_index]


    def _resolve(self, var, var_offset, level, replace):
        # Just map-through link
        var = self._check_var(var)
        norm_type = self.norm_type(self.type)
        return norm_type._resolve(var, var_offset, level, replace)
    

    def to_basic(self):
        try:
            norm_type = self.norm_type(self.type)
        except ValueError:
            norm_type = Primitive("<invalid>", size=0)
        return norm_type.to_basic()
