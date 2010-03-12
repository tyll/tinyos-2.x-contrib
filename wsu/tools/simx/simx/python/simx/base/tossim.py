from simx.base import Node, RadioRedirect


class TossimBase(object):
    """
    A wrapper for the TOSSIM base object.

    TossimBase caches L{Node} objects, supplies a proxy radio object
    (L{RadioRedirect}), and provides a way for other Simx components
    to (cleanly) extend Tossim access methods.
    
    Several helper functions as a convenience and provide some
    additional checks. Ideally some of these changes would be
    incorporated directly into the TOSSIM layer; however TossimBase
    sits on top of TOSSIM and provides a level of abstraction.

    Arguably, one of the most powerful features of TossimBase is the
    ability to register extensions that can define new features on
    nodes and the tossim (TossimBase, in this case) object. This is
    used to easily tie in other Simx components.
    """

    DEFAULT_MAX_NODES = 1000
    
    def __init__(self, target, max_nodes=DEFAULT_MAX_NODES):
        """
        Initializer.

        @type  target: TOSSIM.Tossim
        @param target: Tossim object being wrapped
        @type  max_nodes: int
        @param max_nodes: maximum number of supported nodes; should agree
                          with TOSSIM
        """
        self.node_cache = [None] * max_nodes
        self.target = target

        self._extensions = []
        #: of {attribute: [handler*]}, attribute can be None for "all"
        self._hooks = {}

        self.tossim_radio = target.radio() # used by Nodes
        self._radio = RadioRedirect(target.radio(), self)
        self._ticks_per_second = target.ticksPerSecond()
        self._max_nodes = max_nodes


    def __getattr__(self, attr):
        """
        Proxy all unknown attributes to target.
        """
        try:
            return self.__dict__.get(attr) or getattr(self.target, attr)
        except AttributeError:
            raise AttributeError(
                "type object '%s' has no attribute '%s': extensions=%s" %
                (self.__class__.__name__, attr, self.extension_names()))


    def __hasattr__(self, attr):
        """
        Proxy all unknown attributes to target.
        """
        return attr in self.__dict__ or hasattr(self.target, attr)


    def register_extension(self, extension):
        """
        Register an extension.

        @type  extension: L{Extension}
        @param extension: extension to register

        @raise RuntimeError: if the extension is already registered
        """
        if ([ext for ext in self._extensions
             if ext.extension_name == extension.extension_name]):
            raise RuntimeError("already registered: %s" %
                               extension.extension_name)

        extension.decorate_tossim_class(TossimBase)
        extension.decorate_node_class(Node)

        # make sure to decorate existing nodes
        for node in self.cached_nodes():
            extension.decorate_node(node)

        self._extensions.append(extension)


    def extension_names(self):
        """
        Returns the a list of the names of registered extensions.

        @rtype:  list, of string
        @return: names of registered extensions
        """
        return [ext.extension_name for ext in self._extensions]


    def seconds_as_ticks(self, seconds, whence=0):
        """
        Returns the number of ticks for the specified seconds.

        @type  seconds: float
        @param seconds: seconds to convert into tossim ticks

        @rtype:  long
        @return: number of ticks in seconds
        """
        return (seconds * self._ticks_per_second) + whence


    # PST- already exists as tossim.timeStr
    def time_str(self):
        """
        Returns a human-readable version of simulation time.

        @rtype:  string
        @return: string-representation of B{current} simulation time
        """
        return self.target.timeStr()


    def ticks_per_second(self):
        """
        Returns the number of ticks per second, cached.

        @rtype:  long
        @return: tossim ticks per second
        """
        return self._ticks_per_second

    ticksPerSecond = ticks_per_second


    def radio(self):
        """
        Returns a L{RadioRedirect} radio object.

        The returned object ensures that 'original-style' Tossim radio
        methods can be invoked while correctly dispatching to the
        correct L{Node}.

        @rtype:  L{RadioRedirect}
        @return: radio object
        """
        return self._radio


    def add_channel(self, name, out_io):
        """
        Link a TOSSIM channel with an output stream.
        
        @type  name: string
        @param name: name of channel
        @type  out_io: file, possibly L{ChannelBridge}
        @param out_io: channel out-stream
        """
        return self.target.addChannel(name, io)


    def remove_channel(self, name, out_io):
        """
        Remove a TOSSIM channel from an output stream.
        
        @type  name: string
        @param name: name of channel
        @type  out_io: file, possibly L{ChannelBridge}
        @param out_io: channel out-stream
        """
        return self.target.removeChannel(name, io)


    def get_node(self, num):
        """
        Retrieve a node based upon an id.

        I{The resulting node is cached:} all lookups will return the
        same L{Node} object. This property allows node objects to be
        decorated and to maintain state.

        @type  num: int
        @param num: id of node to retrieve

        @raise IndexError: invalid node number

        @rtype:  L{Node}
        @return: the associated node, which has been cached
        """
        if num < 0 or num >= self._max_nodes:
            raise IndexError("invalid node id: %s" % num)

        node = self.node_cache[num]
        if not node:
            source_node = self.target.getNode(num)
            node = self.node_cache[num] = Node(source_node, self)
            for extension in self._extensions:
                extension.decorate_node(node)

        return node

    getNode = get_node


    def get_nodes(self, numbers):
        """
        Get one (or many) nodes at once.

        @type  numbers: iterable, of int
        @param numbers: nodes to retrieve
        
        @raise ValueError: if any node number is out of range

        @rtype:  list, of L{Node}
        @return: list of nodes, which may be []
        """
        return [self.get_node(num) for num in numbers]


    def __getitem__(self, selector):
        """
        Combines get_node and get_nodes depending on selector.

        If the selector is a slice, returns a list of all the nodes in
        the range; if selector is iterable, returns a list of all
        nodes with the specified ids; otherwise, selector is taken as
        the id of a single node and a single node is returned.

        @type  selector: slice, iterable, int
        @param selector: selection of nodes

        @raise ValueError: if any node number is out of range
        """
        if isinstance(selector, slice):
            nodes = xrange(*selector.indices(self.max_nodes()))
            return self.get_nodes(nodes)
        elif hasattr(selector, "__iter__"):
            return self.get_nodes(selector)
        else:
            return self.get_node(selector)


    def max_nodes(self):
        """
        Returns the maximum number of supported nodes.

        @rtype:  int
        @return: number of supported nodes
        """
        return len(self.node_cache)


    def cached_nodes(self):
        """
        Returns a list of all nodes that have been looked up (and
        thereby cached).

        The list may contain nodes which have not been powered on or
        do not have valid link-gain properties, etc.
       
        @rtype:  list
        @return: cached nodes
        """
        return [node for node in self.node_cache if node]


    def node_changed(self, node, attribute=None):
        """
        Called by a node when a change occurs.

        @type  attribute: string
        @param attribute: attribute that changed, or None for "any"
        """
        
        return


    def add_hook(self, obj, *attributes):
        """
        Register a hook.

        @type  obj: object, responds to node_changed(node, attribute)
        @param obj: hook target
        @type  attributes: *list, ofstring
        @param attributes: attributes for which to associate hook

        @raise ValueError: if obj is self
        """
        if obj is self:
            raise ValueError("this would be bad")

        for attribute in attributes:
            hooks = self._hooks.get(attribute, [])
            if obj not in hooks:
                hooks.push(obj)
            self._hooks[attribute] = hooks

