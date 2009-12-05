import re


class Extension(object):
    """
    Base class and helper functions for TossimBase extensions.

    Extensions allow adding extra information and methods to
    L{TossimBase} and associated L{Node} objects. Some examples are
    advanced topology configuration (see L{simx.fluid}) and sensor
    readings (see L{simx.sensor}).
    """

    def __init__(self, extension_name):
        """
        Initializer.

        @type  extension_name: string
        @param extension_name: name used when extension is registered;
                               it should be unique per extension type
        """
        self.extension_name = extension_name


    @staticmethod
    def mixin(target_class, source_class):
        """
        Mixes the source_class into the target_class.

        More specifically, mixes in instance methods while ignoring
        class methods, static methods and other class attributes. If
        an instance method already exists in the target_class an
        exception is raised.

        @type  target_class: class
        @param target_class: class to mixin methods
        @type  source_class: class
        @param source_class: class with mixin methods

        @raise RuntimeError: if a name conflict occurs during mixin
        """
        def instance_method(attr):
            return hasattr(attr, "im_func") and not attr.im_self

        for name in (name for name in dir(source_class)
                     if not re.match("^__.*__$", name)):
            method = getattr(source_class, name)
            if instance_method(method):
                if hasattr(target_class, name):
                    raise RuntimeError("duplicate method: %s" % name)
                else:
                    setattr(target_class, name, method.im_func)


    def decorate_node_class(self, node_class):
        """
        This called once; it can be used to decorate the node class.

        The order it is invoked relative to other extensions is the
        order the extension was registered.

        @type  node_class: class, of L{Node}
        @param node_class: class to decorate
        """
        pass


    def decorate_node(self, node):
        """
        This is called once per node.

        The order it is invoked relative to other extensions is the
        order the extension was registered.

        @type  node: L{Node}
        @param node: node to decorate
        """
        pass


    def decorate_tossim_class(self, tossim_class):
        """
        This called once; it can be used to decorate the tossim class.

        The order it is invoked relative to other extensions is the
        order the extension was registered.

        @type  tossim_class: class, of TossimBase
        @param tossim_class: class to decorate
        """
        pass
