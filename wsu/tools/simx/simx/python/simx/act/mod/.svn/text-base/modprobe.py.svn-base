"""
ModProbe
"""


import logging
import re
from simx import json as simplejson
from simx.act.msg.ReactReply import success_reply, failure_reply
from simx.act.msg import ReactBindWatch, ReactWatch

#from simx.act.context import reply
#from simx import probe
#from simx.act.context import R
from simx.probe import Probe
class ModProbe(object):
    """
    Probe binding.
    """

    log = logging.getLogger(__name__)

    def __init__(self, reactor=None, probe_loader=None):
        print "modprobe initiated"
        self.reactor = reactor
        self.probe_loader = probe_loader
        self.bindings = {} # of id => (resolved, [bindings])
        self.binding = {} # binding_id: {mote_id: binding}
        self.probes = [] # save probes
        self.last_bind_id = 0

    def add_binding(self, resolved_binding):
        """
        Adds a particular binding and returns the binding ID.
        """
        bind_id = self.last_bind_id
        assert not bind_id in self.bindings
        self.bindings[bind_id] = (resolved_binding, [])
        #self.probes.append(resolved_binding)
        self.last_bind_id += 1
        return bind_id

    def remove_binding(self, binding_id):
        """
        Removes a particular binding ID.

        The binding must exist or an error will be raised.
        """
        #PST -- must clean up buffers?
        binding = self.bindings[binding_id]
        del self.bindings[binding_id]
        pass

    def attach_node(self, binding_id, node_id):
        """
        Attach a node to a particular binding.

        The binding must exist and the node cannot already be attached.
        """
        (resolved, bindings) = self.bindings[binding_id]
        if node_id in bindings:
            raise ValueError("Duplicate node %i" % node_id)
        bindings.append(resolved.bind(node_id))

    def detach_node(self, binding_id, node_id):
        pass

    def detach_node_all(self, node_id):
        pass
            
    def remove_all_bindings(self):
        pass
    
    def DEL_ALL(self):
        self.bindings = {} # of id => (resolved, [bindings])
        self.binding = {} # binding_id: {mote_id: binding}
        self.probes = [] # save probes


    def _rebindings(self, rebinding_str):
        """
        Returns split replacements strings or None.
        """
        pairs = [pok for pok
                 in (p.strip() for p in rebinding_str.split(","))
                 if pok]
        rebindings = [p.split("=") for p in pairs]
        #print "pairs****", pairs
        #print "rebindings****", rebindings
        try:
            # don't actually do anything, but will throw an exception
            # if an invalid assignment occurs
            for (a, b) in rebindings:
                pass
        except:
#            raise ValueError("Invalid replacement: %s" % rebinding_str)
            reply = failure_reply("Invalid replacement: %s" % rebinding_str)
            from simx.act.context import R
            R.reply(reply)
        else:
            return rebindings


    def handler(self):
#        for k, v in self.bindings:
#            (resolved, bindings) = v
#            print "Binding %i has %i binding" % (k, len(bindings))
            # PST-- execute shadows, transmit results
        dirty= Probe.synchronize_all(self.probes)
        #if(tmp is not None and tmp != []): print tmp[0]
        #print "handler",dirty
        for probe in dirty:
            #print "probe.node",probe.node
            self.check_update(probe)

        #print self.binding
        

#        for a in self.binding:
#            print "a",a,"b",b
        pass
    def check_update(self,probe):
        def sendWatchMsg(id,value):
            watch = ReactWatch.Msg()
            watch.set_var_id(id)
            watch.set_value(value)
            from simx.act.context import R
            R.reply(watch)

        for k, v in self.binding.iteritems():
            if(probe.node==v.node_id):
                #print k, v.id,v.node_id,v.name
                value=self.QUERY(v.node_id,v.name,v.watch)
                #print "value",value
                sendWatchMsg(v.id,str(value))
#        # keep in-sync with updates..
#        memo = probe.memo()
#        memo.event_count += 1
#        # only odd probes update!
#        assert probe.node % 2, "odd node (but was %s)" % probe.node
#        # and check update value
#        assert probe["uint16"] == memo.event_count * probe.node
        pass


    def DECLARE_PROBE(self,nodes, var, rebinding_str):
     #def PROBE_BIND(self, varname, rebinding_str):
        """
        Establish a particular binding.

        Initially, no nodes are added.
        """

#        try:
#            rebindings = self._rebindings(rebinding_str)
#            resolved = self.probe_loader.lookup(varname, *rebindings)
#            binding_id = self.add_binding(resolved)
#            msg = simplejson.dumps({
#                    'id': binding_id,
#                    'resolved': resolved.to_basic()
#                    })
#        except StandardError, exc:
#            reply(failure_reply(str(exc)))
#        else:
#            reply(success_reply(msg))

        #print "rebindings****", rebinding_str
        rebindings = self._rebindings(rebinding_str)
        if rebindings is None:
            return
        #print "rebindings: ",rebindings

        varname, varpara=self.splitbyName(var)
        rebound = self.probe_loader.lookup(varname, *rebindings)
        #binding_id = self.add_binding(rebound)
        #print "rebound",rebound.to_basic(),"\n",simplejson.dumps(rebound.to_basic())
        value=rebound.bind(nodes)
        #print varpara
        if(varpara is not None):
            for para in varpara:
                n=re.match(r"([0-9]+)",para)
                if(n is not None):
                   para=int(n.group(1))
                value=value[para]
                #print "para:",value
                
        #if varpara is not None and re.match(r"([0-9]+)",varpara[-1]) is not None:
            #print "value:",value
        #else:
            #print "value:",value.get()
        #rebound = self.probe_loader.lookup(varname, *rebindings)
        #print "rebound",rebound
        
        msg = simplejson.dumps(rebound.to_basic())
        #print "msg:",msg
        #from simx.act.context import R
        #R.reply(msg)

    def ATTACH_NODE(self, probe_id, node_id):
        try:
            self.attach_node(probe_id, node_id)
        except StandardError, exc:
            reply(failure_reply(exc.message))
        else:
            reply(success_reply("Good"))


    def GET_LISTING(self):
        """
        Return a listing of all known variable and type information.
        """
        def conv(src):
            "Convert to proper transmission structure"
            return dict((k, v.to_basic()) for k, v in src.iteritems())
        
        data = {
            'variables': conv(self.probe_loader.variables),
            'structures': conv(self.probe_loader.structs),
            'typedefs': conv(self.probe_loader.typedefs)
            }
        msg = simplejson.dumps(data)
#        reply(success_reply(msg))
        from simx.act.context import R
        R.reply(success_reply(msg))

    def VIEW_REBIND(self, varname, rebinding_str):
        """
        Rebind a view.
        """
        try:
            rebindings = self._rebindings(rebinding_str)
            rebound = self.probe_loader.lookup(varname, *rebindings)
            msg = simplejson.dumps(rebound.to_basic())
        except StandardError, exc:
#            reply(failure_reply(str(exc)))
            from simx.act.context import R
            R.reply(failure_reply(exc.message))
        else:
#            reply(success_reply(msg))
            from simx.act.context import R
            R.reply(success_reply(msg))


    def BIND(self, nodeId, varname, watch=None,expr_str=None):
        """
        Creating a binding for a variable.

        If the variable is already bound it is updated. The variable
        binding is returned on success.

        If the variable can not be bound or rebound, a BindingFailed
        exception is raised.
        """
        rebinding_str=""
        #print "rebindings****", rebinding_str
        rebindings = self._rebindings(rebinding_str)
        if rebindings is None:
            return
        #print "rebindings: ",rebindings

        for k, v in self.binding.iteritems():
            if(nodeId==v.node_id and varname==v.name and watch==v.watch):
                self.replyWatch(v)
                return
        binding = self.probe_loader.lookup(varname, *rebindings)

        binding_id = self.add_binding(binding)
        var_obj = binding.bind(nodeId)
        self.probes.append(var_obj)
        
        value=var_obj


        varpara=re.split(r"\]\[|[\]\[]",watch)
        if varpara is not None and len(varpara)>=2:
            del varpara[0]
            del varpara[-1]
            for para in varpara:
                n=re.match(r"([0-9]+)",para)
                if(n is not None):
                    para=int(n.group(1))
        else:
            varpara=None



        if(varpara is not None):
            for para in varpara:
                n=re.match(r"([0-9]+)",para)
                if(n is not None):
                   para=int(n.group(1))
                #print para
                value=value[para]
                #print "para:",value

        #if (varpara is not None and varpara != "") and re.match(r"([0-9]+)",varpara[-1]) is not None:
           # print "value:",value
        #else:
            #print "value:",value.get()


        bindingVar= Binding(binding_id)
        bindingVar.node_id = nodeId
        bindingVar.name = varname
        bindingVar.watch = watch
        bindingVar.probe = var_obj

        bindingVar.last = value
        self.binding[binding_id] = bindingVar
        self.replyWatch(bindingVar)
        self.check_update(var_obj)
        #return bindingVar
    def QUERY(self, nodeId, varname, watch=None,expr_str=None):
        """
        Creating a binding for a variable.

        If the variable is already bound it is updated. The variable
        binding is returned on success.

        If the variable can not be bound or rebound, a BindingFailed
        exception is raised.
        """
        rebinding_str=""
        #print "rebindings****", rebinding_str
        rebindings = self._rebindings(rebinding_str)
        if rebindings is None:
            return
        #print "rebindings: ",rebindings


        binding = self.probe_loader.lookup(varname, *rebindings)
        var_obj = binding.bind(nodeId)
        value=var_obj
        varpara=re.split(r"\]\[|[\]\[]",watch)
        if varpara is not None and len(varpara)>=2:
            del varpara[0]
            del varpara[-1]
            for para in varpara:
                n=re.match(r"([0-9]+)",para)
                if(n is not None):
                    para=int(n.group(1))
        else:
            varpara=None



        if(varpara is not None):
            for para in varpara:
                n=re.match(r"([0-9]+)",para)
                if(n is not None):
                   para=int(n.group(1))
                #print para
                value=value[para]
                #print "para:",value
        ret=0
        if (varpara is not None and varpara != "") and re.match(r"([0-9]+)",varpara[-1]) is not None:
            ret=value
        else:
            ret=value.get()

        return ret
        #return bindingVar

    def replyWatch(self,var):
        """
        Send the variable binding information in a reply.
        """
        resp = ReactBindWatch.Msg()
        resp.set_node(var.node_id)
        resp.set_var_id(var.id)
        resp.set_var_type(0)
        resp.set_varname(var.name)
        resp.set_watchexpr(var.expr_str)
        resp.set_value(var.last)
        from simx.act.context import R
        R.reply(resp)







    def splitbyName(self,var):
        #split varname by mainpart and parameter part
        #for example, A$B["header"][1], will be A$B, ["header"][1]
        m=re.match(r"([\w$]+)(.*)",var)
        varname=m.group(1)
        varParaTemp = m.group(2)
        varpara=None
        if(varParaTemp is not None):
            #get parameter
            varpara=re.split(r"\]\[|[\]\[]",varParaTemp)
            if varpara is not None and len(varParaTemp)>=2:
                del varpara[0]
                del varpara[-1]
                for para in varpara:
                    n=re.match(r"([0-9]+)",para)
                    if(n is not None):
                        para=int(n.group(1))
            else:
                varpara=None
       
        return (varname,varpara)

class Binding (object):
    """
    A variable binding.
    """

#    __slots__ = ['rev', 'id', 'node_id',
#                 'name', 'obj', 'last', 'expr_str', 'expr']

    def __init__(self, binding_id=0):
        """
        binding_id - group id
        """
        self.id = binding_id
        self.node_id = 0xFFFF
        self.name = "(none)"
        self.watch = ""
        self.probe = None
        self.expr_str = ""
        self.expr = None


    def use_break(self, expr_str=None):
        """
        Set a watch-break.

        If expr_str is None or empty, clears the break. Returns False
        if, and only if, there was an error compiling expr_str.
        """
        if expr_str is None or len(expr_str.strip()) == 0:
            self.clear_break()
            return True

        try:
            expr = compile(expr_str, "modwatch", "eval")
        except:
            return False
        else:
            self.expr_str = expr_str
            self.expr = expr
            return True


    def clear_break(self, expr_str=""):
        """
        Removes the watch break.
        """
        self.expr_str = expr_str
        self.expr = None


    def test_break (self):
        """
        Test if the break condition matches.

        Returns True iff the condition matches.
        """
        try:
            return eval(self.expr, globals(), {'_': current})
        except Exception, e:
            self.clear_break("(invalid: %s)" % self.expr_str)
            return False



