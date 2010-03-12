import math
from Link import BasicLinkModel
from Support import extendMote
from Manager import NodeManager

TOSSIM_MAX_NODES = 1000 # as per TOS 2.1 default

class GenericNode(object):
    pass


class GenericTopo(NodeManager):
    """
    Creates a generic topology (that is not tied to TOSSIM).

    This can be useful to generate and save different topologies that
    can be examined and/or loaded later without needing to integrate
    with TOSSIM.

    Since these are not real motes, the only TOSSIM Mote-like property
    they have is an ID.
    """

    #TODO: support link model generation
    def __init__(self):
        self._nodes = [None] * TOSSIM_MAX_NODES
        self._links = {}
        self.model = BasicLinkModel()


    def getNode(self, i):
        n = self._nodes[i]
        if not n:
            n = GenericNode()
            extendMote(n, txmap=self.model.txmap)
            n.id = lambda: i # give it an ID
            self._nodes[i] = n

        return n


    def maxNodes(self):
        return TOSSIM_MAX_NODES


    def nodes(self):
        return filter(lambda n: n is not None, self._nodes)


    def gain(self, a, b):
        return self._links.get((a.id(), b.id()))


    def needsRebuild(self):
        raise NotImplementedError


    def rebuildModel(self):
        nodes = self.nodes()
        for i, a in enumerate(nodes):
            ai = a.id()
            for b in map(lambda x: nodes[x], range(i+1, len(nodes))):
                bi = b.id()
                (ga, gb) = self.model.gain(a, b)
                self._links[(ai, bi)] = ga
                self._links[(bi, ai)] = gb


def TossimTopo(BASE, *opts, **kws):
    """
    Create a TOSSIM wrapper/topology map manager.

    tossim_class should be the TOSSIM module, likely just TOSSIM.

    This actually creates a new class and instantiates a corresponding
    object. The extra layer is to allow direct injection of the
    superclass.
    """

    DYNAMIC = kws.get("dynamic")

    class _Manager(NodeManager, BASE):
        
        def __init__(self, *opts, **kws):
            BASE.__init__(self, *opts)
            self._nodes = [None] * TOSSIM_MAX_NODES
            self.change_hooks = []
            self.link_hooks = []
            self.dynamic = False

        def addChangeHook(self, hook):
            self.change_hooks.append(hook)

        def addLinkHook(self, hook):
            self.link_hooks.append(hook)

        def moteOnChange(self, mote):
            for hook in self.change_hooks:
                hook(mote)

        def linkChanged(self, mote, other, gain):
            for hook in self.link_hooks:
                hook(mote, other, gain)

        def getNode(self, i, **kws):
            n = self._nodes[i]
            if not n:
                n = BASE.getNode(self, i)
                self._nodes[i] = n
                options = {"onchange": lambda x: self.moteOnChange(x),
                           "monitor": self,
                           "radio": self.radio(),
                           "txmap": lambda x: x}
                options.update(kws)
                extendMote(n, **options)

            return n

        def needsRebuild(self):
            return False

        def rebuildModel(self):
            return False

        def maxNodes(self):
            return TOSSIM_MAX_NODES

        def nodes(self):
            return filter(lambda n: n is not None, self._nodes)

        def poweredNodes(self):
            """
            List of nodes that are 'on'.
            """
            return filter(lambda n: n.isOn(), self.nodes())

        def activeNodes(self):
            """
            List of nodes that have been accessed.
            """
            #return filter(lambda n: n.isOn(), self.nodes())
            return self.nodes()

        def gain(self, a, b):
            (src, dest) = (a.id(), b.id())
            r = self.radio()
            if r.connected(src, dest):
                return self.radio().gain(src, dest)

    # Dynamic just provides basics
    if not DYNAMIC:
        return _Manager(*opts, **kws)

            
    class _DynManager(_Manager):

        def __init__(self, *opts, **kws):
            _Manager.__init__(self, *opts, **kws)
            # of type TopoNode, index is ID
            self.model = BasicLinkModel()
            self.block_reenter = False
            self.dynamic = True
            

        def moteOnChange(self, mote):
            """
            Invoked by a mote whenever an internal change occurs.
            """
            if self.block_reenter:
                return

            # Rebuild txgain (should check if txgain is modified and
            # use flag)
            try:
                self.block_reenter = True
                self.rebuildLinks_Isolated(mote)
            finally:
                self.block_reenter = False
                
            _Manager.moteOnChange(self, mote)
            

        def getNode(self, i, **kws):
            return _Manager.getNode(self, i, txmap=self.model.txmap)


        def needsRebuild(self):
            """
            Returns True iff at least one of the nodes is "dirty".
            """
            return any(True for x in self.nodes() if x.dirty)


        def rebuildModel(self):
            """
            Completely re-builds the radio-model.

            This should be called after a TX-power or position change
            or a change to the topology in general.

            **I have NO IDEA how and/or if this will work with the
              TOSSIM/T2 noise model. (For now I just ignore it.)
            """
            nodes = self.nodes()

            for a in nodes:
                for b in a.neighbors:
                    (gain_a, gain_b) = self.model.gain(a, b)
                    a.add(b, gain_a)
                    b.add(a, gain_b)

            for n in nodes:
                n.mark_clean()


        def rebuildLinks_Isolated(self, node, link_in=True):
            """
            Rebuilds information for a single node.

            If link_in is True then neighbor links will be re-applied
            as well. (Not rebuilding neighbors is useful for a txgain
            change; the node positions are the same but the outward
            gain is reduced.)
            """
            for other in node.neighbors:
                (gain_out, gain_in) = self.model.gain(node, other)
                node.add(other, gain_out)
                if link_in:
                    other.add(node, gain_in)

            # TODO: This is broken, the node isn't necc. entirely clean
            node.mark_clean()

 
    return _DynManager(*opts, **kws)
