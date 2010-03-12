import React, ReactCmd
from ..mig.python.ReactConst import ReactConst
from warnings import warn

MESSAGES = [React.Msg, ReactCmd.Msg]
MESSAGE_LOOKUP = dict((m.get_amType(), m) for m in MESSAGES)

def split_at(list, at):
    return (list[0:at], list[at:])

def merge_multipart(*parts):
    return "\0".join(parts)

def split_multipart(str, lim):
    return smart_split(str, "\0", lim)

def smart_split(str, sep, lim, default=""):
    """
    Split into at least lim elements using default value if needed.
    """
    s = str.split(sep, lim - 1)
    if len(s) < lim:
        s.extend([default] * (lim - len(s)))
    return s

def ConstructMessage(type, data):
    """
    Attempt to construct a message of the given type from data.

    Returns the new message or None.
    """
    klass = MESSAGE_LOOKUP.get(type)
    if klass is not None:
        return klass(data)

def mergeReact(message, partial):
    """
    Returns (complete_message, partial).

    message must be a ReactMsg. partial is the previous partial
    (returned from last mergeReact invocation).
    """
    if message.get_type() == 0: # partial
        if partial is None:
            warn("Partial found but no partial in progress: ignoring")
        else:
            partial = partial.merge(message)
    else: # full
        if partial is not None:
            warn("Message start but partial in progress: hijacking")
        partial = message

    if partial is not None and partial.complete():
        return (partial.extract(), None)
    return (None, partial)
