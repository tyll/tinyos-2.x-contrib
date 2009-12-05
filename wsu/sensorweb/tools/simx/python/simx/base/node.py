class Node(object):
    """
    Wrapper for a TOSSIM Node. This is one of the underlying
    components to bridge the gap between TOSSIM and Simx by allowing a
    place to add extra features to nodes in an extensible mannder.

    B{WARNING:} For this to work correctly, the node objects wrapped
    must only be fetched/accessed through L{TossimBase} . Direct node
    access circumventing L{TossimBase} may result in conflicting
    states.
    """

    #: Minimum size needed for Tossim CPM model generator.
    MIN_TRACE_SIZE = 100

    def __init__(self, node_target, tossim_base):
        """
        Initializer.

        @type  node_target: Tossim Node
        @param node_target: node to wrap
        @type  tossim_base: L{TossimBase}
        @param tossim_base: base to use
        """
        self._id = node_target.id()
        self.node = node_target
        self.tossim = tossim_base
        self.radio = tossim_base.tossim_radio
        self.trace_count = 0 #: track noise trace additions
        
        # Has this node been modified? set below in changed() call
        self.dirty = None

        # A node is only considered valid after the noise model has
        # been generated for it.
        self.valid = False

        self.changed(True)

        self._links = {}


    def __getattr__(self, attr):
        """
        Proxy all unknown attributes to target.
        """
        try:
            return self.__dict__.get(attr) or getattr(self.node, attr)
        except AttributeError:
            raise AttributeError(
                "type object '%s' has no attribute '%s': extensions=%s" %
                (self.__class__.__name__, attr, self.tossim.extension_names()))


    def __hasattr__(self, attr):
        """
        Proxy all unknown attributes to target.
        """
        return attr in self.__dict__ or hasattr(self.node, attr)


    def id(self):
        """
        Returns the id of the node.

        @rtype:  long
        @return: id of the node
        """
        return self._id


    def boot_at_time(self, time):
        """
        Boot a node at the specified time.

        @type  time: long
        @param time: tossim ticks
        """
        self.node.bootAtTime(time)

    bootAtTime = boot_at_time


    def turn_on(self, boot_time=None):
        """
        Turn the node on and set the dirty flag.

        @type  boot_time: long
        @param boot_time: time to boot, or None
        """
        self.node.turnOn()
        self.changed(True)
        if boot_time is not None:
            self.boot_at_time(boot_time)
            
    turnOn = turn_on


    def turn_off(self):
        """
        Turn the mote off and set the dirty flag.
        """
        self.node.turnOff()
        self.changed(True)

    turnOff = turn_off


    def add_noise_trace_reading(self, value):
        """
        Add a noise trace reading; wrapper to keep track of trace
        counts.

        @type  value: int
        @param value: trace reading to add
        """
        self.node.addNoiseTraceReading(int(value))
        self.trace_count += 1

    addNoiseTraceReading = add_noise_trace_reading

        
    def create_noise_model(self, force=False):
        """
        Create/generate the noise model.

        This wrapper that prevents creation of a noise model if not
        enough noise has been added.

        @param force: if a true value, tries to generate noise model
                      anyway (B{not recommended})
        @raise ValueError: not enough trace readings
        """
        if not force and self.trace_count < Node.MIN_TRACE_SIZE:
            raise ValueError(
                "Refusing to create noise model for %d: "
                "only %d of %d required traces added" %
                (self.id(), self.trace_count, Node.MIN_TRACE_SIZE))
        else:
            self.node.createNoiseModel()
            self.valid = True
            self.changed()

    createNoiseModel = create_noise_model


    def use_flat_noise_floor(self, floor=-110):
        """
        Add a flat noise floor for the node.

        This is a convenience method to add the required fixed-value
        noise readings and generate the noise model.

        @type  floor: int
        @param floor: noise floor to use
        
        @raise RuntimeError: if there are existing noise traces
        """
        if self.trace_count > 0:
            raise RuntimeError(
                "Noise traces have already been added to this node.")

        for count in xrange(0, Node.MIN_TRACE_SIZE):
            self.add_noise_trace_reading(floor)

        self.create_noise_model()

        
    def link(self, other, gain):
        """
        Create a DIRECTED radio link: this node S{->} other node.

        @type  other: L{Node}
        @param other: other node
        @type  gain: int
        @param gain: gain from this node S{->} other node.

        @raise ValueError: if gain is None
        @raise ValueError: if other is self
        """
        if gain is None:
            raise ValueError("gain is None")
        if self is other:
            raise ValueError("can't link to self")
        self._links[other] = gain
        self.radio.add(self.id(), other.id(), gain)


    def link_both(self, other, gain):
        """
        Creates a symmetric radio link: this node S{<-}S{->} other node.

        @type  other: L{Node}
        @param other: other node
        @type  gain: int
        @param gain: gain from this node S{<-}S{->} other node.

        @raise ValueError: if gain is None
        @raise ValueError: if other is self
        """
        self.link(other, gain)
        other.link(self, gain)


    def unlink(self, other):
        """
        Unlink the DIRECTIONAL radio link: this node S{->} other node.

        @type  other: L{Node}
        @param other: other node
        """
        # remove with no error
        self._links.pop(other, None)
        self.radio.remove(self.id(), other.id())


    def unlink_both(self, other):
        """
        Unlink both radio links between this node and other node.

        @type  other: L{Node}
        @param other: other node
        """
        self.unlink(other)
        other.unlink(self)

        
    def get_link(self, other):
        """
        Returns the gain of the link or None.

        @rtype: int, or None
        @return: gain, or None (if not connected)
        """
        return self._links.get(other, None)

        
    def neighbors(self):
        """
        Returns an iterable object of all linked neigbors.

        B{WARNING:} This does not necessarily return a list.

        @rtype: iterable, of L{Node}
        @return: iterable object of connected nodes
        """
        return self._links.keys()


    def links(self):
        """
        Returns an iterable object of links.

        B{WARNING:} This does not necessarily return a list.

        @rtype: iterable, where each item is (other_node, gain)
        @return: iterable object of links
        """
        return self._links.iteritems()


    def changed(self, dirty=None):
        """
        Invoke onchange callback.
        """
        if dirty is not None:
            self.dirty = dirty

        self.tossim.node_changed(self)


    def clear_dirty(self):
        """
        Clear the dirty flag.
        """
        self.dirty = False
