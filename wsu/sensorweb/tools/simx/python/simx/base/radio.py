class RadioRedirect(object):
    """
    This 'radio' object intercepts calls and redirects them to the
    appropriate L{Node}. By performing this action, this object allows
    the old Tossim radio interface to be used with L{TossimBase}
    without fear of "stale" nodes.
    """

    def __init__(self, real_radio, tossim_base):
        """
        Initializer.
        
        @type  real_radio: TOSSIM.Radio
        @param real_radio: real TOSSIM radio object
        @type  tossim_base: L{TossimBase}
        @param tossim_base: base to use for L{Node} access
        """
        self.tossim = tossim_base
        self.radio = real_radio

    
    def threshold(self):
        """
        Returns the CCA threshold.

        @rtype:  int
        @return: CCA threshold
        """
        return self.radio.threshold()
            

    def set_threshold(self, val):
        """
        Sets the CCA threshold.

        @type  val: int
        @param val: value to set

        @rtype:  int
        @return: new CCA threshold, as read from the radio
        """
        self.radio.setThreshold(val)
        return self.radio.threshold()

    setThreshold = set_threshold


    def add(self, src, dst, gain):
        """
        Add a link from src S{->} dst of gain.

        @type  src: int
        @param src: source node number
        @type  dst: int
        @param dst: destination node number
        @type  gain: int
        @param gain: gain from source S{->} destination
        """
        src_node, dst_node = self.tossim[src], self.tossim[dst]
        src_node.link(dst_node, gain)


    def remove(self, src, dst):
        """
        Remove the src S{->} dst link.

        @type  src: int
        @param src: source node number
        @type  dst: int
        @param dst: destination node number
        """
        src_node, dst_node = self.tossim[src], self.tossim[dst]
        src_node.unlink(dst_node)


    def connected(self, src, dst):
        """
        Returns true if src and dst are connected.

        @type  src: int
        @param src: source node number
        @type  dst: int
        @param dst: destination node number

        @rtype:  bool
        @return: True iff source S{->} destination or source is destination
        """
        src_node, dst_node = self.tossim[src], self.tossim[dst]
        if (src_node is dst_node 
            or src_node.get_link(dst_node) is not None):
            return True


    def gain(self, src, dst):
        """
        Returns the gain between src S{->} dst.

        @type  src: int
        @param src: source node number
        @type  dst: int
        @param dst: destination node number

        @rtype:  int, or None
        @return: gain between source S{->} destination, or None if they
                 are not connected
        """
        src_node, dst_node = self.tossim[src], self.tossim[dst]
        return src_node.get_link(dst_node)
