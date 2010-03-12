from simx.base.testutil import import_assert_functions
import_assert_functions(globals())

from simx.base import Extension

def test_mixin():

    class S(object):
        some_attr = "some_attr"

        def instance_method(self):     return "instance_method"
        def _instance_method(self):   return "_instance_method"
        def __instance_method__(self): return "__instance_method__"
        
        @classmethod
        def klass_method(klass): return "klass_method"

        @staticmethod
        def static_method(): return "static_method"

    class T(object):
        pass

    t = T()
    Extension.mixin(T, S)

    has = ["instance_method", "_instance_method"]
    for name in has:
        # attributes exist
        yield lambda _: assert_(hasattr(t, _), "has " + _), name
        # expected value
        yield lambda _: assert_(getattr(t, _), "get " + _), name

    hasnot = ["some_attr", "__instance_method__",
              "klass_method", "static_method"]
    for name in hasnot:
        yield lambda _: assert_(not hasattr(t, _), "has not " + _), name
