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
#
# @author Kamin Whitehouse 
#

import re
from jpype import JPackage

class JavaInheritor ( object ) :
    """This python class should usually be inherited from.  It has one
    field called self.javaParents which should be a list of java
    objects, and this python class \"inherits\" all fields and
    functions of those java objects.  If two java objects have the
    same field or function, the one from the first object in the list
    is used.  The fields and functions, of course, can be overridden
    in the derived python class.

    At the end of the constructor of the derived python class, the
    constructor of this class MUST be called as follows:
        JavaInheritor.__init__(self, javaParents)
    """

    def __init__(self, javaParents):
        self._inheritedFields = {}
        self._fullClassnames = []
        self._inheritedFieldNames = []
        self._javaParents = javaParents
        classmatch = re.compile('^<jpype\\._jclass\\.(.*\\.(.+?)) ')
        pythonfield = re.compile('__.+__')
        allFieldNames = set(dir(self)) | \
                        set(dir(JPackage.java.lang.Object))
        for parent in self._javaParents :
            fieldNames = set(dir(parent)) - allFieldNames
            allFieldNames |= fieldNames 
            match = classmatch.match(repr(parent))
            self._fullClassnames.append(match.group(1))
            className = match.group(2)
            for field in fieldNames :
                if pythonfield.match(field) :
                    continue
                self._inheritedFields[field] = parent
                self.__dict__[field]=None
                name = className + "." + field
                if type(parent.__getattribute__(field)) == \
                   type(parent.__getattribute__("hashCode")):
                        name += "()"
                self._inheritedFieldNames.append(name)
        self.__initialized = True
        
    def __repr__(self) :
        return "%s object at %s:\n\n%s" % (self.__class__, hex(id(self)), str(self))

    def __str__(self) :
        """The type of object"""
        string= "Python object derived from java classes:\n"
        for parent in self._fullClassnames:
            string += "\t%s\n" % parent
        string += "\nThe following java fields/methods are inherited:\n"
        for field in self._inheritedFieldNames:
            string += "\t%s\n" % field
        return string
    
    def __getattribute__(self, name) :
        """get the value of the first field with this name.
        This is also used for calling parent functions.  It has
        the weird semantics that a field can override a function,
        and vice versa"""
        fields = object.__getattribute__(self,"__dict__")
        if not fields.has_key("_JavaInheritor__initialized"):
            return object.__getattribute__(self, name)

        _inheritedFields = object.__getattribute__(self, "_inheritedFields")
        if _inheritedFields.has_key(name) :
            return _inheritedFields[name].__getattribute__(name)

        return object.__getattribute__(self, name)
            
    def __setattr__(self, name, value) :
        """Set the attr on this python object if it exists.
        Otherwise, check if the field exists on the java object,
        and set it as long as it is not a function."""
        if not self.__dict__.has_key("_JavaInheritor__initialized") or \
           (self.__dict__.has_key(name) and
            not name in self._inheritedFields.keys() ) :
            self.__dict__[name] = value
            return
        elif self.__dict__.has_key("_javaParents") and \
             name in self._inheritedFields.keys() :
            return self._inheritedFields[name].__setattr__(name, value)
        raise AttributeError("Object has no attribute '%s'" % name)
            
