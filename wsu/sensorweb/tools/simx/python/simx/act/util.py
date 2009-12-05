from simx.act.msg import ReactReply


def dynamic_import(fqn):
    """
    Import a module use a FQN and return the last module in the
    chain. See python.org/doc/2.5/lib/built-in-funcs.html.
    """
    #print "utilfqn",fqn
    mod = __import__(fqn)
    #print "mod",mod
    components = fqn.split('.')
    for comp in components[1:]:
        mod = getattr(mod, comp)
    
    return mod


def failure_reply(result):
    """
    Generate a failure reply with one refinement.
    """
    reply = ReactReply.Msg()
    reply.set_status(ReactReply.FAILURE)
    reply.add_refinement(ReactReply.ERROR, result)
    return reply


def success_replies(results):
    """
    Generate a successful reply with multiple refinements.
    """
    reply = ReactReply.Msg()
    reply.set_status(ReactReply.SUCCESS)
    for result in results:
        reply.add_refinement(ReactReply.NORMAL, result)
        #print "result: ",result
    return reply


def success_reply(result):
    """
    Generate a succesful reply with one refinement.
    """
    reply = ReactReply.Msg()
    reply.set_status(ReactReply.SUCCESS)
    reply.add_refinement(ReactReply.NORMAL, result)
    return reply
