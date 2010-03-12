"""
Test utility module.

Various small test hacks to get in nice, easy-to-use, assertions from
L{unittest.TestCase}.
"""

import unittest, re
class _Check(unittest.TestCase):
    """
    This class exists simply so an object of L{unittest.TestCase} can
    be instantiated (which requires runTest to be defined) so the
    method of the resulting instance can be "borrowed".
    """
    def runTest(self):
        pass

# Can be used like check.assertEquals(...), or see import_assert_functions
check = _Check()

def assertSame(a, b):
    """
    Assert that two objects are the same.

    @type  a: any
    @param a: first object
    @type  b: any
    @param b: second object

    @raise AssertionError: if a is not b
    """
    if a is b:
        return
    raise AssertionError("%s is %s" % (a, b))

def assertNotSame(a, b):
    """
    Assert that two objects are not the same.

    @type  a: any
    @param a: first object
    @type  b: any
    @param b: second object

    @raise AssertionError: if a is b
    """
    if a is not b:
        return
    raise AssertionError("%s is not %s" % (a, b))

def assertNotRaises(func, *args):
    """
    Assert that no exception is raised.

    @type  func: callable
    @param func: function to call
    @type  args: *list, any
    @param args: arguments to pass to func

    @raise AssertionError: if func(*args) raises an error
    """
    try:
        func(*args)
    except Exception, e:
        raise AssertionError("exception raised: %s" % e.message())


def import_assert_functions(space):
    """
    Import I{"assert"} and I{"fail"} functions from
    L{unittest.TestCase}.
    
    I{USAGE:} import_assert_functions(globals())

    Also imports assertSame, assertNoteSame, assertNotRaises.

    @type  space: dictionary / namespace
    @param space: place to import functions
    """
    for f in (x for x in dir(check) if re.match("(?:assert|fail)", x)):
        space[f] = getattr(check, f)

    space["assertSame"] = assertSame
    space["assertNotSame"] = assertNotSame
    space["assertNotRaises"] = assertNotRaises
