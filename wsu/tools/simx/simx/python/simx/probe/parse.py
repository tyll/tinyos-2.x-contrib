# "Copyright (c) 2000-2003 The Regents of the University of California.  
# All rights reserved.
#
# Permission to use, copy, modify, and distribute this software and its
# documentation for any purpose, without fee, and without written agreement
# is hereby granted, provided that the above copyright notice, the following
# two paragraphs and the author appear in all copies of this software.
# 
# IN NO EVENT SHALL THE UNIVERSITY OF CALIFORNIA BE LIABLE TO ANY PARTY FOR
# DIRECT, INDIRECT, SPECIAL, INCIDENTAL, OR CONSEQUENTIAL DAMAGES ARISING OUT
# OF THE USE OF THIS SOFTWARE AND ITS DOCUMENTATION, EVEN IF THE UNIVERSITY
# OF CALIFORNIA HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
# 
# THE UNIVERSITY OF CALIFORNIA SPECIFICALLY DISCLAIMS ANY WARRANTIES,
# INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY
# AND FITNESS FOR A PARTICULAR PURPOSE.  THE SOFTWARE PROVIDED HEREUNDER IS
# ON AN "AS IS" BASIS, AND THE UNIVERSITY OF CALIFORNIA HAS NO OBLIGATION TO
# PROVIDE MAINTENANCE, SUPPORT, UPDATES, ENHANCEMENTS, OR MODIFICATIONS."

# Loosely based off of TossimNescDecls.py/TossimApp.py by Kamin
# Whitehouse and Philip Levis.

# @author Paul Stickney

"""
Probe (and modify) TOSSIM variables.

Resolving applies types (which may just be "virtually linked" up until
this point) and connects data-structures with a physical location in
memory. Only variables may start resolved definition trees because
they provide absolute memmory addresses.

There are no provisions made for pointers.
"""

from xml.dom import minidom
import re

import probedef
import probe


class ReplacementError(RuntimeError):
    """
    If an error occurs during the replacement (except lookup failure).
    """
    def __init__(self, msg=""):
        RuntimeError.__init__(self, msg)


class LookupError(RuntimeError):
    """
    If an error occurs during a variable lookup.
    """
    def __init__(self, msg=""):
        RuntimeError.__init__(self, msg)


class ProbeLink():
    """
    Reference holder to be able to assign references early. This is to
    allow attachment of definitions to data-structures which are
    not-yet defined (and could possibly be used for recursive or
    co-recursive data-types).
    """
    def __init__(self, ref=None, link=None):
        self.ref = ref
        self.link = link


# Some helper functions for dealing with [nesC application] XML
def attr(elm, name):
    """
    Read an attribute from elm.

    Coverts the element to a normal Python (ASCII) string. Returns ""
    if the attribute does not exist.
    """
    return str(elm.getAttribute(name))

def decode_number(num):
    """
    Decodes numbers found in app.xml.

    They are of the formats "U:" (undefined), "V:" (void/none?), or
    "I:<integer>". Returns None if the number is undefined ("U:") or
    an empty string. Raises an exception if the format is otherwise
    invalid.
    """
    if num == "" or num == "U:":
        return None
    elif num == "V:": # "void?" use for pointer and unsized arrays
        return 0
    elif num[0:2] == "I:":
        try:
            return int(num[2:])
        except ValueError:
            raise ValueError("Failed to decode (%s) as a number" % num)
    else:
        raise ValueError("Invalid encoded number (%s)" % num)

def text(norns):
    """
    Returns ASCII text from one (or more) nodes with minimized whitespace.
    
    node can be a list of dom nodes or a single node.
    """
    nodes = norns if hasattr(norns, '__iter__') else (norns,)
    return re.sub(r"\s+", " ", " ".join(n.toxml("ASCII") for n in nodes))
               
def children_matching(node, fn):
    """
    Returns generator of child element nodes matching a predicate.
    """
    return (n for n in node.childNodes
            if n.nodeType == n.ELEMENT_NODE and fn(n))

def children_with_tag(node, tag):
    return children_matching(node, lambda n: n.tagName == tag)

def children_with_tags(node, tags):
    return children_matching(node, lambda n: n.tagName in tags)

def child_matching(node, fn):
    """
    Returns matching child element or raises ValueError if <> 1 match.
    """
    m = [n for n in node.childNodes if n.nodeType == n.ELEMENT_NODE and fn(n)]
    if len(m) != 1:
        raise ValueError("Expected one match, found (%d): %s" %
                         (len(m), text(node)))
    return m[0]

def child_with_tag(node, tag):
    try:
        return child_matching(node, lambda n: n.tagName == tag)
    except ValueError:
        raise ValueError("Expected one <%s> element: %s" % (tag, node))

def child_type_node(node):
    """
    Returns the first node from nodes which appears to be a "type" element.

    Raises a ValueError if there isn't exactly one type node.
    """
    return child_matching(node, lambda n: n.tagName.startswith("type-"))


class ProbeLoader(object):
    """
    Build Probe Definitions from a nesC-generate app.xml file.
    """

    def __init__(self, file, prober):
        """
        prober - should support prober interface (eg. SimxProbe)
        """
        # PST why is initialization here?
        probe.init(prober)

        self.link_lookup = {}     # of type ref-id => ProbeLink

        self.type_handler = {
            'type-array': self.parse_array_type,

            'type-int': self.parse_primitive_type,
            'type-float': self.parse_primitive_type,
            'type-void': self.parse_primitive_type,
            'type-function': self.parse_primitive_type,

            'type-pointer': self.parse_pointer_type,
            'type-tag': self.parse_tag_type,
            'type-qualified': self.parse_qualified_type,
            'type-var': self.parse_var_type
            }

        dom = minidom.parse(file)
        nesc_node = dom.documentElement

        # typedefs, structs/unions and variables in different
        # namespaces in C
        self.typedefs = self.load_typedefs(nesc_node)
        self.structs = self.load_structures(nesc_node)
        self.variables = self.load_variables(nesc_node)

        dom.unlink()

        # Keys are: (varname, tuple(replacments))
        self.resolve_cache = {}


    def resolve_link(self, ref):
        """
        Returns an existing link or creates (and caches a new link).
        """
        link = self.link_lookup.get(ref)
        if link is None:
            link = ProbeLink(ref=ref)
            self.link_lookup[ref] = link
        return link


    def parse_type(self, node):
        """
        Parse the type from the given node.

        Returns a Probe Definition.
        """
        typename = node.tagName
        size = decode_number(attr(node, "size"))
        handler = self.type_handler.get(typename)
        if not handler:
            raise ValueError("Unknown type format '%s' in: %s" %
                             (typename, text(node)))

        return handler(typename, size, node)


    def parse_array_type(self, typename, size, node):
        count = decode_number(attr(node, "elements"))

        # PST--
        # something like int *foo[] -- just ignore for now
#        if count == 0:
        if not count:
            return self.parse_type(child_type_node(node))

        # Array types are recursive -- Easy n-dimensional arrays
        cdef = self.parse_type(child_type_node(node))

        if count * cdef.size != size:
            raise ValueError(
                "Expected size (%d) differs from actual (%d*%d=%d)" %
                (size, count, cdef.size, count * cdef.size))

        return probedef.Array(element_type=cdef, size=size, count=count)

    def parse_primitive_type(self, typename, size, node):
        cname = attr(node, "cname")
        nx_type = bool(attr(node, "network"))
        return probedef.Primitive(type=cname, nx_type=nx_type, size=size)

    def parse_pointer_type(self, typename, size, node):
        return probedef.Primitive(type="pointer", size=size)

    def parse_tag_type(self, typename, size, node):
        accepted = ["struct-ref", "union-ref",
                    "nx_struct-ref", "nx_union-ref",
                    "typedef-ref", "enum-ref"]
        ref_node = child_matching(node, lambda n: n.tagName in accepted)
        ref = attr(ref_node, "ref")
        return probedef.Link(type=self.resolve_link(ref), size=size)

    def parse_qualified_type(self, typename, size, node):
        return self.parse_type(child_type_node(node))

    def parse_var_type(self, typename, size, node):
        # PST- just try and skip stupid defintion
        return self.parse_tag_type(typename, size or 0, node)


    def parse_field(self, field):
        """
        Build a new Probe Definition for a given field.
    
        field -- xml node represent field definition
        """
        name = attr(field, "name")
        offset_bits = decode_number(attr(field, "bit-offset"))

        expected_size = decode_number(attr(field, "size"))
        if expected_size is None:
            bit_size = decode_number(attr(field, "bit-size"))
            if bit_size is None:
                raise ValueError("Field has no size specified: %s" %
                                 text(field))
            # PST-- isn't correct, but doesn't throw a fit on MY app.xml
            expected_size = (bit_size / 8) + 1

        tdef = self.parse_type(child_type_node(field))

    # Might be foo blah[]
#    if tdef.size != expected_size:
#        raise("Expected size '%s' but found '%s' in: %s" %
#              (expected_size, tdef.size, text(field)))

        assert tdef.offset_bits is None, "Attempting to re-assign offset"

        return (name, tdef.dup(offset_bits=offset_bits))


    def load_typedefs(self, nesc_node):
        typedefs_node = child_with_tag(nesc_node, 'typedefs')
        return dict(self.load_typedef(t) for t
                    in children_with_tag(typedefs_node, 'typedef'))


    def load_typedef(self, t):
        # returns (name, tdef)
        ref = attr(t, "ref")
        if not ref:
            raise ValueError("Missing reference id: %s" % text(s))        

        name = attr(t, "name")
        if not name:
            raise ValueError("Missing typedef name: %s" % text(s))

        link = self.resolve_link(ref) # pre-resolve link
        if link.link is not None:
            raise ValueError("Reference '%s' previously defined: %s" %
                             (ref, text(t)))

        tdef = self.parse_type(child_type_node(t))
        link.link = tdef # update link
        return (name, tdef)


    def load_structures(self, nesc_node):
        tags_node = child_with_tag(nesc_node, 'tags')
        accepted_tags = ['struct', 'nx_struct', 'union', 'nx_union']
        return dict(f for f in
                    (self.load_structure(s) for s
                     in children_with_tags(tags_node, accepted_tags))
                    if f is not None)


    def load_structure(self, s):
        # returns (name, sdef) if a named structure, otherwise None

        ref = attr(s, "ref")
        if not ref:
            raise ValueError("Missing reference id: %s" % text(s))

        # structs may be empty, but they still have a size of 0
        expected_size = decode_number(attr(s, "size"))
        if expected_size is None:
            raise ValueError("Missing size: %s" % text(s))

        link = self.resolve_link(ref) # pre-resolve link
        if link.link is not None:
            raise ValueError("Duplicate reference (%s): %s" % (ref, text(s)))

        sdef = probedef.Struct(size=expected_size)
        found_size = 0
        for f in children_with_tag(s, 'field'):
            name, fdef = self.parse_field(f)
            sdef.members[name] = fdef
            found_size += fdef.size

        # PST-- disabled because bit fields are not correctly handled
#        if found_size != expected_size:
#            raise ("Expected size '%s' but found '%s' in: %s" %
#                   (expected_size, found_size, text(s)))

        name = attr(s, "name")
        link.link = sdef # update link
        
        return (name, sdef) if name else None


    def load_variables(self, nesc_node):
        variables_node = child_with_tag(nesc_node, 'variables')
        return dict(f for f in
                    (self.load_variable(v) for v
                     in children_with_tag(variables_node, 'variable'))
                    if f is not None)


    def load_variable(self, v):
        # Returns (name, vdef) if Tossim-accessible variable or None

        components = list(children_with_tag(v, "component-ref"))
        if len(components) == 0:
            # not part of component so not Tossim-var
            return None
        elif len(components) > 1:
            raise ValueError("Multiple components found: %s" % text(v))
            
        name = "%s$%s" % (attr(components[0], "qname"),
                          attr(v, "name"))
        tdef = self.parse_type(child_type_node(v))
        vdef = tdef.dup(var=name)

        return (name, vdef)


    def structural_lookup(self, spec, base=None, eval=False):
        # PST-- documentation is wrong
        """
        Looks up the structure definition from the given spec. This is
        used internally by the lookup method.

        Spec is a string in the form:
        { varname_or_typename }? { "[*]" | { "[" key_or_index "]" }* }

        If varname_or_typename is specified it is used to lookup the
        starting definition. If varname_or_typename is is not
        specified AND base is not None, the base is used otherwise, if
        base is None, a LookupError is raised.

        If eval is True the resolved structure is dynamically
        descended into and the result of the last lookup is returned.
        """
        #print "** \n\n ** spec: ",spec
        match = re.match(r"([\w$]+)(.*)", spec)
        #print "** \n\n ** m: ",m," "
        
        if match:
            vartype = match.group(1)
            #print "** \n\n ** vartype: ",vartype
            
            type = (self.variables.get(vartype) or
                    self.typedefs.get(vartype) or
                    self.structs.get(vartype))
            if not type:
                raise LookupError("No variable or type: %s" % vartype)
            spec = match.group(2)
        elif not match and base is not None:
            type = base
        else:
            raise ValueError("Variable or typename missing: %s" % spec)

        if not spec or spec == "[*]": # no index into type
            return ("", type)

        indexes = re.findall(r"\[(\w+)\]", spec)
        # Ensure extracted match re-forms
        #print "indexes", "[" + "][".join(indexes) + "]"," ", spec
        if "[" + "][".join(indexes) + "]" != spec:
            raise ValueError("Invalid structure specification: %s" % spec)

        if eval:
            for i in indexes:
                try:
                    i = int(i)
                except ValueError:
                    pass
                type = type[i]

        return (spec, type)


    def lookup(self, varname, *replace):
        """
        Returns a resolved ProbeDef for a given variable.

        Replace is a list of (struct_a, struct_b) where struct_a and
        struct_b can be looked up with structure_lookup(). struct_a
        supports relative structure lookups whereas struct_b does not.

        e.g:
        lookup("Foo$bar")

        Results of successful lookups are cached (per variable name
        and replacements).

        Raises a LookupError if the specific variable name can not be
        found or a ReplacementError if a requested replacement was not
        used.
        """
        # Check cache
        cache_id = (varname, tuple(tuple(n) for n in replace))
        if cache_id in self.resolve_cache:
            return self.resolve_cache[cache_id]

        probe_def = self.variables.get(varname)
        if not probe_def:
            raise LookupError("Variable not found: %s" % varname)

        if not replace:
            # Simple case when no rebinding
            probe_def, _ = probe_def.resolve()

        else:
            # Keep top-level var even if root is replaced
            top_var = probe_def.var

            for bind, target in replace:
                # note changing base per iteration
                spec, _ = self.structural_lookup(bind, base=probe_def)
                _, target_def = self.structural_lookup(target, eval=True)

                replace = {spec: target_def}
                probe_def, _replace = \
                    probe_def.resolve(top_var, replace=replace)

                if _replace:
                    raise ReplacementError(
                        "Unused replacements: %s" % _replace.keys())

        # Update cache
        self.resolve_cache[cache_id] = probe_def
        return probe_def
