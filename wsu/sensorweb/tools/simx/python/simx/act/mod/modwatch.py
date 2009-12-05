"""
ModWatch
"""
import logging

from simx.act.msg import ReactBindWatch, ReactWatch
from simx.watch.Watch import Watcher
from simx.watch.Watch import BindingFailed

from simx.act.context import T


class ModWatch(object):

 """
 Watch Binding.
 """

 log = logging.getLogger(__name__)

 def __init__(self, reactor, tossim=None,time_control=None,):
   print "modwatch initiated"
   #if tossim is not None:
       # print "load watch with tossim: ",tossim
   self.tossim = tossim or reactor.service.resolve("Tossim")
   #print "self.tossim.getNode(0).getVariable()", self.tossim.getNode(0).getVariable()

   #self.tossim = T5

   self.time_control = time_control or reactor.service.resolve("TimeControl")
   #self.probe_loader = probe_loader
   self.watcher = Watcher()

 def handler(self):

        def sendWatchMsg(var):
            watch = ReactWatch.Msg()
            watch.set_var_id(var.id)
            watch.set_value(str(current))
            from simx.act.context import R
            R.reply(watch)

        def handle_delta (matched, var):
            sendWatchMsg(var)
            if matched:
                RR.debug("WATCH TRIGGERED %s: val=%s)" %
                        (var.expr_str, str(var.last)))
                TimeControl.stop()

        delta = self.watcher.generate_delta()
        for i in delta:
            print "i: ",i
            handle_delta(*i)


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
        from simx.act.context import R
        R.reply(resp)

 def ADD(self,node_ids, varname, expr_str=""):
        """
        nodes - iterable of node ids
        varname - name of variable, string
        """
        for node_id in node_ids:
            #SINGLE_ADD(node_id, varname, expr_str=expr_str)
            SINGLE_A(node_id, varname, expr_str=expr_str)

 def SINGLE_ADD(self,node_id, varname, expr_str=""):
            #node = self.tossim[node_id]
            node = self.tossim.getNode(node_id)
            self.log.debug("Adding variable '%s' on mote %d" % (varname, node_id))

            if not node:
                self.log.debug("NO NODE WITH ID: %d" % node_id)
                return

            try:
                var = self.watcher.bind(node, varname, expr_str)
                if not var:
                    raise BindingFailed("Failed to bind")
            except Exception, e:
                self.log.debug("BIND FAILED (%d:%s): %s" %
                        (node_id, varname, e.message))
            else:
                self.log.debug("VAR %d:%s BOUND/REBOUND AS %d" %
                        (var.node_id, var.name, var.id))
                self.replyWatch(var)

 def SINGLE_A(self,node_id, varname, expr_str=""):
         pass
         #if not expr_str:
            #def = loader.lookup(varname,expr_str)
         #else:
            #def = loader.lookup(varname)
         #var = def.bind(node_id)
         #print var



 def QUERY(self,bind_id):
            """
            Reply with binding information for the specific bind_id.
            """
            binding = self.watcher.binding.get(bind_id)
            if not binding:
                self.log.debug("NO WATCH BINDING FOR %s" % repr(bind_id))
                # invalid node ID triggers client deletion
                binding = Watch.Binding(bind_id)

            self.log.debug("SENDING WATCH FOR %s" % bind_id)
            self.replyWatch(var)


 def DEL(self,var_id):
            from simx.act.context import R
            R.strReply("<NI DEL>")
            pass


 def DEL_ALL(self):
            return
