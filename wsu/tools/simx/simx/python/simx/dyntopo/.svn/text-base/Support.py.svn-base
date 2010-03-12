from sets import Set

# This should correspond with the current TOSSIM noise generator.
# The TOSSIM/T2 wiki claims CPM needs at least 100 readings.
REQUIRED_TRACE_SIZE = 100

class DummyMonitor(object):
    # Gain may be None!
    def linkChanged(source, dest, gain):
        pass
    def nodeDirty(source, dest, gain):
        pass


def extendMote(mote, txmap=None,
               onchange=lambda node: None,
               monitor=DummyMonitor(),
               radio=None):
    """
    Extends mote (of TOSSIM.Mote) with singleton attributes.

    The accessors set_txgain, set_pos and mark_clean control the
    following attributes which should be treated as read-only:

    ro_txgain - transmit power gain.
    ro_pld0 - path loss at dl0 (must correspond with link model!)
    ro_pos (x,y) - position, in meters
    ro_dirty - if link gain needs to be re-computed
    """
    # I do not know how to use the new-style property() in this
    # approach (or if it can even be adapted to
    # singleton-objects). One problem is the Mote class itself is
    # "locked" because it is implemented in C++/SWIG. Here we just,
    # well, fiddle with individual objects.
    if txmap is None:
        raise ValueError, "txmap is required"

    old_addNoiseTraceReading = mote.addNoiseTraceReading
    def addNoiseTraceReading(value):
        old_addNoiseTraceReading(int(value))
        mote.ro_traces = mote.ro_traces + 1
        
    old_createNoiseModel = mote.createNoiseModel
    def createNoiseModel():
        if mote.ro_traces < REQUIRED_TRACE_SIZE:
            raise ValueError("Refusing to create noise model for %d: "
                             "only %d of %d required traces" %
                             (mote.id(), mote.ro_traces, REQUIRED_TRACE_SIZE))
        else:
            old_createNoiseModel()
            mote.ro_valid = True
            onchange(mote)

            
    # Calling SWIG is slow; cache the ID in Python.
    # The my_id variable is also closured further down to avoid
    # a function call entirely.
    my_id = mote.id()
    mote.id = lambda: my_id

    #
    # Invert links so they are attached to nodes;
    # this also provides a simple iterator through neighbors.
    #
    # This is potentially very costly memory-wise. However, it doesn't
    # have the O(n*n) problem with the current access methods to detect
    # which nodes are connected (more direct access to the underlying
    # representation may fix this).
    #
    neighbors = Set()

    def add(other, gain):
        """
        Connect this node with the other node using the specified gain.
        """
        neighbors.add(other)
        radio.add(my_id, other.id(), gain)
        monitor.linkChanged(mote, other, gain)

    # Adds neighbor entry, but does not create link in TOSSIM model.
    # Does nothing if the link already exists.
    def touch(other):
        """
        If the other node is not connected, mark it as a neighbor.
        """
        if other not in neighbors:
            neighbors.add(other)
            monitor.linkChanged(mote, other, None)

    def remove(other):
        """
        Remove the connection between this node and other.
        """
        neighbors.remove(other)
        radio.remove(my_id, other.id())
        monitor.linkChanged(mote, other, None)

    def gain(other):
        """
        Report the gain between the two nodes.
        """
        return radio.gain(my_id, other.id())

    def connected(other):
        """
        Returns True iff the link has been connected logically;
        it may not actually have been added to the underlying radio model.
        (As is the case with touch.)
        """
        return other in neighbors

    mote.add = add
    mote.touch = touch
    mote.remove = remove
    mote.gain = gain
    mote.connected = connected
    mote.neighbors = neighbors # not a function call


    def useFlatNoiseFloor(floor):
        """
        Add a flat noise floor for the node.
        This assumes that the noise model is currently empty.
        """
        if mote.ro_traces > 0:
            raise RuntimeError("A flat noise floor can only be added "
                               "to motes with no noise readings.")
        for i in xrange(0, REQUIRED_TRACE_SIZE):
            mote.addNoiseTraceReading(floor)
        mote.createNoiseModel()

    old_turnOn = mote.turnOn
    def turnOn():
        old_turnOn()
        mote.ro_dirty = True
        onchange(mote)

    old_turnOff = mote.turnOff
    def turnOff():
        old_turnOff()
        mote.ro_dirty = True
        onchange(mote)

    def set_txgain(val):
        mote.ro_txgain = val
        mote.ro_pld0 = txmap(val)
        mote.ro_dirty = True
        onchange(mote)
        return val

    def set_pos(val):
        mote.ro_pos = val
        mote.ro_dirty = True
        onchange(mote)
        return val

    def mark_clean():
        mote.ro_dirty = False
        onchange(mote)

    mote.set_txgain = set_txgain
    mote.set_pos = set_pos
    mote.mark_clean = mark_clean
    mote.turnOn = turnOn
    mote.turnOff = turnOff
    mote.addNoiseTraceReading = addNoiseTraceReading
    mote.createNoiseModel = createNoiseModel
    mote.useFlatNoiseFloor = useFlatNoiseFloor

    # Direct access to avoid early firing of onchange
    mote.ro_txgain = 0
    mote.ro_pld0 = txmap(0)
    mote.ro_pos = (0,0)
    mote.ro_dirty = True
    mote.ro_valid = False
    mote.ro_traces = 0
    onchange(mote)
