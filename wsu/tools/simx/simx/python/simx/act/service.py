from warnings import warn

class Manager(object):
    """
    Manage basic "service lookup".
    """

    def __init__(self):
        self.services = {} # service_name: component

    def register(self, name, component):
        """
        Registers a service.

        Services used as default values to loading modules.
        """
        if name in self.services:
            warn("Service '%s' re-registered" % name)
        self.services[name] = component

    def names(self):
        """
        Returns a list of all registered services.
        """
        return self.services.keys()

    def find(self, name):
        """
        Returns the service associated with name or None.
        """
        s = self.services.get(name)
        if s is None:
            warn("No service for %s" % name)
        return s

    def resolve(self, name):
        """
        Returns the service associate with name or raises an exception.
        """
        s = self.services.get(name)
        if s is None:
            raise Exception("No service found for %s" % name)
        return s
