"""
Reactor
"""

import new
import sys
import traceback
from warnings import warn
import logging

try:
    import cString as _StringIO
except:
    import StringIO as _StringIO

try:
    from simx.act.msg.Helper import ConstructMessage, mergeReact
except ImportError, e:
    raise ImportError(
        "Error loading MIG modules: %s\n"
        "This likely means that Act has not been correctly built.\n"
        "Enter into the Act root directory and run 'make'."
        % e.message)

from simx.act.msg import React, ReactCmd, ReactReply

import simx.act.context as context
import simx.act.service as service
import simx.act.util as act_util

MODULE_NAMESPACE = "simx.act.mod"
GUARD = object()
OUT_IO =  _StringIO.StringIO()
REAL_STDOUT = sys.stdout

log = logging.getLogger(__name__)


def use_reply_context(reply):
    context.set_reply_context(reply)


def react_core(msg, reactor, ctx):
    """
    Bridge to perform ``command excution''.

    This may as well be the heart of Act.
    """

    cmd = msg.get_cmd()
    #log.debug("EXEC " + cmd)
    OUT_IO = _StringIO.StringIO()
    try:
        exec_locals = reactor.locals
        # Hack-around exec/eval stmt/expr limitations by side-effect.
        # Output is only generated if data is written to OUT (or sys.stdout)
        # or _ is assigned to.
        exec_locals['OUT'] = OUT_IO
        exec_locals['_'] = GUARD
        use_reply_context(ctx)
        #print "before : ",OUT_IO.getvalue()
        try:
            # temporarily redirect sys.stdout for capture
            sys.stdout = OUT_IO
            exec cmd in reactor.globals, exec_locals
        finally:
             sys.stdout = REAL_STDOUT
        out = []
        read = OUT_IO.getvalue()
        #print "read",read
        result = exec_locals['_']
        if read:
            out.append(read)
        if result is not GUARD:
            out.append(repr(result))
        if out:
            ctx.reply(act_util.success_replies(out))
            #pass

    except:
        (exc_type, exc, trace) = sys.exc_info()
        trace = trace.tb_next # skip first trace
        error_msg = "".join(traceback.format_exception(exc_type, exc, trace))
        
        print >>sys.stderr, ">> reactCore error\n", error_msg, \
            "== command ==", cmd, "<< end", exc_type," ",exc," ",trace
        print "fail\n"
        ctx.reply(act_util.failure_reply(error_msg))

    finally:
        # switch back to global context
        use_reply_context(reactor)


class ReactR(object):
    """
    Main reactor object.

    This is not thread safe or re-entrant: a mutated version is passed
    to the handler on each request.
    """

    __slots__ = ['injector', 'globals', 'locals', 'dispatch', 'source',
                 'packet', 'partial', 'mod_handlers', 'replies',
                 'modules', 'service']

    def __init__(self, injector=None, globals_=None):
        self.service = service.Manager()
        self.injector = injector
        if not globals_:
            globals_ = context.GLOBAL_CONTEXT
        self.globals = globals_
        self.locals = {}
        self.dispatch = {ReactCmd.Msg: lambda m, ctx: react_core(m, self, ctx)}
        self.source = None
        self.packet = None
        self.partial = None
        self.mod_handlers = []
        self.modules = {} # of name: [mod, opts, keywords]

        self.globals["RELOAD"] = \
            new.instancemethod(ReactR.reload_mods, self, ReactR)

        use_reply_context(self)


    @staticmethod
    def _qualified_mod_name(mod_name, namespace=MODULE_NAMESPACE):
        """
        Returns the qualified module name for a mod.
        """
        return "%s.mod%s" % (namespace, mod_name.lower())


    @staticmethod
    def _mod_classname(mod_name):
        """
        Returns the classname for a mod.
        """
        return "Mod%s" % mod_name.title()
    

    def load_mod(self, mod_name, *args, **kws):
        """
        Load a module specified by mod_name.
        """
        fqn = self._qualified_mod_name(mod_name)
        #print "fqn",fqn,"\n"
        try:
            mod_module = act_util.dynamic_import(fqn)
            #print "mod_module",mod_module
            mod_class = getattr(mod_module, self._mod_classname(mod_name))
            mod = self._init_mod(mod_class, args, kws)
        except:
            exc = sys.exc_info()[1]
            raise Exception("%s [%s]" % (exc, fqn))
        else:
            #print "register"
            return self._register_mod(mod, mod_name, args, kws)


    def _init_mod(self, mod_class, args, kws):
        """
        Initializes a module. This does not register the module.
        """
        try:
            return mod_class(self, *args, **kws)
        except:
            # Re-raise errors as exceptions.
            exc = sys.exc_info()[1]
            if not isinstance(exc, Exception):
                raise Exception(exc.message)
            else:
                raise


    def _register_mod(self, mod, mod_name, args, kws):
        """
        Register a given module.
        """
        mod_name = mod_name.upper()
        
        self.modules[mod_name] = [mod, args, kws]
        self.globals[mod_name] = mod
        #print self.modules
        if hasattr(mod, 'handler'):
            handler = mod.handler
            self.mod_handlers.append(handler)


    def reload_mods(self):
        """
        Force a reload of all currently loaded modules.
        """
        # TODO: make this do something?
        pass
#        for _, info in self.modules.iteritems():
#            mod, args, kws = info
#            reload(mod)


    def loaded_mods(self):
        """
        Returns a list of the loaded modules.
        """
        return self.modules.keys()


    def _dispatcher(self, msg, ctx):
        """
        Dispatch a given message based upon the type.
        """
        try:
            use_reply_context(ctx)
            self.dispatch[msg.__class__](msg, ctx)
        except KeyError:
            print "No dispatch for " + repr(msg)


    def handler(self):
        """
        Read in packets from the stream.
        """
        react_msg = React.Msg(self.packet)
        (res, self.partial) = mergeReact(react_msg, self.partial)

        if res is not None:
            (msg_type, track_id, data) = res
            msg = ConstructMessage(msg_type, data)
            if msg is not None:
                msg.track_id = track_id
                msg.source = self.source
                #print "msg.track_id: ",msg.track_id," res: ",res," self.partial: ",self.partial,self.source,"\n"
#                log.debug("Dispatch %s with track %s\n" %
#                          (msg.__class__, track_id))
                if track_id:
                    self._dispatcher(msg,
                                     ReplyContext(self, track_id=track_id))
                else:
                    self._dispatcher(msg, self)
            else:
                warn("message not handled: " + self.packet)


    def process(self):
        """
        Read and handle pending packets.
        """
        # process mod handlers
        #print "process\n"
        use_reply_context(self)
        for mod_handler in self.mod_handlers:
            mod_handler()

        # normal process
        for (self.source, self.packet) in self.injector.read_packets():
            self.handler()


    def announce(self, message):
        """
        Announce something.
        """
        pass


    def reply(self, message, target=None, track_id=0):
        """
        Add a reply.

        Replies are sent in order added.
        """
#        log.debug("Sending %s(%s): %s" %
#                  (type(message), track_id, len(message.dataGet())))
#        if track_id is None:
#            track_id = 0
        #if(track_id!=0):print "core: reply: ",type(message), track_id, len(message.dataGet()),message,"\n"
        if isinstance(message, React.Msg):
            self.injector.inject(message, target)
        else:
            for part in React.Msg.encode(message, track_id=track_id):
                #if(track_id!=0):print "part",part
                self.injector.inject(part, target)
                #pass


    def debug(self, message, target=None, track_id=0):
        """
        Seng a debug message.
        """
        #print "DEBUG:", message
        cmd = ReactReply.Msg()
        cmd.set_status(ReactReply.UNSOLICITED)
        cmd.add_refinement(ReactReply.DEBUG, message)
        self.reply(cmd, target, track_id)


class ReplyContext(object):
    """
    Associate a reply with a source. This is used for any messages
    with a tracking id or target.
    """

    # PST-- locals should be removed
    __slots__ = ['reactor', 'target', 'track_id']

    def __init__(self, reactor, target=None, track_id=0):
        self.reactor = reactor
        self.target = target
        self.track_id = track_id


    def reply(self, message, target=None, track_id=None):
        """
        Send a reply.
        """
        log.debug("Writing msg with %s\n" % track_id)
        return self.reactor.reply(
            message,
            target or self.target,
            track_id if track_id is not None else self.track_id)
