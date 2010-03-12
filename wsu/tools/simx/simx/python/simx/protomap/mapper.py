class ServerClientMap(object):
    """
    Mapping for each client from a name to ID. The mapping is not
    sharable among different clients.
    """

    def __init__(self):
        self.id_resolver = {} # name => id


    def resolve_id(self, name):
        """
        Returns the id associated with the given name or None if it
        does not exist.
        """
        return self.id_resolver.get(name)


    def add_resolution(self, name, id):
        """
        Add a binding from the given name to the given ID. It is an
        error if the name is re-bound.
        """
        if self.id_resolver.get(name, id) != id:
            raise ValueError("conflicting resolution")
        
        self.id_resolver[name] = id


class ServerMap(object):
    """
    Mapping for the server. The mapping is shared for all clients.

    The name is the fully qualified name and may include a sub-type
    qualifier.
    """

    def __init__(self):
        self.id_resolver = {}       # name => id
        self.name_resolver = {}     # id => name
        self.pbuffer_resolver = {}  # name => protocol buffer
        self.handler_resolver = {}  # name => handler
        self.last_id = 1

    def resolve_id(self, name):
        """
        Returns the ID mapped to name, or None.
        """
        return self.id_resolver.get(name)

    def resolve_name(self, id):
        """
        Returns the name mapped to an ID, or None.
        """
        return self.name_resolver.get(id)

    def resolve_protobuffer(self, name):
        """
        Returns the protocol buffer class mapped to a name, or None.
        """
        return self.pbuffer_resolver.get(name)

    def resolve_handler(self, name):
        """
        Returns the handler mapped to a name, or None.
        """
        return self.handler_resolver.get(name)

    def set_handler(self, target, handler):
        """
        Establish a handler for a specific protocol buffer (possibly
        with a subname).

        target can either be the Protocol Buffer class or a tuple of
        (Protocol Buffer class, subname).

        handler should be a function taking two parameters: the client
        and the message.
        """

        if hasattr(target, "__iter__"):
            (pbuffer_class, subname) = target
        else:
            (pbuffer_class, subname) = (target, None)

        name = pbuffer_class.DESCRIPTOR.full_name
        if subname:
            name = name + "$" + subname

        if not name in self.id_resolver:
            # only create first time
            id = self.last_id
            self.id_resolver[name] = id
            self.name_resolver[id] = name
            self.pbuffer_resolver[name] = pbuffer_class
            self.last_id = id + 1

        self.handler_resolver[name] = handler

