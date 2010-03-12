"""
ModTopo
"""

import logging
import time

from simx.act.mig.python import ReactNodeInfo, ReactLink
from simx.act.mig.python.ReactConst import ReactConst
#from simx.act.context import R

class ModTopo(object):
    """
    Simx/Topo bridge.
    """

    log = logging.getLogger(__name__)

    def __init__(self, reactor=None, tossim_topo=None):
        """
        reactor - Reactor
        tossim_topo - TossimTopo
        """
        self.reator=reactor
        self.topo = tossim_topo or reactor.service.resolve("TossimTopo")
        self.topo.addChangeHook(self._node_change)
        self.topo.addLinkHook(self._link_change)


    def _link_msg(self, node, other, gain):
        """
        Returns a link-gain message.
        """
        link = ReactLink.Msg()
        link.set_node1(node.id())
        link.set_node2(other.id())
        link.set_gain1to2(gain
                          if gain is not None
                          else ReactConst.INVALID_LINK)
        link.set_gain2to1(ReactConst.IGNORE_LINK)
        return link


    def _info_for_node(self, node):
        """
        Returns a node-info message.
        """
        cmd = ReactNodeInfo.Msg()
        cmd.set_id(node.id())
        (x_pos, y_pos) = node.ro_pos

        # distances sent as mm
        cmd.set_x(x_pos * 1000)
        cmd.set_y(y_pos * 1000)

        status = 0
        if node.isOn():
            status |= ReactConst.NODE_ON
        if node.ro_dirty:
            status |= ReactConst.NODE_STALE
        if not node.ro_valid:
            status |= ReactConst.NODE_INVALID
            
        cmd.set_status(status)    
        return cmd


    def _node_change(self, node):
        """
        Node status changed (event callback).
        """
#        self.log.debug("Sending new node data for %d" % node.id())
        from simx.act.context import R
        R.reply(self._info_for_node(node))


    def _link_change(self, node, other, gain):
        """
        Link status changed (event callback).
        """
#        self.log.debug("Sending new link information %d(%s)->%d"
#                       % (node.id(), gain, other.id()))
        from simx.act.context import R
        R.reply(self._link_msg(node, other, gain))


    def GEN(self, nodes=None, mode="grid", *args, **kws):
        """
        Generate a given topology.
        """
        pass


    def REBUILD(self, quiet=False):
        """
        Request a rebuild of the radio model.
        """
        self.log.info("Rebuild started (%d nodes)"
                      % len(self.topo.activeNodes()))

        started = time.time()
        self.topo.rebuildModel()

        self.log.info("Rebuild finished (%f seconds)"
                      % (time.time() - started))

        # If not quite, transmit changes after rebuild
        if not quiet:
            self.QUERY()


    def MOVE(self, node_id, x_pos, y_pos, quiet=False):
        """
        Move a node with the given ID to the new location.
        """
        node = self.topo.getNode(node_id)
        node.set_pos((x_pos, y_pos))

        if not quiet:
            from simx.act.context import R
            R.reply(self._info_for_node(node))


    def QUERY(self, node_ids=None):
        """
        Query a selection of nodes.
        """
        self.QUERY_NODES(node_ids)
        self.QUERY_LINKS(node_ids)
 

    def QUERY_NODES(self, node_ids=None):
        nodes = self.topo[node_ids] if node_ids else self.topo.activeNodes()
        self.log.debug("Sending node information for %d nodes" % len(nodes))
        for node in nodes:
            from simx.act.context import R
            R.reply(self._info_for_node(node))


    def QUERY_LINKS(self, node_ids=None):
        nodes = self.topo[node_ids] if node_ids else self.topo.activeNodes()
        self.log.debug("Sending link information for %d nodes" % len(nodes))
        for n in nodes:
            for o in n.neighbors:
                from simx.act.context import R
                R.reply(self._link_msg(n, o, n.gain(o)))
