class BindingFailed (Exception):
    def __init__ (self, msg="Could not bind"):
        Exception.__init__(self, msg)


class Watcher (object):
    """
    Manage watched variables.
    """

    def __init__ (self):
        self.binding = {} # binding_id: {mote_id: binding}
        self.offset = 1   # [1, 0xFFFF]


    def find_free_id (self):
        """
        Try to find an available ID.

        The range of ID's is [1, 0xFFFF], or 2**16 - 1. Using 23 as
        the skip the LCM is 1.5M. And, I have no idea if this is any
        better than just a +1 skip...

        As a fail-safe this will raise an exception if more than half
        of the binding space has been occupied.
        """
        if len(self.binding) > 0xEFFF:
            raise ValueError("Bind capacity exceeded: %d items",
                             len(self.binding))

        i = self.offset

        while self.binding.has_key(i):
            i += 23
            if i > 0xFFFF:  # skip '0'
                i %= 0xFFFF

        self.offset = i
        return i


    def bind (self, node, varname, watch=None):
        """
        Creating a binding for a variable.

        If the variable is already bound it is updated. The variable
        binding is returned on success.

        If the variable can not be bound or rebound, a BindingFailed
        exception is raised.
        """
#        binding = self.fetch_binding(node.id(), varname)
#        if binding:
#            self.update_binding(binding, watch)
#            return binding
#
#        bind_id = self.find_free_id()
#        print "bind_id: ",bind_id
#        var_obj = node.getVariable(varname)
#        print varname,":",var_obj.getData()
#       if var_obj is None or var_obj.getData() == "<no such variable>":
#            print "Bind failed for %d:%s" % (node.id(), varname)
#            raise BindingFailed("Failed to access variable")

        # create and store
        binding = Binding(bind_id)
        binding.node_id = node.id()
        binding.name = varname
        binding.obj = var_obj
        binding.use_break(watch)
        binding.last = binding.obj.getData()
        self.binding[bind_id] = binding


        return binding


    def update_binding (self, binding, watch=None):
        return binding.use_break(watch)


    def unbind (self, node_id, var_name):
        """
        Removes a variable binding.

        Returns the removed binding. or None.
        """
        binding = self.fetch_binding(node_id, var_name)
        if binding:
            self.binding.pop(binding.id)
            return binding


    def unbind_by_id (self, bind_id):
        """
        Removes a variable binding with the id.

        Returns the removed binding, or None.
        """
        if self.binding.has_key(bind_id):
            return self.binding.pop(bind_id)


    def fetch_binding (self, node_id, varname):
        """
        Fetch the variable binding for the specific mote/variable.

        Returns None if the binding does not exist.
        """
        for binding in self.binding.itervalues():
            if binding.node_id == node_id and binding.name == varname:
                return binding


    def generate_delta (self):
        """
        Generate list changed bindings.

        Returns a list of the form [(matched, binding), ....] where
        matched is a boolean representing is the watch expression is
        currently matching.

        SIDE-EFFECT: This advanced the current delta. That is, when
        called twice in a row, the 2nd invocation will always return
        [].
        """
        return map(lambda binding: (binding.test_break(), binding),
                   self.changed_bindings())

    
    def changed_bindings (self):
        """
        Generate a list of all bindings which have been changed.

        It is usually prefered to use generate_delta instead.

        SIDE-EFFECT: This resets the last binding value to the current
        value. That is, when called twice in a row, the 2nd invocation
        will always return [].
        """
        changed = []
        for binding in self.binding.itervalues():
            current = binding.obj.getData()
            if binding.last != current:
                binding.last = current
                changed.append(binding)

        return changed


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
