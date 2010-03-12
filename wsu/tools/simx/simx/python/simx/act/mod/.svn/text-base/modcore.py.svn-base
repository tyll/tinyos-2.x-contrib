"""
ModCore
"""

import logging
import sys


class ModCore(object):
    """
    Bridge for core reactor functions.
    """

    log = logging.getLogger(__name__)

    def __init__(self, reactor=None):
        self.reactor = reactor


    def services(self):
        """
        Report services.
        """
        service_names = self.services.names()
        self.reactor.debug(", ".join(service_names))


    def mods(self):
        """
        Report loaded modules.
        """
        
        mods = self.reactor.loaded_mods()
        self.reactor.debug(", ".join(mods))


    def load_mod(self, name, *opts, **kws):
        """
        Load a specific module.
        """
        try:
            #self.reactor.loadMod(name, *opts, **kws)
            self.reactor.load_mod(name, *opts, **kws)
        except:
            exc = sys.exc_info()[1]
            self.reactor.debug("Failed to load module:\n%s" % exc)


    def reload_mods(self):
        """
        Reload all loaded modules.
        """
        try:
            self.reactor.reload_mods()
        except:
            exc = sys.exc_info()[1]
            self.reactor.debug("Failed to reload modules:\n%s" % exc)
        else:
            self.reactor.debug("Modules reloaded")
